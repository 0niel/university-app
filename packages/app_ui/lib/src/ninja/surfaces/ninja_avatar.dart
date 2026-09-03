import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:flutter/widgets.dart';

enum NinjaAvatarTone { ink, surface, indigo, lecture, lab, exam }

class NinjaAvatar extends StatelessWidget {
  const NinjaAvatar({
    required this.initials,
    super.key,
    this.size = 44,
    this.tone = NinjaAvatarTone.surface,
    this.online = false,
    this.level,
    this.borderColor,
  });

  final String initials;
  final double size;
  final NinjaAvatarTone tone;
  final bool online;
  final String? level;
  final Color? borderColor;

  static double fontSizeFor(double diameter) {
    if (diameter >= 88) return 28;
    if (diameter >= 72) return 22;
    if (diameter >= 56) return 18;
    if (diameter >= 40) return 13;
    if (diameter >= 32) return 11;
    if (diameter >= 28) return 10;
    return 9;
  }

  static FontWeight weightFor(double diameter) =>
      diameter >= 40 ? FontWeight.w700 : FontWeight.w800;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      NinjaAvatarTone.ink => (colors.ink, colors.canvas),
      NinjaAvatarTone.surface => (colors.tint, colors.accent),
      NinjaAvatarTone.indigo => (colors.accent, colors.onAccent),
      NinjaAvatarTone.lecture => (colors.lectureTint, colors.lecture),
      NinjaAvatarTone.lab => (colors.labTint, colors.lab),
      NinjaAvatarTone.exam => (colors.examTint, colors.exam),
    };

    final avatar = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Text(
        initials,
        style: AppText.sans(fontSizeFor(size), weightFor(size))
            .copyWith(color: foreground),
      ),
    );

    if (!online && level == null) return avatar;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          if (level != null)
            PositionedDirectional(
              end: -2,
              bottom: -2,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? colors.surface,
                    width: 2,
                  ),
                ),
                child: Text(
                  level!,
                  style: AppText.countBadge.copyWith(color: colors.onAccent),
                ),
              ),
            )
          else if (online)
            PositionedDirectional(
              end: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors.lecture,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? colors.surface,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

typedef AppAvatarGroupItem = NinjaAvatarGroupItem;

typedef AppAvatarGroup = NinjaAvatarGroup;

class NinjaAvatarGroupItem {
  const NinjaAvatarGroupItem(
    this.initials, {
    this.tone = NinjaAvatarTone.surface,
  });

  final String initials;
  final NinjaAvatarTone tone;
}

class NinjaAvatarGroup extends StatelessWidget {
  const NinjaAvatarGroup({
    required this.items,
    super.key,
    this.overflowCount = 0,
    this.size = 32,
    this.ringWidth = 2,
    this.overlap = 10,
    this.ringColor,
  });

  final List<NinjaAvatarGroupItem> items;
  final int overflowCount;
  final double size;
  final double ringWidth;
  final double overlap;
  final Color? ringColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ring = ringColor ?? colors.surface;
    final ringed = size + ringWidth * 2;
    final effectiveOverlap = size <= 28 ? 8.0 : overlap;
    final step = ringed - effectiveOverlap;

    final entries = <Widget>[
      for (final item in items)
        NinjaAvatar(initials: item.initials, size: size, tone: item.tone),
      if (overflowCount > 0)
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surface2,
            shape: BoxShape.circle,
          ),
          child: Text(
            '+$overflowCount',
            style: AppText.sans(
              NinjaAvatar.fontSizeFor(size),
              NinjaAvatar.weightFor(size),
            ).copyWith(color: colors.muted),
          ),
        ),
    ];
    if (entries.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: ringed + step * (entries.length - 1),
      height: ringed,
      child: Stack(
        children: [
          for (var index = 0; index < entries.length; index++)
            PositionedDirectional(
              start: step * index,
              child: Container(
                padding: EdgeInsets.all(ringWidth),
                decoration: BoxDecoration(color: ring, shape: BoxShape.circle),
                child: entries[index],
              ),
            ),
        ],
      ),
    );
  }
}
