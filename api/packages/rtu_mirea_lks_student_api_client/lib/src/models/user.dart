import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {

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
  });
  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'] as int,
      login: json['arUser']['LOGIN'],
      email: json['arUser']['EMAIL'],
      name: json['arUser']['NAME'],
      lastName: json['arUser']['LAST_NAME'],
      secondName: json['arUser']['SECOND_NAME'],
      photoUrl: json['arUser']['PHOTO'],
      lastLoginDate: json['arUser']['LAST_LOGIN'],
      registerDate: json['arUser']['DATE_REGISTER'],
      birthday: json['arUser']['PERSONAL_BIRTHDAY'],
      students: StudentModel.fromJson(json),
    );
  }

  /// Bitrix24 user id
  final int id;

  /// Email in edu-mirea.ru domain.
  final String login;

  /// Personal email.
  final String email;

  /// User name.
  final String name;

  /// User last name.
  final String lastName;

  /// User second name.
  final String secondName;

  /// User birthday.
  final String birthday;

  /// User photo url.
  final String photoUrl;

  /// User students.
  final String registerDate;

  /// User students.
  final String lastLoginDate;

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
      ];
}
