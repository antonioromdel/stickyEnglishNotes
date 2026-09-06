import 'package:flutter/material.dart';

import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_collection_palette.dart';
import '../../../../data/database/app_database.dart';

class CardsGroupFilterBar extends StatelessWidget {
  const CardsGroupFilterBar({
    super.key,
    required this.groups,
    required this.selectedGroupId,
    required this.onSelected,
  });

  final List<CardGroup> groups;
  final int? selectedGroupId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final selectedGroup = _groupById(selectedGroupId);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Flexible(
            child: OutlinedButton.icon(
              key: const Key('cards-filter-button'),
              onPressed: () => _openGroupPicker(context),
              icon: const Icon(Icons.filter_list),
              label: const Text('Filtrar por grupo'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          if (selectedGroup != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: InputChip(
                  key: const Key('cards-filter-selected'),
                  avatar: CircleAvatar(
                    backgroundColor: AppCollectionPalette.forId(
                      selectedGroup.id,
                      Theme.of(context).brightness,
                    ).background,
                  ),
                  label: Text(
                    selectedGroup.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onDeleted: () => onSelected(null),
                  deleteButtonTooltipMessage: 'Quitar filtro',
                  deleteIconColor: Theme.of(context).colorScheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.sm),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  CardGroup? _groupById(int? groupId) {
    if (groupId == null) return null;
    for (final group in groups) {
      if (group.id == groupId) return group;
    }
    return null;
  }

  Future<void> _openGroupPicker(BuildContext context) async {
    final brightness = Theme.of(context).brightness;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            key: const Key('cards-filter-group-list'),
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
                  'Grupos',
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
              ListTile(
                key: const Key('cards-filter-all'),
                leading: const Icon(Icons.layers_outlined),
                title: const Text('Todas'),
                selected: selectedGroupId == null,
                onTap: () {
                  onSelected(null);
                  Navigator.of(sheetContext).pop();
                },
              ),
              for (final group in groups)
                ListTile(
                  key: Key('cards-filter-group-${group.id}'),
                  leading: CircleAvatar(
                    backgroundColor: AppCollectionPalette.forId(
                      group.id,
                      brightness,
                    ).background,
                    radius: 10,
                  ),
                  title: Text(group.name),
                  selected: selectedGroupId == group.id,
                  onTap: () {
                    onSelected(group.id);
                    Navigator.of(sheetContext).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
