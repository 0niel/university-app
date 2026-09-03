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

class MediaErrorState extends StatelessWidget {
  const MediaErrorState({
    required this.title,
    required this.retryLabel,
    required this.onRetry,
    super.key,
  });

  final String title;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    const dark = AppColors.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLineIconWidget(
              AppLineIcon.wifiOff,
              size: 32,
              color: dark.muted,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: dark.ink),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton.secondary(label: retryLabel, onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
