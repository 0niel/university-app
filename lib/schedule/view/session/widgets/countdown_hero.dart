part of '../session_page.dart';

class _CountdownHero extends StatelessWidget {
  const _CountdownHero({required this.exams});

  final List<_Exam> exams;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;
    final first = exams.firstOrNull;
    final last = exams.lastOrNull;
    final locale = Localizations.localeOf(context).toString();
    final examCount = exams.where((exam) => exam.lessonType == .exam).length;
    final creditCount = exams
        .where((exam) => exam.lessonType == .credit)
        .length;
    final avgReadiness = exams.isEmpty
        ? 0
        : (exams.fold<double>(0, (sum, exam) => sum + exam.readiness) /
                  exams.length *
                  100)
              .round();

    return NinjaScheduleSurface(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            l10n.sessionUntilFirstExam,
            textAlign: .center,
            style: NinjaText.microLabel.copyWith(color: colors.muted),
          ),
          const SizedBox(height: 6),
          Text(
            first == null ? '—' : '${first.days}',
            style: NinjaText.tabular(
              NinjaText.display.copyWith(color: colors.ink),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            first == null
                ? l10n.sessionNoPlannedExams
                : l10n.sessionHeroSubtitle(
                    first.subject,
                    DateFormat('d MMMM', locale).format(first.date),
                  ),
            textAlign: .center,
            style: NinjaText.subtext.copyWith(color: colors.mutedDark),
          ),
          if (last != null) ...[
            const SizedBox(height: 18),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                _HeroStat(
                  value: '$examCount+$creditCount',
                  label: l10n.sessionExamsCredits,
                ),
                _HeroStat(
                  value: '$avgReadiness%',
                  label: l10n.sessionReadinessLabel,
                ),
                _HeroStat(
                  value: '${last.days}',
                  label: l10n.sessionDaysTotal,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
