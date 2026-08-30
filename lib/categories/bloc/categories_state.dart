part of 'categories_bloc.dart';

@freezed
abstract class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    @Default(CategoriesStatus.initial) CategoriesStatus status,
    List<Category>? categories,
    Category? selectedCategory,
    @Default(<NewsSourceItem>[]) List<NewsSourceItem> sources,
  }) = _CategoriesState;

  const CategoriesState._();

  String? getCategoryName(String categoryId) => categories
      ?.firstWhereOrNull((category) => category.id == categoryId)
      ?.name;
}
