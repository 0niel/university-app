import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppRankNode extends StatelessWidget {
  const AppRankNode({
    required this.rank,
    required this.isActive,
    required this.isDone,
    super.key,
  });

  final NinjaRank rank;
  final bool isActive;
  final bool isDone;

  static const _greyscale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isLocked = !isActive && !isDone;
    final background = isActive
        ? colors.primary
        : isDone
            ? colors.primary.withValues(alpha: 0.14)
            : colors.surfaceHigh;
    Widget emoji = Text(rank.emoji, style: const TextStyle(fontSize: 20));
    if (isLocked) {
      emoji = Opacity(
        opacity: 0.5,
        child: ColorFiltered(colorFilter: _greyscale, child: emoji),
      );
    }

    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: emoji,
        ),
        const SizedBox(height: 5),
        Text(
          rank.name,
          style: AppText.captionSmall.copyWith(
            color: isActive ? colors.primary : colors.deactiveDarker,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
