import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../../../data/repositories/card_errors_repository.dart';
import '../domain/frequent_card_error.dart';

final frequentCardErrorsProvider =
    StreamProvider<List<FrequentCardError>>((ref) {
  return ref
      .watch(cardErrorsRepositoryProvider)
      .watchAllWithCards()
      .map(groupFrequentErrors);
});

class ErrorsController {
  ErrorsController(this._errors);

  final CardErrorsRepository _errors;

  Future<void> dismissCard(int cardId) {
    return _errors.deleteByCard(cardId);
  }
}

final errorsControllerProvider = Provider<ErrorsController>((ref) {
  return ErrorsController(ref.watch(cardErrorsRepositoryProvider));
});
