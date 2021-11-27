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
    required authShortlink,
    required registerDate,
    required lastLoginDate,
    required course,
    required personalNumber,
    required educationStartDate,
    required educationEndDate,
    required academicGroup,
    required department,
    required prodDepartment,
    required type,
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
          authShortlink: authShortlink,
          registerDate: registerDate,
          lastLoginDate: lastLoginDate,
          course: course,
          personalNumber: personalNumber,
          educationStartDate: educationStartDate,
          educationEndDate: educationEndDate,
          academicGroup: academicGroup,
          department: department,
          prodDepartment: prodDepartment,
          type: type,
        );

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final student = json["STUDENTS"].values.first;
    final eduProgram = json["EDU_PROGRAM"].values.first;

    return UserModel(
      id: json["ID"],
      login: json["arUser"]["LOGIN"],
      email: json["arUser"]["EMAIL"],
      name: json["arUser"]["NAME"],
      lastName: json["arUser"]["LAST_NAME"],
      secondName: json["arUser"]["SECOND_NAME"],
      isActive: student["ACTIVE"] == "Y",
      photoUrl: json["arUser"]["PHOTO"],
      authShortlink: json["arUser"]["UF_AUTH_SHORTLINK"],
      lastLoginDate: json["arUser"]["LAST_LOGIN"],
      registerDate: json["arUser"]["DATE_REGISTER"],
      course: int.parse(student["PROPERTIES"]["COURSE"]["VALUE"]),
      personalNumber: student["PROPERTIES"]["PERSONAL_NUMBER"]["VALUE"],
      birthday: json["arUser"]["PERSONAL_BIRTHDAY"],
      educationStartDate: student["PROPERTIES"]["START_DATE"]["VALUE"],
      educationEndDate: student["PROPERTIES"]["END_DATE"]["VALUE"],
      academicGroup: student["PROPERTIES"]["ACADEMIC_GROUP"]["VALUE_TEXT"],
      eduProgramCode: eduProgram["PROPERTIES"]["OKSO_CODE"]["VALUE"],
      eduProgram: eduProgram["NAME"],
      department: eduProgram["PROPERTIES"]["DEPARTMENT"]["VALUE_TEXT"],
      prodDepartment: eduProgram["PROPERTIES"]["PROD_DEPARTMENT"]["VALUE_TEXT"],
      type: eduProgram["TYPE"],
    );
  }
}
