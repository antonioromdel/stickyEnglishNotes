import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stickeenglishnotes/core/router/app_router.dart';
import 'package:stickeenglishnotes/core/updates/store_update.dart';
import 'package:stickeenglishnotes/core/updates/store_update_prompt.dart';

class _UpdateAvailable extends StoreUpdateChecker {
  const _UpdateAvailable();

  @override
  Future<bool> isUpdateAvailable() async => true;
}

class _RecordingListing extends StoreListing {
  int opens = 0;

  @override
  Future<void> open() async {
    opens += 1;
  }
}

void main() {
  testWidgets('avisa y abre la tienda al pulsar Actualizar', (tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    final listing = _RecordingListing();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          rootNavigatorKeyProvider.overrideWith((ref) => navigatorKey),
          storeUpdateCheckerProvider.overrideWith(
            (ref) => const _UpdateAvailable(),
          ),
          storeListingProvider.overrideWith((ref) => listing),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          home: const StoreUpdatePrompt(child: Text('Inicio')),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Nueva versión'), findsOneWidget);
    expect(find.text('Actualizar'), findsOneWidget);

    await tester.tap(find.byKey(const Key('store-update-button')));
    await tester.pump();

    expect(listing.opens, 1);
    expect(find.text('Nueva versión'), findsNothing);
  });

  testWidgets('no muestra la ventana si Play no tiene versión nueva', (
    tester,
  ) async {
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          rootNavigatorKeyProvider.overrideWith((ref) => navigatorKey),
          storeUpdateCheckerProvider.overrideWith(
            (ref) => const UnavailableStoreUpdate(),
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          home: const StoreUpdatePrompt(child: Text('Inicio')),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Nueva versión'), findsNothing);
    expect(find.text('Inicio'), findsOneWidget);
  });
}
