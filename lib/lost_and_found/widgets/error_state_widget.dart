import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildErrorIllustration(context),
            const SizedBox(height: 24),
            Text(
              'Что-то пошло не так',
              style: AppTextStyle.titleM.copyWith(fontWeight: FontWeight.w600, color: appColors.active),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(message, style: AppTextStyle.body.copyWith(color: appColors.deactive), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Попробовать снова'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorIllustration(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(color: appColors.colorful07.withOpacity(0.1), shape: BoxShape.circle),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: appColors.surface,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: appColors.cardShadowLight, blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Center(child: Icon(Icons.error_outline_rounded, size: 50, color: appColors.colorful07)),
        ),
      ],
    );
  }
}
