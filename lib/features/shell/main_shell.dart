import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/navigation/doc_bottom_nav_bar.dart';

/// Main scaffold shell hosting bottom navigation and indexed tab branches.
class MainShell extends StatelessWidget {
  const MainShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      key: const ValueKey('main_shell_pop_scope'),
      canPop: navigationShell.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && navigationShell.currentIndex != 0) {
          navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: DocBottomNavBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onDestinationSelected,
        ),
      ),
    );
  }
}

