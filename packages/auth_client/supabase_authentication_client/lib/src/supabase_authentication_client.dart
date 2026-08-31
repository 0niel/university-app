import 'package:auth_client/auth_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthenticationClient implements AuthenticationClient {
  const SupabaseAuthenticationClient({
    required GoTrueClient supabaseAuth,
  }) : _supabaseAuth = supabaseAuth;

  final GoTrueClient _supabaseAuth;

  @override
  Stream<AuthenticationUser> get user {
    return _supabaseAuth.onAuthStateChange.map((data) {
      final session = data.session;

      if (session == null) {
        return AuthenticationUser.anonymous;
      }

      return session.user.toUser;
    });
  }

  @override
  Future<void> sendLoginEmailLink({
    required String email,
    required String appPackageName,
  }) async {
    try {
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
      await _supabaseAuth.signUp(email: email, password: password);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpFailure(error), stackTrace);
    }
  }

  @override
  Future<void> signInAnonymously() async {
    try {
      await _supabaseAuth.signInAnonymously();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SignInAnonymouslyFailure(error), stackTrace);
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
    }
  }
}

extension on User {
  AuthenticationUser get toUser {
    return AuthenticationUser(
      id: id,
      email: email,
      isNewUser: createdAt == lastSignInAt,
    );
  }
}
