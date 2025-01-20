import 'package:flutter/material.dart';
import 'package:wear/ambient_mode/ambient_mode.dart';
import 'package:wear/l10n/l10n.dart';
import 'package:wear/nfc_pass/nfc_pass.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AmbientModeBuilder(
      child: const CounterPage(),
      builder: (context, isAmbientModeActive, child) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            // This makes elements such as buttons have a fewer pixels in
            // padding and general spacing. good for devices with limited screen
            // real state.
            visualDensity: VisualDensity.compact,
            // When in ambient mode, change the apps color scheme
            colorScheme: isAmbientModeActive
                ? const ColorScheme.dark(
                    primary: Colors.white24,
                    onSurface: Colors.white10,
                  )
                : const ColorScheme.dark(
                    primary: Color(0xFF6200EE),
                  ),
          ),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        );
      },
    );
  }
}
