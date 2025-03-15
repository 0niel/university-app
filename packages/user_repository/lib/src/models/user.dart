import 'package:auth_client/auth_client.dart';

/// {@template user}
/// User model represents the current user with subscription plan.
/// {@endtemplate}
class User extends AuthenticationUser {
  /// {@macro user}
  const User({
    required super.id,
    super.email,
    super.name,
    super.photo,
    super.isNewUser,
  });

  /// Converts [AuthenticationUser] to [User].
  factory User.fromAuthenticationUser({
    required AuthenticationUser authenticationUser,
  }) =>
      User(
        email: authenticationUser.email,
        id: authenticationUser.id,
        name: authenticationUser.name,
        photo: authenticationUser.photo,
        isNewUser: authenticationUser.isNewUser,
      );

  /// Whether the current user is anonymous.
  @override
  bool get isAnonymous => this == anonymous;

  /// Anonymous user which represents an unauthenticated user.
  static const User anonymous = User(
    id: '',
  );
}
