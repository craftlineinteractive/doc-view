import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Reasons for PDF to Word conversion failure.
enum PdfToWordErrorReason {
  fileNotFound,
  encrypted,
  noTextFound,
  pageLimitExceeded,
  textLimitExceeded,
  conversionFailed,
  cancelled,
}

/// Typed exception thrown during PDF to Word conversion.
class PdfToWordException implements Exception {
  final PdfToWordErrorReason reason;
  final String? message;

  const PdfToWordException(this.reason, [this.message]);

  @override
  String toString() => 'PdfToWordException($reason, ${message ?? ""})';
}

/// Heading level classified by font size and formatting heuristics.
enum WordHeadingLevel {
  normal,
  heading1,
  heading2,
}

/// Single formatted text run within a paragraph.
class WordRun {
  final String text;
  final bool isBold;
  final bool isItalic;
  final bool isRtl;

  const WordRun({
    required this.text,
    this.isBold = false,
    this.isItalic = false,
    this.isRtl = false,
  });
}

/// Structured paragraph of extracted text.
class WordParagraph {
  final List<WordRun> runs;
  final WordHeadingLevel heading;
  final bool isRtl;
  final bool isBullet;

  const WordParagraph({
    required this.runs,
    this.heading = WordHeadingLevel.normal,
    this.isRtl = false,
    this.isBullet = false,
  });

  String get plainText => runs.map((r) => r.text).join();
}

/// DTO sent across isolate boundary to execute conversion.
class _PdfToWordParams {
  final String sourcePath;
  final String outputPath;
  final String? password;
  final bool insertPageBreaks;
  final SendPort? progressPort;
  final SendPort? cancelPort;
  final int slowConvertDelayMs;

  const _PdfToWordParams({
    required this.sourcePath,
    required this.outputPath,
    this.password,
    this.insertPageBreaks = true,
    this.progressPort,
    this.cancelPort,
    this.slowConvertDelayMs = 0,
  });
}

/// Token allowing cancellation of an in-flight PDF to Word conversion.
class PdfToWordCancellationToken {
  bool _isCancelled = false;
  SendPort? _controlPort;

  bool get isCancelled => _isCancelled;

  void cancel() {
    _isCancelled = true;
    _controlPort?.send('cancel');
  }

  void _attach(SendPort port) {
    _controlPort = port;
    if (_isCancelled) {
      port.send('cancel');
    }
  }
}

/// Result of quick preflight check for text content in a PDF.
class PdfTextPreflightResult {
  final int pageCount;
  final bool isEncrypted;
  final bool hasText;
  final int totalCharacters;

  const PdfTextPreflightResult({
    required this.pageCount,
    required this.isEncrypted,
    required this.hasText,
    required this.totalCharacters,
  });
}

/// Service providing isolate-safe, client-side PDF to Word (.docx) document conversion.
class PdfToWordService {
  const PdfToWordService();

  static const int maxPages = 1000;
  static const int maxTextChars = 20 * 1024 * 1024; // 20 MB text limit

  /// Debug-only slow conversion switch for testing cancellation and kill tests.
  /// Guarded by kDebugMode.
  static bool slowConvertForTesting = false;
  static int slowConvertDelayMs = 0;

  /// Verification helper ensuring slowConvert cannot activate in release mode.
  static bool isSlowConvertActive({required bool isDebug}) {
    return isDebug && slowConvertForTesting && slowConvertDelayMs > 0;
  }

  /// Fast pre-check to verify if a PDF contains extractable text without running full conversion.
  Future<PdfTextPreflightResult> checkTextLayer({
    required String sourcePath,
    String? password,
  }) async {
    return Isolate.run(() => _runPreflightCheck(sourcePath, password));
  }

