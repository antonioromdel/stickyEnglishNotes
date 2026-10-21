import 'package:google_mlkit_translation/google_mlkit_translation.dart';

String translatorLanguageLabel(TranslateLanguage language) {
  return switch (language) {
    TranslateLanguage.afrikaans => 'Afrikáans',
    TranslateLanguage.albanian => 'Albanés',
    TranslateLanguage.arabic => 'Árabe',
    TranslateLanguage.belarusian => 'Bielorruso',
    TranslateLanguage.bengali => 'Bengalí',
    TranslateLanguage.bulgarian => 'Búlgaro',
    TranslateLanguage.catalan => 'Catalán',
    TranslateLanguage.chinese => 'Chino',
    TranslateLanguage.croatian => 'Croata',
    TranslateLanguage.czech => 'Checo',
    TranslateLanguage.danish => 'Danés',
    TranslateLanguage.dutch => 'Neerlandés',
    TranslateLanguage.english => 'Inglés',
    TranslateLanguage.esperanto => 'Esperanto',
    TranslateLanguage.estonian => 'Estonio',
    TranslateLanguage.finnish => 'Finés',
    TranslateLanguage.french => 'Francés',
    TranslateLanguage.galician => 'Gallego',
    TranslateLanguage.georgian => 'Georgiano',
    TranslateLanguage.german => 'Alemán',
    TranslateLanguage.greek => 'Griego',
    TranslateLanguage.gujarati => 'Guyaratí',
    TranslateLanguage.haitian => 'Haitiano',
    TranslateLanguage.hebrew => 'Hebreo',
    TranslateLanguage.hindi => 'Hindi',
    TranslateLanguage.hungarian => 'Húngaro',
    TranslateLanguage.icelandic => 'Islandés',
    TranslateLanguage.indonesian => 'Indonesio',
    TranslateLanguage.irish => 'Irlandés',
    TranslateLanguage.italian => 'Italiano',
    TranslateLanguage.japanese => 'Japonés',
    TranslateLanguage.kannada => 'Canarés',
    TranslateLanguage.korean => 'Coreano',
    TranslateLanguage.latvian => 'Letón',
    TranslateLanguage.lithuanian => 'Lituano',
    TranslateLanguage.macedonian => 'Macedonio',
    TranslateLanguage.malay => 'Malayo',
    TranslateLanguage.maltese => 'Maltés',
    TranslateLanguage.marathi => 'Maratí',
    TranslateLanguage.norwegian => 'Noruego',
    TranslateLanguage.persian => 'Persa',
    TranslateLanguage.polish => 'Polaco',
    TranslateLanguage.portuguese => 'Portugués',
    TranslateLanguage.romanian => 'Rumano',
    TranslateLanguage.russian => 'Ruso',
    TranslateLanguage.slovak => 'Eslovaco',
    TranslateLanguage.slovenian => 'Esloveno',
    TranslateLanguage.spanish => 'Español',
    TranslateLanguage.swahili => 'Suajili',
    TranslateLanguage.swedish => 'Sueco',
    TranslateLanguage.tagalog => 'Tagalo',
    TranslateLanguage.tamil => 'Tamil',
    TranslateLanguage.telugu => 'Telugu',
    TranslateLanguage.thai => 'Tailandés',
    TranslateLanguage.turkish => 'Turco',
    TranslateLanguage.ukrainian => 'Ucraniano',
    TranslateLanguage.urdu => 'Urdu',
    TranslateLanguage.vietnamese => 'Vietnamita',
    TranslateLanguage.welsh => 'Galés',
  };
}

List<TranslateLanguage> sortedTranslatorLanguages() {
  final languages = TranslateLanguage.values.toList()
    ..sort(
      (a, b) =>
          translatorLanguageLabel(a).compareTo(translatorLanguageLabel(b)),
    );
  return languages;
}
