import 'package:app_ui/src/colors/colors.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_line_icon.dart';
import 'package:flutter/widgets.dart';

class AppEntryEmblem extends StatelessWidget {
  const AppEntryEmblem({required this.icon, super.key, this.tone});

  final AppLineIcon icon;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = tone ?? colors.ink;
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: tone == null ? colors.surface2 : colors.tintOf(color, .12),
        borderRadius: BorderRadius.circular(AppRadius.banner),
      ),
      child: AppLineIconWidget(icon, size: 24, color: color),
    );
  }
}
