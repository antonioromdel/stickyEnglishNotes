import 'dart:math' as math;

import 'package:flutter/material.dart';

class FlipCard extends StatelessWidget {
  const FlipCard({
    super.key,
    required this.isFlipped,
    required this.front,
    required this.back,
    this.onTap,
  });

  final bool isFlipped;
  final Widget front;
  final Widget back;
  final VoidCallback? onTap;

  static const duration = Duration(milliseconds: 320);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: isFlipped ? 1 : 0),
        duration: duration,
        curve: Curves.easeInOutCubic,
        builder: (context, value, child) {
          final angle = value * math.pi;
          final showBack = value > 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: showBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: back,
                  )
                : front,
          );
        },
      ),
    );
  }
}
