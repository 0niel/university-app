import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_action_button.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:flutter/widgets.dart';

class NinjaLessonRow extends StatelessWidget {
  const NinjaLessonRow({
    required this.title,
    required this.time,
    super.key,
    this.meta,
    this.color,
    this.chipLabel,
    this.chipColor,
    this.past = false,
    this.current = false,
    this.actions = const <NinjaLessonAction>[],
    this.onTap,
    this.inset = NinjaMetrics.screenPadding,
  });

  final String title;
  final String time;
  final String? meta;
  final Color? color;
  final String? chipLabel;
  final Color? chipColor;
  final bool past;
  final bool current;
  final List<NinjaLessonAction> actions;
  final VoidCallback? onTap;
  final double inset;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final accent = color ?? colors.subjectColor(title);
    final foreground = current ? colors.onInk : colors.ink;
    final secondary =
        current ? colors.onInk.withValues(alpha: 0.68) : colors.mutedDark;
    final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
    final chip = chipLabel;
    final metaText = meta;

    Widget row = Padding(
      padding: EdgeInsets.symmetric(horizontal: inset, vertical: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: current ? colors.ink : const Color(0x00000000),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: current
                      ? colors.brand
                      : accent.withValues(alpha: colors.isDark ? 0.22 : 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AppLineIconWidget(
                  AppLineIcon.book,
                  size: 20,
                  color: current ? colors.onInk : accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (largeText) ...[
                      _NinjaLessonTitle(
                        title: title,
                        chip: chip,
                        chipColor: chipColor ?? colors.scarlet,
                        foreground: foreground,
                      ),
                      const SizedBox(height: 5),
                      _NinjaLessonTime(time: time, color: secondary),
                    ] else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _NinjaLessonTitle(
                              title: title,
                              chip: chip,
                              chipColor: chipColor ?? colors.scarlet,
                              foreground: foreground,
                            ),
                          ),
                          const SizedBox(width: 10),
                          _NinjaLessonTime(time: time, color: secondary),
                        ],
                      ),
                    if (metaText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        metaText,
                        style: NinjaText.subtext.copyWith(color: secondary),
                      ),
                    ],
                    if (actions.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final action in actions)
                            NinjaActionButton(
                              label: action.label,
                              onPressed: action.onPressed,
                              tone: current || !action.primary
                                  ? NinjaActionTone.surface
                                  : NinjaActionTone.ink,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (past) row = Opacity(opacity: 0.5, child: row);
    if (onTap != null) {
      row = Semantics(
        button: true,
        label: '$title, $time',
        child: AppPressable(onTap: onTap, child: row),
      );
    }
    return row;
  }
}

class NinjaLessonAction {
  const NinjaLessonAction({
    required this.label,
    this.onPressed,
    this.primary = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;
}

class _NinjaLessonTitle extends StatelessWidget {
  const _NinjaLessonTitle({
    required this.title,
    required this.chip,
    required this.chipColor,
    required this.foreground,
  });

  final String title;
  final String? chip;
  final Color chipColor;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final chip = this.chip;
    return Wrap(
      spacing: 8,
      runSpacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(title, style: NinjaText.headline.copyWith(color: foreground)),
        if (chip != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: chipColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              chip,
              style: NinjaText.badge.copyWith(
                letterSpacing: 0,
                color: chipColor,
              ),
            ),
          ),
      ],
    );
  }
}

class _NinjaLessonTime extends StatelessWidget {
  const _NinjaLessonTime({required this.time, required this.color});

  final String time;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: NinjaText.tabular(
        NinjaText.subtext.copyWith(fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
