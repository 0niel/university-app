import 'package:app_ui/src/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum NinjaGlyph {
  arrowLeft('<path d="M15 6l-6 6 6 6"/>'),
  chevronRight('<path d="M9 6l6 6-6 6"/>'),
  check('<path d="M5 12l4.5 4.5L19 7"/>'),
  trash(
    '<path d="M3 6h18M8 6V4a1 1 0 011-1h6a1 1 0 011 1v2 '
    'M5 6l1 14a2 2 0 002 2h8a2 2 0 002-2l1-14"/>',
  ),
  warning('<path d="M12 3l9 16H3z"/><path d="M12 10v4M12 17v.5"/>'),
  info(
    '<circle cx="12" cy="12" r="9"/><path d="M12 11v6"/> '
    '<circle cx="12" cy="8" r="1" fill="currentColor"/>',
  ),
  search('<circle cx="11" cy="11" r="6.5"/><path d="M20 20l-4.2-4.2"/>'),
  bell(
    '<path d="M6 16V11a6 6 0 0112 0v5l1.5 2H4.5L6 16z"/> '
    '<path d="M10 20a2 2 0 004 0"/>',
  );

  const NinjaGlyph(this.body);

  final String body;
}

class NinjaGlyphIcon extends StatelessWidget {
  const NinjaGlyphIcon(
    this.glyph, {
    super.key,
    this.size,
    this.color,
    this.strokeWidth = 2,
  });

  final NinjaGlyph glyph;
  final double? size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final resolvedSize = size ?? iconTheme.size ?? 20;
    final resolvedColor = color ?? iconTheme.color ?? context.colors.ink;
    final svg = '<svg xmlns="http://www.w3.org/2000/svg" width="$resolvedSize" '
        'height="$resolvedSize" viewBox="0 0 24 24" fill="none" '
        'stroke="#000000" stroke-width="$strokeWidth" stroke-linecap="round" '
        'stroke-linejoin="round">${glyph.body}</svg>';

    return Align(
      widthFactor: 1,
      heightFactor: 1,
      child: SvgPicture.string(
        svg,
        width: resolvedSize,
        height: resolvedSize,
        colorFilter: ColorFilter.mode(resolvedColor, BlendMode.srcIn),
      ),
    );
  }
}
