import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:app_ui/src/ninja/surfaces/ninja_glyph.dart';
import 'package:app_ui/src/widgets/app_pressable.dart';
import 'package:app_ui/src/widgets/app_row_trailing.dart';
import 'package:flutter/material.dart';

class NinjaListCell extends StatelessWidget {
  const NinjaListCell({
    required this.title,
    super.key,
    this.subtitle,
    this.trailingLabel,
    this.trailingColor,
    this.titleColor,
    this.trailing,
    this.showChevron = true,
    this.showDivider = true,
    this.horizontalPadding = 16,
    this.onTap,
    this.onDelete,
    this.dismissibleKey,
  })  : _subject = false,
        time = null,
        meta = null,
        color = null;

  const NinjaListCell.subject({
    required this.title,
    required this.time,
    super.key,
    this.meta,
    this.color,
    this.showDivider = true,
    this.onTap,
    this.onDelete,
    this.dismissibleKey,
  })  : _subject = true,
        subtitle = null,
        trailingLabel = null,
        trailingColor = null,
        titleColor = null,
        trailing = null,
        horizontalPadding = 16,
        showChevron = false;

  final String title;
  final String? subtitle;
  final String? trailingLabel;
  final Color? trailingColor;
  final Color? titleColor;
  final Widget? trailing;
  final double horizontalPadding;
  final bool showChevron;
  final bool showDivider;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Key? dismissibleKey;
  final String? time;
  final String? meta;
  final Color? color;
  final bool _subject;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    var cell = _subject ? _buildSubject(colors) : _buildBase(colors);
    if (onTap != null) cell = AppPressable(onTap: onTap, child: cell);
    if (onDelete != null) {
      cell = Dismissible(
        key: dismissibleKey ?? ValueKey('ninja-list-cell-$title'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete!(),
        background: ColoredBox(
          color: colors.scarlet,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: NinjaGlyphIcon(
                NinjaGlyph.trash,
                size: 18,
                color: colors.onScarlet,
              ),
            ),
          ),
        ),
        child: cell,
      );
    }
    return cell;
  }

  Widget _buildBase(NinjaColors colors) {
    final label = trailingLabel;
    final control = trailing;
    final subtitleText = subtitle;
    return Container(
      color: Colors.transparent,
      constraints: const BoxConstraints(minHeight: NinjaMetrics.minTouchTarget),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 15,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: NinjaText.body.copyWith(
                    color: titleColor ?? colors.ink,
                  ),
                ),
                if (subtitleText != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitleText,
                    style: NinjaText.subtext.copyWith(
                      fontSize: 12,
                      color: colors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (control != null) ...[
            const SizedBox(width: 10),
            control,
          ] else if (label != null) ...[
            const SizedBox(width: 10),
            AppRowTrailing(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: NinjaText.family,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: trailingColor ?? colors.muted,
                ),
              ),
            ),
          ],
          if (showChevron) ...[
            const SizedBox(width: 6),
            NinjaGlyphIcon(
              NinjaGlyph.chevronRight,
              size: 14,
              color: colors.chevron,
              strokeWidth: 2.5,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubject(NinjaColors colors) {
    final metaText = meta;
    final timeText = time;
    return ColoredBox(
      color: Colors.transparent,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              NinjaMetrics.subjectBarWidthCompact + 13,
              14,
              16,
              14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: NinjaText.family,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: colors.ink,
                        ),
                      ),
                    ),
                    if (timeText != null) ...[
                      const SizedBox(width: 10),
                      Text(
                        timeText,
                        style: NinjaText.tabular(
                          TextStyle(
                            fontFamily: NinjaText.family,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.muted,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (metaText != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    metaText,
                    style: NinjaText.subtext.copyWith(
                      fontSize: 12,
                      color: colors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          PositionedDirectional(
            start: 0,
            top: 14,
            bottom: 14,
            width: NinjaMetrics.subjectBarWidthCompact,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color ?? colors.subjectColor(title),
                borderRadius: const BorderRadiusDirectional.horizontal(
                  end: Radius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
