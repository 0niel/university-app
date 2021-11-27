import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String name;
  final String secondName;
  final String lastName;
  final String email;
  final String employmentKind;
  final String rate;
  final String employmentDate;
  final String fireDate;
  final String post;
  final String department;

  const Employee({
    required this.name,
    required this.secondName,
    required this.lastName,
    required this.email,
    required this.employmentKind,
    required this.employmentDate,
    required this.rate,
    required this.fireDate,
    required this.post,
    required this.department,
  });

  @override
  List<Object?> get props => [
        name,
        secondName,
        lastName,
        email,
        employmentKind,
        employmentDate,
        rate,
        fireDate,
        post,
        department,
      ];
}
