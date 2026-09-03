import 'dart:async';

import 'package:auth_client/auth_client.dart';
import 'package:deep_link_client/deep_link_client.dart';
import 'package:package_info_client/package_info_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/user_failure.dart';
import 'package:user_repository/src/user_storage.dart';

export 'user_failure.dart';
export 'user_storage.dart';

class UserRepository {
  const UserRepository({
    required this._authenticationClient,
    required this._packageInfoClient,
    required this._deepLinkService,
    required this._storage,
    this.initializeUser,
    this.onInitializationError,
    this.initializationTimeout = const Duration(seconds: 8),
  });

  final AuthenticationClient _authenticationClient;
  final UserStorage _storage;
  final PackageInfoClient _packageInfoClient;
  final DeepLinkService _deepLinkService;
  final Future<void> Function(String userId)? initializeUser;
  final void Function(Object error, StackTrace stackTrace)?
  onInitializationError;
  final Duration initializationTimeout;

  /// Stream of [User] which will emit the current user when
  /// the authentication state.
  ///
  Stream<User> get user =>
      _authenticationClient.user.switchMap((authenticationUser) {
        if (authenticationUser.isAnonymous) {
          return Stream.value(User.anonymous);
        }
        return Stream.fromFuture(_initializeUser(authenticationUser));
      });

  Future<User> _initializeUser(AuthenticationUser authenticationUser) async {
    try {
      await initializeUser
          ?.call(authenticationUser.id)
          .timeout(initializationTimeout);
    } on Object catch (error, stackTrace) {
      onInitializationError?.call(error, stackTrace);
    }
    return User.fromAuthenticationUser(authenticationUser: authenticationUser);
  }

  /// A stream of incoming email links used to authenticate the user.
  ///
  /// Emits when a new email link is emitted on [DeepLinkClient.deepLinkStream],
  /// which is validated using [AuthenticationClient.isLogInWithEmailLink].
  Stream<Uri> get incomingEmailLinks => _deepLinkService.deepLinkStream.where(
    (deepLink) => _authenticationClient.isLogInWithEmailLink(
      emailLink: deepLink.toString(),
    ),
  );

  /// Sends an authentication link to the provided [email].
  ///
  /// Throws a [SendLoginEmailLinkFailure] if an exception occurs.
  Future<void> sendLoginEmailLink({required String email}) async {
    try {
      await _authenticationClient.sendLoginEmailLink(
        email: email,
        appPackageName: _packageInfoClient.packageName,
      );
    } on SendLoginEmailLinkFailure {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(SendLoginEmailLinkFailure(error), stackTrace);
    }
  }

  /// Signs in with the provided [email] and [emailLink].
  ///
  /// Throws a [LogInWithEmailLinkFailure] if an exception occurs.
  Future<void> logInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    try {
      await _authenticationClient.logInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );
    } on LogInWithEmailLinkFailure {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithEmailLinkFailure(error), stackTrace);
    }
  }

  /// Signs in with the provided [email] and one-time [code] from email.
  ///
  /// Throws a [LogInWithEmailLinkFailure] if an exception occurs.
  Future<void> logInWithEmailCode({
    required String email,
    required String code,
  }) async {
    try {
      await _authenticationClient.logInWithEmailCode(email: email, code: code);
    } on LogInWithEmailLinkFailure {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithEmailLinkFailure(error), stackTrace);
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithPasswordFailure] if an exception occurs.
  Future<void> logInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authenticationClient.logInWithPassword(
        email: email,
        password: password,
      );
    } on LogInWithPasswordFailure {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(LogInWithPasswordFailure(error), stackTrace);
    }
  }

  /// Registers a new account with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _authenticationClient.signUp(email: email, password: password);
    } on SignUpFailure {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(SignUpFailure(error), stackTrace);
    }
  }

  /// Signs in as an anonymous (guest) user.
  ///
  /// Throws a [SignInAnonymouslyFailure] if an exception occurs.
  Future<void> signInAnonymously() async {
    try {
      await _authenticationClient.signInAnonymously();
    } on SignInAnonymouslyFailure {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(SignInAnonymouslyFailure(error), stackTrace);
    }
  }

  /// Sends a password reset email containing a one-time code to [email].
  ///
  /// Throws a [SendPasswordResetEmailFailure] if an exception occurs.
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _authenticationClient.sendPasswordResetEmail(email: email);
    } on SendPasswordResetEmailFailure {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        SendPasswordResetEmailFailure(error),
        stackTrace,
      );
    }
  }

  /// Confirms a password reset using the one-time [code] sent to [email] and
  /// sets the [newPassword].
  ///
  /// Throws a [ResetPasswordFailure] if an exception occurs.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      await _authenticationClient.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
    } on ResetPasswordFailure {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(ResetPasswordFailure(error), stackTrace);
    }
  }

  /// Signs out the current user which will emit
  /// [User.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await _authenticationClient.logOut();
    } on LogOutFailure {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(LogOutFailure(error), stackTrace);
    }
  }

  /// Deletes the current user account.
  Future<void> deleteAccount() async {
    try {
      await _authenticationClient.deleteAccount();
    } on DeleteAccountFailure {
      rethrow;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(DeleteAccountFailure(error), stackTrace);
    }
  }

  /// Returns the number of times the app was opened.
  Future<int> fetchAppOpenedCount() async {
    try {
      return await _storage.fetchAppOpenedCount();
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(FetchAppOpenedCountFailure(error), stackTrace);
    }
  }

  /// Increments the number of times the app was opened by 1.
  Future<void> incrementAppOpenedCount() async {
    try {
      final value = await fetchAppOpenedCount();
      final result = value + 1;
      await _storage.setAppOpenedCount(count: result);
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        IncrementAppOpenedCountFailure(error),
        stackTrace,
      );
    }
  }
}
