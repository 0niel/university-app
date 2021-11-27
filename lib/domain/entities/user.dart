import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String login;
  final String email;
  final String name;
  final String lastName;
  final String secondName;
  final bool isActive;
  final String birthday;
  final String eduProgram;
  final String eduProgramCode;
  final String photoUrl;
  final String? authShortlink;
  final String registerDate;
  final String lastLoginDate;
  final int course;
  final String personalNumber;
  final String educationStartDate;
  final String educationEndDate;
  final String academicGroup;
  final String department;
  final String prodDepartment;
  final String type;

  const User({
    required this.id,
    required this.login,
    required this.email,
    required this.name,
    required this.lastName,
    required this.secondName,
    required this.isActive,
    required this.birthday,
    required this.eduProgram,
    required this.eduProgramCode,
    required this.photoUrl,
    required this.authShortlink,
    required this.registerDate,
    required this.lastLoginDate,
    required this.course,
    required this.personalNumber,
    required this.educationStartDate,
    required this.educationEndDate,
    required this.academicGroup,
    required this.department,
    required this.prodDepartment,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        login,
        email,
        name,
        lastName,
        secondName,
        isActive,
        birthday,
        eduProgram,
        eduProgramCode,
        photoUrl,
        authShortlink,
        registerDate,
        lastLoginDate,
        course,
        personalNumber,
        educationStartDate,
        educationEndDate,
        academicGroup,
        department,
        prodDepartment,
        type,
      ];
}