  /// Converts a PDF file into a standard Microsoft Word (.docx) document.
  Future<String> convertPdfToWord({
    required String sourcePath,
    String? outputPath,
    String? password,
    bool insertPageBreaks = true,
    void Function(double progress)? onProgress,
    PdfToWordCancellationToken? cancellationToken,
  }) async {
    final resolvedOutputPath = outputPath ?? _defaultOutputPath(sourcePath);

    final receivePort = ReceivePort();
    final cancelReceivePort = ReceivePort();
    cancelReceivePort.listen((msg) {
      if (msg is SendPort) {
        cancellationToken?._attach(msg);
      }
    });

    try {
      if (onProgress != null) {
        receivePort.listen((message) {
          if (message is double) {
            onProgress(message);
          }
        });
      }

      final params = _PdfToWordParams(
        sourcePath: sourcePath,
        outputPath: resolvedOutputPath,
        password: password,
        insertPageBreaks: insertPageBreaks,
        progressPort: receivePort.sendPort,
        cancelPort: cancelReceivePort.sendPort,
        slowConvertDelayMs:
            kDebugMode && slowConvertForTesting ? slowConvertDelayMs : 0,
      );

      final result = await Isolate.run(() => _runPdfToWordConversion(params));
      return result;
    } catch (e) {
      final tempFile = File('$resolvedOutputPath.tmp');
      if (tempFile.existsSync()) {
        try {
          tempFile.deleteSync();
        } catch (_) {}
      }
      rethrow;
    } finally {
      receivePort.close();
      cancelReceivePort.close();
    }
  }

  static String _defaultOutputPath(String sourcePath) {
    final dir = p.dirname(sourcePath);
    final baseName = p.basenameWithoutExtension(sourcePath);
    String target = p.join(dir, '$baseName.docx');
    int counter = 1;
    while (File(target).existsSync()) {
      target = p.join(dir, '$baseName ($counter).docx');
      counter++;
    }
    return target;
  }
}

/// Top-level isolate worker function for preflight text inspection.
PdfTextPreflightResult _runPreflightCheck(String sourcePath, String? password) {
  final file = File(sourcePath);
  if (!file.existsSync()) {
    throw const PdfToWordException(PdfToWordErrorReason.fileNotFound);
  }

  PdfDocument? doc;
  try {
    final bytes = file.readAsBytesSync();
    doc = PdfDocument(inputBytes: bytes, password: password);
    final count = doc.pages.count;
    if (count == 0) {
      return const PdfTextPreflightResult(
        pageCount: 0,
        isEncrypted: false,
        hasText: false,
        totalCharacters: 0,
      );
    }

    final extractor = PdfTextExtractor(doc);
    int totalChars = 0;
    // Check first 5 pages for rapid preflight
    final checkPages = count > 5 ? 5 : count;
    for (int i = 0; i < checkPages; i++) {
      final text = extractor.extractText(startPageIndex: i, endPageIndex: i);
      totalChars += text.trim().length;
      if (totalChars > 20) break;
    }

    return PdfTextPreflightResult(
      pageCount: count,
      isEncrypted: false,
      hasText: totalChars > 0,
      totalCharacters: totalChars,
    );
  } catch (e) {
    if (e.toString().toLowerCase().contains('password') ||
        e.toString().toLowerCase().contains('encrypted') ||
        e is ArgumentError) {
      return const PdfTextPreflightResult(
        pageCount: 0,
        isEncrypted: true,
        hasText: false,
        totalCharacters: 0,
      );
    }
    rethrow;
  } finally {
    doc?.dispose();
  }
}

