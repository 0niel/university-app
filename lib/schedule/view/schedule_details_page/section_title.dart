part of '../schedule_details_page.dart';

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
      ),
      child: AppSectionTitle(
        title: title,
        action: action,
        onActionTap: onAction,
        topMargin: AppSpacing.sheetBottom,
        bottomPadding: AppSpacing.sectionGap,
      ),
    );
  }
}
