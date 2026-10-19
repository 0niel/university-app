import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rtu_mirea_app/design_preview/design_preview_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await AppGlass.warmUp().timeout(const Duration(seconds: 3));
  } on Object catch (error) {
    debugPrint('Glass shader preload failed: $error');
  }
  await initializeDateFormatting('ru');
  runApp(const DesignPreviewApp());
}