/// Top-level isolate worker function executing full conversion.
Future<String> _runPdfToWordConversion(_PdfToWordParams params) async {
  final file = File(params.sourcePath);
  if (!file.existsSync()) {
    throw const PdfToWordException(PdfToWordErrorReason.fileNotFound);
  }

  PdfDocument? doc;
  try {
    final bytes = file.readAsBytesSync();
    try {
      doc = PdfDocument(inputBytes: bytes, password: params.password);
    } catch (e) {
      if (e.toString().toLowerCase().contains('password') ||
          e.toString().toLowerCase().contains('encrypted') ||
          e is ArgumentError) {
        throw const PdfToWordException(
          PdfToWordErrorReason.encrypted,
          'Password required or incorrect password provided.',
        );
      }
      throw PdfToWordException(
        PdfToWordErrorReason.conversionFailed,
        'Failed to read PDF document: $e',
      );
    }

    final pageCount = doc.pages.count;
    if (pageCount > PdfToWordService.maxPages) {
      throw const PdfToWordException(
        PdfToWordErrorReason.pageLimitExceeded,
        'Document exceeds maximum supported 1,000 pages limit.',
      );
    }

    final extractor = PdfTextExtractor(doc);
    final allPagesParagraphs = <List<WordParagraph>>[];
    int totalExtractedChars = 0;

    final cancelWorkerPort = ReceivePort();
    bool isCancelled = false;
    cancelWorkerPort.listen((msg) {
      if (msg == 'cancel') {
        isCancelled = true;
      }
    });
    params.cancelPort?.send(cancelWorkerPort.sendPort);

    for (int pageIdx = 0; pageIdx < pageCount; pageIdx++) {
      if (isCancelled) {
        cancelWorkerPort.close();
        final tempFile = File('${params.outputPath}.tmp');
        if (tempFile.existsSync()) {
          try {
            tempFile.deleteSync();
          } catch (_) {}
        }
        throw const PdfToWordException(
          PdfToWordErrorReason.cancelled,
          'Conversion cancelled by user.',
        );
      }

      if (kDebugMode && params.slowConvertDelayMs > 0) {
        await Future<void>.delayed(Duration(milliseconds: params.slowConvertDelayMs));
      }

      params.progressPort?.send(pageIdx / pageCount * 0.85);

      final lines = extractor.extractTextLines(
        startPageIndex: pageIdx,
        endPageIndex: pageIdx,
      );

      final pageParagraphs = _groupLinesIntoParagraphs(lines);
      for (final p in pageParagraphs) {
        totalExtractedChars += p.plainText.length;
        if (totalExtractedChars > PdfToWordService.maxTextChars) {
          throw const PdfToWordException(
            PdfToWordErrorReason.textLimitExceeded,
            'Document extracted text exceeds 20 MB limit.',
          );
        }
      }

      allPagesParagraphs.add(pageParagraphs);
    }

    // Verify document contains extractable text
    bool hasAnyText = false;
    for (final pagePars in allPagesParagraphs) {
      for (final p in pagePars) {
        if (p.plainText.trim().isNotEmpty) {
          hasAnyText = true;
          break;
        }
      }
      if (hasAnyText) break;
    }

    if (!hasAnyText) {
      throw const PdfToWordException(
        PdfToWordErrorReason.noTextFound,
        'No extractable text found in document (scanned PDF or vector images).',
      );
    }

    params.progressPort?.send(0.90);

    // Build Word OOXML ZIP Archive
    final docxBytes = _buildDocxArchive(
      allPagesParagraphs: allPagesParagraphs,
      insertPageBreaks: params.insertPageBreaks,
    );

    params.progressPort?.send(0.95);

    // Atomic disk write via .tmp file
    final targetFile = File(params.outputPath);
    final tempPath = '${params.outputPath}.tmp';
    final tempFile = File(tempPath);

    if (tempFile.existsSync()) {
      try {
        tempFile.deleteSync();
      } catch (_) {}
    }

    tempFile.writeAsBytesSync(docxBytes, flush: true);

    if (!tempFile.existsSync() || tempFile.lengthSync() == 0) {
      throw const PdfToWordException(
        PdfToWordErrorReason.conversionFailed,
        'Failed to write temporary conversion output file.',
      );
    }

    // Atomic rename
    tempFile.renameSync(targetFile.path);
    cancelWorkerPort.close();

    // Output verification: re-read output zip, verify required parts
    try {
      final verifyBytes = targetFile.readAsBytesSync();
      final verifyArchive = ZipDecoder().decodeBytes(verifyBytes);
      final hasContentTypes = verifyArchive.files.any(
        (f) => f.name == '[Content_Types].xml' && f.size > 0,
      );
      final hasDocumentXml = verifyArchive.files.any(
        (f) => f.name == 'word/document.xml' && f.size > 0,
      );
      if (!hasContentTypes || !hasDocumentXml) {
        if (targetFile.existsSync()) targetFile.deleteSync();
        throw const PdfToWordException(
          PdfToWordErrorReason.conversionFailed,
          'Output document failed OOXML verification.',
        );
      }
    } catch (e) {
      if (targetFile.existsSync()) {
        try {
          targetFile.deleteSync();
        } catch (_) {}
      }
      if (e is PdfToWordException) rethrow;
      throw PdfToWordException(
        PdfToWordErrorReason.conversionFailed,
        'Output document verification failed: $e',
      );
    }

    params.progressPort?.send(1.0);
    return targetFile.path;
  } finally {
    doc?.dispose();
  }
}

