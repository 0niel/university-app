import 'dart:convert';

import 'package:rtu_mirea_app/domain/entities/student.dart';

import 'edu_program_model.dart';

class StudentModel extends Student {
  const StudentModel({
    required id,
    required isActive,
    required course,
    required personalNumber,
    required educationStartDate,
    required educationEndDate,
    required academicGroup,
    required code,
    required eduProgram,
    required status,
  }) : super(
          id: id,
          isActive: isActive,
          eduProgram: eduProgram,
          course: course,
          personalNumber: personalNumber,
          educationStartDate: educationStartDate,
          educationEndDate: educationEndDate,
          academicGroup: academicGroup,
          code: code,
          status: status,
        );

  static List<StudentModel> fromRawJson(String str) => StudentModel.fromJson(json.decode(str));

  static List<StudentModel> fromJson(Map<String, dynamic> json) {
    final studentsRaw = json["STUDENTS"].values.where((element) =>
        !element["PROPERTIES"]["PERSONAL_NUMBER"]["VALUE"].contains("Д") &&
        !element["PROPERTIES"]["PERSONAL_NUMBER"]["VALUE"].contains("Ж"));

    return List<StudentModel>.from(studentsRaw.map(
      (e) => StudentModel(
        id: e["ID"],
        isActive: e["ACTIVE"] == "Y",
        course: int.parse(e["PROPERTIES"]["COURSE"]["VALUE"]),
        personalNumber: e["PROPERTIES"]["PERSONAL_NUMBER"]["VALUE"],
        educationEndDate: e["PROPERTIES"]["END_DATE"]["VALUE"],
        academicGroup: e["PROPERTIES"]["ACADEMIC_GROUP"]["VALUE_TEXT"],
        educationStartDate: e["PROPERTIES"]["START_DATE"]["VALUE"],
        code: e["CODE"],
        eduProgram: EduProgramModel.fromJson(json["EDU_PROGRAM"][e["PROPERTIES"]["EDU_PROGRAM"]["VALUE"]]),
        status: e["PROPERTIES"]["STATUS"]["VALUE_TEXT"],
      ),
    ));
  }
}
