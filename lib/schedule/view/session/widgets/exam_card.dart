part of '../session_page.dart';

class _ExamCard extends StatelessWidget {
  const _ExamCard({required this.exam, required this.onTap});

  final _Exam exam;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final locale = Localizations.localeOf(context).toString();
    return NinjaScheduleSurface(
      onTap: onTap,
      semanticLabel: '${exam.subject}, ${exam.typeName}',
      child: Row(
        spacing: 14,
        crossAxisAlignment: .start,
        children: [
          Container(
            width: 54,
            padding: const .symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: exam.color.withValues(alpha: .12),
              borderRadius: .circular(NinjaRadius.control),
            ),
            child: Column(
              children: [
                Text(
                  '${exam.days}',
                  style: NinjaText.tabular(
                    NinjaText.headline.copyWith(color: exam.color),
                  ),
                ),
                Text(
                  context.l10n.sessionDaysShort,
                  style: NinjaText.helper.copyWith(color: exam.color),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 2,
                  children: [
                    Text(
                      exam.typeName,
                      style: NinjaText.microLabel.copyWith(color: exam.color),
                    ),
                    Text(
                      '· ${DateFormat('d MMMM', locale).format(exam.date)} '
                      '${exam.time}',
                      style: NinjaText.tabular(
                        NinjaText.helper.copyWith(
                          color: colors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  exam.subject,
                  style: NinjaText.body.copyWith(
                    color: colors.ink,
                    fontWeight: .w600,
                  ),
                ),
                if (exam.teacher.isNotEmpty || exam.room != '—') ...[
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (exam.teacher.isNotEmpty) exam.teacher,
                      if (exam.room != '—') exam.room,
                    ].join(' · '),
                    style: NinjaText.subtext.copyWith(
                      color: colors.muted,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: .circular(NinjaRadius.pill),
                        child: SizedBox(
                          height: 8,
                          child: Stack(
                            fit: .expand,
                            children: [
                              ColoredBox(color: colors.surfaceAlt),
                              FractionallySizedBox(
                                alignment: .centerLeft,
                                widthFactor: exam.readiness.clamp(0.0, 1.0),
                                child: ColoredBox(color: colors.brand),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${(exam.readiness * 100).round()}%',
                      style: NinjaText.tabular(
                        NinjaText.helper.copyWith(color: colors.muted),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
