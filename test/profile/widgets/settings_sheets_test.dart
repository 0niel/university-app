import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/sync_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_sheets.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    l10n = await AppLocalizations.delegate.load(const Locale('ru'));
  });

  for (final policy in SyncPolicy.values) {
    testWidgets(
      'selecting ${policy.name} closes the root sheet and preserves '
      'the nested settings route',
      (tester) async {
        final nestedNavigator = GlobalKey<NavigatorState>();
        SyncPolicy? selected;
        await tester.pumpWidget(
          MaterialApp(
            theme: NinjaTheme.dark(),
            locale: const Locale('ru'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Navigator(
              key: nestedNavigator,
              onGenerateRoute: (_) => MaterialPageRoute<void>(
                builder: (context) => const Scaffold(body: Text('Profile')),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        unawaited(
          nestedNavigator.currentState!.push<void>(
            MaterialPageRoute<void>(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () => showSyncPolicySheet(
                    context,
                    current: SyncPolicy.always,
                    onSelected: (value) => selected = value,
                  ),
                  child: const Text('Settings'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();
        expect(find.byType(AppSheet), findsOneWidget);
        await tester.tap(find.text(syncPolicyLabel(l10n, policy)));
        await tester.pumpAndSettle();

        expect(selected, policy);
        expect(find.byType(AppSheet), findsNothing);
        expect(find.text('Settings'), findsOneWidget);
        expect(nestedNavigator.currentState!.canPop(), isTrue);
        expect(tester.takeException(), isNull);
      },
    );
  }

  group('homeContentSummary', () {
    test('reports every section when nothing is hidden', () {
      expect(
        homeContentSummary(l10n, const UiPreferencesState()),
        l10n.settingsHomeContentAll,
      );
    });

    test('reports an empty home honestly', () {
      expect(
        homeContentSummary(
          l10n,
          const UiPreferencesState(enabledSections: {}),
        ),
        l10n.settingsHomeContentNone,
      );
    });

    test('lists the sections the user actually kept', () {
      expect(
        homeContentSummary(
          l10n,
          const UiPreferencesState(
            enabledSections: {HomeSection.deadlines, HomeSection.trending},
          ),
        ),
        'дедлайны, обсуждения',
      );
    });
  });
}
