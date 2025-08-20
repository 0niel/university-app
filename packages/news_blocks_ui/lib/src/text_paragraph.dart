import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template text_paragraph}
/// A reusable text paragraph news block widget.
/// {@endtemplate}
class TextParagraph extends StatelessWidget {
  /// {@macro text_paragraph}
  const TextParagraph({required this.block, super.key});

  /// The associated [TextParagraphBlock] instance.
  final TextParagraphBlock block;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        block.text,
        style: AppTextStyle.body.copyWith(color: colors.active, height: 1.5),
      ),
    );
  }
}
