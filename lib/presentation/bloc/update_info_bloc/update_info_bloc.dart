import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:rtu_mirea_app/domain/entities/update_info.dart';
import 'package:rtu_mirea_app/domain/usecases/get_update_info.dart';

part 'update_info_event.dart';
part 'update_info_state.dart';

class UpdateInfoBloc extends Bloc<UpdateInfoEvent, UpdateInfoState> {
  final GetUpdateInfo getUpdateInfo;

  UpdateInfoBloc({required this.getUpdateInfo})
      : super(const NoUpdateDialog()) {
    on<SetUpdateInfo>(_onSetInfo);
    on<DialogIsShown>(_setShown);
  }

  void init() async {
    final res = await getUpdateInfo.call();
    res.fold(
      (l) => log('Fail happened : ${l.cause}'),
      (r) => add(SetUpdateInfo(data: r)),
    );
  }

  void _onSetInfo(SetUpdateInfo event, emit) async {
    emit(ShowUpdateDialog(data: event.data));
  }

  void _setShown(DialogIsShown event, emit) async {
    emit(const NoUpdateDialog());
  }
}
