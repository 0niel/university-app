import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/schedule/widgets/ninja_schedule_surface.dart';
import 'package:rtu_mirea_app/schedule_diff/widgets/schedule_diff_item_card.dart';
import 'package:schedule/schedule.dart';

class ScheduleDiffSection extends StatelessWidget {
  const ScheduleDiffSection({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.items,
    super.key,
  });

  final String title;
  final String subtitle;
  final Color color;
  final AppLineIcon icon;
  final List<LessonChangeDetail> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final scale = Theme.of(context).scale;
    return SliverToBoxAdapter(
      child: Container(
        margin: .symmetric(
          horizontal: NinjaMetrics.screenPadding,
          vertical: scale.space(12),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            NinjaScheduleSurface(
              padding: .all(scale.space(16)),
              child: Row(
                children: [
                  Container(
                    width: scale.size(NinjaMetrics.minTouchTarget),
                    height: scale.size(NinjaMetrics.minTouchTarget),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: AppLineIconWidget(icon, color: color, size: 21),
                  ),
                  SizedBox(width: scale.space(16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          title,
                          style: NinjaText.headline.copyWith(
                            color: colors.ink,
                            fontWeight: .bold,
                          ),
                        ),
                        SizedBox(height: scale.space(8)),
                        Text(
                          subtitle,
                          style: NinjaText.body.copyWith(color: colors.muted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: scale.space(8)),
            Column(
              children: items.asMap().entries.expand((entry) {
                final index = entry.key;
                final item = entry.value;
                return [
                  ScheduleDiffItemCard(
                    detail: item,
                    isLast: index == items.length - 1,
                  ),
                  if (index != items.length - 1)
                    SizedBox(height: scale.space(8)),
                ];
              }).toList(),
            ),
            SizedBox(height: scale.space(24)),
          ],
        ),
      ),
    );
  }
}
