part of 'group_space_view.dart';

class _NinjaGroupSpaceSectionHeader extends StatelessWidget {
  const _NinjaGroupSpaceSectionHeader({
    this.title,
    this.actionLabel,
    this.onAction,
  });

  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final title = this.title;
    if (title == null) return const SizedBox(height: 18);
    final action = actionLabel;
    final stacked = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final heading = Text(
      title,
      maxLines: 2,
      overflow: .ellipsis,
      style: AppText.title.copyWith(color: colors.ink),
    );
    return Padding(
      padding: const .fromLTRB(
        AppSpacing.screen,
        28,
        AppSpacing.screen,
        8,
      ),
      child: stacked
          ? Column(
              crossAxisAlignment: .start,
              children: [
                heading,
                if (action != null) ...[
                  const SizedBox(height: 8),
                  NinjaChipRow(
                    padding: .zero,
                    children: [NinjaChip(label: action, onTap: onAction)],
                  ),
                ],
              ],
            )
          : Row(
              crossAxisAlignment: .baseline,
              textBaseline: .alphabetic,
              children: [
                Expanded(child: heading),
                if (action != null) ...[
                  const SizedBox(width: 10),
                  NinjaChip(label: action, onTap: onAction),
                ],
              ],
            ),
    );
  }
}
