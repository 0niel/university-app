part of 'rooms_cubit.dart';

@freezed
class RoomsState with _$RoomsState {
  const factory RoomsState.initial() = _Initial;
  const factory RoomsState.loading() = _Loading;
  const factory RoomsState.loaded(Map<String, dynamic> data) = _Loaded;
  const factory RoomsState.notFound() = _NotFound;
  const factory RoomsState.error() = _Error;
}
