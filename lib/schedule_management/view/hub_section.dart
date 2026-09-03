part of 'schedule_management_page.dart';

class _HubSection extends StatelessWidget {
  const _HubSection({
    required this.title,
    required this.onEdit,
    required this.children,
  });

  final String title;
  final VoidCallback onEdit;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final stackHeader = MediaQuery.textScalerOf(context).scale(1) >= 1.4;
    final edit = NinjaButton.text(
      label: context.l10n.edit,
      size: NinjaButtonSize.small,
      onPressed: onEdit,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              10,
              AppSpacing.screen,
              10,
            ),
            child: stackHeader
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppText.headline.copyWith(color: colors.ink),
                      ),
                      const SizedBox(height: 4),
                      edit,
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppText.headline.copyWith(color: colors.ink),
                        ),
                      ),
                      edit,
                    ],
                  ),
          ),
          ...children,
        ],
      ),
    );
  }
}
