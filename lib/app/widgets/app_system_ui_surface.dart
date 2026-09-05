import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtu_mirea_app/app/utils/system_ui_configurator.dart';

class AppSystemUiSurface extends StatelessWidget {
  const AppSystemUiSurface({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appSystemUiOverlayStyle(theme),
      child: ColoredBox(color: theme.scaffoldBackgroundColor, child: child),
    );
  }
}
