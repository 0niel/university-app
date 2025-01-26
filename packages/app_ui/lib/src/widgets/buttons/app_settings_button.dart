import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSettingsButton extends StatelessWidget {
  const AppSettingsButton({
    required this.onClick,
    super.key,
  });
  final VoidCallback onClick;

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
          color: Theme.of(context).extension<AppColors>()!.active,
        ),
      ),
    );
  }
}
