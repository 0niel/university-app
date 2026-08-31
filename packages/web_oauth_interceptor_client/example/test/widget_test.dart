import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the OAuth action', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyApp()));

    expect(find.text('OAuth Interceptor Example'), findsOneWidget);
    expect(find.text('Start OAuth Flow'), findsOneWidget);
  });
}
