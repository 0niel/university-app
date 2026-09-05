import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:promo_repository/promo_repository.dart';
import 'package:rtu_mirea_app/profile/cubit/ui_preferences_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_sheets.dart';
import 'package:rtu_mirea_app/profile/widgets/settings_toggle_row.dart';
import 'package:rtu_mirea_app/promo/cubit/cubit.dart';
import 'package:rtu_mirea_app/promo/view/promo_banner_slot.dart';

import '../../helpers/pump_app.dart';

class _Banners extends MockCubit<PromoBannersState>
    implements PromoBannersCubit {}

class _Dismissals extends MockCubit<PromoDismissalsState>
    implements PromoDismissalsCubit {}

class _Preferences extends MockCubit<UiPreferencesState>
    implements UiPreferencesCubit {}

const banner = PromoBanner(
  id: 'b1',
  slug: 'yandex-eda-courier',
  title: 'Курьер Яндекс Еды',
  subtitle: 'Выплаты каждый день',
  kicker: 'Подработка',
  ctaLabel: 'Как заработать',
  ctaUrl: 'https://example.com',
  placements: [PromoPlacement.home, PromoPlacement.schedule],
);

void main() {
  late _Banners banners;
  late _Dismissals dismissals;
  late _Preferences preferences;

  setUpAll(() {
    registerFallbackValue(PromoPlacement.home);
    registerFallbackValue(PromoEvent.open);
    registerFallbackValue(banner);
  });

  setUp(() {
    banners = _Banners();
    dismissals = _Dismissals();
    preferences = _Preferences();
    when(() => banners.state).thenReturn(
      const PromoBannersState(banners: [banner], loaded: true),
    );
    when(() => dismissals.state).thenReturn(const PromoDismissalsState());
    when(() => preferences.state).thenReturn(const UiPreferencesState());
    when(() => banners.trackImpression(any(), any())).thenReturn(null);
  });

  Widget wrap(Widget child) => MultiBlocProvider(
    providers: [
      BlocProvider<PromoBannersCubit>.value(value: banners),
      BlocProvider<PromoDismissalsCubit>.value(value: dismissals),
      BlocProvider<UiPreferencesCubit>.value(value: preferences),
    ],
    child: Scaffold(body: child),
  );

  testWidgets('renders the banner and reports an impression', (tester) async {
    await tester.pumpApp(
      wrap(const PromoBannerSlot(placement: PromoPlacement.schedule)),
    );
    await tester.pump();

    expect(find.text('Курьер Яндекс Еды'), findsOneWidget);
    expect(find.text('Как заработать'), findsOneWidget);
    expect(find.byType(AppPromoCard), findsOneWidget);
    verify(
      () => banners.trackImpression(banner, PromoPlacement.schedule),
    ).called(1);
  });

  testWidgets('hides when partner offers are disabled', (tester) async {
    when(() => preferences.state).thenReturn(
      const UiPreferencesState(showPromoBanners: false),
    );
    await tester.pumpApp(
      wrap(const PromoBannerSlot(placement: PromoPlacement.home)),
    );

    expect(find.byType(AppPromoCard), findsNothing);
  });

  testWidgets('hides when the banner was hidden forever', (tester) async {
    when(() => dismissals.state).thenReturn(
      PromoDismissalsState(hidden: {banner.dismissKey}),
    );
    await tester.pumpApp(
      wrap(const PromoBannerSlot(placement: PromoPlacement.home)),
    );

    expect(find.byType(AppPromoCard), findsNothing);
  });

  testWidgets('enabling promos keeps individual hides and pending writes', (
    tester,
  ) async {
    when(() => preferences.state).thenReturn(
      const UiPreferencesState(showPromoBanners: false),
    );
    when(() => dismissals.state).thenReturn(
      PromoDismissalsState(
        hidden: {banner.dismissKey},
        pending: {banner.dismissKey},
      ),
    );
    await tester.pumpApp(
      wrap(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showHomeContentSheet(context),
            child: const Text('Settings'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    final toggle = tester
        .widgetList<SettingsToggleRow>(
          find.byType(SettingsToggleRow),
        )
        .last;
    toggle.onChanged!(true);
    verify(() => preferences.setShowPromoBanners(value: true)).called(1);
    verifyNever(() => dismissals.reset());
    expect(dismissals.state.hidden, {banner.dismissKey});
    expect(dismissals.state.pending, {banner.dismissKey});
  });

  testWidgets('renders nothing without promo providers', (tester) async {
    await tester.pumpApp(
      const Scaffold(body: PromoBannerSlot(placement: PromoPlacement.home)),
    );

    expect(find.byType(AppPromoCard), findsNothing);
  });

  testWidgets('close button opens the hide sheet with both options', (
    tester,
  ) async {
    await tester.pumpApp(
      wrap(const PromoBannerSlot(placement: PromoPlacement.home)),
    );
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppLineIconWidget && widget.icon == AppLineIcon.close,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Скрыть на 3 дня'), findsOneWidget);
    expect(find.text('Больше не показывать'), findsOneWidget);
  });

  testWidgets('hiding closes only the sheet and keeps the page', (
    tester,
  ) async {
    when(() => dismissals.hide(any())).thenReturn(null);
    when(
      () =>
          banners.trackEvent(any(), any(), placement: any(named: 'placement')),
    ).thenReturn(null);
    await tester.pumpApp(
      wrap(const PromoBannerSlot(placement: PromoPlacement.home)),
    );
    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppLineIconWidget && widget.icon == AppLineIcon.close,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Больше не показывать'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    verify(() => dismissals.hide(banner)).called(1);
    expect(find.byType(AppPromoCard), findsOneWidget);
    expect(find.text('Больше не показывать'), findsNothing);
    await tester.pump(const Duration(seconds: 3));
  });
}
