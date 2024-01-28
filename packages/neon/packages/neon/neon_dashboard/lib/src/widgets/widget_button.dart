import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcloud/dashboard.dart' as dashboard;

/// Button inside a dashboard widget that is used to trigger an action.
class DashboardWidgetButton extends StatelessWidget {
  /// Creates a new dashboard widget button.
  const DashboardWidgetButton({
    required this.button,
    super.key,
  });

  /// The dashboard widget button to be displayed.
  final dashboard.Widget_Buttons button;

  @override
  Widget build(BuildContext context) {
    void onPressed() => context.go(button.link);
    final label = Text(button.text);
    final icon = switch (button.type) {
      'new' => Icons.add,
      'more' => Icons.more_outlined,
      'setup' => Icons.launch,
      _ => null,
    };
    if (icon != null) {
      return Align(
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: label,
        ),
      );
    }

    return Align(
      child: FilledButton(
        onPressed: onPressed,
        child: label,
      ),
    );
  }
}
