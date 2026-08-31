import 'package:app_ui/src/ninja/ninja_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum NinjaGlyph {
  arrowLeft('<path d="M19 12H5M11 6l-6 6 6 6"/>'),
  chevronRight('<path d="m9 5 7 7-7 7"/>'),
  check('<path d="m4.5 12.5 5 5 10-11"/>'),
  trash('<path d="M4 7h16M9.5 7V4h5v3M6.5 7l1 13h9l1-13"/>'),
  warning('<path d="M12 3.5 22 20.5H2z"/><path d="M12 10v4.5M12 18h.01"/>'),
  info('<circle cx="12" cy="12" r="9"/><path d="M12 11v5M12 8h.01"/>'),
  search('<circle cx="11" cy="11" r="7"/><path d="m16.5 16.5 4.5 4.5"/>'),
  bell(
    '<path d="M6 9a6 6 0 0 1 12 0c0 5 2 6 2 6H4s2-1 2-6"/>'
    ' <path d="M10.5 20a1.8 1.8 0 0 0 3 0"/>',
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
    final resolvedColor = color ?? iconTheme.color ?? context.ninja.ink;
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
