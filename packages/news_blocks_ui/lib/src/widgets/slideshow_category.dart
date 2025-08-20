import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template slideshow_category}
/// A widget displaying a slideshow label.
/// A widget displaying a slideshow category.
/// {@endtemplate}
class SlideshowCategory extends StatelessWidget {
  /// {@macro slideshow_category}
  const SlideshowCategory({
    required this.slideshowText,
    this.isIntroduction = true,
    super.key,
  });

  /// Whether this slideshow category is
  /// being displayed in an introduction.
  final bool isIntroduction;

  /// Text displayed in the slideshow category widget.
  final String slideshowText;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final backgroundColor =
        isIntroduction ? colors.secondary : colors.surface.withOpacity(0);
    final textColor = isIntroduction ? colors.white : colors.accent;
    const horizontalSpacing = AppSpacing.xs;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            decoration: BoxDecoration(color: backgroundColor),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                horizontalSpacing,
                0,
                horizontalSpacing,
                AppSpacing.xxs,
              ),
              child: Text(
                slideshowText.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
