import 'package:flutter/widgets.dart';

import '../extensions/l10n_extension.dart';

/// Validation failure reasons for file names.
enum FileNameValidationError {
  empty,
  tooLong,
  reservedName,
  startsWithDot,
  invalidCharacters;

  String localizedMessage(BuildContext context) {
    switch (this) {
      case FileNameValidationError.empty:
        return context.l10n.errorFileNameEmpty;
      case FileNameValidationError.tooLong:
        return context.l10n.errorFileNameTooLong;
      case FileNameValidationError.reservedName:
        return context.l10n.errorFileNameReserved;
      case FileNameValidationError.startsWithDot:
        return context.l10n.errorFileNameStartsWithDot;
      case FileNameValidationError.invalidCharacters:
        return context.l10n.errorFileNameInvalidChars;
    }
  }
}

/// Typed reasons for file rename operation failures.
enum RenameFailureReason {
  validation,
  alreadyExists,
  sourceNotFound,
  ioError;

  String localizedMessage(
    BuildContext context, {
    FileNameValidationError? validationError,
    String? details,
  }) {
    switch (this) {
      case RenameFailureReason.validation:
        return validationError?.localizedMessage(context) ??
            context.l10n.errorFileNameInvalidChars;
      case RenameFailureReason.alreadyExists:
        return context.l10n.errorRenameAlreadyExists;
      case RenameFailureReason.sourceNotFound:
        return context.l10n.errorRenameSourceNotFound;
      case RenameFailureReason.ioError:
        return context.l10n.errorRenameFailed(details ?? '');
    }
  }
}

/// Typed reasons for batch file deletion failures.
enum DeleteFailureReason {
  databaseUpdateFailed,
  ioError;

  String localizedMessage(BuildContext context, {String? details}) {
    switch (this) {
      case DeleteFailureReason.databaseUpdateFailed:
        return context.l10n.errorDeleteDatabaseFailed;
      case DeleteFailureReason.ioError:
        return context.l10n.errorDeleteFailed(details ?? '');
    }
  }
}

/// Typed reasons for page range parsing failures.
enum PageRangeErrorReason {
  documentHasNoPages,
  empty,
  emptySegment,
  invalidFormat,
  incompleteRange,
  nonNumeric,
  belowMinimum,
  reversedRange,
  exceedsPageCount,
  invalidPageNumber;

  String localizedMessage(
    BuildContext context, {
    String? token,
    int? start,
    int? end,
    int? totalPages,
  }) {
    switch (this) {
      case PageRangeErrorReason.documentHasNoPages:
        return context.l10n.errorPageRangeDocNoPages;
      case PageRangeErrorReason.empty:
        return context.l10n.errorPageRangeEmpty;
      case PageRangeErrorReason.emptySegment:
        return context.l10n.errorPageRangeEmptySegment;
      case PageRangeErrorReason.invalidFormat:
        return context.l10n.errorPageRangeInvalidFormat(token ?? '');
      case PageRangeErrorReason.incompleteRange:
        return context.l10n.errorPageRangeIncomplete(token ?? '');
      case PageRangeErrorReason.nonNumeric:
        return context.l10n.errorPageRangeNonNumeric(token ?? '');
      case PageRangeErrorReason.belowMinimum:
        return context.l10n.errorPageRangeBelowMinimum;
      case PageRangeErrorReason.reversedRange:
        return context.l10n.errorPageRangeReversed(start ?? 0, end ?? 0);
      case PageRangeErrorReason.exceedsPageCount:
        return context.l10n.errorPageRangeExceeds(token ?? '', totalPages ?? 0);
      case PageRangeErrorReason.invalidPageNumber:
        return context.l10n.errorPageRangeInvalidNumber(token ?? '');
    }
  }
}

/// Typed reasons for image-to-PDF conversion failures.
enum ImageToPdfErrorReason {
  noImages,
  maxImagesExceeded,
  processingFailed,
  generationFailed;

