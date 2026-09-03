import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_error_state.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/widgets.dart';

class FailureScreen extends StatelessWidget {
  const FailureScreen({
    required this.title,
    super.key,
    this.description,
    this.icon = AppLineIcon.alert,
    this.buttonText,
    this.onButtonPressed,
    this.padding = const EdgeInsets.all(AppSpacing.screen),
  });

  final String title;
  final String? description;
  final AppLineIcon icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = buttonText;

    return ColoredBox(
      color: colors.canvas,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: padding,
            child: AppErrorState(
              lineIcon: icon,
              title: title,
              message: description,
              primaryLabel: label ?? '',
              onPrimary: onButtonPressed,
              footnote: null,
            ),
          ),
        ),
      ),
    );
  }
}
