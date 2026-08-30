import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    required this.onPressed,
    super.key,
    this.icon = Icons.arrow_back,
    this.iconColor,
  });

  const AppBackButton.light({
    required this.onPressed,
    super.key,
    this.icon = Icons.arrow_back,
  }) : iconColor = Colors.white;

  final VoidCallback onPressed;

  final IconData icon;

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: iconColor ?? colors.active,
      ),
      splashRadius: 20,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}
