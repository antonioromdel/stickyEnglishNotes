import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'repositories/card_errors_repository.dart';
import 'repositories/card_groups_repository.dart';
import 'repositories/flashcards_repository.dart';
import 'repositories/reviews_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final cardGroupsRepositoryProvider = Provider<CardGroupsRepository>((ref) {
  return CardGroupsRepository(ref.watch(appDatabaseProvider));
});

final flashcardsRepositoryProvider = Provider<FlashcardsRepository>((ref) {
  return FlashcardsRepository(ref.watch(appDatabaseProvider));
});

final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  return ReviewsRepository(ref.watch(appDatabaseProvider));
});

final cardErrorsRepositoryProvider = Provider<CardErrorsRepository>((ref) {
  return CardErrorsRepository(ref.watch(appDatabaseProvider));
});
