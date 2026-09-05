import 'dart:async';

import 'package:auth_client/auth_client.dart';
import 'package:supabase_authentication_client/src/supabase_auth_callback_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthenticationClient implements AuthenticationClient {
  const SupabaseAuthenticationClient({
    required GoTrueClient supabaseAuth,
  }) : _supabaseAuth = supabaseAuth;

  final GoTrueClient _supabaseAuth;

  @override
  Stream<AuthenticationUser> get user {
    return Stream<AuthenticationUser>.multi((controller) {
      final subscription = _supabaseAuth.onAuthStateChange.listen(
        (data) => controller.add(
          data.session?.user.toUser ?? AuthenticationUser.anonymous,
        ),
        onError: (Object error, StackTrace stackTrace) {
          controller.add(
            _supabaseAuth.currentSession?.user.toUser ??
                AuthenticationUser.anonymous,
          );
        },
        onDone: controller.close,
      );
      controller
        ..onCancel = subscription.cancel
        ..add(
          _supabaseAuth.currentSession?.user.toUser ??
              AuthenticationUser.anonymous,
        );
    }).distinct();
  }

  @override
  Future<void> sendLoginEmailLink({
    required String email,
    required String appPackageName,
  }) async {
    try {
      _ensureNoGuestSession();
      await _supabaseAuth.signInWithOtp(
        email: email,
        shouldCreateUser: false,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SendLoginEmailLinkFailure(error), stackTrace);
    }
  }

  Future<void> _verifyOTP({
    required String email,
    required String token,
  }) async {
    try {
      _ensureNoGuestSession();
      await _supabaseAuth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.email,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithEmailLinkFailure(error), stackTrace);
    }
  }

  @override
  Future<void> logInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      _ensureNoGuestSession();
      await _supabaseAuth.signInWithPassword(email: email, password: password);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithPasswordFailure(error), stackTrace);
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _ensureNoGuestSession();
      await _supabaseAuth.signUp(email: email, password: password);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpFailure(error), stackTrace);
    }
  }

  @override
  Future<void> signInAnonymously() async {
    try {
      await SupabaseAuthCallbackHandler.forClient(
        _supabaseAuth,
      ).signInAnonymously();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignInAnonymouslyFailure(error), stackTrace);
    }
  }

  @override
  Future<void> linkGuestEmail({
    required String userId,
    required String email,
  }) async {
    try {
      final user = _supabaseAuth.currentUser;
      if (user == null || user.id != userId || !user.isAnonymous) {
        throw StateError('The guest session is no longer active.');
      }
      await _supabaseAuth.updateUser(UserAttributes(email: email));
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpFailure(error), stackTrace);
    }
  }

  @override
  Future<void> verifyGuestEmail({
    required String userId,
    required String email,
    required String code,
  }) async {
    try {
      final user = _supabaseAuth.currentUser;
      if (user?.id != userId) {
        throw StateError('The guest session is no longer active.');
      }
      if (user != null &&
          !user.isAnonymous &&
          user.emailConfirmedAt != null &&
          user.email?.toLowerCase() == email.toLowerCase()) {
        return;
      }
      if (user?.isAnonymous != true) {
        throw StateError('The account does not match this email verification.');
      }
      final result = await _supabaseAuth.verifyOTP(
        email: email,
        token: code,
        type: OtpType.emailChange,
      );
      final verified = result.user ?? _supabaseAuth.currentUser;
      if (verified?.id != userId ||
          (verified?.isAnonymous ?? true) ||
          verified?.emailConfirmedAt == null ||
          verified?.email?.toLowerCase() != email.toLowerCase()) {
        throw StateError(
          'Email verification did not preserve the guest account.',
        );
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithEmailLinkFailure(error), stackTrace);
    }
  }

  @override
  Future<void> setAccountPassword({
    required String userId,
    required String password,
  }) async {
    try {
      final user = _supabaseAuth.currentUser;
      if (user == null ||
          user.id != userId ||
          user.isAnonymous ||
          user.emailConfirmedAt == null) {
        throw StateError(
          'A verified email is required before setting a password.',
        );
      }
      await _supabaseAuth.updateUser(UserAttributes(password: password));
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpFailure(error), stackTrace);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _supabaseAuth.resetPasswordForEmail(email);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SendPasswordResetEmailFailure(error),
        stackTrace,
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      _ensureNoGuestSession();
      await _supabaseAuth.verifyOTP(
        email: email,
        token: code,
        type: OtpType.recovery,
      );
      await _supabaseAuth.updateUser(UserAttributes(password: newPassword));
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(ResetPasswordFailure(error), stackTrace);
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _supabaseAuth.signOut();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await Supabase.instance.client.functions.invoke('delete-account');
      await _supabaseAuth.signOut();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteAccountFailure(error), stackTrace);
    }
  }

  @override
  bool isLogInWithEmailLink({required String emailLink}) {
    return emailLink.contains('://login-callback');
  }

  @override
  Future<void> logInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    final token = Uri.parse(emailLink).queryParameters['token'];
    if (token == null || token.isEmpty) {
      throw const LogInWithEmailLinkFailure(
        FormatException('The login callback does not contain an OTP.'),
      );
    }
    await _verifyOTP(email: email, token: token);
  }

  @override
  Future<void> logInWithEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      _ensureNoGuestSession();
      await _supabaseAuth.verifyOTP(
        email: email,
        token: code,
        type: OtpType.email,
      );
    } on AuthException {
      try {
        await _supabaseAuth.verifyOTP(
          email: email,
          token: code,
          type: OtpType.signup,
        );
      } catch (error, stackTrace) {
        Error.throwWithStackTrace(LogInWithEmailLinkFailure(error), stackTrace);
      }
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithEmailLinkFailure(error), stackTrace);
    }
  }

  void _ensureNoGuestSession() {
    if (_supabaseAuth.currentUser?.isAnonymous ?? false) {
      throw StateError(
        'Link the guest account before signing in to another account.',
      );
    }
  }
}

extension on User {
  AuthenticationUser get toUser {
    return AuthenticationUser(
      id: id,
      email: (email?.trim().isEmpty ?? true) ? null : email!.trim(),
      isNewUser: createdAt == lastSignInAt,
      isGuest: isAnonymous,
    );
  }
}
