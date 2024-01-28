import 'dart:convert';

import 'package:rtu_mirea_app/data/models/student_model.dart';
import 'package:rtu_mirea_app/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required id,
    required login,
    required email,
    required name,
    required lastName,
    required secondName,
    required birthday,
    required photoUrl,
    required registerDate,
    required lastLoginDate,
    required students,
  }) : super(
          id: id,
          login: login,
          email: email,
          name: name,
          lastName: lastName,
          secondName: secondName,
          birthday: birthday,
          photoUrl: photoUrl,
          registerDate: registerDate,
          lastLoginDate: lastLoginDate,
          students: students,
        );

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["ID"],
      login: json["arUser"]["LOGIN"],
      email: json["arUser"]["EMAIL"],
      name: json["arUser"]["NAME"],
      lastName: json["arUser"]["LAST_NAME"],
      secondName: json["arUser"]["SECOND_NAME"],
      photoUrl: json["arUser"]["PHOTO"],
      lastLoginDate: json["arUser"]["LAST_LOGIN"],
      registerDate: json["arUser"]["DATE_REGISTER"],
      birthday: json["arUser"]["PERSONAL_BIRTHDAY"],
      students: StudentModel.fromJson(json),
    );
  }
}
