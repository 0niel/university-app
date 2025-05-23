import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String name;
  final String secondName;
  final String lastName;
  final String email;
  final String institute;
  final String department;

  const Employee({
    required this.name,
    required this.secondName,
    required this.lastName,
    required this.email,
    required this.institute,
    required this.department,
  });

  @override
  List<Object?> get props => [name, secondName, lastName, email, institute, department];
}
