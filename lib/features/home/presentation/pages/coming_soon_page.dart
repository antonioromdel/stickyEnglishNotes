import 'package:flutter/material.dart';

import '../../../../core/widgets/app_drawer_button.dart';
import '../../../../core/widgets/app_empty_state.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({
    super.key,
    required this.title,
    required this.icon,
    this.showMenuButton = true,
  });

  final String title;
  final IconData icon;
  final bool showMenuButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showMenuButton ? const AppDrawerButton() : null,
        title: Text(title),
      ),
      body: AppEmptyState(
        icon: icon,
        title: 'En desarrollo',
        message: 'Esta sección estará disponible más adelante.',
      ),
    );
  }
}
