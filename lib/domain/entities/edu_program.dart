import 'package:equatable/equatable.dart';

class EduProgram extends Equatable {
  final String eduProgram;
  final String eduProgramCode;
  final String department;
  final String prodDepartment;
  final String? type;

  const EduProgram({
    required this.eduProgram,
    required this.eduProgramCode,
    required this.department,
    required this.prodDepartment,
    required this.type,
  });

  @override
  List<Object?> get props => [
        eduProgram,
        eduProgramCode,
        department,
        prodDepartment,
        type,
      ];
}