  String localizedMessage(
    BuildContext context, {
    int? maxCount,
    String? failedPath,
    String? details,
  }) {
    switch (this) {
      case ImageToPdfErrorReason.noImages:
        return context.l10n.errorImageToPdfNoImages;
      case ImageToPdfErrorReason.maxImagesExceeded:
        return context.l10n.errorImageToPdfMaxExceeded(maxCount ?? 100);
      case ImageToPdfErrorReason.processingFailed:
        return context.l10n.errorImageToPdfProcessingFailed(failedPath ?? '');
      case ImageToPdfErrorReason.generationFailed:
        return context.l10n.errorImageToPdfGenerationFailed(details ?? '');
    }
  }
}

/// Typed reasons for PDF merge failures.
enum PdfMergeErrorReason {
  insufficientFiles,
  passwordProtectedOrDamaged,
  noPages,
  mergeFailed;

  String localizedMessage(
    BuildContext context, {
    String? fileName,
    String? details,
  }) {
    switch (this) {
      case PdfMergeErrorReason.insufficientFiles:
        return context.l10n.errorPdfMergeInsufficient;
      case PdfMergeErrorReason.passwordProtectedOrDamaged:
        return context.l10n.errorPdfMergeDamagedOrEncrypted(fileName ?? '');
      case PdfMergeErrorReason.noPages:
        return context.l10n.errorPdfMergeNoPages;
      case PdfMergeErrorReason.mergeFailed:
        return context.l10n.errorPdfMergeFailed(details ?? '');
    }
  }
}

/// Typed reasons for PDF split failures.
enum PdfSplitErrorReason {
  noRangesSpecified,
  passwordProtectedOrDamaged,
  rangeOutOfBounds,
  splitFailed;

  String localizedMessage(
    BuildContext context, {
    String? fileName,
    int? start,
    int? end,
    String? details,
  }) {
    switch (this) {
      case PdfSplitErrorReason.noRangesSpecified:
        return context.l10n.errorPdfSplitNoRanges;
      case PdfSplitErrorReason.passwordProtectedOrDamaged:
        return context.l10n.errorPdfSplitDamagedOrEncrypted(fileName ?? '');
      case PdfSplitErrorReason.rangeOutOfBounds:
        return context.l10n.errorPdfSplitRangeOutOfBounds(
          start ?? 0,
          end ?? 0,
          fileName ?? '',
        );
      case PdfSplitErrorReason.splitFailed:
        return context.l10n.errorPdfSplitFailed(details ?? '');
    }
  }
}

/// Typed reasons for PDF page edit operation failures.
enum PdfPageEditErrorReason {
  sourceFileNotFound,
  passwordProtectedOrCorrupt,
  allPagesDeleted,
  saveFailed,
  unsupportedSourcePage;

  String localizedMessage(BuildContext context, {String? details}) {
    switch (this) {
      case PdfPageEditErrorReason.sourceFileNotFound:
        return context.l10n.errorRenameSourceNotFound;
      case PdfPageEditErrorReason.passwordProtectedOrCorrupt:
        return context.l10n.pagesErrorUnreadable;
      case PdfPageEditErrorReason.allPagesDeleted:
        return context.l10n.pagesDeleteAllBlocked;
      case PdfPageEditErrorReason.saveFailed:
        return context.l10n.errorRenameFailed(details ?? '');
      case PdfPageEditErrorReason.unsupportedSourcePage:
        return context.l10n.pagesErrorUnreadable;
    }
  }
}

/// Categorized failure reasons for PDF annotation operations (Phase G5a).
enum PdfAnnotationErrorReason {
  sourceFileNotFound,
  passwordProtected,
  corruptDocument,
  signedDocumentReplaceBlocked,
  tooManyStrokes,
  tooManyTextBoxes,
  textBoxTooLong,
  saveFailed;

