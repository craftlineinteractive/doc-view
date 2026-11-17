import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../core/errors/app_errors.dart';
import '../../core/utils/file_name_utils.dart';
import '../models/doc_file.dart';
import '../repositories/file_repository.dart';

/// Result types for file rename operations.
sealed class RenameResult {
  const RenameResult();
}

class RenameSuccess extends RenameResult {
  final DocFile updatedFile;
  const RenameSuccess(this.updatedFile);
}

class RenameFailure extends RenameResult {
  final RenameFailureReason reason;
  final FileNameValidationError? validationError;
  final String? details;

  const RenameFailure({
    required this.reason,
    this.validationError,
    this.details,
  });

  /// Backward-compatible string message.
  String get errorMessage => reason.name;

  String localizedMessage(BuildContext context) =>
      reason.localizedMessage(context, validationError: validationError, details: details);
}

/// Result of batch file deletion.
class DeleteResult {
  final int deletedCount;
  final int failedCount;
  final DeleteFailureReason? errorReason;
  final String? details;

  const DeleteResult({
    required this.deletedCount,
    required this.failedCount,
    this.errorReason,
    this.details,
  });

  /// Backward-compatible string message.
  String? get errorMessage => errorReason?.name;

  bool get isFullSuccess => failedCount == 0 && deletedCount > 0;
  bool get hasDeletions => deletedCount > 0;

  String? localizedMessage(BuildContext context) =>
      errorReason?.localizedMessage(context, details: details);
}

/// Service performing safe physical and database file operations.
class FileOperationsService {
  FileOperationsService({required this.repository});

  final FileRepository repository;

  /// Renames [file] on disk and in SQLite with [newBaseName] (without extension).
  ///
  /// Preserves the original file extension. Validates the candidate name,
  /// checks for target collision, and falls back to copy+delete if cross-device move occurs.
  Future<RenameResult> rename(DocFile file, String newBaseName) async {
    try {
      final validationError = validateFileName(newBaseName);
      if (validationError != null) {
        return RenameFailure(
          reason: RenameFailureReason.validation,
          validationError: validationError,
        );
      }

      final newPath = buildRenamedPath(file.path, newBaseName);
      if (newPath == file.path) {
        return RenameSuccess(file);
      }

      final targetFile = File(newPath);
      if (await targetFile.exists()) {
        return const RenameFailure(reason: RenameFailureReason.alreadyExists);
      }

      final oldFile = File(file.path);
      if (!await oldFile.exists()) {
        return const RenameFailure(reason: RenameFailureReason.sourceNotFound);
      }

      try {
        await oldFile.rename(newPath);
      } catch (e) {
        // Fallback for cross-device or permission-constrained rename: copy then delete original
        try {
          await oldFile.copy(newPath);
          await oldFile.delete();
        } catch (copyErr) {
          return RenameFailure(
            reason: RenameFailureReason.ioError,
            details: copyErr.toString(),
          );
        }
      }

      final newName = p.basename(newPath);
      if (file.id != null) {
        await repository.updatePath(file.id!, newPath, newName);
      }

      final updatedDoc = file.copyWith(
        path: newPath,
        name: newName,
        modified: DateTime.now(),
      );

      return RenameSuccess(updatedDoc);
    } catch (e) {
      return RenameFailure(
        reason: RenameFailureReason.ioError,
        details: e.toString(),
      );
    }
  }

  /// Deletes multiple [files] from disk and removes database rows ONLY for
  /// files successfully deleted or already missing on disk.
  Future<DeleteResult> delete(List<DocFile> files) async {
    if (files.isEmpty) {
      return const DeleteResult(deletedCount: 0, failedCount: 0);
    }

    final successfulIds = <int>[];
    var failedCount = 0;

    for (final file in files) {
      try {
        final ioFile = File(file.path);
        if (await ioFile.exists()) {
          await ioFile.delete();
        }
        if (file.id != null) {
          successfulIds.add(file.id!);
        }
      } catch (e) {
        failedCount++;
      }
    }

    if (successfulIds.isNotEmpty) {
      try {
        await repository.deleteByIds(successfulIds);
      } catch (e) {
        return DeleteResult(
          deletedCount: successfulIds.length,
          failedCount: failedCount,
          errorReason: DeleteFailureReason.databaseUpdateFailed,
          details: e.toString(),
        );
      }
    }

    return DeleteResult(
      deletedCount: successfulIds.length,
      failedCount: failedCount,
    );
  }

  /// Shares one or more [files] via the system share sheet.
  Future<void> share(List<DocFile> files) async {
    if (files.isEmpty) return;
    try {
      final xFiles = files
          .where((f) => File(f.path).existsSync())
          .map((f) => XFile(f.path))
          .toList();

      if (xFiles.isEmpty) return;

      await SharePlus.instance.share(
        ShareParams(
          files: xFiles,
        ),
      );
    } catch (_) {
      // Ignored: non-fatal if user dismisses share dialog or system rejects
    }
  }
}
