import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/knowledge_bank/utils/material_search.dart';
import 'package:rtu_mirea_app/knowledge_bank/widgets/material_subject_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class _Repository extends Mock implements CampusRepository {}

Widget _subject(CampusRepository repository) => MaterialApp(
  theme: AppTheme.lightTheme,
  locale: const Locale('ru'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: MaterialSubjectPicker(repository: repository, selected: const {}),
  ),
);

void main() {
  test('material normalization preserves programming-language symbols', () {
    expect(normalizeMaterialSearch(' C++ '), 'c++');
    expect(normalizeMaterialSearch('C#'), 'c#');
    expect(
      normalizeMaterialSearch('Дискретная — математика'),
      'дискретнаяматематика',
    );
  });

  testWidgets('keeps selected subjects when the query changes', (tester) async {
    final repository = _Repository();
    when(
      () => repository.searchMaterialSubjects(any()),
    ).thenAnswer((_) async => ['Математика', 'Программирование']);
    await tester.pumpWidget(_subject(repository));
    await tester.pump();
    await tester.tap(find.text('Математика'));
    await tester.enterText(find.byType(TextField), 'прог');
    await tester.pump(const Duration(milliseconds: 310));
    await tester.pump();
    await tester.tap(find.text('Программирование'));
    await tester.enterText(find.byType(TextField), '');
    await tester.pump(const Duration(milliseconds: 310));
    await tester.pump();
    final checkboxes = tester.widgetList<AppCheckbox>(find.byType(AppCheckbox));
    expect(checkboxes.map((checkbox) => checkbox.value), [true, true]);
  });

  testWidgets('ignores an old response after a newer query', (tester) async {
    final repository = _Repository();
    final old = Completer<List<String>>();
    final recent = Completer<List<String>>();
    when(
      () => repository.searchMaterialSubjects(''),
    ).thenAnswer((_) => old.future);
    when(
      () => repository.searchMaterialSubjects('прог'),
    ).thenAnswer((_) => recent.future);
    await tester.pumpWidget(_subject(repository));
    await tester.enterText(find.byType(TextField), 'прог');
    await tester.pump(const Duration(milliseconds: 310));
    recent.complete(['Программирование']);
    await tester.pump();
    old.complete(['Математика']);
    await tester.pump();
    expect(find.text('Программирование'), findsOneWidget);
    expect(find.text('Математика'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
