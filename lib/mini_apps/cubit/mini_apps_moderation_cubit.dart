import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';

part 'mini_apps_moderation_state.dart';
part 'mini_apps_moderation_status.dart';
part 'mini_apps_moderation_cubit.freezed.dart';

class MiniAppsModerationCubit extends Cubit<MiniAppsModerationState> {
  MiniAppsModerationCubit({required MiniAppsRepository miniAppsRepository})
    : _repository = miniAppsRepository,
      super(const MiniAppsModerationState());

  final MiniAppsRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: .loading));
    try {
      final queue = await _repository.getModerationQueue();
      emit(
        state.copyWith(
          status: .populated,
          queue: queue,
          processingAppId: null,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<bool> moderate(
    MiniApp app,
    MiniAppModerationAction action, {
    String notes = '',
  }) async {
    emit(state.copyWith(processingAppId: app.id));
    try {
      await _repository.moderateApp(
        appId: app.id,
        action: action,
        notes: notes,
      );
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(processingAppId: null));
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> resolveReports(
    MiniApp app, {
    bool dismiss = false,
    String notes = '',
  }) async {
    emit(state.copyWith(processingAppId: app.id));
    try {
      await _repository.resolveReports(
        appId: app.id,
        dismiss: dismiss,
        notes: notes,
      );
      await load();
      return true;
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(processingAppId: null));
      addError(error, stackTrace);
      return false;
    }
  }
}
