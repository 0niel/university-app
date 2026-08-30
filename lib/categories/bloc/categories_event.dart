part of 'categories_bloc.dart';

@freezed
sealed class CategoriesEvent with _$CategoriesEvent {
  const factory CategoriesEvent.requested() = CategoriesRequested;

  const factory CategoriesEvent.categorySelected({
    required Category category,
  }) = CategorySelected;
}
