import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks/news_blocks.dart';

/// {@template text_caption}
/// A reusable text caption news block widget.
/// {@endtemplate}
class TextCaption extends StatelessWidget {
  /// {@macro text_caption}
  const TextCaption({required this.block, this.colorValues, super.key});

  /// The associated [TextCaptionBlock] instance.
  final TextCaptionBlock block;

  /// The color values of this text caption.
  ///
  /// Defaults to [_defaultColors].
  final Map<TextCaptionColor, Color>? colorValues;

  /// The default color values of this text caption.
  static Map<TextCaptionColor, Color> _defaultColors(AppColors colors) => {
    TextCaptionColor.normal: colors.active,
    TextCaptionColor.light: colors.onSurface.withValues(alpha: 0.6),
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;
    final defaults = _defaultColors(colors);
    final palette = colorValues ?? defaults;
    final color =
        palette[block.color] ??
        defaults[TextCaptionColor.normal] ??
        colors.active;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        block.text,
        style: AppText.caption.copyWith(color: color),
      ),
    );
  }
}
