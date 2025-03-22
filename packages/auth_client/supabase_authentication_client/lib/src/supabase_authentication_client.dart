import 'package:auth_client/auth_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:token_storage/token_storage.dart';

/// {@template supabase_authentication_client}
/// A Firebase implementation of the [AuthenticationClient] interface.
/// {@endtemplate}
class SupabaseAuthenticationClient implements AuthenticationClient {
  /// {@macro supabase_authentication_client}
  SupabaseAuthenticationClient({
    required TokenStorage tokenStorage,
    required GoTrueClient supabaseAuth,
  })  : _tokenStorage = tokenStorage,
        _supabaseAuth = supabaseAuth {
    user.listen(_onUserChanged);
  }

  final TokenStorage _tokenStorage;
  final GoTrueClient _supabaseAuth;

  /// Stream of [AuthenticationUser] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [AuthenticationUser.anonymous] if the user is not authenticated.
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

  /// Sends an authentication link to the provided [email].
  ///
  /// Opening the link redirects to the app with [appPackageName]
  /// using Firebase Dynamic Links and authenticates the user
  /// based on the provided email link.
  ///
  /// Throws a [SendLoginEmailLinkFailure] if an exception occurs.
  @override
  Future<void> sendLoginEmailLink({
    required String email,
    required String appPackageName,
  }) async {
    try {
      await _supabaseAuth.signInWithOtp(
        email: email,
        shouldCreateUser: true,
        emailRedirectTo: '$appPackageName://login-callback',
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(SendLoginEmailLinkFailure(error), stackTrace);
    }
  }

  /// Signs in with the provided [token].
  ///
  /// Throws a [LogInWithEmailLinkFailure] if an exception occurs.
  Future<void> _verifyOTP({
    required String email,
    required String token,
  }) async {
    try {
      await _supabaseAuth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithEmailLinkFailure(error), stackTrace);
    }
  }

  /// Signs out the current user which will emit
  /// [AuthenticationUser.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  @override
  Future<void> logOut() async {
    try {
      await _supabaseAuth.signOut();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Deletes and signs out the user.
  @override
  Future<void> deleteAccount() async {
    throw DeleteAccountFailure(
      Exception('Delete account is not supported by Supabase'),
    );
  }

  /// Updates the user token in [TokenStorage] if the user is authenticated.
  Future<void> _onUserChanged(AuthenticationUser user) async {
    if (!user.isAnonymous) {
      await _tokenStorage.saveToken(user.id);
    } else {
      await _tokenStorage.clearToken();
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
  }) {
    final token = Uri.parse(emailLink).queryParameters['token']!;
    return _verifyOTP(email: email, token: token);
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
