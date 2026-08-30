import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/wallet/widgets/widgets.dart';

void main() {
  group('WalletBalanceBlock', () {
    const profile = UserGamificationProfile(
      userId: 'user-1',
      xp: 200,
      level: 4,
      shurikens: 88,
      streakDays: 9,
    );
    const overview = ProfileOverview(groupRank: 3, groupSize: 25);

    Widget buildSubject() {
      return MaterialApp(
        theme: NinjaTheme.dark(),
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: WalletBalanceBlock(profile: profile, overview: overview),
        ),
      );
    }

    testWidgets(
      'opens the shuriken explainer sheet from the info button',
      (tester) async {
        await tester.pumpWidget(buildSubject());

        expect(find.byType(WalletExplainerRow), findsNothing);

        await tester.tap(
          find.byWidgetPredicate(
            (widget) =>
                widget is AppLineIconWidget && widget.icon == AppLineIcon.info,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(WalletExplainerRow), findsOneWidget);
      },
    );
  });
}
