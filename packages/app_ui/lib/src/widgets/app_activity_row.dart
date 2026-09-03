import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_dashed_border.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

enum AppActivityType { event, retake, extra, personal, consult }

extension AppActivityTypeX on AppActivityType {
  String get label => switch (this) {
        AppActivityType.event => 'Событие',
        AppActivityType.retake => 'Пересдача',
        AppActivityType.extra => 'Доп. занятие',
        AppActivityType.personal => 'Личное',
        AppActivityType.consult => 'Консультация',
      };

  Color color(AppColors colors) => switch (this) {
        AppActivityType.event => colors.accent,
        AppActivityType.retake => colors.exam,
        AppActivityType.extra => colors.lecture,
        AppActivityType.personal => colors.warn,
        AppActivityType.consult => colors.lab,
      };

  AppLineIcon get icon => switch (this) {
        AppActivityType.event => AppLineIcon.star,
        AppActivityType.retake => AppLineIcon.alert,
        AppActivityType.extra => AppLineIcon.plus,
        AppActivityType.personal => AppLineIcon.pin,
        AppActivityType.consult => AppLineIcon.message,
      };
}

class AppActivityRow extends StatelessWidget {
  const AppActivityRow({
    required this.type,
    required this.time,
    required this.title,
    super.key,
    this.endTime,
    this.place,
    this.subtitle,
    this.onTap,
  });

  final AppActivityType type;
  final String time;
  final String? endTime;
  final String title;
  final String? place;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = type.color(colors);
    final endText = endTime;
    final meta = [
      place,
      subtitle,
    ].where((value) => value != null && value.isNotEmpty).join(' · ');

    return AppPressable(
      onTap: onTap,
      semanticsLabel: '${type.label}, $time, $title',
      child: AppDashedBorder(
        color: colors.line,
        radius: AppRadius.field,
        strokeWidth: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.field),
          child: ColoredBox(
            color: colors.surface,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: 4, child: ColoredBox(color: tone)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.actionInset,
                        AppSpacing.lg,
                        AppSpacing.actionInset,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: time,
                                  children: [
                                    if (endText != null)
                                      TextSpan(
                                        text: '–$endText',
                                        style: AppText.timeEnd.copyWith(
                                          color: colors.muted2,
                                        ),
                                      ),
                                  ],
                                ),
                                style: AppText.time.copyWith(color: colors.ink),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              _TypePill(type: type, tone: tone),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            title,
                            style: AppText.headline.copyWith(color: colors.ink),
                          ),
                          if (meta.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              meta,
                              style: AppText.caption.copyWith(
                                color: colors.muted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.type, required this.tone});

  final AppActivityType type;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.micro,
      ),
      decoration: BoxDecoration(
        color: colors.tintOf(tone),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLineIconWidget(type.icon, size: AppIconSize.micro, color: tone),
          const SizedBox(width: AppSpacing.xs),
          Text(type.label, style: AppText.micro.copyWith(color: tone)),
        ],
      ),
    );
  }
}
