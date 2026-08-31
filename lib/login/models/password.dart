import 'package:formz/formz.dart';

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([super.value = '']) : super.dirty();

  static const int minLength = 8;

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return .empty;
    return value.length < minLength ? .tooShort : null;
  }
}

enum PasswordValidationError { empty, tooShort }
