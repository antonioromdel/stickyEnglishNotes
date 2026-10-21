import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_side_menu.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSideMenu(),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Estudiar',
          ),
          NavigationDestination(
            icon: Icon(Icons.translate),
            selectedIcon: Icon(Icons.translate),
            label: 'Traductor',
          ),
          NavigationDestination(
            icon: Icon(Icons.text_snippet_outlined),
            selectedIcon: Icon(Icons.text_snippet),
            label: 'Textos',
          ),
        ],
      ),
    );
  }
}
