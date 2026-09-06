import 'package:flutter/material.dart';

bool needsCompactCardText(String text) {
  return text.trim().contains('\n');
}

class FlashcardFaceText extends StatelessWidget {
  const FlashcardFaceText({
    super.key,
    required this.text,
    this.color,
    this.singleLineFontSize,
    this.adaptToLines = false,
  });

  final String text;
  final Color? color;
  final double? singleLineFontSize;
  final bool adaptToLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final singleLineStyle = theme.textTheme.displaySmall?.copyWith(
      color: color,
      fontSize: singleLineFontSize,
    );
    final multiLineStyle = theme.textTheme.titleLarge?.copyWith(
      color: color,
      height: 1.35,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = adaptToLines &&
            (needsCompactCardText(text) ||
                _exceedsSingleLine(
                  text: text,
                  style: singleLineStyle,
                  maxWidth: constraints.maxWidth,
                ));

        return Text(
          text,
          textAlign: TextAlign.center,
          style: compact ? multiLineStyle : singleLineStyle,
        );
      },
    );
  }
}

bool _exceedsSingleLine({
  required String text,
  required TextStyle? style,
  required double maxWidth,
}) {
  if (maxWidth <= 0 || maxWidth == double.infinity) return false;

  final painter = TextPainter(
    text: TextSpan(text: text, style: style),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: 1,
  )..layout(maxWidth: maxWidth);

  return painter.didExceedMaxLines;
}
