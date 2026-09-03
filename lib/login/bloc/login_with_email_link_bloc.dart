import 'dart:async';

import 'package:analytics_repository/analytics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_repository/user_repository.dart';

part 'login_with_email_link_event.dart';
part 'login_with_email_link_bloc.freezed.dart';
part 'login_with_email_link_state.dart';
part 'login_with_email_link_status.dart';

class LoginWithEmailLinkBloc
    extends Bloc<LoginWithEmailLinkEvent, LoginWithEmailLinkState> {
  LoginWithEmailLinkBloc({required this.userRepository})
    : super(const LoginWithEmailLinkState()) {
    on<LoginWithEmailLinkSubmitted>(_onLoginWithEmailLinkSubmitted);
    on<LoginWithEmailCodeSubmitted>(_onLoginWithEmailCodeSubmitted);
    on<LoginWithEmailCodeResetRequested>((event, emit) {
      if (state.status != LoginWithEmailLinkStatus.loading) {
        emit(const LoginWithEmailLinkState());
      }
    });

    _incomingEmailLinksSub = userRepository.incomingEmailLinks
        .handleError(addError)
        .listen((emailLink) => add(LoginWithEmailLinkSubmitted(emailLink)));
  }

  final UserRepository userRepository;

  late StreamSubscription<Uri> _incomingEmailLinksSub;

  Future<void> _onLoginWithEmailLinkSubmitted(
    LoginWithEmailLinkSubmitted event,
    Emitter<LoginWithEmailLinkState> emit,
  ) async {
    if (state.status == LoginWithEmailLinkStatus.loading) return;
    try {
      emit(state.copyWith(status: .loading));

      final currentUser = await userRepository.user.first;
      if (!currentUser.isAnonymous) {
        throw Exception('The user is already logged in');
      }

      final emailLink = event.emailLink;
      if (!emailLink.queryParameters.containsKey('code')) {
        throw Exception(
          'No `code` parameter found in the received email link',
        );
      }

      final redirectUrl = Uri.tryParse(
        emailLink.queryParameters['continueUrl'] ?? '',
      );

      final email = redirectUrl?.queryParameters['email'];
      if (email == null) {
        throw Exception(
          'No `email` parameter found in the received email link',
        );
      }

      await userRepository.logInWithEmailLink(
        email: email,
        emailLink: emailLink.toString(),
      );

      emit(state.copyWith(status: .success));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  Future<void> _onLoginWithEmailCodeSubmitted(
    LoginWithEmailCodeSubmitted event,
    Emitter<LoginWithEmailLinkState> emit,
  ) async {
    if (state.status == LoginWithEmailLinkStatus.loading ||
        state.status == LoginWithEmailLinkStatus.success) {
      return;
    }
    try {
      emit(state.copyWith(status: .loading));

      final currentUser = await userRepository.user.first;
      if (!currentUser.isAnonymous) {
        throw Exception('The user is already logged in');
      }

      await userRepository.logInWithEmailCode(
        email: event.email,
        code: event.code,
      );

      emit(state.copyWith(status: .success));
    } on Exception catch (error, stackTrace) {
      emit(state.copyWith(status: .failure));
      addError(error, stackTrace);
    }
  }

  @override
  Future<void> close() async {
    await _incomingEmailLinksSub.cancel();
    return super.close();
  }
}
