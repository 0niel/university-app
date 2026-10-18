import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rtu_mirea_app/login/bloc/password_reset_bloc.dart';
import 'package:rtu_mirea_app/login/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart' hide User;

class _Users extends Mock implements UserRepository {}

class _Failure extends AuthenticationException {
  const _Failure(super.error);
}

void main() {
  const email = 'student@university.example';
  const password = 'new-password-123';
  const emailState = PasswordResetState(email: Email.dirty(email));
  const codeState = PasswordResetState(
    step: PasswordResetStep.code,
    email: Email.dirty(email),
    code: '123456',
  );
  const passwordState = PasswordResetState(
    step: PasswordResetStep.password,
    email: Email.dirty(email),
    password: Password.dirty(password),
    confirmedPassword: ConfirmedPassword.dirty(
      password: password,
      value: password,
    ),
    verifiedUserId: 'verified-owner',
  );

  late _Users users;

  setUp(() {
    users = _Users();
    when(
      () => users.sendPasswordResetEmail(email: any(named: 'email')),
    ).thenAnswer((_) async {});
    when(
      () => users.verifyPasswordResetCode(
        email: any(named: 'email'),
        code: any(named: 'code'),
      ),
    ).thenAnswer((_) async => 'verified-owner');
    when(
      () => users.setAccountPassword(
        userId: any(named: 'userId'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
  });

  PasswordResetBloc build() => PasswordResetBloc(userRepository: users);

  blocTest<PasswordResetBloc, PasswordResetState>(
    'can enter an existing recovery code without sending another email',
    build: build,
    seed: () => emailState,
    act: (bloc) => bloc.add(const PasswordResetCodeEntryRequested()),
    expect: () => [emailState.copyWith(step: PasswordResetStep.code)],
    verify: (_) => verifyNever(
      () => users.sendPasswordResetEmail(email: any(named: 'email')),
    ),
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'rate limited email requests still open code input with a cooldown',
    build: build,
    seed: () => emailState,
    setUp: () {
      when(() => users.sendPasswordResetEmail(email: email)).thenThrow(
        const _Failure(
          AuthException(
            'Wait',
            statusCode: '429',
            code: 'over_email_send_rate_limit',
          ),
        ),
      );
    },
    act: (bloc) => bloc.add(PasswordResetRequested()),
    expect: () => [
      emailState.copyWith(status: FormzSubmissionStatus.inProgress),
      emailState.copyWith(
        step: PasswordResetStep.code,
        status: FormzSubmissionStatus.failure,
        error: PasswordResetError.rateLimited,
        resendSeconds: 60,
      ),
    ],
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'duplicate requests and resend during cooldown do not send extra emails',
    build: build,
    seed: () => emailState,
    act: (bloc) async {
      final sent = bloc.stream.firstWhere((state) => state.step == .code);
      bloc
        ..add(PasswordResetRequested())
        ..add(PasswordResetRequested());
      await sent;
      bloc.add(PasswordResetRequested());
    },
    expect: () => [
      emailState.copyWith(status: FormzSubmissionStatus.inProgress),
      emailState.copyWith(step: PasswordResetStep.code, resendSeconds: 60),
    ],
    verify: (_) => verify(
      () => users.sendPasswordResetEmail(email: email),
    ).called(1),
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'verification opens the password step and clears the consumed OTP',
    build: build,
    seed: () => codeState,
    act: (bloc) => bloc.add(const PasswordResetCodeSubmitted()),
    expect: () => [
      codeState.copyWith(status: FormzSubmissionStatus.inProgress),
      codeState.copyWith(
        step: PasswordResetStep.password,
        code: '',
        verifiedUserId: 'verified-owner',
      ),
    ],
    verify: (_) {
      verify(
        () => users.verifyPasswordResetCode(email: email, code: '123456'),
      ).called(1);
      verifyNever(
        () => users.setAccountPassword(
          userId: any(named: 'userId'),
          password: any(named: 'password'),
        ),
      );
    },
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'invalid code retains email and code and allows correction',
    build: build,
    seed: () => codeState,
    setUp: () {
      when(
        () => users.verifyPasswordResetCode(email: email, code: '123456'),
      ).thenThrow(
        const _Failure(AuthException('Expired', code: 'otp_expired')),
      );
    },
    act: (bloc) async {
      final failed = bloc.stream.firstWhere(
        (state) => state.error == .invalidCode,
      );
      bloc.add(const PasswordResetCodeSubmitted());
      await failed;
      bloc.add(const PasswordResetCodeChanged('654321'));
    },
    expect: () => [
      codeState.copyWith(status: FormzSubmissionStatus.inProgress),
      codeState.copyWith(
        status: FormzSubmissionStatus.failure,
        error: PasswordResetError.invalidCode,
      ),
      codeState.copyWith(code: '654321'),
    ],
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'a failed password update retries without consuming the OTP again',
    build: build,
    seed: () => passwordState,
    setUp: () {
      var calls = 0;
      when(
        () => users.setAccountPassword(
          userId: 'verified-owner',
          password: password,
        ),
      ).thenAnswer((_) async {
        if (calls++ == 0) throw Exception('Offline');
      });
    },
    act: (bloc) async {
      final failed = bloc.stream.firstWhere(
        (state) => state.error == .updateFailed,
      );
      bloc.add(const PasswordResetSubmitted());
      await failed;
      bloc.add(const PasswordResetSubmitted());
    },
    expect: () => [
      passwordState.copyWith(status: FormzSubmissionStatus.inProgress),
      passwordState.copyWith(
        status: FormzSubmissionStatus.failure,
        error: PasswordResetError.updateFailed,
      ),
      passwordState.copyWith(status: FormzSubmissionStatus.inProgress),
      passwordState.copyWith(
        step: PasswordResetStep.complete,
        password: const Password.pure(),
        confirmedPassword: const ConfirmedPassword.pure(),
        verifiedUserId: null,
        status: FormzSubmissionStatus.success,
      ),
    ],
    verify: (_) {
      verify(
        () => users.setAccountPassword(
          userId: 'verified-owner',
          password: password,
        ),
      ).called(2);
      verifyNever(
        () => users.verifyPasswordResetCode(
          email: any(named: 'email'),
          code: any(named: 'code'),
        ),
      );
    },
  );

  for (final (code, expected) in [
    ('weak_password', PasswordResetError.weakPassword),
    ('same_password', PasswordResetError.samePassword),
  ]) {
    blocTest<PasswordResetBloc, PasswordResetState>(
      '$code preserves the verified password step',
      build: build,
      seed: () => passwordState,
      setUp: () {
        when(
          () => users.setAccountPassword(
            userId: 'verified-owner',
            password: password,
          ),
        ).thenThrow(_Failure(AuthException('Rejected', code: code)));
      },
      act: (bloc) => bloc.add(const PasswordResetSubmitted()),
      expect: () => [
        passwordState.copyWith(status: FormzSubmissionStatus.inProgress),
        passwordState.copyWith(
          status: FormzSubmissionStatus.failure,
          error: expected,
        ),
      ],
    );
  }

  blocTest<PasswordResetBloc, PasswordResetState>(
    'a lost verified session returns to recovery code entry',
    build: build,
    seed: () => passwordState,
    setUp: () {
      when(
        () => users.setAccountPassword(
          userId: 'verified-owner',
          password: password,
        ),
      ).thenThrow(_Failure(StateError('The verified owner changed')));
    },
    act: (bloc) => bloc.add(const PasswordResetSubmitted()),
    expect: () => [
      passwordState.copyWith(status: FormzSubmissionStatus.inProgress),
      passwordState.copyWith(
        step: PasswordResetStep.code,
        verifiedUserId: null,
        status: FormzSubmissionStatus.failure,
        error: PasswordResetError.sessionExpired,
      ),
    ],
  );

  blocTest<PasswordResetBloc, PasswordResetState>(
    'changing the password revalidates an existing confirmation',
    build: build,
    seed: () => passwordState,
    act: (bloc) =>
        bloc.add(const PasswordResetPasswordChanged('different-123')),
    verify: (bloc) => expect(bloc.state.isValid, isFalse),
  );

  test(
    'cooldown uses elapsed time after returning from the background',
    () async {
      var now = DateTime.utc(2026, 10, 18);
      final bloc = PasswordResetBloc(userRepository: users, now: () => now);
      addTearDown(bloc.close);
      bloc.add(const PasswordResetEmailChanged(email));
      await bloc.stream.firstWhere((state) => state.email.isValid);
      bloc.add(PasswordResetRequested());
      await bloc.stream.firstWhere((state) => state.step == .code);
      now = now.add(const Duration(minutes: 5));
      await bloc.stream.firstWhere((state) => state.canResend);
      expect(bloc.state.resendSeconds, 0);
    },
  );

  test(
    'a late response after leaving recovery does not emit or start a timer',
    () async {
      final request = Completer<void>();
      when(
        () => users.sendPasswordResetEmail(email: email),
      ).thenAnswer((_) => request.future);
      final bloc = build()..add(const PasswordResetEmailChanged(email));
      await bloc.stream.firstWhere((state) => state.email.isValid);
      bloc.add(PasswordResetRequested());
      await bloc.stream.firstWhere((state) => state.isBusy);
      await bloc.close();
      request.complete();
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.step, PasswordResetStep.email);
      expect(bloc.state.resendSeconds, 0);
    },
  );
}
