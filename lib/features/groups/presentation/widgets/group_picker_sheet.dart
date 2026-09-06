import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_collection_palette.dart';
import '../../../../data/database/app_database.dart';

class GroupPickerResult {
  const GroupPickerResult({required this.groupId});

  final int? groupId;
}

Future<GroupPickerResult?> showGroupPickerSheet({
  required BuildContext context,
  required List<CardGroup> groups,
  int? selectedGroupId,
  bool includeAllOption = false,
  String title = 'Grupo',
}) {
  final brightness = Theme.of(context).brightness;

  return showModalBottomSheet<GroupPickerResult>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: ListView(
          key: const Key('group-picker-list'),
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(
                title,
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
            ),
            if (includeAllOption)
              ListTile(
                key: const Key('group-picker-all'),
                leading: const Icon(Icons.layers_outlined),
                title: const Text('Todas'),
                selected: selectedGroupId == null,
                onTap: () => Navigator.of(sheetContext).pop(
                  const GroupPickerResult(groupId: null),
                ),
              ),
            for (final group in groups)
              ListTile(
                key: Key('group-picker-${group.id}'),
                leading: CircleAvatar(
                  backgroundColor: AppCollectionPalette.forId(
                    group.id,
                    brightness,
                  ).background,
                  radius: 10,
                ),
                title: Text(group.name),
                selected: selectedGroupId == group.id,
                onTap: () => Navigator.of(sheetContext).pop(
                  GroupPickerResult(groupId: group.id),
                ),
              ),
          ],
        ),
      );
    },
  );
}
