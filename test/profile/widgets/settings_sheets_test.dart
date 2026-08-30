import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_sheets.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    l10n = await AppLocalizations.delegate.load(const Locale('ru'));
  });

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
