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
    final colors = context.ninja;
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
              NinjaMetrics.screenPadding,
              10,
              NinjaMetrics.screenPadding,
              10,
            ),
            child: stackHeader
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: NinjaText.headline.copyWith(color: colors.ink),
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
                          style: NinjaText.headline.copyWith(color: colors.ink),
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
