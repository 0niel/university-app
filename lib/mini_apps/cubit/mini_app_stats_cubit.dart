import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';

part 'mini_app_stats_state.dart';
part 'mini_app_stats_range.dart';
part 'mini_app_stats_status.dart';
part 'mini_app_stats_cubit.freezed.dart';

class MiniAppStatsCubit extends Cubit<MiniAppStatsState> {
  MiniAppStatsCubit({
    required MiniAppsRepository miniAppsRepository,
    required this._appId,
  }) : _repository = miniAppsRepository,
       super(const MiniAppStatsState());

  final MiniAppsRepository _repository;
  final String _appId;

  Future<void> load() => _fetch(state.range);

  Future<void> rangeChanged(MiniAppStatsRange range) {
    if (range == state.range && state.status == .populated) {
      return Future.value();
    }
    return _fetch(range);
  }

  Future<void> _fetch(MiniAppStatsRange range) async {
    emit(state.copyWith(status: .loading, range: range));
    try {
      final stats = await _repository.getStats(_appId, days: range.days);
      if (range != state.range) return;
      emit(state.copyWith(status: .populated, stats: stats));
    } on Exception catch (error, stackTrace) {
      if (range != state.range) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }
}
