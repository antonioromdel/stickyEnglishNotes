import 'package:flutter/material.dart';

/// Abre el menú lateral del [Scaffold] principal.
class AppDrawerButton extends StatelessWidget {
  const AppDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('open-drawer-button'),
      tooltip: 'Menú',
      onPressed: () {
        context.findRootAncestorStateOfType<ScaffoldState>()?.openDrawer();
      },
      icon: const Icon(Icons.menu),
    );
  }
}
