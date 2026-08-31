import 'package:app_ui/src/widgets/toast/toast_manager.dart';
import 'package:flutter/material.dart';

@Deprecated('Use ToastManager.showBanner/showSuccess/showCelebration instead')
abstract final class AppInAppNotifications {
  @Deprecated('Use ToastManager.showBanner instead')
  static void showPush(
    BuildContext context, {
    required String title,
    required String message,
    String timeLabel = 'сейчас',
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    ToastManager.showBanner(
      context,
      title: title,
      message: message,
      timeLabel: timeLabel,
      onTap: onTap,
      duration: duration,
    );
  }

  @Deprecated('Use ToastManager.showSuccess instead')
  static void showSuccess(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    ToastManager.showSuccess(
      context,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  @Deprecated('Use ToastManager.showCelebration instead')
  static void showAchievement(
    BuildContext context, {
    required String emoji,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 4),
  }) {
    ToastManager.showCelebration(
      context,
      emoji: emoji,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      duration: duration,
    );
  }
}
