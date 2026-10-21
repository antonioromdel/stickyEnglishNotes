import 'package:flutter/material.dart';

class TutorialStep {
  const TutorialStep({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;
}

const tutorialSteps = <TutorialStep>[
  TutorialStep(
    icon: Icons.style_outlined,
    title: 'Tarjetas para recordar',
    body: 'Cada tarjeta tiene un frente y un reverso. Lees el frente, piensas la respuesta y la volteas para comprobarla. Las tarjetas, el estudio y el progreso se guardan en el móvil y funcionan sin conexión.',
  ),
  TutorialStep(
    icon: Icons.home_outlined,
    title: 'El inicio',
    body: 'En Inicio ves cuántas tarjetas tienes pendientes y la racha de días seguidos. El botón grande empieza o continúa la sesión. Desde ahí también puedes crear una tarjeta, abrir Mis tarjetas, Ver grupos y Mis errores. El icono de menú abre el menú lateral.',
  ),
  TutorialStep(
    icon: Icons.add_rounded,
    title: 'Crea una tarjeta',
    body: 'Escribe el frente, el reverso y, si quieres, un ejemplo. Elige el tipo: palabra, frase u oración. Toda tarjeta pertenece al menos a un grupo. Si no eliges otro, queda en General.',
  ),
  TutorialStep(
    icon: Icons.search,
    title: 'Tus tarjetas',
    body: 'En Mis tarjetas solo se ve el frente. Toca una para abrirla, voltéala y, si hace falta, edítala o elimínala. Desliza arriba o abajo para pasar a la siguiente, como en un feed. El buscador mira el frente y el reverso a partir de 3 caracteres. También puedes filtrar por grupo.',
  ),
  TutorialStep(
    icon: Icons.folder_outlined,
    title: 'Los grupos',
    body: 'Los grupos sirven para ordenar, por ejemplo verbos o viajes. Una tarjeta puede estar en varios. Desde un grupo puedes estudiar solo esas tarjetas. Si borras un grupo, las tarjetas que solo estaban ahí pasan a General.',
  ),
  TutorialStep(
    icon: Icons.menu_book_outlined,
    title: 'Una sesión de estudio',
    body: 'La sesión muestra las tarjetas pendientes, una a una. Toca la tarjeta para voltearla. El botón de audio lee el texto en voz alta. Si sales a medias, en Inicio aparece Continuar y retomas por donde ibas. En Estudiar puedes limitar la sesión a un grupo.',
  ),
  TutorialStep(
    icon: Icons.touch_app_outlined,
    title: 'Las tres respuestas',
    body: 'Después de voltear, elige una. No recuerdo cuenta como fallo: la tarjeta vuelve a los 5 minutos y aparece en Mis errores. ¡He acertado! cuenta como acierto y vuelve al día siguiente. ¡Acertado! también es un acierto, pero no entra en el estudio de mañana: se recuerda en 2 días.',
  ),
  TutorialStep(
    icon: Icons.insights_outlined,
    title: 'Errores, progreso y ajustes',
    body: 'Mis errores reúne lo que marcaste como No recuerdo. Puedes quitar una tarjeta de esa lista sin borrarla. En el menú lateral, Progreso muestra precisión, racha y la actividad de los últimos días. Ajustes cambia el tema, la hora del recordatorio y la voz: inglés de Reino Unido o Estados Unidos, y español.',
  ),
];
