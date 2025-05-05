import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'lost_and_found_event.dart';
part 'lost_and_found_state.dart';

class LostFoundBloc extends Bloc<LostFoundEvent, LostFoundState> {
  final LostFoundRepository repository;
  final UserRepository userRepository;

  LostFoundBloc({required this.repository, required this.userRepository}) : super(LostFoundInitial()) {
    on<LoadLostFoundItems>(_onLoadLostFoundItems);
    on<CreateLostFoundItem>(_onCreateLostFoundItem);
    on<UpdateLostFoundItem>(_onUpdateLostFoundItem);
    on<DeleteLostFoundItem>(_onDeleteLostFoundItem);
    on<SearchLostFoundItems>(_onSearchLostFoundItems);
    on<UpdateLostFoundItemStatus>(_onUpdateItemStatus);
  }

  Future<void> _onUpdateItemStatus(UpdateLostFoundItemStatus event, Emitter<LostFoundState> emit) async {
    emit(LostFoundLoading());
    try {
      await repository.updateItemStatus(itemId: event.item.id!, newStatus: event.newStatus);
      emit(LostFoundOperationSuccess('Статус объявления успешно обновлен'));
    } catch (e) {
      emit(LostFoundError(e.toString()));
    }
  }

  Future<void> _onLoadLostFoundItems(LoadLostFoundItems event, Emitter<LostFoundState> emit) async {
    emit(LostFoundLoading());
    try {
      final items = await repository.getItems(status: event.status);
      emit(LostFoundLoaded(items));
    } catch (e) {
      emit(LostFoundError(e.toString()));
    }
  }

  Future<void> _onCreateLostFoundItem(CreateLostFoundItem event, Emitter<LostFoundState> emit) async {
    emit(LostFoundLoading());
    try {
      final user = await userRepository.user.first;
      await repository.createItem(
        authorId: user.id,
        authorEmail: user.email!,
        title: event.title,
        description: event.description,
        telegram: event.telegram,
        phoneNumber: event.phoneNumber,
        status: event.status,
        images: event.images,
      );
      emit(LostFoundOperationSuccess('Объявление успешно создано'));
    } catch (e) {
      emit(LostFoundError(e.toString()));
    }
  }

  Future<void> _onUpdateLostFoundItem(UpdateLostFoundItem event, Emitter<LostFoundState> emit) async {
    emit(LostFoundLoading());
    try {
      final user = await userRepository.user.first;
      if (user.id != event.item.authorId) {
        throw Exception('У вас нет прав на редактирование этого объявления');
      }

      await repository.updateItem(item: event.item);
      emit(LostFoundOperationSuccess('Объявление успешно обновлено'));
    } catch (e) {
      emit(LostFoundError(e.toString()));
    }
  }

  Future<void> _onDeleteLostFoundItem(DeleteLostFoundItem event, Emitter<LostFoundState> emit) async {
    emit(LostFoundLoading());
    try {
      final user = await userRepository.user.first;
      if (user.id != event.item.authorId) {
        throw Exception('У вас нет прав на удаление этого объявления');
      }

      await repository.deleteItem(itemId: event.item.id!);
      emit(LostFoundOperationSuccess('Объявление успешно удалено'));
    } catch (e) {
      emit(LostFoundError(e.toString()));
    }
  }

  Future<void> _onSearchLostFoundItems(SearchLostFoundItems event, Emitter<LostFoundState> emit) async {
    emit(LostFoundLoading());
    try {
      final items = await repository.searchItems(query: event.query);
      emit(LostFoundLoaded(items));
    } catch (e) {
      emit(LostFoundError(e.toString()));
    }
  }
}
