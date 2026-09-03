import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/free_rooms/cubit/free_rooms_filter.dart';

part 'free_rooms_state.dart';
part 'free_rooms_cubit.freezed.dart';
part 'free_rooms_status.dart';

class FreeRoomsCubit extends Cubit<FreeRoomsState> {
  FreeRoomsCubit({required this._campusRepository})
    : super(const FreeRoomsState());

  final CampusRepository _campusRepository;
  var _revision = 0;

  Future<void> load() async {
    final revision = ++_revision;
    emit(state.copyWith(status: .loading));
    try {
      final rooms = await _campusRepository.getFreeRooms();
      if (isClosed || revision != _revision) return;
      emit(state.copyWith(status: .populated, rooms: rooms));
    } on Exception catch (error, stackTrace) {
      if (isClosed || revision != _revision) return;
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void campusChanged(String campus) =>
      emit(state.copyWith(campus: campus, floor: null));

  void floorChanged(int? floor) => emit(state.copyWith(floor: floor));

  void queryChanged(String query) => emit(state.copyWith(query: query));
}
