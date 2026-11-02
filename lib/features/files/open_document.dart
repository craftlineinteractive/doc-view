import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/doc_file.dart';
import '../providers/providers.dart';

/// Marks [file] as opened and navigates to the document viewer route.
void openDocument(BuildContext context, WidgetRef ref, DocFile file) {
  ref.read(fileActionsControllerProvider).markOpened(file);
  context.push('/viewer', extra: file);
}
