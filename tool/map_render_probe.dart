import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'src/map_render_probe.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const MapRenderProbe(),
    ),
  );
}
