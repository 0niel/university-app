import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

class MediaLoadingState extends StatelessWidget {
  const MediaLoadingState({this.progress, super.key});

  final double? progress;

  @override
  Widget build(BuildContext context) {
    const dark = AppColors.dark;
    final value = progress;
    return Center(
      child: value == null || value <= 0
          ? AppSpinner(color: dark.ink)
          : AppProgressRing(
              value: value,
              size: 56,
              color: dark.accent,
              trackColor: dark.surface2,
            ),
    );
  }
}
