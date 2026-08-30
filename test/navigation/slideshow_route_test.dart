import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';

void main() {
  testWidgets('shows a useful fallback when slideshow payload is absent', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/slideshow',
      routes: Routes.all,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.darkTheme,
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
    await tester.pump();

    expect(find.text('Слайд-шоу'), findsOneWidget);
    expect(find.text('Ошибка загрузки'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppLineIconWidget && widget.icon == AppLineIcon.image,
      ),
      findsOneWidget,
    );
  });
}
