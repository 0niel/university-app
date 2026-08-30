part of 'knowledge_bank_cubit.dart';

@freezed
abstract class KnowledgeBankState with _$KnowledgeBankState {
  const factory KnowledgeBankState({
    @Default(KnowledgeBankStatus.initial) KnowledgeBankStatus status,
    @Default(UserGamificationProfile.empty) UserGamificationProfile profile,
    @Default(<StudyMaterial>[]) List<StudyMaterial> materials,
    @Default(<MaterialAuthor>[]) List<MaterialAuthor> authors,
    @Default('all') String type,
  }) = _KnowledgeBankState;

  const KnowledgeBankState._();

  List<StudyMaterial> get filteredMaterials => [
    for (final material in materials)
      if (type == 'all' || material.materialType == type) material,
  ];
}
