import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/contributors/bloc/contributors_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/tools/view/tools_page.dart';
import 'package:unicons/unicons.dart';

import 'mock_contributors_bloc.dart';

void main() {
  group('ToolsView contributors loading', () {
    late ContributorsBloc bloc;

    setUp(() {
      bloc = MockContributorsBloc();
      when(() => bloc.state).thenReturn(
        const ContributorsState(status: ContributorsStatus.loading),
      );
    });

    Widget buildSubject({
      String? communityChatUrl,
      double textScale = 1,
      bool reduceMotion = false,
    }) {
      return MaterialApp(
        theme: AppTheme.darkTheme,
        locale: const Locale('ru'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ru')],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: reduceMotion,
            accessibleNavigation: reduceMotion,
          ),
          child: child!,
        ),
        home: RepositoryProvider.value(
          value: UniversityConfig(
            organizationId: 'example-university',
            appName: 'Example University',
            universityName: 'Example University',
            universityShortName: 'EU',
            websiteUrl: 'https://university.example',
            supportEmail: 'support@university.example',
            deepLinkScheme: 'exampleuniversity',
            webAppHost: 'app.university.example',
            webAppPathPrefix: '/app',
            communityChatUrl: communityChatUrl,
          ),
          child: BlocProvider<ContributorsBloc>.value(
            value: bloc,
            child: const ToolsView(),
          ),
        ),
      );
    }

    testWidgets(
      'shows the skeleton on cold load and hides the spinner',
      (tester) async {
        tester.view.physicalSize = const Size(600, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(buildSubject());
        await tester.pump();

        expect(find.byType(NinjaSkeleton), findsWidgets);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets('hides the chat card when it is not configured', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      expect(find.byIcon(UniconsLine.telegram), findsNothing);
    });

    testWidgets('shows the chat card when it is configured', (tester) async {
      await tester.pumpWidget(
        buildSubject(communityChatUrl: 'https://t.me/example_university'),
      );
      await tester.pump();

      expect(find.byIcon(UniconsLine.telegram), findsOneWidget);
    });

    testWidgets('the page header keeps a 44px circular refresh action', (
      tester,
    ) async {
      when(() => bloc.state).thenReturn(
        const ContributorsState(status: ContributorsStatus.loaded),
      );
      await tester.pumpWidget(buildSubject());
      await tester.pump();

      final button = find.byKey(const ValueKey('tools-refresh-button'));
      expect(button, findsOneWidget);
      expect(
        tester.getSize(button),
        const Size(NinjaMetrics.minTouchTarget, NinjaMetrics.minTouchTarget),
      );

      final title = tester.widget<Text>(find.text('Ссылки'));
      expect(title.style?.fontSize, NinjaText.display.fontSize);
    });

    testWidgets('a contributors failure keeps the community links usable', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(600, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      when(() => bloc.state).thenReturn(
        const ContributorsState(status: ContributorsStatus.failure),
      );

      await tester.pumpWidget(
        buildSubject(
          communityChatUrl: 'https://t.me/example_university',
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaErrorCard), findsOneWidget);
      expect(find.text('Повторить'), findsOneWidget);
      expect(find.byIcon(UniconsLine.github), findsOneWidget);
      expect(find.byIcon(UniconsLine.telegram), findsOneWidget);
    });

    testWidgets('fits a compact screen with large text', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildSubject(
          communityChatUrl: 'https://t.me/example_university',
          textScale: 2,
          reduceMotion: true,
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
    });
  });
}
