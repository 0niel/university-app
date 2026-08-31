import 'package:auth_client/src/authentication_exception.dart';
import 'package:auth_client/src/models/authentication_user.dart';

export 'authentication_exception.dart';

abstract class AuthenticationClient {
  /// Stream of [AuthenticationUser] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [AuthenticationUser.anonymous] if the user is not authenticated.
  Stream<AuthenticationUser> get user;

  /// Sends an authentication link to the provided [email].
  ///
  /// Opening the link should redirect to the app with [appPackageName]
  /// and authenticate the user based on the provided email link.
  ///
  /// Throws a [SendLoginEmailLinkFailure] if an exception occurs.
  Future<void> sendLoginEmailLink({
    required String email,
    required String appPackageName,
  });

  /// Checks if an incoming [emailLink] is a sign-in with email link.
  ///
  /// Throws a [IsLogInWithEmailLinkFailure] if an exception occurs.
  bool isLogInWithEmailLink({required String emailLink});

  /// Signs in with the provided [email] and [emailLink].
  ///
  /// Throws a [LogInWithEmailLinkFailure] if an exception occurs.
  Future<void> logInWithEmailLink({
    required String email,
    required String emailLink,
  });

  /// Signs in with the provided [email] and one-time [code] from email.
  ///
  /// Throws a [LogInWithEmailLinkFailure] if an exception occurs.
  Future<void> logInWithEmailCode({
    required String email,
    required String code,
  });

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithPasswordFailure] if an exception occurs.
  Future<void> logInWithPassword({
    required String email,
    required String password,
  });

  /// Registers a new account with the provided [email] and [password].
  ///
  /// Depending on the project's confirmation settings the user may need to
  /// confirm their email (via link or [logInWithEmailCode]) before a session
  /// is established.
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({
    required String email,
    required String password,
  });

  /// Signs in as an anonymous (guest) user, creating a temporary session that
  /// is not tied to any email.
  ///
  /// Throws a [SignInAnonymouslyFailure] if an exception occurs.
  Future<void> signInAnonymously();

  /// Sends a password reset email containing a one-time code to the provided
  /// [email].
  ///
  /// Throws a [SendPasswordResetEmailFailure] if an exception occurs.
  Future<void> sendPasswordResetEmail({required String email});

  /// Confirms a password reset using the one-time [code] sent to [email] and
  /// sets the [newPassword].
  ///
  /// Throws a [ResetPasswordFailure] if an exception occurs.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  /// Signs out the current user which will emit
  /// [AuthenticationUser.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut();

  /// Deletes the current user account.
  ///
  /// Throws a [DeleteAccountFailure] if an exception occurs.
  Future<void> deleteAccount();
}
