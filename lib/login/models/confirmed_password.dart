import 'package:formz/formz.dart';

class ConfirmedPassword
    extends FormzInput<String, ConfirmedPasswordValidationError> {
  const ConfirmedPassword.pure() : password = '', super.pure('');

  const ConfirmedPassword.dirty({required this.password, String value = ''})
    : super.dirty(value);

  final String password;

  @override
  ConfirmedPasswordValidationError? validator(String value) {
    if (value.isEmpty) return .empty;
    return password == value ? null : .mismatch;
  }
}

enum ConfirmedPasswordValidationError { empty, mismatch }
