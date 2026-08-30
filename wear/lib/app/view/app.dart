import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:wear/ambient_mode/ambient_mode.dart';
import 'package:wear/home/home.dart';
import 'package:wear/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return AmbientModeBuilder(
      child: const HomePage(),
      builder: (context, isAmbientModeActive, child) {
        return MaterialApp(
          theme: AppTheme.darkTheme.copyWith(
            visualDensity: VisualDensity.compact,
            extensions: [
              if (isAmbientModeActive)
                AppColors.dark.copyWith(
                  active: Colors.white70,
                  deactive: Colors.white38,
                  primary: Colors.white24,
                )
              else
                AppColors.dark,
            ],
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
