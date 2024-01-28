import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcloud/dashboard.dart' as dashboard;

/// Displays a single dashboard widget and its items.
class DashboardWidget extends StatelessWidget {
  /// Creates a new dashboard widget items.
  const DashboardWidget({
    required this.widget,
    required this.children,
    super.key,
  });

  /// The dashboard widget to be displayed.
  final dashboard.Widget widget;

  /// The items of the widget to be displayed.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: widget.widgetUrl != null && widget.widgetUrl!.isNotEmpty ? () => context.go(widget.widgetUrl!) : null,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: children,
            ),
          ),
        ),
      );
}
