import 'package:flutter/material.dart';

export 'assets.gen.dart';

// Generated assets file
class Assets {
  static const _AssetsIcons icons = _AssetsIcons();
}

class _AssetsIcons {
  const _AssetsIcons();

  SvgGenImage get playIcon => const SvgGenImage('assets/icons/play_icon.svg');
  SvgGenImage get arrowLeftDisable => const SvgGenImage('assets/icons/arrow_left_disable.svg');
  SvgGenImage get arrowLeftEnable => const SvgGenImage('assets/icons/arrow_left_enable.svg');
  SvgGenImage get arrowRightDisable => const SvgGenImage('assets/icons/arrow_right_disable.svg');
  SvgGenImage get arrowRightEnable => const SvgGenImage('assets/icons/arrow_right_enable.svg');
}

class SvgGenImage {
  const SvgGenImage(this.path);
  final String path;

  Widget svg({double? width, double? height, Color? color}) {
    // For now, return a placeholder icon
    return Icon(
      Icons.play_arrow,
      size: width ?? height ?? 24,
      color: color,
    );
  }
}
