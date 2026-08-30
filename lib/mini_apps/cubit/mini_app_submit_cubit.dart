import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';

part 'mini_app_submit_state.dart';
part 'mini_app_submit_status.dart';
part 'mini_app_submit_cubit.freezed.dart';

class MiniAppSubmitCubit extends Cubit<MiniAppSubmitState> {
  MiniAppSubmitCubit({required MiniAppsRepository miniAppsRepository})
    : _repository = miniAppsRepository,
      super(const MiniAppSubmitState());

  final MiniAppsRepository _repository;

  static final _slugPattern = RegExp(r'^[a-z0-9][a-z0-9-]{2,39}$');

  Map<String, dynamic>? parseScreenJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } on FormatException catch (_) {}
    emit(state.copyWith(status: .invalidJson));
    return null;
  }

  bool isSlugValid(String slug) => _slugPattern.hasMatch(slug);

  Future<void> submit({
    required String slug,
    required String name,
    required String description,
    required String iconEmoji,
    required MiniAppCategory category,
    required MiniAppSourceKind sourceKind,
    String? originUrl,
    String entryPath = '/',
    List<MiniAppScreen> screens = const [],
    List<MiniAppPermission> permissions = const [],
    bool asDraft = false,
  }) async {
    if (!isSlugValid(slug) || name.trim().isEmpty) {
      emit(state.copyWith(status: .invalidFields));
      return;
    }
    final hosted = sourceKind == .hosted;
    if (hosted && screens.isEmpty) {
      emit(state.copyWith(status: .invalidJson));
      return;
    }
    if (hosted && !_screenPathsValid(screens)) {
      emit(state.copyWith(status: .invalidScreens));
      return;
    }
    if (sourceKind == .remote && !(originUrl ?? '').startsWith('https://')) {
      emit(state.copyWith(status: .invalidFields));
      return;
    }

    emit(state.copyWith(status: .submitting));
    try {
      await _repository.submitApp(
        slug: slug,
        name: name.trim(),
        description: description.trim(),
        iconEmoji: iconEmoji.isEmpty ? '🧩' : iconEmoji,
        category: category,
        sourceKind: sourceKind,
        originUrl: sourceKind == .remote ? originUrl : null,
        entryPath: hosted ? '/' : entryPath,
        screens: hosted ? screens : const [],
        permissions: sourceKind == .remote ? permissions : const [],
        asDraft: asDraft,
      );
      emit(state.copyWith(status: .success));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  static final _pathPattern = RegExp(r'^/[a-z0-9\-/]*$');

  bool _screenPathsValid(List<MiniAppScreen> screens) {
    final paths = screens.map((s) => s.path).toList();
    return paths.contains('/') &&
        paths.toSet().length == paths.length &&
        paths.every(_pathPattern.hasMatch);
  }
}
