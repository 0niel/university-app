part of 'lost_and_found_bloc.dart';

abstract class LostFoundEvent extends Equatable {
  const LostFoundEvent();

  @override
  List<Object?> get props => [];
}

/// Загрузить записи (список вещей)
class LoadLostFoundItems extends LostFoundEvent {
  final LostFoundItemStatus? status;

  const LoadLostFoundItems({this.status});

  @override
  List<Object?> get props => [status];
}

/// Создать новую запись
class CreateLostFoundItem extends LostFoundEvent {
  final String title;
  final String? description;
  final String? telegram;
  final String? phoneNumber;
  final LostFoundItemStatus status;
  final List<File> images;

  const CreateLostFoundItem({
    required this.title,
    this.description,
    this.telegram,
    this.phoneNumber,
    required this.status,
    required this.images,
  });

  @override
  List<Object?> get props => [title, description, telegram, phoneNumber, status, images];
}

/// Обновить запись
class UpdateLostFoundItem extends LostFoundEvent {
  final LostFoundItem item;
  final List<File> newImages;

  const UpdateLostFoundItem(this.item, this.newImages);

  @override
  List<Object?> get props => [item, newImages];
}

/// Удалить запись
class DeleteLostFoundItem extends LostFoundEvent {
  final LostFoundItem item;

  const DeleteLostFoundItem(this.item);

  @override
  List<Object?> get props => [item];
}

/// Поиск вещей
class SearchLostFoundItems extends LostFoundEvent {
  final String query;

  const SearchLostFoundItems(this.query);

  @override
  List<Object?> get props => [query];
}

/// Обновить статус объявления
class UpdateLostFoundItemStatus extends LostFoundEvent {
  final LostFoundItem item;
  final LostFoundItemStatus newStatus;

  const UpdateLostFoundItemStatus({required this.item, required this.newStatus});

  @override
  List<Object?> get props => [item, newStatus];
}
