# Sticky English Notes

App móvil de flashcards para aprender inglés. Funciona completamente sin conexión: las tarjetas, las revisiones y las estadísticas viven en el dispositivo.

El objetivo es estudiar rápido, recordar a largo plazo y consultar el progreso sin fricción. La arquitectura está pensada para poder ampliarla más adelante a otros idiomas o materias.

## Características

- **Estudio con repetición espaciada**: voltea la tarjeta, valora (Otra vez / Difícil / Bien / Fácil) y el algoritmo calcula la próxima revisión.
- **Sesiones reanudables**: puedes salir y continuar por donde lo dejaste.
- **Tarjetas propias**: frente, reverso, ejemplo opcional y tipo (palabra, frase u oración).
- **Grupos**: organiza las tarjetas; existe un grupo *General* por defecto.
- **Mis errores**: las respuestas marcadas como *Otra vez* aparecen en una lista para repasar lo que más cuesta.
- **Progreso real**: tarjetas estudiadas, aciertos, fallos, precisión, pendientes, racha y actividad de los últimos 7 días.
- **Pronunciación (TTS)**: voces en inglés (Reino Unido / Estados Unidos) y español.
- **Recordatorios locales**: notificaciones para no olvidar estudiar.
- **Apariencia**: tema claro, oscuro o del sistema.

## Stack

| Área | Tecnología |
| --- | --- |
| UI | Flutter, Dart, Material 3 |
| Estado | Riverpod |
| Navegación | GoRouter |
| Persistencia | Drift + SQLite |
| Preferencias | SharedPreferences |
| Extra | TTS local y notificaciones locales |

No hay backend, autenticación ni sincronización en la nube.

## Requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) con SDK Dart `^3.13.2`
- Un emulador o dispositivo (Android o iOS)

## Cómo ejecutar

```bash
flutter pub get
flutter run
```

Si cambias el esquema de Drift, regenera el código:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Arquitectura

El código se organiza por funcionalidades. La UI no accede a la base de datos: pasa por providers y repositorios.

```text
UI → Controller / Provider → Repository → Database
```

```text
lib/
├── core/          # tema, rutas, widgets y TTS compartidos
├── features/      # home, cards, groups, study, statistics, errors, settings
├── data/          # Drift, tablas y repositorios
└── main.dart
```

Cada feature suele separar `presentation`, `application` y, cuando hace falta, `domain`.

## Sistema de estudio

Una tarjeta está **pendiente** cuando `nextReviewAt` es menor o igual que ahora.

Intervalos iniciales (primera revisión):

| Valoración | Intervalo |
| --- | --- |
| Otra vez | 5 minutos |
| Difícil | 1 día |
| Bien | 2 días |
| Fácil | 4 días |

En revisiones posteriores el intervalo crece según el historial. Esa lógica vive en `SpacedRepetitionService`, no en la pantalla de estudio.

Cada respuesta genera un registro de revisión (tarjeta, resultado, dificultad, fecha e intervalos).

## Base de datos

SQLite local (`sticky_english_notes`) con cuatro tablas:

- `card_groups`
- `flashcards`
- `reviews`
- `card_errors`

Borrar un grupo mueve sus tarjetas a *General*. Borrar una tarjeta elimina en cascada sus revisiones y errores.

## Tests

```bash
flutter analyze
flutter test
```

Hay tests de unidad y de widgets para el SRS, repositorios, estadísticas, formularios y pantallas principales.

## Licencia

Proyecto privado (`publish_to: 'none'`).
