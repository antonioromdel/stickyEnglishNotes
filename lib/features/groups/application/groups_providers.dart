import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';

final cardGroupsProvider = StreamProvider<List<CardGroup>>((ref) {
  return ref.watch(cardGroupsRepositoryProvider).watchAll();
});
