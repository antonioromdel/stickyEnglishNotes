import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../application/cards_providers.dart';

class CardsSearchField extends StatelessWidget {
  const CardsSearchField({
    super.key,
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final trimmed = query.trim();
    final showMinLengthHint =
        trimmed.isNotEmpty && trimmed.length < cardSearchMinLength;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: const Key('cards-search-field'),
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: 'Buscar por frente o reverso',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: query.isEmpty
                  ? null
                  : IconButton(
                      key: const Key('cards-search-clear'),
                      tooltip: 'Borrar búsqueda',
                      onPressed: onClear,
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          if (showMinLengthHint) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Escribe al menos $cardSearchMinLength caracteres',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
