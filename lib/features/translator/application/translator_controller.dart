import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import 'mlkit_translator_engine.dart';

class TranslatorView {
  const TranslatorView({
    required this.source,
    required this.target,
    required this.input,
    required this.output,
    required this.loading,
    this.error,
  });

  final TranslateLanguage source;
  final TranslateLanguage target;
  final String input;
  final String output;
  final bool loading;
  final String? error;

  TranslatorView copyWith({
    TranslateLanguage? source,
    TranslateLanguage? target,
    String? input,
    String? output,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return TranslatorView(
      source: source ?? this.source,
      target: target ?? this.target,
      input: input ?? this.input,
      output: output ?? this.output,
      loading: loading ?? this.loading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

final translatorDebounceProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 350),
);

class TranslatorController extends Notifier<TranslatorView> {
  Timer? _debounce;
  int _generation = 0;

  @override
  TranslatorView build() {
    ref.onDispose(() => _debounce?.cancel());
    return const TranslatorView(
      source: TranslateLanguage.spanish,
      target: TranslateLanguage.english,
      input: '',
      output: '',
      loading: false,
    );
  }

  void setInput(String value) {
    state = state.copyWith(input: value, clearError: true);
    _schedule();
  }

  void setSource(TranslateLanguage language) {
    if (language == state.target) {
      state = state.copyWith(source: language, target: state.source);
    } else {
      state = state.copyWith(source: language);
    }
    _schedule();
  }

  void setTarget(TranslateLanguage language) {
    if (language == state.source) {
      state = state.copyWith(target: language, source: state.target);
    } else {
      state = state.copyWith(target: language);
    }
    _schedule();
  }

  void swapLanguages() {
    state = state.copyWith(source: state.target, target: state.source);
    _schedule();
  }

  void clear() {
    _debounce?.cancel();
    _generation++;
    state = state.copyWith(
      input: '',
      output: '',
      loading: false,
      clearError: true,
    );
  }

  void _schedule() {
    _debounce?.cancel();
    final text = state.input.trim();
    if (text.isEmpty) {
      _generation++;
      state = state.copyWith(output: '', loading: false, clearError: true);
      return;
    }

    state = state.copyWith(loading: true, clearError: true);
    _debounce = Timer(ref.read(translatorDebounceProvider), _translate);
  }

  Future<void> _translate() async {
    final generation = ++_generation;
    final current = state;
    final text = current.input;

    try {
      final result = await ref
          .read(translatorEngineProvider)
          .translate(
            text: text,
            source: current.source,
            target: current.target,
          );
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(output: result, loading: false, clearError: true);
    } on Object catch (error, stackTrace) {
      debugPrint('No se pudo traducir: $error\n$stackTrace');
      if (!ref.mounted || generation != _generation) return;
      state = state.copyWith(
        loading: false,
        error: 'No se pudo traducir. La primera vez necesitas conexión para descargar el idioma.',
      );
    }
  }
}

final translatorControllerProvider =
    NotifierProvider<TranslatorController, TranslatorView>(
      TranslatorController.new,
    );