/// Groups raw Syncfusion TextLines into structured paragraphs and runs using layout heuristics.
List<WordParagraph> _groupLinesIntoParagraphs(List<TextLine> rawLines) {
  if (rawLines.isEmpty) return const [];

  // Sort lines into reading order: primary top-to-bottom, secondary left-to-right
  final lines = List<TextLine>.from(rawLines);
  lines.sort((a, b) {
    final topDiff = a.bounds.top - b.bounds.top;
    if (topDiff.abs() > 3.0) {
      return topDiff.compareTo(0);
    }
    return a.bounds.left.compareTo(b.bounds.left);
  });

  // Calculate median font size and median line height
  final fontSizes = lines.map((l) => l.fontSize).where((s) => s > 0).toList()..sort();
  final medianFontSize = fontSizes.isNotEmpty ? fontSizes[fontSizes.length ~/ 2] : 11.0;

  final lineHeights = lines.map((l) => l.bounds.height).where((h) => h > 0).toList()..sort();
  final medianLineHeight = lineHeights.isNotEmpty ? lineHeights[lineHeights.length ~/ 2] : 14.0;

  final paragraphs = <WordParagraph>[];
  final currentRuns = <WordRun>[];
  WordHeadingLevel currentHeading = WordHeadingLevel.normal;
  bool currentIsRtl = false;
  bool currentIsBullet = false;
  double lastBottom = -1.0;

  void flushParagraph() {
    if (currentRuns.isNotEmpty) {
      paragraphs.add(
        WordParagraph(
          runs: List<WordRun>.from(currentRuns),
          heading: currentHeading,
          isRtl: currentIsRtl,
          isBullet: currentIsBullet,
        ),
      );
      currentRuns.clear();
      currentHeading = WordHeadingLevel.normal;
      currentIsRtl = false;
      currentIsBullet = false;
    }
  }

  for (final line in lines) {
    final trimmedText = line.text.trim();
    if (trimmedText.isEmpty) continue;

    final verticalGap = lastBottom >= 0 ? line.bounds.top - lastBottom : 0.0;
    final isNewParagraphByGap = verticalGap > (medianLineHeight * 1.5);
    final isBulletMarker = _isBulletMarker(trimmedText);

    // Classify heading
    WordHeadingLevel heading = WordHeadingLevel.normal;
    final isBold = line.fontStyle.contains(PdfFontStyle.bold) ||
        line.fontName.toLowerCase().contains('bold');
    final isItalic = line.fontStyle.contains(PdfFontStyle.italic) ||
        line.fontName.toLowerCase().contains('italic') ||
        line.fontName.toLowerCase().contains('oblique');

    if (line.fontSize > medianFontSize * 1.8) {
      heading = WordHeadingLevel.heading1;
    } else if (line.fontSize >= medianFontSize * 1.3) {
      heading = WordHeadingLevel.heading2;
    }

    final isRtl = _isRtlText(line.text);

    if (isNewParagraphByGap || isBulletMarker || heading != currentHeading || currentRuns.isEmpty) {
      flushParagraph();
      currentHeading = heading;
      currentIsRtl = isRtl;
      currentIsBullet = isBulletMarker;
    }

    currentRuns.add(
      WordRun(
        text: line.text,
        isBold: isBold,
        isItalic: isItalic,
        isRtl: isRtl,
      ),
    );

    lastBottom = line.bounds.bottom;
  }

  flushParagraph();
  return paragraphs;
}

