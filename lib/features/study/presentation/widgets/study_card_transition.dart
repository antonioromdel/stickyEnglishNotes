import 'package:flutter/material.dart';

/// Pasa de una tarjeta a la siguiente con un deslizamiento corto y un fundido.
class StudyCardTransition extends StatelessWidget {
  const StudyCardTransition({
    super.key,
    required this.cardId,
    required this.child,
  });

  final int cardId;
  final Widget child;

  static const duration = Duration(milliseconds: 320);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        final incoming = child.key == ValueKey<int>(cardId);
        final slide = Tween<Offset>(
          begin: incoming ? const Offset(0.22, 0) : const Offset(-0.16, 0),
          end: Offset.zero,
        ).animate(animation);

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: KeyedSubtree(key: ValueKey<int>(cardId), child: child),
    );
  }
}
