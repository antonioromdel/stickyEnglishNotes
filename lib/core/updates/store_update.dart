import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_info.dart';

/// Consulta si Google Play tiene una versión más nueva.
///
/// Solo responde cuando la app está instalada desde Play. En una APK
/// instalada a mano, o si Play no contesta, devuelve false.
abstract class StoreUpdateChecker {
  const StoreUpdateChecker();

  Future<bool> isUpdateAvailable();
}

class PlayStoreUpdateChecker extends StoreUpdateChecker {
  const PlayStoreUpdateChecker();

  @override
  Future<bool> isUpdateAvailable() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }

    try {
      final info = await InAppUpdate.checkForUpdate();
      return info.updateAvailability == UpdateAvailability.updateAvailable;
    } on Object catch (error, stackTrace) {
      debugPrint(
        'No se pudo comprobar si hay una versión nueva: $error\n$stackTrace',
      );
      return false;
    }
  }
}

class UnavailableStoreUpdate extends StoreUpdateChecker {
  const UnavailableStoreUpdate();

  @override
  Future<bool> isUpdateAvailable() async => false;
}

/// Abre la ficha de la app en Google Play.
class StoreListing {
  const StoreListing();

  Future<void> open() async {
    final market = Uri.parse('market://details?id=${AppInfo.androidPackageId}');
    final web = Uri.parse(
      'https://play.google.com/store/apps/details?id=${AppInfo.androidPackageId}',
    );

    try {
      final openedMarket = await launchUrl(
        market,
        mode: LaunchMode.externalApplication,
      );
      if (openedMarket) return;
      await launchUrl(web, mode: LaunchMode.externalApplication);
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudo abrir Google Play: $error\n$stackTrace');
    }
  }
}

final storeUpdateCheckerProvider = Provider<StoreUpdateChecker>(
  (ref) => const PlayStoreUpdateChecker(),
);

final storeListingProvider = Provider<StoreListing>(
  (ref) => const StoreListing(),
);
