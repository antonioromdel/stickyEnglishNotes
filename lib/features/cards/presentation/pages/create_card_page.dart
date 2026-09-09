import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_collection_palette.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/paper_card.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/models/card_enums.dart';
import '../../../../data/providers.dart';
import '../../../../data/repositories/card_groups_repository.dart';
import '../../../groups/application/groups_providers.dart';
import '../../application/create_card_controller.dart';
import '../../domain/card_draft.dart';
import '../card_type_labels.dart';

class CreateCardPage extends ConsumerStatefulWidget {
  const CreateCardPage({
    super.key,
    this.cardId,
    this.initialGroupId,
  });

  final int? cardId;
  final int? initialGroupId;

  bool get isEditing => cardId != null;

  @override
  ConsumerState<CreateCardPage> createState() => _CreateCardPageState();
}

class _CreateCardPageState extends ConsumerState<CreateCardPage> {
  final _frontController = TextEditingController();
  final _backController = TextEditingController();
  final _exampleController = TextEditingController();
  final _frontFocus = FocusNode();

  FlashcardType _type = FlashcardType.word;
  Set<int> _groupIds = {};
  bool _submitting = false;
  bool _loadingCard = false;
  bool _missingCard = false;
  String? _frontError;
  String? _backError;

  @override
  void initState() {
    super.initState();
    if (widget.initialGroupId != null) {
      _groupIds = {widget.initialGroupId!};
    }
    if (widget.cardId != null) {
      _loadingCard = true;
      _loadCard();
    }
  }

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    _exampleController.dispose();
    _frontFocus.dispose();
    super.dispose();
  }

  Future<void> _loadCard() async {
    final card = await ref.read(flashcardsRepositoryProvider).getById(
      widget.cardId!,
    );
    if (!mounted) return;

    if (card == null) {
      setState(() {
        _loadingCard = false;
        _missingCard = true;
      });
      return;
    }

    _frontController.text = card.front;
    _backController.text = card.back;
    _exampleController.text = card.example ?? '';
    final groupIds = await ref.read(flashcardsRepositoryProvider).getGroupIds(
      card.id,
    );
    if (!mounted) return;

    setState(() {
      _type = card.type;
      _groupIds = groupIds;
      _loadingCard = false;
    });
  }

  Future<void> _save() async {
    final groupsList = ref.read(cardGroupsProvider).maybeWhen(
          data: (value) => value,
          orElse: () => const <CardGroup>[],
        );
    final draft = CardDraft(
      front: _frontController.text,
      back: _backController.text,
      example: _exampleController.text,
      type: _type,
      groupIds: _effectiveGroupIds(groupsList),
      source: CardSource.manual,
    );

    setState(() {
      _frontError = draft.frontError;
      _backError = draft.backError;
    });
    if (!draft.isValid) return;

    setState(() => _submitting = true);
    try {
      final controller = ref.read(createCardControllerProvider);
      if (widget.isEditing) {
        await controller.update(cardId: widget.cardId!, draft: draft);
      } else {
        await controller.create(draft);
      }
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing ? 'Tarjeta actualizada' : 'Tarjeta guardada',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('No se pudo guardar la tarjeta: $error\n$stackTrace');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar la tarjeta.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _toggleGroup(int groupId, List<CardGroup> groups) {
    final selected = {..._effectiveGroupIds(groups)};
    if (selected.contains(groupId)) {
      if (selected.length <= 1) return;
      selected.remove(groupId);
    } else {
      selected.add(groupId);
    }
    setState(() => _groupIds = selected);
  }

  Set<int> _effectiveGroupIds(List<CardGroup> groups) {
    if (_groupIds.isNotEmpty) return _groupIds;
    final defaultId = CardGroupsRepository.defaultIdOf(groups);
    return defaultId == null ? <int>{} : {defaultId};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groups = ref.watch(cardGroupsProvider);
    final groupsList = groups.maybeWhen(
      data: (value) => value,
      orElse: () => const <CardGroup>[],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar tarjeta' : 'Nueva tarjeta'),
      ),
      body: _body(theme, groupsList),
      bottomNavigationBar: _missingCard || _loadingCard
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.sm,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: FilledButton(
                  key: const Key('card-save-button'),
                  onPressed: _submitting ? null : _save,
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(widget.isEditing ? 'Guardar cambios' : 'Guardar'),
                ),
              ),
            ),
    );
  }

  Widget _body(ThemeData theme, List<CardGroup> groups) {
    if (_loadingCard) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_missingCard) {
      return const AppEmptyState(
        icon: Icons.style_outlined,
        title: 'Esta tarjeta ya no existe',
        message: 'Vuelve a la lista e inténtalo de nuevo.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.xxxl,
      ),
      children: [
        Text(
          'Una cara, una idea.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _CardSideField(
          fieldKey: const Key('card-front-field'),
          label: 'Frente',
          hint: 'hello',
          controller: _frontController,
          focusNode: _frontFocus,
          autofocus: !widget.isEditing,
          textInputAction: TextInputAction.next,
          errorText: _frontError,
        ),
        const SizedBox(height: AppSpacing.lg),
        _CardSideField(
          fieldKey: const Key('card-back-field'),
          label: 'Reverso',
          hint: 'hola',
          controller: _backController,
          minLines: 5,
          maxLines: 10,
          textInputAction: TextInputAction.newline,
          errorText: _backError,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Grupos', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _GroupSelector(
          groups: groups,
          selectedIds: _effectiveGroupIds(groups),
          onToggle: (groupId) => _toggleGroup(groupId, groups),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Ejemplo (opcional)', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          key: const Key('card-example-field'),
          controller: _exampleController,
          minLines: 2,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (!_submitting) _save();
          },
          decoration: const InputDecoration(
            hintText: 'She said hello to everyone.',
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Tipo', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _TypeSelector(
          selected: _type,
          onSelected: (type) => setState(() => _type = type),
        ),
      ],
    );
  }
}

