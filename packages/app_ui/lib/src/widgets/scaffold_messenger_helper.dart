import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

typedef LoadingCallback = Future<LoadingResult> Function();
typedef LoadingResult = ({bool isSuccess, String? message});

class ScaffoldMessengerHelper {
  static void showLoading({
    required BuildContext context,
    required String title,
    required LoadingCallback loadingCallback,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);

    _executeLoadingCallback(
      context: context,
      loadingCallback: loadingCallback,
      title: title,
    );
  }

  static Future<void> _executeLoadingCallback({
    required BuildContext context,
    required LoadingCallback loadingCallback,
    required String title,
  }) async {
    try {
      final result = await loadingCallback();

      final resultSnackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            _buildStatusIcon(context, result.isSuccess),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                result.message ?? title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(resultSnackBar);
      }
    } catch (error) {
      if (error is FlutterError && error.diagnostics.first.level == DiagnosticLevel.info) {
        return;
      }
      final errorSnackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).extension<AppColors>()!.colorful07,
        content: Row(
          children: [
            _buildStatusIcon(context, false),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Ошибка загрузки',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(errorSnackBar);
      }
    }
  }

  static Container _buildStatusIcon(BuildContext context, bool isSuccess) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: HugeIcon(
        icon: isSuccess ? HugeIcons.strokeRoundedCheckmarkCircle01 : HugeIcons.strokeRoundedAlertCircle,
        color: isSuccess
            ? Theme.of(context).extension<AppColors>()!.colorful05
            : Theme.of(context).extension<AppColors>()!.colorful07,
        size: 20,
      ),
    );
  }

  static void showMessage({
    required BuildContext context,
    required String title,
    String? subtitle,
    bool isSuccess = true,
  }) {
    final content = Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: HugeIcon(
            icon: isSuccess ? HugeIcons.strokeRoundedCheckmarkCircle01 : HugeIcons.strokeRoundedAlertCircle,
            color: isSuccess
                ? Theme.of(context).extension<AppColors>()!.active
                : Theme.of(context).extension<AppColors>()!.colorful07,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.bodyBold,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: AppTextStyle.body,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: content,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }
}
