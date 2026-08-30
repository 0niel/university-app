import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('renders items and reports the selected value', (tester) async {
    String? selectedValue;
    await tester.pumpWidget(
      wrap(
        AppChipRow(
          value: 'news',
          items: const [
            AppChipRowItem(value: 'news', label: 'Новости'),
            AppChipRowItem(value: 'events', label: 'События'),
          ],
          onChanged: (value) => selectedValue = value,
        ),
      ),
    );

    expect(find.text('Новости'), findsOneWidget);
    expect(find.text('События'), findsOneWidget);

    await tester.tap(find.text('События'));
    expect(selectedValue, 'events');
  });
}
