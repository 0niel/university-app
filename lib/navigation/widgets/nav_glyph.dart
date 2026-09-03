import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';

enum NavGlyph { home, schedule, map, services, profile }

class NavGlyphIcon extends StatelessWidget {
  const NavGlyphIcon(
    this.glyph, {
    super.key,
    this.size = 23,
    this.strokeWidth = 2.2,
  });

  final NavGlyph glyph;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return AppLineIconWidget(
      switch (glyph) {
        NavGlyph.home => AppLineIcon.home,
        NavGlyph.schedule => AppLineIcon.calendar,
        NavGlyph.map => AppLineIcon.map,
        NavGlyph.services => AppLineIcon.services,
        NavGlyph.profile => AppLineIcon.user,
      },
      size: size,
      strokeWidth: strokeWidth,
    );
  }
}
