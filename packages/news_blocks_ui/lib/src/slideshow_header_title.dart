import 'package:app_ui/app_ui.dart' show AppSpacing, AppText, ThemeDataColorsX;
import 'package:flutter/material.dart';

class SlideshowHeaderTitle extends StatelessWidget {
  const SlideshowHeaderTitle({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    return Padding(
      key: const Key('slideshow_headerTitle'),
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        bottom: AppSpacing.lg,
      ),
      child: Text(title, style: AppText.title.copyWith(color: colors.active)),
    );
  }
}
