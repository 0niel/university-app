part of '../deadlines_body.dart';

class _EmptyDeadlines extends StatelessWidget {
  const _EmptyDeadlines({required this.onCreate, super.key});

  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.ninja.surface,
        borderRadius: BorderRadius.circular(NinjaRadius.card),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: NinjaEmptyState.screen(
          icon: const AppLineIconWidget(AppLineIcon.calendar, size: 24),
          title: context.l10n.deadlinesEmptyTitle,
          message: context.l10n.deadlinesEmptySubtitle,
          actionLabel: context.l10n.deadlinesFabLabel,
          onAction: onCreate,
        ),
      ),
    ).animateEmptyState();
  }
}
