import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/domain/usecases/send_nfc_not_exist_feedback.dart';

part 'nfc_feedback_event.dart';
part 'nfc_feedback_state.dart';
part 'nfc_feedback_bloc.freezed.dart';

class NfcFeedbackBloc extends Bloc<NfcFeedbackEvent, NfcFeedbackState> {
  SendNfcNotExistFeedback sendNfcNotExistFeedback;

  NfcFeedbackBloc({required this.sendNfcNotExistFeedback})
      : super(const _Initial()) {
    on<NfcFeedbackEvent>((event, emit) {
      event.map(
        started: (e) => emit(const _Initial()),
        sendFeedback: (e) async {
          emit(const _Loading());
          final result = await sendNfcNotExistFeedback(
            SendNfcNotExistFeedbackParams(
              e.fullName,
              e.group,
              e.personalNumber,
              e.studentId,
            ),
          );
          result.fold(
            (failure) => emit(_Failure(failure.cause ?? 'Неизвестная ошибка')),
            (success) => emit(const _Success()),
          );
        },
      );
    });
  }
}
