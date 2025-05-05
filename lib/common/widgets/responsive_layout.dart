import 'package:flutter/material.dart';

enum ScreenType { mobile, tablet, desktop }

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({super.key, required this.mobile, this.tablet, this.desktop});

  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1100) {
      return ScreenType.desktop;
    } else if (width >= 650) {
      return ScreenType.tablet;
    }
    return ScreenType.mobile;
  }

  static bool isDesktop(BuildContext context) => getScreenType(context) == ScreenType.desktop;

  static bool isTablet(BuildContext context) => getScreenType(context) == ScreenType.tablet;

  static bool isMobile(BuildContext context) => getScreenType(context) == ScreenType.mobile;

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(context);

    switch (screenType) {
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
        return mobile;
      default:
        return mobile;
    }
  }
}
