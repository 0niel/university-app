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
        photoUrl
      ];
}
