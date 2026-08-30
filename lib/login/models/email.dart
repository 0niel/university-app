import 'package:formz/formz.dart';

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure({this.allowedDomains = const []}) : super.pure('');

  const Email.dirty([super.value = ''])
    : allowedDomains = const [],
      super.dirty();

  const Email.dirtyWithDomains(
    super.value, {
    required this.allowedDomains,
  }) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
    '[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?'
    r'(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );

  final List<String> allowedDomains;

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return .empty;
    if (!_emailRegExp.hasMatch(value)) return .invalid;
    if (allowedDomains.isEmpty) return null;
    final domain = value.substring(value.lastIndexOf('@') + 1).toLowerCase();
    final matchesPolicy = allowedDomains.any((allowed) {
      final normalized = allowed.trim().toLowerCase().replaceFirst(
        RegExp('^@'),
        '',
      );
      return normalized == domain;
    });
    return matchesPolicy ? null : .invalid;
  }
}

enum EmailValidationError { empty, invalid }
