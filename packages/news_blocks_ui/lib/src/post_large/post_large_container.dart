import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

@visibleForTesting
class PostLargeContainer extends StatelessWidget {
  const PostLargeContainer({
    required this.children,
    required this.isContentOverlaid,
    super.key,
  });

  final List<Widget> children;
  final bool isContentOverlaid;

  @override
  Widget build(BuildContext context) {
    final scale = Theme.of(context).scale;
    return isContentOverlaid
        ? ClipRRect(
          borderRadius: BorderRadius.circular(scale.radius(16)),
          child: Stack(
            key: const Key('postLarge_stack'),
            alignment: Alignment.bottomLeft,
            children: children,
          ),
        )
        : Column(key: const Key('postLarge_column'), children: children);
  }
}
