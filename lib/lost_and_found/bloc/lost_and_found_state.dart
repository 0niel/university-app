part of 'lost_and_found_bloc.dart';

abstract class LostFoundState extends Equatable {
  const LostFoundState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class LostFoundInitial extends LostFoundState {}

/// Состояние загрузки (например, при фетче данных)
class LostFoundLoading extends LostFoundState {}

/// Состояние с загруженным списком вещей
class LostFoundLoaded extends LostFoundState {
  final List<LostFoundItem> items;

  const LostFoundLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

/// Состояние успешной операции
class LostFoundOperationSuccess extends LostFoundState {
  final String message;

  const LostFoundOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Состояние ошибки
class LostFoundError extends LostFoundState {
  final String message;

  const LostFoundError(this.message);

  @override
  List<Object?> get props => [message];
}
