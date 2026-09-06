import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/friends/cubit/friends_list_cubit.dart';
import 'package:rtu_mirea_app/home/cubit/home_cubit.dart';
import 'package:rtu_mirea_app/home/models/app_settings.dart';
import 'package:rtu_mirea_app/home/view/widgets/home_quick_actions.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/navigation/routes/routes.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_hce_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/pass_security_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/geo_sharing_cubit.dart';
import 'package:rtu_mirea_app/profile/cubit/profile_cubit.dart';
import 'package:rtu_mirea_app/profile/utils/settings_search_filter.dart';
import 'package:rtu_mirea_app/profile/view/profile_page.dart';
import 'package:rtu_mirea_app/profile/widgets/settings/settings_privacy_section.dart';
import 'package:rtu_mirea_app/services/data/services_directory.dart';

import '../helpers/pump_app.dart';

class _App extends Mock implements AppBloc {}

class _Home extends Mock implements HomeCubit {}

class _Profile extends MockCubit<ProfileState> implements ProfileCubit {}

class _Friends extends MockCubit<FriendsListState>
    implements FriendsListCubit {}

class _Pass extends MockCubit<PassSecurityState> implements PassSecurityCubit {}

class _Hce extends MockCubit<NfcHceState> implements NfcHceCubit {}

class _Geo extends MockCubit<GeoSharingState> implements GeoSharingCubit {}

void main() {
  for (final platform in [TargetPlatform.iOS, TargetPlatform.android]) {
    final supported = platform == TargetPlatform.android;

    testWidgets(
      'catalog, search and saved shortcuts respect $platform',
      (tester) async {
        await tester.pumpApp(
          Scaffold(
            body: Builder(
              builder: (context) {
                final config = UniversityConfig.current;
                expect(config.isEnabled(.nfcPass), isTrue);
                final entries = ServicesDirectory.sections(
                  context,
                  config: config,
                ).expand((section) => section.entries).toList();
                expect(
                  entries.any(
                    (entry) => entry.model.routePath == '/services/nfc',
                  ),
                  supported,
                );
                expect(
                  entries.any(
                    (entry) => entry.model.routePath == '/services/wallet',
                  ),
                  isTrue,
                );
                const savedIds = {'/services/nfc', '/services/deadlines'};
                return HomeQuickActions(
                  services: entries
                      .where((entry) => savedIds.contains(entry.id))
                      .toList(),
                  onAll: () {},
                );
              },
            ),
          ),
        );
        final l10n = tester.element(find.byType(HomeQuickActions)).l10n;
        expect(
          find.text(l10n.homePass),
          supported ? findsOneWidget : findsNothing,
        );
        expect(find.text(l10n.homeDeadlines), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant.only(platform),
    );

    testWidgets(
      'profile hides only the pass entry on $platform',
      (tester) async {
        PackageInfo.setMockInitialValues(
          appName: 'App',
          packageName: 'test.app',
          version: '1',
          buildNumber: '1',
          buildSignature: '',
        );
        final profile = _Profile();
        final friends = _Friends();
        when(() => profile.state).thenReturn(const ProfileState());
        when(() => friends.state).thenReturn(const FriendsListState());
        addTearDown(profile.close);
        addTearDown(friends.close);
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: profile),
              BlocProvider<FriendsListCubit>.value(value: friends),
            ],
            child: const ProfileView(),
          ),
          size: const Size(430, 2200),
        );
        await tester.pumpAndSettle();
        final l10n = tester.element(find.byType(ProfileView)).l10n;
        expect(
          find.text(l10n.profileStudentCard),
          supported ? findsOneWidget : findsNothing,
        );
        expect(find.text(l10n.friendsTitle), findsOneWidget);
        expect(find.text(l10n.settingsTitle), findsWidgets);
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant.only(platform),
    );

    testWidgets(
      'privacy pass settings and search respect $platform',
      (tester) async {
        final pass = _Pass();
        final hce = _Hce();
        final geo = _Geo();
        when(
          () => pass.state,
        ).thenReturn(const PassSecurityState(available: true));
        when(() => hce.state).thenReturn(const NfcHceState(available: true));
        when(() => geo.state).thenReturn(const GeoSharingState(loaded: true));
        addTearDown(pass.close);
        addTearDown(hce.close);
        addTearDown(geo.close);
        await tester.pumpApp(
          MultiBlocProvider(
            providers: [
              if (supported) BlocProvider<PassSecurityCubit>.value(value: pass),
              if (supported) BlocProvider<NfcHceCubit>.value(value: hce),
              BlocProvider<GeoSharingCubit>.value(value: geo),
            ],
            child: Scaffold(
              body: SettingsPrivacySection(
                settings: const UserSettings(),
                onChanged: (_) {},
              ),
            ),
          ),
        );
        final l10n = tester.element(find.byType(SettingsPrivacySection)).l10n;
        expect(
          find.text(l10n.settingsBiometricsPass),
          supported ? findsOneWidget : findsNothing,
        );
        expect(
          find.text(l10n.settingsNfcEmulation),
          supported ? findsOneWidget : findsNothing,
        );
        expect(find.text(l10n.settingsAnonymousReactions), findsOneWidget);
        expect(
          SettingsSearchFilter(
            query: l10n.settingsBiometricsPass,
            l10n: l10n,
          ).hasResults,
          supported,
        );
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant.only(platform),
    );

    testWidgets(
      'old pass links redirect safely on $platform',
      (tester) async {
        final app = _App();
        final home = _Home();
        when(
          () => app.state,
        ).thenReturn(const AppState(status: AppStatus.authenticated));
        when(() => home.state).thenReturn(
          const HomeState(settings: AppSettings(onboardingShown: true)),
        );
        final production = createRouter(appBloc: app, homeCubit: home);
        final router = GoRouter(
          initialLocation: '/services/nfc?from=shortcut',
          redirect: production.configuration.topRedirect,
          routes: [
            for (final path in ['/services', '/services/nfc'])
              GoRoute(path: path, builder: (_, _) => Text(path)),
          ],
        );
        addTearDown(router.dispose);
        addTearDown(production.dispose);
        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.path,
          supported ? '/services/nfc' : '/services',
        );
        expect(tester.takeException(), isNull);
      },
      variant: TargetPlatformVariant.only(platform),
    );
  }
}
