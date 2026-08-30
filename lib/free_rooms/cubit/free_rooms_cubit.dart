import 'package:bloc/bloc.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'free_rooms_state.dart';
part 'free_rooms_cubit.freezed.dart';
part 'free_rooms_status.dart';

class FreeRoomsCubit extends Cubit<FreeRoomsState> {
  FreeRoomsCubit({required this._campusRepository})
    : super(const FreeRoomsState());

  final CampusRepository _campusRepository;

  Future<void> load() async {
    emit(state.copyWith(status: .loading));
    try {
      final rooms = await _campusRepository.getFreeRooms();
      emit(state.copyWith(status: .populated, rooms: rooms));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  void buildingChanged(String building) =>
      emit(state.copyWith(building: building));
}