  String localizedMessage(BuildContext context, {String? details}) {
    switch (this) {
      case PdfAnnotationErrorReason.sourceFileNotFound:
        return context.l10n.errorRenameSourceNotFound;
      case PdfAnnotationErrorReason.passwordProtected:
        return context.l10n.annotateErrorPasswordProtected;
      case PdfAnnotationErrorReason.corruptDocument:
        return context.l10n.annotateErrorCorrupt;
      case PdfAnnotationErrorReason.signedDocumentReplaceBlocked:
        return context.l10n.annotateSignedReplaceBlocked;
      case PdfAnnotationErrorReason.tooManyStrokes:
        return context.l10n.annotateErrorTooManyStrokes;
      case PdfAnnotationErrorReason.tooManyTextBoxes:
        return context.l10n.addTextErrorTooManyBoxes;
      case PdfAnnotationErrorReason.textBoxTooLong:
        return context.l10n.addTextErrorBoxTooLong;
      case PdfAnnotationErrorReason.saveFailed:
        return context.l10n.annotateErrorSaveFailed(details ?? '');
    }
  }
}

/// Typed exception thrown by PDF annotation operations.
class PdfAnnotationException implements Exception {
  final PdfAnnotationErrorReason reason;
  final String? message;

  const PdfAnnotationException(this.reason, [this.message]);

  @override
  String toString() => 'PdfAnnotationException($reason, $message)';
}

/// Exception thrown by PDF page editing operations.
class PdfPageEditException implements Exception {
  final PdfPageEditErrorReason reason;
  final String? message;

  const PdfPageEditException(this.reason, [this.message]);

  @override
  String toString() => 'PdfPageEditException($reason, $message)';
}

/// Categorized failure reasons for PDF printing operations.
enum PrintPdfErrorReason {
  fileNotFound,
  fileTooLarge,
  unreadablePdf,
  passwordProtected,
  printFailed;

  String localizedMessage(BuildContext context) {
    switch (this) {
      case PrintPdfErrorReason.fileNotFound:
        return context.l10n.errorRenameSourceNotFound;
      case PrintPdfErrorReason.fileTooLarge:
        return context.l10n.printPdfErrorTooLarge;
      case PrintPdfErrorReason.unreadablePdf:
        return context.l10n.printPdfErrorUnreadable;
      case PrintPdfErrorReason.passwordProtected:
        return context.l10n.printPdfErrorPassword;
      case PrintPdfErrorReason.printFailed:
        return context.l10n.printPdfErrorFailed;
    }
  }
}

/// Typed exception thrown during PDF printing flow.
class PrintPdfException implements Exception {
  final PrintPdfErrorReason reason;
  final String? message;

  const PrintPdfException(this.reason, [this.message]);

  @override
  String toString() => 'PrintPdfException($reason, $message)';
}

/// Categorized failure reasons for Recycle bin operations.
enum TrashErrorReason {
  fileMissing,
  tooLarge,
  notEnoughSpace,
  copyFailed,
  verifyFailed,
  deleteOriginalFailed,
  restoreTargetUnavailable,
  databaseFailed,
  unknown;

  String localizedMessage(BuildContext context, {String? details}) {
    switch (this) {
      case TrashErrorReason.fileMissing:
        return context.l10n.errorRenameSourceNotFound;
      case TrashErrorReason.tooLarge:
        return context.l10n.trashErrorTooLarge;
      case TrashErrorReason.notEnoughSpace:
        return context.l10n.trashErrorNotEnoughSpace;
      case TrashErrorReason.copyFailed:
      case TrashErrorReason.verifyFailed:
      case TrashErrorReason.deleteOriginalFailed:
      case TrashErrorReason.restoreTargetUnavailable:
      case TrashErrorReason.databaseFailed:
      case TrashErrorReason.unknown:
        return context.l10n.trashErrorGeneric(details ?? '');
    }
  }
}

/// Typed exception thrown during Recycle bin operations.
class TrashException implements Exception {
  final TrashErrorReason reason;
  final String? message;

  const TrashException(this.reason, [this.message]);

  @override
  String toString() => 'TrashException($reason, $message)';
}


