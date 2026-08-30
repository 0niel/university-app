import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news_repository/news_repository.dart';

part 'categories_event.dart';
part 'categories_state.dart';
part 'categories_status.dart';
part 'categories_bloc.freezed.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({required this.newsRepository})
    : super(const CategoriesState()) {
    on<CategoriesRequested>(_onCategoriesRequested);
    on<CategorySelected>(_onCategorySelected);
  }

  final NewsRepository newsRepository;

  FutureOr<void> _onCategoriesRequested(
    CategoriesRequested event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    try {
      final response = await newsRepository.getCategories();

      emit(
        state.copyWith(
          status: .populated,
          categories: response.categories,
          selectedCategory: response.categories.firstOrNull,
          sources: response.sources,
        ),
      );
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void _onCategorySelected(
    CategorySelected event,
    Emitter<CategoriesState> emit,
  ) => emit(state.copyWith(selectedCategory: event.category));
}
