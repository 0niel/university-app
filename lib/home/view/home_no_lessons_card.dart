import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class HomeNoLessonsCard extends StatelessWidget {
  const HomeNoLessonsCard({required this.hadLessons, super.key});

  final bool hadLessons;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final foreground = colors.ink;
    final muted = colors.mutedDark;
    final title = hadLessons ? l10n.homeAllClassesDone : l10n.dayOffTitle;

    return AppPressable(
      onTap: () => context.go('/schedule'),
      semanticsLabel: '$title. ${l10n.homeOpenWeek}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.brandTint,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const .fromLTRB(14, 14, 12, 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: .center,
                decoration: BoxDecoration(
                  color: colors.brand,
                  shape: .circle,
                ),
                child: AppLineIconWidget(
                  hadLessons ? .check : .spark,
                  size: 24,
                  color: colors.onBrand,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: NinjaText.dialogTitle.copyWith(
                        color: foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.homeOpenWeek,
                      maxLines: 2,
                      overflow: .ellipsis,
                      style: NinjaText.subtext.copyWith(color: muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                alignment: .center,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: .circle,
                ),
                child: AppLineIconWidget(
                  .calendar,
                  size: 20,
                  color: colors.brandInk,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