class _CardSideField extends StatelessWidget {
  const _CardSideField({
    required this.fieldKey,
    required this.label,
    required this.hint,
    required this.controller,
    required this.textInputAction,
    this.minLines = 1,
    this.maxLines = 3,
    this.focusNode,
    this.autofocus = false,
    this.errorText,
  });

  final Key fieldKey;
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final int minLines;
  final int maxLines;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMultiline = minLines > 1;
    final fieldStyle = isMultiline
        ? theme.textTheme.titleLarge
        : theme.textTheme.headlineMedium;

    return PaperCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          TextField(
            key: fieldKey,
            controller: controller,
            focusNode: focusNode,
            autofocus: autofocus,
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: isMultiline
                ? TextInputType.multiline
                : TextInputType.text,
            style: fieldStyle,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: fieldStyle?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.28),
                fontWeight: FontWeight.w500,
              ),
              errorText: errorText,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: AppSpacing.sm),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupSelector extends StatelessWidget {
  const _GroupSelector({
    required this.groups,
    required this.selectedIds,
    required this.onToggle,
  });

  final List<CardGroup> groups;
  final Set<int> selectedIds;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final group in groups)
          FilterChip(
            key: Key('card-group-chip-${group.id}'),
            label: Text(group.name),
            selected: selectedIds.contains(group.id),
            avatar: CircleAvatar(
              backgroundColor: AppCollectionPalette.forId(
                group.id,
                brightness,
              ).background,
              radius: 8,
            ),
            onSelected: (_) => onToggle(group.id),
          ),
      ],
    );
  }
}

class _TypeSelector extends StatelessWidget {
  const _TypeSelector({
    required this.selected,
    required this.onSelected,
  });

  final FlashcardType selected;
  final ValueChanged<FlashcardType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final type in FlashcardType.values)
          ChoiceChip(
            label: Text(cardTypeLabel(type)),
            selected: selected == type,
            onSelected: (_) => onSelected(type),
          ),
      ],
    );
  }
}
