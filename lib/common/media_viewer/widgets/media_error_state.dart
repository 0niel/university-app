import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

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