bool _isBulletMarker(String text) {
  if (text.startsWith('•') ||
      text.startsWith('–') ||
      text.startsWith('—') ||
      text.startsWith('*') ||
      text.startsWith('- ')) {
    return true;
  }
  final numberedMatch = RegExp(r'^\d+[\.\)]\s+').hasMatch(text);
  final letteredMatch = RegExp(r'^[a-zA-Z][\.\)]\s+').hasMatch(text);
  return numberedMatch || letteredMatch;
}

bool _isRtlText(String text) {
  // Arabic: \u0600-\u06FF, Hebrew: \u0590-\u05FF
  return RegExp(r'[\u0600-\u06FF\u0590-\u05FF]').hasMatch(text);
}

/// Sanitizes XML characters and strips illegal XML 1.0 control codes.
String _escapeXml(String input) {
  final buffer = StringBuffer();
  for (int i = 0; i < input.length; i++) {
    final code = input.codeUnitAt(i);
    // Strip illegal XML control characters except tab (9), newline (10), carriage return (13)
    if (code < 32 && code != 9 && code != 10 && code != 13) {
      continue;
    }
    switch (code) {
      case 38: // &
        buffer.write('&amp;');
        break;
      case 60: // <
        buffer.write('&lt;');
        break;
      case 62: // >
        buffer.write('&gt;');
        break;
      case 34: // "
        buffer.write('&quot;');
        break;
      case 39: // '
        buffer.write('&apos;');
        break;
      default:
        buffer.writeCharCode(code);
    }
  }
  return buffer.toString();
}

