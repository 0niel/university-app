import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_list_row.dart';
import 'package:flutter/widgets.dart';

class AppDisclosure extends StatefulWidget {
  const AppDisclosure({
    required this.title,
    required this.child,
    super.key,
    this.subtitle,
    this.leading,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.contentPadding = const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      0,
      AppSpacing.lg,
      AppSpacing.lg,
    ),
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget child;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final EdgeInsetsGeometry contentPadding;

  @override
  State<AppDisclosure> createState() => _AppDisclosureState();
}

class _AppDisclosureState extends State<AppDisclosure> {
  late bool _expanded = widget.initiallyExpanded;

  void _toggle() {
    setState(() => _expanded = !_expanded);
    widget.onExpansionChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
            (MediaQuery.maybeAccessibleNavigationOf(context) ?? false);
    final duration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 180);
    final content = _expanded
        ? Padding(padding: widget.contentPadding, child: widget.child)
        : const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MergeSemantics(
          child: Semantics(
            expanded: _expanded,
            child: AppListRow(
              title: widget.title,
              titleMaxLines: null,
              subtitle: widget.subtitle,
              leading: widget.leading,
              trailing: AnimatedRotation(
                turns: _expanded ? .5 : 0,
                duration: duration,
                curve: Curves.easeOutCubic,
                child: AppLineIconWidget(
                  AppLineIcon.chevronD,
                  size: AppIconSize.sm,
                  color: context.colors.muted,
                ),
              ),
              onTap: _toggle,
            ),
          ),
        ),
        if (reduceMotion)
          content
        else
          AnimatedSize(
            alignment: Alignment.topCenter,
            duration: duration,
            curve: Curves.easeOutCubic,
            child: content,
          ),
      ],
    );
  }
}
