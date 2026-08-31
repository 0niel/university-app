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

  Future<void> load() async {
    emit(state.copyWith(status: .loading));
    try {
      final (profileResult, materialsResult, authorsResult) = await (
        _loadSource(
          _gamificationRepository.getProfile(),
          state.profile,
        ),
        _loadSource(
          _campusRepository.getPublicMaterials(),
          state.materials,
        ),
        _loadSource(
          _campusRepository.getTopMaterialAuthors(),
          state.authors,
        ),
      ).wait;
      final hasFreshData =
          profileResult.succeeded ||
          materialsResult.succeeded ||
          authorsResult.succeeded;
      emit(
        state.copyWith(
          status: hasFreshData ? .populated : .failure,
          profile: profileResult.value,
          materials: materialsResult.value,
          authors: authorsResult.value,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void typeChanged(String type) => emit(state.copyWith(type: type));

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

  StudyMaterial _incrementDownloads(StudyMaterial material) =>
      material.copyWith(downloads: material.downloads + 1);

  Future<({T value, bool succeeded})> _loadSource<T>(
    Future<T> future,
    T fallback,
  ) async {
    try {
      return (value: await future, succeeded: true);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      return (value: fallback, succeeded: false);
    }
  }
}
