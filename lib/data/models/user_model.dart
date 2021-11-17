import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required id,
    required login,
    required email,
    required name,
    required lastName,
    required secondName,
    required isActive,
    required birthday,
    required eduProgram,
    required eduProgramCode,
    required photoUrl,
  }) : super(
          id: id,
          login: login,
          email: email,
          name: name,
          lastName: lastName,
          secondName: secondName,
          isActive: isActive,
          birthday: birthday,
          eduProgram: eduProgram,
          eduProgramCode: eduProgramCode,
          photoUrl: photoUrl,
        );

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["ID"],
        login: json["arUser"]["LOGIN"],
        email: json["arUser"]["EMAIL"],
        name: json["arUser"]["NAME"],
        lastName: json["arUser"]["LAST_NAME"],
        secondName: json["arUser"]["SECOND_NAME"],
        isActive: json["STUDENTS"].values.first["ACTIVE"] == "Y",
        photoUrl: json["arUser"]["PHOTO"],
        eduProgramCode: '',
        eduProgram: '',
        birthday: '',
      );
}
