/// Tipo de contenido de la flashcard.
enum FlashcardType { word, phrase, sentence }

/// Dificultad general percibida de la tarjeta (no es la valoración de una revisión).
enum CardDifficulty { easy, normal, hard }

/// Origen de la tarjeta. Permite distinguir más adelante errores, IA o importaciones.
enum CardSource { manual, mistake, ai, imported }

/// Valoración de una revisión concreta (Again / Hard / Good / Easy).
enum ReviewRating { again, hard, good, easy }

/// Resultado derivado de una revisión, usado en estadísticas.
enum ReviewResult { correct, incorrect }
