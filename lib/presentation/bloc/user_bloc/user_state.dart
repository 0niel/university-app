part of 'user_bloc.dart';

enum UserStatus {
  initial,
  unauthorized,
  loading,
  authorized,
  authorizeError,
}

@JsonSerializable()
class UserState extends Equatable {
  const UserState({
    this.user,
    this.status = UserStatus.initial,
  });

  final User? user;

  final UserStatus status;

  UserState copyWith({
    User? user,
    UserStatus? status,
    String? errorMessage,
  }) {
    return UserState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }

  factory UserState.fromJson(Map<String, dynamic> json) => _$UserStateFromJson(json);

  Map<String, dynamic> toJson() => _$UserStateToJson(this);

  @override
  List<Object?> get props => [user, status];
}
