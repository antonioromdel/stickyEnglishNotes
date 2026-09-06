import 'package:flutter/material.dart';

import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/study_stats.dart';

class DailyActivityChart extends StatelessWidget {
  const DailyActivityChart({super.key, required this.days});

  final List<DailyActivity> days;

  static const _weekdayLabels = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final maxCount = days.fold<int>(
      0,
      (current, day) => day.reviewCount > current ? day.reviewCount : current,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final day in days)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 96,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: 18,
                        height: _barHeight(day.reviewCount, maxCount),
                        decoration: BoxDecoration(
                          color: day.reviewCount == 0
                              ? scheme.primary.withValues(alpha: 0.16)
                              : scheme.primary,
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _weekdayLabels[day.day.weekday - 1],
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  double _barHeight(int count, int maxCount) {
    if (maxCount == 0 || count == 0) return 8;
    return 8 + (88 * (count / maxCount));
  }
}
