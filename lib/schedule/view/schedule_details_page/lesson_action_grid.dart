part of '../schedule_details_page.dart';

class _LessonActionGrid extends StatelessWidget {
  const _LessonActionGrid({required this.onNote, required this.onRoute});

  final VoidCallback onNote;
  final VoidCallback onRoute;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        10,
        NinjaMetrics.screenPadding,
        0,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked =
              constraints.maxWidth < 300 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.5;
          final route = NinjaButton.primary(
            label: l10n.lessonDetailsRoute,
            expanded: true,
            onPressed: onRoute,
          );
          final note = NinjaButton.secondary(
            label: l10n.lessonDetailsNote,
            expanded: true,
            onPressed: onNote,
          );
          if (stacked) {
            return Column(
              children: [route, const SizedBox(height: 8), note],
            );
          }
          return Row(
            children: [
              Expanded(child: route),
              const SizedBox(width: 8),
              Expanded(child: note),
            ],
          );
        },
      ),
    );
  }
}
