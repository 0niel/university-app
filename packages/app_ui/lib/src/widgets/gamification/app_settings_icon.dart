import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/widgets/app_icon_tile.dart';
import 'package:flutter/widgets.dart';

class AppSettingsIcon extends StatelessWidget {
  const AppSettingsIcon({
    required this.icon,
    required this.color,
    super.key,
    this.size = 36,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AppIconTile(
      size: size,
      radius: size / 3,
      background: context.colors.tintOf(color),
      child: Icon(icon, size: size * .5, color: color),
    );
  }
}
