part of 'profile_page.dart';

class _ProfileSectionLabel extends StatelessWidget {
  const _ProfileSectionLabel({
    required this.label,
    this.action,
    this.onAction,
  });

  final String label;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final title = Text(
      label,
      maxLines: textScale >= 1.5 ? 3 : 2,
      overflow: .ellipsis,
      style: NinjaText.title.copyWith(color: colors.ink),
    );
    final action = this.action;
    final actionWidget = action == null
        ? null
        : NinjaChip(label: action, onTap: onAction);
    return Padding(
      padding: const .fromLTRB(
        NinjaMetrics.screenPadding,
        28,
        NinjaMetrics.screenPadding,
        8,
      ),
      child: textScale >= 1.5
          ? Column(
              crossAxisAlignment: .start,
              children: [
                title,
                if (actionWidget != null) ...[
                  const SizedBox(height: 8),
                  actionWidget,
                ],
              ],
            )
          : Row(
              children: [
                Expanded(child: title),
                if (actionWidget != null) ...[
                  const SizedBox(width: 10),
                  AppRowTrailing(child: actionWidget),
                ],
              ],
            ),
    );
  }
}
