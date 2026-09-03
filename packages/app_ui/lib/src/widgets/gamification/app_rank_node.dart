import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/typography/typography.dart';
import 'package:app_ui/src/widgets/gamification/ninja_rank.dart';
import 'package:flutter/widgets.dart';

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
        ? colors.accent
        : isDone
            ? colors.tint
            : colors.surface2;

    Widget emoji = Text(
      rank.emoji,
      style: const TextStyle(fontSize: 20, height: 1),
    );
    if (isLocked) {
      emoji = Opacity(
        opacity: .5,
        child: ColorFiltered(colorFilter: _greyscale, child: emoji),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppControlSize.iconButton,
          height: AppControlSize.iconButton,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: emoji,
        ),
        const SizedBox(height: AppSpacing.fine),
        Text(
          rank.name,
          style: isActive
              ? AppText.captionSmall.copyWith(color: colors.accent)
              : AppText.caption.copyWith(color: colors.muted2),
        ),
      ],
    );
  }
}
