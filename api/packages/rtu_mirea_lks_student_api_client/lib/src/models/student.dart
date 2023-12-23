import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:rtu_mirea_lks_student_api_client/src/models/edu_program.dart';

class Student extends Equatable {
  const Student({
    required this.id,
    required this.isActive,
    required this.course,
    required this.personalNumber,
    required this.educationStartDate,
    required this.educationEndDate,
    required this.academicGroup,
    required this.code,
    required this.eduProgram,
    required this.status,
  });

  static List<Student> fromRawJson(String str) =>
      Student.fromJson(json.decode(str));

  static List<Student> fromJson(Map<String, dynamic> json) {
    final studentsRaw = json['STUDENTS'].values.where((element) =>
        !element['PROPERTIES']['PERSONAL_NUMBER']['VALUE'].contains('Д') &&
        !element['PROPERTIES']['PERSONAL_NUMBER']['VALUE'].contains('Ж'),);

    return List<Student>.from(studentsRaw.map(
      (e) => Student(
        id: e['ID'],
        isActive: e['ACTIVE'] == 'Y',
        course: int.parse(e['PROPERTIES']['COURSE']['VALUE']),
        personalNumber: e['PROPERTIES']['PERSONAL_NUMBER']['VALUE'],
        educationEndDate: e['PROPERTIES']['END_DATE']['VALUE'],
        academicGroup: e['PROPERTIES']['ACADEMIC_GROUP']['VALUE_TEXT'],
        educationStartDate: e['PROPERTIES']['START_DATE']['VALUE'],
        code: e['CODE'],
        eduProgram: EduProgram.fromJson(
            json['EDU_PROGRAM'][e['PROPERTIES']['EDU_PROGRAM']['VALUE']],),
        status: e['PROPERTIES']['STATUS']['VALUE_TEXT'],
      ),
    ),);
  }

  final String id;
  final bool isActive;
  final int course;
  final String personalNumber;
  final String educationStartDate;
  final String educationEndDate;
  final String academicGroup;
  final String code;
  final EduProgram eduProgram;
  final String status; // must be 'активный'
}