/// Assembles a valid Microsoft Word (.docx) ZIP package containing OOXML structures.
Uint8List _buildDocxArchive({
  required List<List<WordParagraph>> allPagesParagraphs,
  required bool insertPageBreaks,
}) {
  final archive = Archive();

  void addXmlFile(String name, String content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  }

  // 1. [Content_Types].xml
  const contentTypesXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
  <Override PartName="/word/settings.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml"/>
  <Override PartName="/word/fontTable.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.fontTable+xml"/>
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
</Types>''';
  addXmlFile('[Content_Types].xml', contentTypesXml);

  // 2. _rels/.rels
  const rootRelsXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
</Relationships>''';
  addXmlFile('_rels/.rels', rootRelsXml);

  // 3. word/_rels/document.xml.rels
  const docRelsXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/settings" Target="settings.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/fontTable" Target="fontTable.xml"/>
</Relationships>''';
  addXmlFile('word/_rels/document.xml.rels', docRelsXml);

  // 4. docProps/core.xml
  const corePropertiesXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <dc:title>Doc View Document</dc:title>
  <dc:creator>Doc View</dc:creator>
  <cp:lastModifiedBy>Doc View</cp:lastModifiedBy>
</cp:coreProperties>''';
  addXmlFile('docProps/core.xml', corePropertiesXml);

  // 4. word/settings.xml
  const settingsXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:settings xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:zoom w:percent="100"/>
</w:settings>''';
  addXmlFile('word/settings.xml', settingsXml);

  // 5. word/fontTable.xml
  const fontTableXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:fonts xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:font w:name="Calibri">
    <w:panose1 w:val="020F0502020204030204"/>
    <w:charset w:val="00"/>
    <w:family w:val="swiss"/>
    <w:pitch w:val="variable"/>
  </w:font>
  <w:font w:name="Arial">
    <w:panose1 w:val="020B0604020202020204"/>
    <w:charset w:val="00"/>
    <w:family w:val="swiss"/>
    <w:pitch w:val="variable"/>
  </w:font>
</w:fonts>''';
  addXmlFile('word/fontTable.xml', fontTableXml);

  // 6. word/styles.xml
  const stylesXml = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:docDefaults>
    <w:rPrDefault>
      <w:rPr>
        <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:cs="Arial"/>
        <w:sz w:val="22"/>
        <w:szCs w:val="22"/>
        <w:lang w:val="en-US"/>
      </w:rPr>
    </w:rPrDefault>
    <w:pPrDefault>
      <w:pPr>
        <w:spacing w:after="140" w:line="240" w:lineRule="auto"/>
      </w:pPr>
    </w:pPrDefault>
  </w:docDefaults>
  <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
    <w:name w:val="Normal"/>
    <w:qFormat/>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Heading1">
    <w:name w:val="heading 1"/>
    <w:basedOn w:val="Normal"/>
    <w:next w:val="Normal"/>
    <w:qFormat/>
    <w:pPr>
      <w:keepNext/>
      <w:spacing w:before="240" w:after="120"/>
      <w:outlineLvl w:val="0"/>
    </w:pPr>
    <w:rPr>
      <w:b/>
      <w:bCs/>
      <w:color w:val="1F4E79"/>
      <w:sz w:val="32"/>
      <w:szCs w:val="32"/>
    </w:rPr>
  </w:style>
  <w:style w:type="paragraph" w:styleId="Heading2">
    <w:name w:val="heading 2"/>
    <w:basedOn w:val="Normal"/>
    <w:next w:val="Normal"/>
    <w:qFormat/>
    <w:pPr>
      <w:keepNext/>
      <w:spacing w:before="180" w:after="80"/>
      <w:outlineLvl w:val="1"/>
    </w:pPr>
    <w:rPr>
      <w:b/>
      <w:bCs/>
      <w:color w:val="2E74B5"/>
      <w:sz w:val="26"/>
      <w:szCs w:val="26"/>
    </w:rPr>
  </w:style>
</w:styles>''';
  addXmlFile('word/styles.xml', stylesXml);

  // 7. word/document.xml
  final docBuffer = StringBuffer();
  docBuffer.write('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n');
  docBuffer.write('<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">\n');
  docBuffer.write('  <w:body>\n');

  for (int pIdx = 0; pIdx < allPagesParagraphs.length; pIdx++) {
    final pagePars = allPagesParagraphs[pIdx];
    final isLastPage = pIdx == allPagesParagraphs.length - 1;

    for (final par in pagePars) {
      docBuffer.write('    <w:p>\n');
      docBuffer.write('      <w:pPr>\n');

      if (par.heading == WordHeadingLevel.heading1) {
        docBuffer.write('        <w:pStyle w:val="Heading1"/>\n');
      } else if (par.heading == WordHeadingLevel.heading2) {
        docBuffer.write('        <w:pStyle w:val="Heading2"/>\n');
      }

      if (par.isRtl) {
        docBuffer.write('        <w:bidi/>\n');
        docBuffer.write('        <w:jc w:val="right"/>\n');
      }

      docBuffer.write('      </w:pPr>\n');

      for (final run in par.runs) {
        docBuffer.write('      <w:r>\n');
        if (run.isBold || run.isItalic || run.isRtl) {
          docBuffer.write('        <w:rPr>\n');
          if (run.isBold) {
            docBuffer.write('          <w:b/>\n');
            docBuffer.write('          <w:bCs/>\n');
          }
          if (run.isItalic) {
            docBuffer.write('          <w:i/>\n');
            docBuffer.write('          <w:iCs/>\n');
          }
          if (run.isRtl) {
            docBuffer.write('          <w:rtl/>\n');
          }
          docBuffer.write('        </w:rPr>\n');
        }
        docBuffer.write('        <w:t xml:space="preserve">${_escapeXml(run.text)}</w:t>\n');
        docBuffer.write('      </w:r>\n');
      }

      docBuffer.write('    </w:p>\n');
    }

    if (insertPageBreaks && !isLastPage && pagePars.isNotEmpty) {
      docBuffer.write('    <w:p><w:r><w:br w:type="page"/></w:r></w:p>\n');
    }
  }

  docBuffer.write('    <w:sectPr>\n');
  docBuffer.write('      <w:pgSz w:w="11906" w:h="16838"/>\n');
  docBuffer.write('      <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/>\n');
  docBuffer.write('    </w:sectPr>\n');
  docBuffer.write('  </w:body>\n');
  docBuffer.write('</w:document>\n');

  final documentXmlStr = docBuffer.toString();
  addXmlFile('word/document.xml', documentXmlStr);

  final zipBytes = ZipEncoder().encode(archive);
  return Uint8List.fromList(zipBytes ?? <int>[]);
}
