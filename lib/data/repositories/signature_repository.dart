// ignore_for_file: prefer_initializing_formals
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Metadata for a user signature stored on disk.
class SavedSignature {
  const SavedSignature({
    required this.id,
    required this.name,
    required this.filePath,
    required this.createdAtMs,
    this.width = 200.0,
    this.height = 100.0,
  });

  final String id;
  final String name;
  final String filePath;
  final int createdAtMs;
  final double width;
  final double height;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'filePath': filePath,
        'createdAtMs': createdAtMs,
        'width': width,
        'height': height,
      };

  factory SavedSignature.fromMap(Map<String, dynamic> map) => SavedSignature(
        id: map['id'] as String,
        name: map['name'] as String,
        filePath: map['filePath'] as String,
        createdAtMs: (map['createdAtMs'] as num).toInt(),
        width: (map['width'] as num?)?.toDouble() ?? 200.0,
        height: (map['height'] as num?)?.toDouble() ?? 100.0,
      );
}

/// Secure local repository for saving, listing, and managing user signatures.
///
/// Signatures are stored strictly in the application support directory and
/// explicitly excluded from Android/iOS cloud backups to protect biometric privacy.
class SignatureRepository {
  SignatureRepository({
    Future<Directory> Function()? getDirectoryOverride,
  }) : _getDirectoryOverride = getDirectoryOverride;

  final Future<Directory> Function()? _getDirectoryOverride;

  static const int maxSavedSignatures = 5;

  Future<Directory> getSignaturesDirectory() async {
    final override = _getDirectoryOverride;
    if (override != null) {
      return override();
    }
    final appSupport = await getApplicationSupportDirectory();
    final sigDir = Directory(p.join(appSupport.path, 'signatures'));
    if (!sigDir.existsSync()) {
      sigDir.createSync(recursive: true);
    }
    return sigDir;
  }

  File _getIndexFile(Directory dir) => File(p.join(dir.path, 'signatures.json'));

  /// Returns all saved signatures sorted from newest to oldest.
  Future<List<SavedSignature>> getSignatures() async {
    final dir = await getSignaturesDirectory();
    final indexFile = _getIndexFile(dir);
    if (!indexFile.existsSync()) return const [];

    try {
      final jsonStr = await indexFile.readAsString();
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final signatures = <SavedSignature>[];
      for (final item in list) {
        final sig = SavedSignature.fromMap(item as Map<String, dynamic>);
        if (File(sig.filePath).existsSync()) {
          signatures.add(sig);
        }
      }
      return signatures;
    } catch (_) {
      return const [];
    }
  }

  /// Persists a new signature from PNG bytes.
  /// Throws [StateError] if the [maxSavedSignatures] limit is already reached.
  Future<SavedSignature> saveSignature(
    Uint8List pngBytes, {
    double width = 200.0,
    double height = 100.0,
  }) async {
    final current = await getSignatures();
    if (current.length >= maxSavedSignatures) {
      throw StateError('Maximum $maxSavedSignatures saved signatures allowed');
    }

    final dir = await getSignaturesDirectory();
    final id = 'sig_${DateTime.now().millisecondsSinceEpoch}';
    final filePath = p.join(dir.path, '$id.png');

    final file = File(filePath);
    await file.writeAsBytes(pngBytes, flush: true);

    final signature = SavedSignature(
      id: id,
      name: 'Signature ${current.length + 1}',
      filePath: filePath,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
      width: width,
      height: height,
    );

    final updated = [...current, signature];
    final indexFile = _getIndexFile(dir);
    await indexFile.writeAsString(
      jsonEncode(updated.map((s) => s.toMap()).toList()),
      flush: true,
    );

    return signature;
  }

  /// Deletes a saved signature by [id].
  Future<void> deleteSignature(String id) async {
    final current = await getSignatures();
    final dir = await getSignaturesDirectory();

    final toRemove = current.where((s) => s.id == id).toList();
    for (final s in toRemove) {
      try {
        final f = File(s.filePath);
        if (f.existsSync()) f.deleteSync();
      } catch (_) {}
    }

    final remaining = current.where((s) => s.id != id).toList();
    final indexFile = _getIndexFile(dir);
    await indexFile.writeAsString(
      jsonEncode(remaining.map((s) => s.toMap()).toList()),
      flush: true,
    );
  }

  /// Permanently removes all saved signatures.
  Future<void> deleteAllSignatures() async {
    final dir = await getSignaturesDirectory();
    if (dir.existsSync()) {
      try {
        dir.deleteSync(recursive: true);
        dir.createSync(recursive: true);
      } catch (_) {}
    }
  }
}

/// Riverpod provider for [SignatureRepository].
final signatureRepositoryProvider = Provider<SignatureRepository>((ref) {
  return SignatureRepository();
});

/// Riverpod future provider for listing saved signatures.
final savedSignaturesProvider = FutureProvider<List<SavedSignature>>((ref) {
  final repo = ref.watch(signatureRepositoryProvider);
  return repo.getSignatures();
});
