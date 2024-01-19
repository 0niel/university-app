import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class AppSettingsButton extends StatelessWidget {
  final VoidCallback onClick;
  const AppSettingsButton({
    Key? key,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
