import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../data/database/app_database.dart';
import '../../../data/repositories/card_groups_repository.dart';
import '../application/groups_controller.dart';
import 'widgets/group_name_dialog.dart';

Future<void> createGroup(BuildContext context, WidgetRef ref) async {
  final name = await showGroupNameDialog(
    context: context,
    title: 'Nuevo grupo',
    confirmLabel: 'Crear',
  );
  if (name == null) return;

  try {
    await ref.read(groupsControllerProvider).create(name: name);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grupo creado'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('No se pudo crear el grupo: $error\n$stackTrace');
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo crear el grupo.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

Future<void> renameGroup(
  BuildContext context,
  WidgetRef ref,
  CardGroup group,
) async {
  final name = await showGroupNameDialog(
    context: context,
    title: 'Renombrar grupo',
    initialName: group.name,
  );
  if (name == null) return;

  try {
    await ref.read(groupsControllerProvider).rename(id: group.id, name: name);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grupo actualizado'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('No se pudo renombrar el grupo: $error\n$stackTrace');
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo renombrar el grupo.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

Future<bool> deleteGroup(
  BuildContext context,
  WidgetRef ref,
  CardGroup group,
) async {
  final confirmed = await showAppConfirmDialog(
    context: context,
    title: 'Eliminar ${group.name}',
    message:
        'Si una tarjeta solo está en este grupo, pasará a ${CardGroupsRepository.defaultName}. Si está en más grupos, se quedará en ellos.',
  );
  if (!confirmed) return false;

  try {
    await ref.read(groupsControllerProvider).delete(group.id);
    if (!context.mounted) return true;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grupo eliminado'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return true;
  } catch (error, stackTrace) {
    debugPrint('No se pudo eliminar el grupo: $error\n$stackTrace');
    if (!context.mounted) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo eliminar el grupo.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return false;
  }
}

Future<void> showGroupActionsSheet(
  BuildContext context,
  WidgetRef ref,
  CardGroup group,
) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const Key('group-action-rename'),
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Renombrar'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                renameGroup(context, ref, group);
              },
            ),
            if (!CardGroupsRepository.isDefault(group))
              ListTile(
                key: const Key('group-action-delete'),
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(sheetContext).colorScheme.error,
                ),
                title: const Text('Eliminar'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  deleteGroup(context, ref, group);
                },
              ),
          ],
        ),
      );
    },
  );
}
