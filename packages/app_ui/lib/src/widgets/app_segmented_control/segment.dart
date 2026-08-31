part of '../app_segmented_control.dart';

class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.option,
    required this.selected,
    required this.expanded,
    required this.onTap,
  });

  final AppSegmentedOption<T> option;
  final bool selected;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 180);
    return Semantics(
      button: true,
      selected: selected,
      enabled: onTap != null,
      child: AppPressable(
        haptics: !selected,
        onTap: onTap,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOutCubic,
          constraints: const BoxConstraints(minHeight: 44),
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: expanded ? 10 : 8,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.brand : Colors.transparent,
            borderRadius: BorderRadius.circular(NinjaRadius.button),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (option.icon case final icon?) ...[
                Icon(
                  icon,
                  size: 14,
                  color: selected ? colors.onBrand : colors.mutedDark,
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  style: NinjaText.body.copyWith(
                    fontSize: 12.5,
                    color: selected ? colors.onBrand : colors.mutedDark,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w700,
                  ),
                  child: Text(
                    option.label,
                    maxLines: expanded ? 2 : 1,
                    overflow:
                        expanded ? TextOverflow.visible : TextOverflow.fade,
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
