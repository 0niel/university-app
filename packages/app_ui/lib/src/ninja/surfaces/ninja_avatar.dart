import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:app_ui/src/ninja/ninja_text.dart';
import 'package:flutter/widgets.dart';

class NinjaAvatar extends StatelessWidget {
  const NinjaAvatar({
    required this.initials,
    super.key,
    this.size = 44,
    this.tone = NinjaAvatarTone.surface,
    this.online = false,
  });

  final String initials;
  final double size;
  final NinjaAvatarTone tone;
  final bool online;

  static double fontSizeFor(double diameter) {
    if (diameter >= 64) return 20;
    if (diameter >= 48) return 15;
    if (diameter >= 44) return 14;
    if (diameter >= 36) return 11.5;
    return 11;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final accent = colors.subjectColor(initials);
    final (background, foreground) = switch (tone) {
      NinjaAvatarTone.ink => (colors.ink, colors.onInk),
      NinjaAvatarTone.surface => (
          accent.withValues(alpha: colors.isDark ? 0.24 : 0.14),
          colors.ink,
        ),
      NinjaAvatarTone.indigo => (colors.brand, colors.onBrand),
    };
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: NinjaText.family,
          fontSize: fontSizeFor(size),
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
    if (!online) return avatar;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          avatar,
          PositionedDirectional(
            end: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                color: colors.canvas,
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum NinjaAvatarTone { ink, surface, indigo }

class NinjaAvatarGroup extends StatelessWidget {
  const NinjaAvatarGroup({
    required this.items,
    super.key,
    this.overflowCount = 0,
    this.size = 36,
    this.ringWidth = 2.5,
    this.overlap = 10,
  });

  final List<NinjaAvatarGroupItem> items;
  final int overflowCount;
  final double size;
  final double ringWidth;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final ringed = size + ringWidth * 2;
    final step = ringed - overlap;
    final entries = <Widget>[
      for (final item in items)
        NinjaAvatar(
          initials: item.initials,
          size: size,
          tone: item.tone,
        ),
      if (overflowCount > 0)
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colors.surfaceAlt,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '+$overflowCount',
            style: TextStyle(
              fontFamily: NinjaText.family,
              fontSize: NinjaAvatar.fontSizeFor(size),
              fontWeight: FontWeight.w700,
              color: colors.ink,
            ),
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
                decoration: BoxDecoration(
                  color: colors.canvas,
                  shape: BoxShape.circle,
                ),
                child: entries[index],
              ),
            ),
        ],
      ),
    );
  }
}

class NinjaAvatarGroupItem {
  const NinjaAvatarGroupItem(
    this.initials, {
    this.tone = NinjaAvatarTone.surface,
  });

  final String initials;
  final NinjaAvatarTone tone;
}
