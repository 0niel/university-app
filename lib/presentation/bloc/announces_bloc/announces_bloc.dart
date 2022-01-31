import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_app/domain/entities/announce.dart';
import 'package:rtu_mirea_app/domain/usecases/get_announces.dart';

part 'announces_event.dart';
part 'announces_state.dart';

class AnnouncesBloc extends Bloc<AnnouncesEvent, AnnouncesState> {
  AnnouncesBloc({required this.getAnnounces}) : super(AnnouncesInitial()) {
    on<LoadAnnounces>(_onLoadAnnounces);
  }

  final GetAnnounces getAnnounces;

  void _onLoadAnnounces(
    LoadAnnounces event,
    Emitter<AnnouncesState> emit,
  ) async {
    emit(AnnouncesLoading());

    final announces = await getAnnounces(GetAnnouncesParams(event.token));

    announces.fold((failure) => emit(AnnouncesLoadError()),
        (r) => emit(AnnouncesLoaded(announces: r)));
  }
}
