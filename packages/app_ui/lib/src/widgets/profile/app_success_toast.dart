import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:app_ui/src/widgets/app_toast.dart';
import 'package:flutter/widgets.dart';

class AppSuccessToast extends StatelessWidget {
  const AppSuccessToast({
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AppToast(
      message: message,
      icon: AppLineIcon.check,
      iconColor: context.colors.lecture,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
