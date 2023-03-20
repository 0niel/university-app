import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/service_locator.dart';

part 'rooms_state.dart';
part 'rooms_cubit.freezed.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(const RoomsState.initial());

  final dio = getIt<Dio>();

  final apiUrl = 'https://timetable.mirea.ru/api';

  Future<void> loadRoomData(String originalRoom) async {
    emit(const RoomsState.loading());

    try {
      final room = originalRoom.split(' ')[1];
      final roomSearchResponse = await dio.get('$apiUrl/room/search/$room');

      final roomSearchData = List<Map<String, dynamic>>.from(
          roomSearchResponse.data as List<dynamic>);

      if (roomSearchData.isEmpty) {
        emit(const RoomsState.notFound());
        return;
      }

      final roomId = (roomSearchData)
          .firstWhere((element) => element['name'] == room)['id'];

      final roomInfoResponse = await dio.get('$apiUrl/room/info/$roomId');

      final purpose = roomInfoResponse.data['purpose'];
      final workload = roomInfoResponse.data['workload'];

      // Дата в формате: YYYY-MM-DD
      final nowDate = DateTime.now().toIso8601String().substring(0, 10);
      final roomScheduleResponse =
          await dio.get('$apiUrl/schedule/room/$roomId?date=$nowDate');

      final schedule = List<Map<String, dynamic>>.from(
          roomScheduleResponse.data as List<dynamic>);

      final isoDatetime = DateTime.now().toIso8601String();
      final statusResponse = await dio
          .get('$apiUrl/room/statuses/all?date_time=$isoDatetime&rooms=$room');

      final status =
          List<Map<String, dynamic>>.from(statusResponse.data as List<dynamic>)
              .firstWhere((element) => element['name'] == room)['status'];

      final result = <String, dynamic>{
        'purpose': purpose,
        'workload': workload,
        'schedule': schedule,
        'status': status == 'free' ? 'Свободна' : 'Занята',
      };

      emit(RoomsState.loaded(result));
    } catch (e) {
      emit(const RoomsState.error());
    }
  }
}
