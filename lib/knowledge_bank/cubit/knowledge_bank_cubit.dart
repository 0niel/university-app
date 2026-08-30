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

  Future<bool> download(StudyMaterial material) async {
    emit(
      state.copyWith(
        materials: [
          for (final m in state.materials)
            if (m.id == material.id) _incrementDownloads(m) else m,
        ],
      ),
    );
    try {
      await _campusRepository.incrementMaterialDownloads(material.id);
      return true;
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          materials: [
            for (final m in state.materials)
              if (m.id == material.id) material else m,
          ],
        ),
      );
      return false;
    }
  }

  Future<void> materialUploaded() => load();

  StudyMaterial _incrementDownloads(StudyMaterial m) => .new(
    id: m.id,
    title: m.title,
    subjectName: m.subjectName,
    materialType: m.materialType,
    downloads: m.downloads + 1,
    likes: m.likes,
    price: m.price,
    pages: m.pages,
    authorName: m.authorName,
    isMine: m.isMine,
    createdAt: m.createdAt,
  );

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
