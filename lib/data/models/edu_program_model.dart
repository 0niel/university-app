import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/edu_program.dart';

class EduProgramModel extends EduProgram {
  const EduProgramModel({
    required eduProgram,
    required eduProgramCode,
    required department,
    required prodDepartment,
    required type,
  }) : super(
          eduProgram: eduProgram,
          eduProgramCode: eduProgramCode,
          department: department,
          prodDepartment: prodDepartment,
          type: type,
        );

  factory EduProgramModel.fromRawJson(String str) => EduProgramModel.fromJson(json.decode(str));

  factory EduProgramModel.fromJson(Map<String, dynamic> json) {
    return EduProgramModel(
      eduProgramCode: json["PROPERTIES"]["OKSO_CODE"]["VALUE"],
      eduProgram: json["NAME"],
      department: json["PROPERTIES"]["DEPARTMENT"]["VALUE_TEXT"],
      prodDepartment: json["PROPERTIES"]["PROD_DEPARTMENT"]["VALUE_TEXT"],
      type: json["TYPE"],
    );
  }
}
