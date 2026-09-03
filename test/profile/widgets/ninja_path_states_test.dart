import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamification_repository/gamification_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/profile/cubit/ninja_path_cubit.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/badges_tab.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/leaderboard_tab.dart';
import 'package:rtu_mirea_app/profile/widgets/ninja_path/quests_tab.dart';

class _Path extends MockCubit<NinjaPathState> implements NinjaPathCubit {}

Widget _app(
  NinjaPathCubit cubit,
  Widget child, {
  bool dark = false,
  double scale = 1,
}) => BlocProvider<NinjaPathCubit>.value(
  value: cubit,
  child: MaterialApp(
    theme: dark ? AppTheme.darkTheme : AppTheme.lightTheme,
    locale: const Locale('ru'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale), disableAnimations: true),
      child: child!,
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(20), child: child),
      ),
    ),
  ),
);

void main() {
  for (final (name, tab) in <(String, Widget)>[
    ('badges', const BadgesTab()),
    ('quests', const QuestsTab()),
    ('leaderboard', const LeaderboardTab()),
  ]) {
    for (final status in [
      NinjaPathLoadStatus.loading,
      NinjaPathLoadStatus.error,
      NinjaPathLoadStatus.loaded,
    ]) {
      testWidgets('$name has a distinct ${status.name} state', (tester) async {
        final cubit = _Path();
        when(() => cubit.state).thenReturn(
          NinjaPathState(
            badgesStatus: status,
            questsStatus: status,
            leaderboardStatus: status,
          ),
        );
        await tester.pumpWidget(_app(cubit, tab));
        await tester.pump(const Duration(milliseconds: 400));
        switch (status) {
          case NinjaPathLoadStatus.loading:
            expect(find.byType(NinjaSkeletonGroup), findsWidgets);
          case NinjaPathLoadStatus.error:
            expect(find.byType(AppErrorState), findsOneWidget);
          case NinjaPathLoadStatus.loaded:
            expect(find.byType(AppEmptyState), findsOneWidget);
          case NinjaPathLoadStatus.initial:
            fail('Unexpected test state');
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final dark in [false, true]) {
    testWidgets(
      'badge grid fits 320px with 200 percent text ${dark ? 'dark' : 'light'}',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(320, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final cubit = _Path();
        when(() => cubit.state).thenReturn(
          const NinjaPathState(
            badgesStatus: NinjaPathLoadStatus.loaded,
            badges: [
              GamificationBadge(
                id: 'one',
                category: 'Активность',
                name: 'Длинное название достижения',
                description:
                    'Подробное описание реального достижения пользователя',
                emoji: '🏆',
                progress: .5,
              ),
              GamificationBadge(
                id: 'two',
                category: 'Активность',
                name: 'Полученное достижение',
                description: 'Ещё одно описание достижения',
                emoji: '⭐',
                isEarned: true,
              ),
            ],
          ),
        );
        await tester.pumpWidget(
          _app(cubit, const BadgesTab(), dark: dark, scale: 2),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final grid = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisCount, 2);
        expect(delegate.childAspectRatio, .4);
      },
    );
  }
}
