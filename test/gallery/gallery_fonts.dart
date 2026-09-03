import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadGalleryFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final sans = FontLoader(AppText.sansFamily);
  for (final weight in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    sans.addFont(
      rootBundle.load('packages/app_ui/assets/fonts/Onest/Onest-$weight.ttf'),
    );
  }
  final serif = FontLoader(AppText.serifFamily)
    ..addFont(
      rootBundle.load(
        'packages/app_ui/assets/fonts/Literata/Literata-Variable.ttf',
      ),
    )
    ..addFont(
      rootBundle.load(
        'packages/app_ui/assets/fonts/Literata/Literata-Italic-Variable.ttf',
      ),
    );
  await Future.wait([sans.load(), serif.load()]);
}
