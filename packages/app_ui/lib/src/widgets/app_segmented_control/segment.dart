part of '../app_segmented_control.dart';

class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.option,
    required this.selected,
    required this.wrapped,
    required this.expanded,
    required this.onTap,
  });

  final AppSegmentedOption<T> option;
  final bool selected;
  final bool wrapped;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 200);
    final foreground = selected ? colors.onAccent : colors.muted;
    final icon = option.icon;

    return AppPressState(
      onTap: onTap,
      enabled: onTap != null,
      haptics: !selected,
      semanticsLabel: option.label,
      semanticsButton: true,
      semanticsSelected: selected,
      builder: (context, {required pressed}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: _segmentHitInset),
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOut,
          height: wrapped ? null : AppControlSize.segmentHeight,
          constraints: wrapped
              ? const BoxConstraints(minHeight: AppControlSize.segmentHeight)
              : null,
          padding: EdgeInsets.symmetric(
            horizontal:
                expanded && !wrapped ? _segmentInset : AppSpacing.sectionGap,
            vertical: _segmentInset,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                AppLineIconWidget(
                  icon,
                  size: AppIconSize.xs,
                  color: foreground,
                ),
                const SizedBox(width: _segmentInset),
              ],
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: Curves.easeOut,
                  style: AppText.segment.copyWith(color: foreground),
                  child: Text(
                    option.label,
                    maxLines: wrapped ? 2 : 1,
                    overflow:
                        wrapped ? TextOverflow.visible : TextOverflow.fade,
                    softWrap: wrapped,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
