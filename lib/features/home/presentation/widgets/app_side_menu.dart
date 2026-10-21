import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_info.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/router/app_routes.dart';

class AppSideMenu extends StatelessWidget {
  const AppSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                    child: Image.asset(
                      'assets/img/logo_stickyNotesEnglish.png',
                      key: const Key('drawer-logo'),
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(AppInfo.name, style: theme.textTheme.titleLarge),
                ],
              ),
            ),
            ListTile(
              key: const Key('drawer-progress'),
              leading: const Icon(Icons.insights_outlined),
              title: const Text('Progreso'),
              onTap: () => _open(context, AppRoutes.progress),
            ),
            ListTile(
              key: const Key('drawer-settings'),
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Ajustes'),
              onTap: () => _open(context, AppRoutes.settings),
            ),
            ListTile(
              key: const Key('drawer-tutorial'),
              leading: const Icon(Icons.school_outlined),
              title: const Text('Tutorial'),
              onTap: () => _open(context, AppRoutes.tutorial),
            ),
            ListTile(
              key: const Key('drawer-rate'),
              leading: const Icon(Icons.star_outline),
              title: const Text('Valóranos'),
              onTap: () => _open(context, AppRoutes.rate),
            ),
          ],
        ),
      ),
    );
  }

  void _open(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.push(route);
  }
}
