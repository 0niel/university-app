import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_user.freezed.dart';

@freezed
abstract class AuthenticationUser with _$AuthenticationUser {
  const factory AuthenticationUser({
    required String id,
    String? email,
    String? name,
    String? photo,
    @Default(true) bool isNewUser,
  }) = _AuthenticationUser;

  const AuthenticationUser._();

  static const anonymous = AuthenticationUser(id: '');

  bool get isAnonymous => this == anonymous;
}
