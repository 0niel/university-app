import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'student.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final int id;

  /// Email in edu-mirea.ru domain
  final String login;

  /// Personal email
  final String email;
  final String name;
  final String lastName;
  final String secondName;
  final String birthday;
  final String photoUrl;
  final String registerDate;
  final String lastLoginDate;

  final List<Student> students;

  const User({
    required this.id,
    required this.login,
    required this.email,
    required this.name,
    required this.lastName,
    required this.secondName,
    required this.birthday,
    required this.photoUrl,
    required this.registerDate,
    required this.lastLoginDate,
    required this.students,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props => [
        id,
        login,
        email,
        name,
        lastName,
        secondName,
        birthday,
        photoUrl,
        registerDate,
        lastLoginDate,
        students,
      ];
}
