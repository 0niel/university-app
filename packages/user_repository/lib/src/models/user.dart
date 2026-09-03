import 'package:auth_client/auth_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    String? email,
    String? name,
    String? photo,
    @Default(true) bool isNewUser,
    @Default(false) bool isGuest,
  }) = _User;

  const User._();

  factory User.fromAuthenticationUser({
    required AuthenticationUser authenticationUser,
  }) => User(
    email: authenticationUser.email,
    id: authenticationUser.id,
    name: authenticationUser.name,
    photo: authenticationUser.photo,
    isNewUser: authenticationUser.isNewUser,
    isGuest: authenticationUser.isGuest,
  );

  bool get isAnonymous => this == anonymous;

  static const User anonymous = User(id: '');
}
