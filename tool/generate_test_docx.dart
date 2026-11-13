import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';

void main() {
  final archive = Archive();

  // [Content_Types].xml
  const contentTypes = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/numbering.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.numbering+xml"/>
</Types>''';

  // _rels/.rels
  const rootRels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>''';

  // word/_rels/document.xml.rels
  const docRels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering" Target="numbering.xml"/>
</Relationships>''';

  // word/numbering.xml with standard Word bullet definitions using Symbol / Wingdings PUA
  const numbering = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:numbering xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <!-- Round Bullet: Symbol font \uF0B7 -->
  <w:abstractNum w:abstractNumId="0">
    <w:lvl w:ilvl="0">
      <w:start w:val="1"/>
      <w:numFmt w:val="bullet"/>
      <w:lvlText w:val="&#xF0B7;"/>
      <w:rPr>
        <w:rFonts w:ascii="Symbol" w:hAnsi="Symbol" w:hint="default"/>
      </w:rPr>
    </w:lvl>
  </w:abstractNum>
  <!-- Square Bullet: Wingdings \uF0A7 -->
  <w:abstractNum w:abstractNumId="1">
    <w:lvl w:ilvl="0">
      <w:start w:val="1"/>
      <w:numFmt w:val="bullet"/>
      <w:lvlText w:val="&#xF0A7;"/>
      <w:rPr>
        <w:rFonts w:ascii="Wingdings" w:hAnsi="Wingdings" w:hint="default"/>
      </w:rPr>
    </w:lvl>
  </w:abstractNum>
  <!-- Arrow Bullet: Wingdings \uF0D8 -->
  <w:abstractNum w:abstractNumId="2">
    <w:lvl w:ilvl="0">
      <w:start w:val="1"/>
      <w:numFmt w:val="bullet"/>
      <w:lvlText w:val="&#xF0D8;"/>
      <w:rPr>
        <w:rFonts w:ascii="Wingdings" w:hAnsi="Wingdings" w:hint="default"/>
      </w:rPr>
    </w:lvl>
  </w:abstractNum>
  <!-- Diamond Bullet: Wingdings \uF0DE -->
  <w:abstractNum w:abstractNumId="3">
    <w:lvl w:ilvl="0">
      <w:start w:val="1"/>
      <w:numFmt w:val="bullet"/>
      <w:lvlText w:val="&#xF0DE;"/>
      <w:rPr>
        <w:rFonts w:ascii="Wingdings" w:hAnsi="Wingdings" w:hint="default"/>
      </w:rPr>
    </w:lvl>
  </w:abstractNum>
  <!-- Checkmark Bullet: Wingdings \uF0FC -->
  <w:abstractNum w:abstractNumId="4">
    <w:lvl w:ilvl="0">
      <w:start w:val="1"/>
      <w:numFmt w:val="bullet"/>
      <w:lvlText w:val="&#xF0FC;"/>
      <w:rPr>
        <w:rFonts w:ascii="Wingdings" w:hAnsi="Wingdings" w:hint="default"/>
      </w:rPr>
    </w:lvl>
  </w:abstractNum>

  <w:num w:numId="1"><w:abstractNumId w:val="0"/></w:num>
  <w:num w:numId="2"><w:abstractNumId w:val="1"/></w:num>
  <w:num w:numId="3"><w:abstractNumId w:val="2"/></w:num>
  <w:num w:numId="4"><w:abstractNumId w:val="3"/></w:num>
  <w:num w:numId="5"><w:abstractNumId w:val="4"/></w:num>
</w:numbering>''';

  // word/document.xml with 5 pages, bullets, and symbols
  final docXml = StringBuffer();
  docXml.write('''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body>
''');

  // Page 1: Round & Square Bullets + Inline Symbols
  docXml.write('''
    <w:p><w:r><w:rPr><w:b/><w:sz w:val="36"/></w:rPr><w:t>Page 1: Standard Bullet Verification</w:t></w:r></w:p>
    <w:p><w:r><w:t>Verifying round bullet list:</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="1"/></w:numPr></w:pPr><w:r><w:t>First round bullet item</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="1"/></w:numPr></w:pPr><w:r><w:t>Second round bullet item with details</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="1"/></w:numPr></w:pPr><w:r><w:t>Third round bullet item verified</w:t></w:r></w:p>

    <w:p><w:r><w:t>Verifying square bullet list:</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="2"/></w:numPr></w:pPr><w:r><w:t>Square bullet item alpha</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="2"/></w:numPr></w:pPr><w:r><w:t>Square bullet item beta</w:t></w:r></w:p>

    <w:p><w:r><w:t>Inline Symbol character via w:sym: </w:t></w:r><w:r><w:sym w:font="Wingdings" w:char="F0FC"/><w:t> Checkmark symbol</w:t></w:r></w:p>
    <w:p><w:r><w:br w:type="page"/></w:r></w:p>
''');

  // Page 2: Arrow & Diamond & Checkmark Bullets
  docXml.write('''
    <w:p><w:r><w:rPr><w:b/><w:sz w:val="36"/></w:rPr><w:t>Page 2: Arrow and Diamond Bullets</w:t></w:r></w:p>
    <w:p><w:r><w:t>Verifying arrow bullet list:</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="3"/></w:numPr></w:pPr><w:r><w:t>Arrow bullet step 1</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="3"/></w:numPr></w:pPr><w:r><w:t>Arrow bullet step 2</w:t></w:r></w:p>

    <w:p><w:r><w:t>Verifying diamond bullet list:</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="4"/></w:numPr></w:pPr><w:r><w:t>Diamond bullet priority A</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="4"/></w:numPr></w:pPr><w:r><w:t>Diamond bullet priority B</w:t></w:r></w:p>

    <w:p><w:r><w:t>Verifying checkmark bullet list:</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="5"/></w:numPr></w:pPr><w:r><w:t>Requirement 1 satisfied</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="5"/></w:numPr></w:pPr><w:r><w:t>Requirement 2 verified</w:t></w:r></w:p>
    <w:p><w:r><w:br w:type="page"/></w:r></w:p>
''');

  // Page 3: Middle Content Page
  docXml.write('''
    <w:p><w:r><w:rPr><w:b/><w:sz w:val="36"/></w:rPr><w:t>Page 3: Middle Content Section</w:t></w:r></w:p>
    <w:p><w:r><w:t>This is page 3 of the multi-page test document. In the original buggy viewer, multi-page documents were cut in half due to scale squared layout calculations, truncating later pages.</w:t></w:r></w:p>
    <w:p><w:r><w:t>With our fix, every single page is fully laid out and rendered smoothly.</w:t></w:r></w:p>
    <w:p><w:r><w:br w:type="page"/></w:r></w:p>
''');

  // Page 4: Fourth Page
  docXml.write('''
    <w:p><w:r><w:rPr><w:b/><w:sz w:val="36"/></w:rPr><w:t>Page 4: Penultimate Section</w:t></w:r></w:p>
    <w:p><w:r><w:t>Almost at the end! Continuing to scroll through page 4 without any white screen issues.</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="1"/></w:numPr></w:pPr><w:r><w:t>Page 4 list item 1</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="1"/></w:numPr></w:pPr><w:r><w:t>Page 4 list item 2</w:t></w:r></w:p>
    <w:p><w:r><w:br w:type="page"/></w:r></w:p>
''');

  // Page 5: Final Page
  docXml.write('''
    <w:p><w:r><w:rPr><w:b/><w:sz w:val="36"/></w:rPr><w:t>Page 5: Final Page Reached</w:t></w:r></w:p>
    <w:p><w:r><w:t>CONGRATULATIONS: You have scrolled all the way to Page 5! The document has finished with all pages visible and zero white screen truncation.</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="5"/></w:numPr></w:pPr><w:r><w:t>All 5 pages fully readable.</w:t></w:r></w:p>
    <w:p><w:pPr><w:numPr><w:ilvl w:val="0"/><w:numId w:val="5"/></w:numPr></w:pPr><w:r><w:t>End of document reached successfully.</w:t></w:r></w:p>
  </w:body>
</w:document>
''');

  void addFile(String name, String content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  }

  addFile('[Content_Types].xml', contentTypes);
  addFile('_rels/.rels', rootRels);
  addFile('word/_rels/document.xml.rels', docRels);
  addFile('word/numbering.xml', numbering);
  addFile('word/document.xml', docXml.toString());

  final zipBytes = ZipEncoder().encode(archive)!;
  File('multipage_bullets.docx').writeAsBytesSync(zipBytes);
  print('Successfully created multipage_bullets.docx (${zipBytes.length} bytes)');
}

