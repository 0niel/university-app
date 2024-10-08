import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class AppSettingsButton extends StatelessWidget {
  final VoidCallback onClick;
  const AppSettingsButton({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      onPressed: onClick,
      icon: Container(
        padding: const EdgeInsets.all(4),
        child: SvgPicture.asset(
          'assets/icons/filter.svg',
          width: 20,
          height: 20,
          color: AppTheme.colorsOf(context).active,
        ),
      ),
    );
  }
}
