import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void configureSystemUI(ThemeData theme) {
  unawaited(SystemChrome.setEnabledSystemUIMode(.edgeToEdge));
  SystemChrome.setSystemUIOverlayStyle(appSystemUiOverlayStyle(theme));
}

SystemUiOverlayStyle appSystemUiOverlayStyle(ThemeData theme) {
  final isDark = theme.brightness == .dark;
  final iconBrightness = isDark ? Brightness.light : Brightness.dark;

  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: theme.scaffoldBackgroundColor,
    statusBarIconBrightness: iconBrightness,
    statusBarBrightness: isDark ? .dark : .light,
    systemNavigationBarIconBrightness: iconBrightness,
    systemNavigationBarDividerColor: Colors.transparent,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarContrastEnforced: false,
  );
}
