import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class NinjaTextBottomBar extends StatelessWidget {
  const NinjaTextBottomBar({
    required this.labels,
    required this.currentIndex,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ColoredBox(
      color: colors.canvas,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xsm,
          AppSpacing.md,
          bottomInset == 0 ? 8 : bottomInset + 4,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Row(
              children: [
                for (var index = 0; index < labels.length; index++) ...[
                  if (index != 0) const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: _NinjaTextBottomBarTab(
                      label: labels[index],
                      selected: index == currentIndex,
                      onTap: () => onSelected(index),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NinjaTextBottomBarTab extends StatefulWidget {
  const _NinjaTextBottomBarTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NinjaTextBottomBarTab> createState() => _NinjaTextBottomBarTabState();
}

class _NinjaTextBottomBarTabState extends State<_NinjaTextBottomBarTab> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reduceMotion = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final selected = widget.selected;
    final background = selected
        ? colors.accent
        : _focused
            ? colors.surface2
            : const Color(0x00000000);

    return Semantics(
      button: true,
      selected: selected,
      label: widget.label,
      onTap: widget.onTap,
      child: ExcludeSemantics(
        child: FocusableActionDetector(
          mouseCursor: SystemMouseCursors.click,
          onShowFocusHighlight: (value) {
            if (_focused != value) setState(() => _focused = value);
          },
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onTap();
                return true;
              },
            ),
          },
          child: AppPressable(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              constraints: const BoxConstraints(minHeight: 44),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.segment.copyWith(
                  color: selected ? colors.onAccent : colors.muted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
