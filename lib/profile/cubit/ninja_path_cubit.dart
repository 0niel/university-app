import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/gamification_repository.dart';

part 'ninja_path_cubit.freezed.dart';
part 'leaderboard_scope.dart';
part 'ninja_path_load_status.dart';
part 'ninja_path_state.dart';

class NinjaPathCubit extends Cubit<NinjaPathState> {
  NinjaPathCubit({
    required GamificationRepository gamificationRepository,
    required this.organizationId,
  }) : _gamification = gamificationRepository,
       super(const NinjaPathState());

  final GamificationRepository _gamification;
  final String organizationId;
  var _leaderboardRequest = 0;

  Future<void> load() async {
    await Future.wait([
      loadBadges(),
      loadQuests(),
      loadLeaderboard(.group),
    ]);
  }

  Future<void> loadBadges() async {
    emit(state.copyWith(badgesStatus: .loading));
    try {
      final badges = await _gamification.getBadges();
      final recent = badges.where((b) => b.isEarned).toList()
        ..sort(
          (a, b) => (b.earnedAt ?? DateTime(0)).compareTo(
            a.earnedAt ?? DateTime(0),
          ),
        );
      if (isClosed) return;
      emit(
        state.copyWith(
          badgesStatus: .loaded,
          badges: badges,
          recentlyUnlocked: recent.firstOrNull,
        ),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      if (!isClosed) {
        emit(state.copyWith(badgesStatus: .error));
      }
    }
  }

  Future<void> loadQuests() async {
    emit(state.copyWith(questsStatus: .loading));
    try {
      final quests = await _gamification.getQuests();
      if (isClosed) return;
      emit(
        state.copyWith(
          questsStatus: .loaded,
          quests: quests,
        ),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      if (!isClosed) {
        emit(state.copyWith(questsStatus: .error));
      }
    }
  }

  Future<void> loadLeaderboard(LeaderboardScope scope) async {
    emit(
      state.copyWith(
        leaderboardStatus: .loading,
        leaderboardScope: scope,
      ),
    );
    final request = ++_leaderboardRequest;
    try {
      final entries = await _gamification.getLeaderboard(
        organizationId,
        scope: scope.value,
      );
      if (isClosed || request != _leaderboardRequest) return;
      emit(
        state.copyWith(
          leaderboardStatus: .loaded,
          leaderboard: entries,
        ),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      if (!isClosed && request == _leaderboardRequest) {
        emit(state.copyWith(leaderboardStatus: .error));
      }
    }
  }
}
