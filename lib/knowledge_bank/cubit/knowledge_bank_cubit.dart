import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gamification_repository/gamification_repository.dart';

part 'knowledge_bank_state.dart';
part 'knowledge_bank_cubit.freezed.dart';
part 'knowledge_bank_status.dart';

class KnowledgeBankCubit extends Cubit<KnowledgeBankState> {
  KnowledgeBankCubit({
    required this._campusRepository,
    required this._gamificationRepository,
  }) : super(const KnowledgeBankState());

  final CampusRepository _campusRepository;
  final GamificationRepository _gamificationRepository;
  int _loadRevision = 0;

  Future<void> load() async {
    if (isClosed) return;
    final revision = ++_loadRevision;
    emit(state.copyWith(status: .loading));
    try {
      final (profileResult, materialsResult, authorsResult) = await (
        _loadSource(
          _gamificationRepository.getProfile,
          state.profile,
        ),
        _loadSource(
          _campusRepository.getPublicMaterials,
          state.materials,
        ),
        _loadSource(
          _campusRepository.getTopMaterialAuthors,
          state.authors,
        ),
      ).wait;
      if (isClosed || revision != _loadRevision) return;
      emit(
        state.copyWith(
          status: materialsResult.succeeded ? .populated : .failure,
          profile: profileResult.value,
          materials: materialsResult.value,
          authors: authorsResult.value,
        ),
      );
      unawaited(_loadPreviewUrls(materialsResult.value, revision));
    } on Object catch (error, stackTrace) {
      if (isClosed || revision != _loadRevision) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _loadPreviewUrls(
    List<StudyMaterial> materials,
    int revision,
  ) async {
    try {
      final urls = await _campusRepository.createMaterialPreviewUrls(
        materials,
      );
      if (isClosed || revision != _loadRevision || urls.isEmpty) return;
      emit(state.copyWith(previewUrls: {...state.previewUrls, ...urls}));
    } on Object catch (error, stackTrace) {
      if (!isClosed) addError(error, stackTrace);
    }
  }

  Future<void> toggleLike(StudyMaterial material) async {
    final result = await _campusRepository.toggleMaterialLike(material.id);
    if (isClosed) return;
    emit(
      state.copyWith(
        materials: [
          for (final m in state.materials)
            if (m.id == material.id)
              m.copyWith(isLiked: result.liked, likes: result.likes)
            else
              m,
        ],
      ),
    );
  }

  void typeChanged(String type) {
    if (isClosed) return;
    emit(state.copyWith(type: type));
  }

  Future<Uri?> materialUrl(StudyMaterial material) async {
    try {
      final url = await _campusRepository.createPublicMaterialUrl(material);
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.isAbsolute) {
        throw const FormatException('Invalid material URL');
      }
      return uri;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return null;
    }
  }

  Future<MaterialAccess> materialAccess(StudyMaterial material) =>
      _campusRepository.getPublicMaterialAccess(material);

  Future<void> purchaseMaterial(
    StudyMaterial material, {
    required int expectedPrice,
  }) async {
    await _campusRepository.purchasePublicMaterial(
      material,
      expectedPrice: expectedPrice,
    );
    final profile = await _loadSource(
      _gamificationRepository.getProfile,
      state.profile,
    );
    if (!isClosed) emit(state.copyWith(profile: profile.value));
  }

  Future<void> materialOpened(StudyMaterial material) async {
    try {
      await _campusRepository.incrementMaterialDownloads(material.id);
      if (isClosed) return;
      emit(
        state.copyWith(
          materials: [
            for (final m in state.materials)
              if (m.id == material.id) _incrementDownloads(m) else m,
          ],
        ),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> materialUploaded() => load();

  Future<void> deleteMaterial(StudyMaterial material) async {
    await _campusRepository.deleteOwnMaterial(material.id);
    if (isClosed) return;
    emit(
      state.copyWith(
        materials: [
          for (final m in state.materials)
            if (m.id != material.id) m,
        ],
      ),
    );
  }

  StudyMaterial _incrementDownloads(StudyMaterial material) =>
      material.copyWith(downloads: material.downloads + 1);

  Future<({T value, bool succeeded})> _loadSource<T>(
    Future<T> Function() operation,
    T fallback,
  ) async {
    try {
      return (value: await operation(), succeeded: true);
    } on Object catch (error, stackTrace) {
      if (!isClosed) addError(error, stackTrace);
      return (value: fallback, succeeded: false);
    }
  }
}
