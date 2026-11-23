// ignore_for_file: prefer_initializing_formals
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Metadata and vector stroke geometry for a user signature stored on disk.
class SavedSignature {
  const SavedSignature({
    required this.id,
    required this.name,
    required this.strokes,
    required this.aspectRatio,
    this.colorValue = 0xFF000000,
    required this.createdAtMs,
    this.width = 200.0,
    this.height = 100.0,
  });

  final String id;
  final String name;
  final List<List<Offset>> strokes;
  final double aspectRatio;
  final int colorValue;
  final int createdAtMs;
  final double width;
  final double height;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'strokes': strokes
            .map((stroke) => stroke.map((p) => [p.dx, p.dy]).toList())
            .toList(),
        'aspectRatio': aspectRatio,
        'colorValue': colorValue,
        'createdAtMs': createdAtMs,
        'width': width,
        'height': height,
      };

  factory SavedSignature.fromMap(Map<String, dynamic> map) {
    final rawStrokes = map['strokes'] as List<dynamic>?;
    final strokes = <List<Offset>>[];
    if (rawStrokes != null) {
      for (final s in rawStrokes) {
        final strokePoints = <Offset>[];
        for (final p in s as List<dynamic>) {
          final pt = p as List<dynamic>;
          strokePoints.add(Offset(
            (pt[0] as num).toDouble(),
            (pt[1] as num).toDouble(),
          ));
        }
        strokes.add(strokePoints);
      }
    }

    return SavedSignature(
      id: map['id'] as String,
      name: map['name'] as String,
      strokes: strokes,
      aspectRatio: (map['aspectRatio'] as num?)?.toDouble() ?? 2.0,
      colorValue: (map['colorValue'] as num?)?.toInt() ?? 0xFF000000,
      createdAtMs: (map['createdAtMs'] as num).toInt(),
      width: (map['width'] as num?)?.toDouble() ?? 200.0,
      height: (map['height'] as num?)?.toDouble() ?? 100.0,
    );
  }
}

/// Secure local repository for saving, listing, and managing vector user signatures.
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

  /// Returns all saved vector signatures sorted from newest to oldest.
  Future<List<SavedSignature>> getSignatures() async {
    final dir = await getSignaturesDirectory();
    final indexFile = _getIndexFile(dir);
    if (!indexFile.existsSync()) return const [];

    try {
      final jsonStr = await indexFile.readAsString();
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final signatures = <SavedSignature>[];
      for (final item in list) {
        signatures.add(SavedSignature.fromMap(item as Map<String, dynamic>));
      }
      return signatures;
    } catch (_) {
      return const [];
    }
  }

  /// Persists a new vector signature with normalized polylines [0..1] x [0..1].
  /// Throws [StateError] if the [maxSavedSignatures] limit is already reached.
  Future<SavedSignature> saveSignature({
    required List<List<Offset>> strokes,
    required double aspectRatio,
    int colorValue = 0xFF000000,
    double width = 200.0,
    double height = 100.0,
  }) async {
    final current = await getSignatures();
    if (current.length >= maxSavedSignatures) {
      throw StateError('Maximum $maxSavedSignatures saved signatures allowed');
    }

    final dir = await getSignaturesDirectory();
    final id = 'sig_${DateTime.now().millisecondsSinceEpoch}';

    // Delete any legacy PNG files in the signatures folder
    try {
      final entities = dir.listSync();
      for (final entity in entities) {
        if (entity is File && entity.path.endsWith('.png')) {
          entity.deleteSync();
        }
      }
    } catch (_) {}

    final signature = SavedSignature(
      id: id,
      name: 'Signature ${current.length + 1}',
      strokes: strokes,
      aspectRatio: aspectRatio,
      colorValue: colorValue,
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

    final remaining = current.where((s) => s.id != id).toList();
    final indexFile = _getIndexFile(dir);
    await indexFile.writeAsString(
      jsonEncode(remaining.map((s) => s.toMap()).toList()),
      flush: true,
    );
  }

  /// Permanently removes all saved signatures and purges any legacy PNG files.
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
