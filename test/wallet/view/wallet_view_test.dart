import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/wallet/cubit/wallet_cubit.dart';
import 'package:rtu_mirea_app/wallet/view/wallet_view.dart';
import 'package:rtu_mirea_app/wallet/widgets/widgets.dart';

class MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {}

Widget _wrap(
  Widget child, {
  double textScale = 1,
  bool reduceMotion = false,
}) {
  return MaterialApp(
    theme: NinjaTheme.dark(),
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
        disableAnimations: reduceMotion,
        accessibleNavigation: reduceMotion,
      ),
      child: child!,
    ),
    home: child,
  );
}

void main() {
  group('WalletView loading skeleton', () {
    late WalletCubit cubit;

    setUp(() {
      cubit = MockWalletCubit();
    });

    testWidgets('shows skeleton and no spinner on cold load', (tester) async {
      when(() => cubit.state).thenReturn(
        const WalletState(status: WalletStatus.loading),
      );

      await tester.pumpWidget(
        _wrap(
          BlocProvider<WalletCubit>.value(
            value: cubit,
            child: const WalletView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(find.bySemanticsLabel('Загрузка'), findsWidgets);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.liveRegion ?? false),
        ),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows history skeleton when loading on the history tab', (
      tester,
    ) async {
      when(() => cubit.state).thenReturn(
        const WalletState(
          status: WalletStatus.loading,
          tab: WalletTab.history,
        ),
      );

      await tester.pumpWidget(
        _wrap(
          BlocProvider<WalletCubit>.value(
            value: cubit,
            child: const WalletView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(NinjaSkeleton), findsWidgets);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && (widget.properties.liveRegion ?? false),
        ),
        findsOneWidget,
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('WalletView failure state', () {
    late WalletCubit cubit;

    setUp(() {
      cubit = MockWalletCubit();
    });

    testWidgets('shows a retryable error instead of a fake zero balance', (
      tester,
    ) async {
      when(
        () => cubit.state,
      ).thenReturn(const WalletState(status: WalletStatus.failure));
      when(() => cubit.load()).thenAnswer((_) async {});

      await tester.pumpWidget(
        _wrap(
          BlocProvider<WalletCubit>.value(
            value: cubit,
            child: const WalletView(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Ошибка загрузки'), findsOneWidget);
      expect(find.byType(WalletBalanceBlock), findsNothing);
      await tester.tap(find.text('Повторить'));
      verify(() => cubit.load()).called(1);
    });
  });

  testWidgets('WalletView tabs ride a pill track on the deep canvas', (
    tester,
  ) async {
    final cubit = MockWalletCubit();
    when(() => cubit.state).thenReturn(
      const WalletState(status: WalletStatus.populated),
    );

    await tester.pumpWidget(
      _wrap(
        BlocProvider<WalletCubit>.value(
          value: cubit,
          child: const WalletView(),
        ),
      ),
    );
    await tester.pump();

    final colors = NinjaColors.dark();
    final track = find.byWidgetPredicate((widget) {
      if (widget is! Container) return false;
      final decoration = widget.decoration;
      return decoration is BoxDecoration &&
          decoration.color == colors.surfaceAlt &&
          decoration.borderRadius == BorderRadius.circular(NinjaRadius.pill);
    });
    expect(track, findsOneWidget);

    final selected = find.byWidgetPredicate((widget) {
      if (widget is! AnimatedContainer) return false;
      final decoration = widget.decoration;
      return decoration is BoxDecoration && decoration.color == colors.brand;
    });
    expect(selected, findsOneWidget);
  });

  testWidgets('WalletView fits 320px at 200 percent with reduced motion', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(320, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final cubit = MockWalletCubit();
    when(() => cubit.state).thenReturn(
      const WalletState(status: WalletStatus.populated),
    );

    await tester.pumpWidget(
      _wrap(
        BlocProvider<WalletCubit>.value(
          value: cubit,
          child: const WalletView(),
        ),
        textScale: 2,
        reduceMotion: true,
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
