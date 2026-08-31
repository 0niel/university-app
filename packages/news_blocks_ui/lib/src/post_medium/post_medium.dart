import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';

/// {@template post_medium}
/// A reusable post medium block widget.
/// {@endtemplate}
class PostMedium extends StatelessWidget {
  /// {@macro post_medium}
  const PostMedium({required this.block, this.onPressed, super.key});

  /// The associated [PostMediumBlock] instance.
  final PostMediumBlock block;

  /// An optional callback which is invoked when the action is triggered.
  /// A [Uri] from the associated [BlockAction] is provided to the callback.
  final BlockActionCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scale = Theme.of(context).scale;
    final action = block.action;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(scale.radius(16)),
        onTap:
            block.hasNavigationAction && action != null
                ? () => onPressed?.call(action)
                : null,
        child:
            block.isContentOverlaid
                ? PostMediumOverlaidLayout(
                  title: block.title,
                  imageUrl: block.imageUrl,
                  publishedAt: block.publishedAt,
                )
                : PostMediumDescriptionLayout(
                  title: block.title,
                  imageUrl: block.imageUrl,
                  description: block.description,
                  publishedAt: block.publishedAt,
                  author: block.author,
                ),
      ),
    );
  }
}
