import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template text_headline}
/// A reusable text headline news block widget.
/// {@endtemplate}
class TextHeadline extends StatelessWidget {
  /// {@macro text_headline}
  const TextHeadline({required this.block, super.key});

  /// The associated [TextHeadlineBlock] instance.
  final TextHeadlineBlock block;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        block.text,
        style: AppTextStyle.h4.copyWith(color: colors.active),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
