import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/widgets.dart';
import 'package:nextcloud/dashboard.dart' as dashboard;

/// A single item in the dashboard widget.
class DashboardWidgetItem extends StatelessWidget {
  /// Creates a new dashboard widget item.
  const DashboardWidgetItem({
    required this.item,
    required this.roundIcon,
    super.key,
  });

  /// The dashboard widget item to be displayed.
  final dashboard.WidgetItem item;

  /// Whether the leading icon should have round corners.
  final bool roundIcon;

  @override
  Widget build(BuildContext context) {
    Widget leading = SizedBox.square(
      dimension: largeIconSize,
      child: NeonImageWrapper(
        borderRadius: roundIcon ? BorderRadius.circular(largeIconSize) : null,
        child: item.iconUrl.isNotEmpty
            ? NeonUrlImage(
                uri: Uri.parse(item.iconUrl),
                size: const Size.square(largeIconSize),
              )
            : Icon(
                Icons.question_mark,
                color: Theme.of(context).colorScheme.error,
              ),
      ),
    );

    final overlayIconUrl = item.overlayIconUrl;
    if (overlayIconUrl != null && overlayIconUrl.isNotEmpty) {
      leading = Stack(
        children: [
          leading,
          SizedBox.square(
            dimension: largeIconSize,
            child: Align(
              alignment: Alignment.bottomRight,
              child: SizedBox.square(
                dimension: smallIconSize,
                child: NeonUrlImage(
                  uri: Uri.parse(overlayIconUrl),
                  size: const Size.square(smallIconSize),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return ListTile(
      title: Text(
        item.title,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        item.subtitle,
        overflow: TextOverflow.ellipsis,
      ),
      leading: leading,
      onTap: item.link.isNotEmpty ? () => context.go(item.link) : null,
    );
  }
}
