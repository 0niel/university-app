import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/material.dart';

class AppEntryTheme extends StatelessWidget {
  const AppEntryTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    return Theme(
      data: theme.copyWith(
        extensions: [
          ...theme.extensions.values.where((value) => value is! AppColors),
          colors.copyWith(accent: colors.ink, onAccent: colors.canvas),
        ],
      ),
      child: child,
    );
  }
}
