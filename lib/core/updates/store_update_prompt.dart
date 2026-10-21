import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../router/app_router.dart';
import 'store_update.dart';

/// Al entrar, si Play tiene una versión nueva, pide actualizar.
class StoreUpdatePrompt extends ConsumerStatefulWidget {
  const StoreUpdatePrompt({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<StoreUpdatePrompt> createState() => _StoreUpdatePromptState();
}

class _StoreUpdatePromptState extends ConsumerState<StoreUpdatePrompt> {
  var _checked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    if (_checked || !mounted) return;
    _checked = true;

    final available = await ref
        .read(storeUpdateCheckerProvider)
        .isUpdateAvailable();
    if (!mounted || !available) return;

    final overlay = ref.read(rootNavigatorKeyProvider).currentState?.overlay;
    final dialogContext = overlay?.context;
    if (dialogContext == null || !dialogContext.mounted) return;

    await showDialog<void>(
      context: dialogContext,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva versión'),
          content: const Text(
            'Hay una versión nueva en Google Play. Puedes actualizarla ahora.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ahora no'),
            ),
            FilledButton(
              key: const Key('store-update-button'),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(storeListingProvider).open();
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
