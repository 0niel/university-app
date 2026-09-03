import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/schedule/view/session/session_exam.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({
    required this.exam,
    required this.readiness,
    required this.onTap,
    super.key,
  });

  final SessionExam exam;
  final double readiness;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = readiness >= .8
        ? colors.lecture
        : readiness >= .5
        ? colors.warn
        : colors.danger;
    return AppCard(
      radius: AppRadius.row,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sectionGap,
      ),
      child: Row(
        children: [
          AppIconTile(
            size: 48,
            radius: AppRadius.banner,
            background: colors.tintOf(exam.color),
            foreground: exam.color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${exam.days}', style: AppText.metric),
                Text(context.l10n.examsDaysShort, style: AppText.gridTag),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sectionGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.subject,
                  style: AppText.headlineStrong.copyWith(color: colors.ink),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  [
                    exam.typeName,
                    DateFormat.MMMd(
                      Localizations.localeOf(context).toString(),
                    ).format(exam.date),
                    if (exam.room.isNotEmpty) exam.room,
                  ].join(' · '),
                  style: AppText.subtext.copyWith(color: colors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.gap),
          SizedBox(
            width: AppControlSize.touchTarget,
            child: Column(
              children: [
                Text(
                  '${(readiness * 100).round()}%',
                  style: AppText.bodyBold.copyWith(color: tone),
                ),
                const SizedBox(height: 5),
                AppProgressBar(
                  value: readiness,
                  height: AppSpacing.xs,
                  color: tone,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
