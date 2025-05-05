import 'package:formz/formz.dart';
import 'package:university_app_server_api/client.dart';

enum TitleValidationError { empty, tooShort }

class ItemTitle extends FormzInput<String, TitleValidationError> {
  const ItemTitle.pure([super.value = '']) : super.pure();
  const ItemTitle.dirty([super.value = '']) : super.dirty();

  @override
  TitleValidationError? validator(String value) {
    if (value.isEmpty) {
      return TitleValidationError.empty;
    } else if (value.trim().length < 3) {
      return TitleValidationError.tooShort;
    }
    return null;
  }
}

enum NoValidationError { none }

class Description extends FormzInput<String, NoValidationError?> {
  const Description.pure([super.value = '']) : super.pure();
  const Description.dirty([super.value = '']) : super.dirty();

  @override
  NoValidationError? validator(String value) {
    return null; // Optional field, no validation needed
  }
}

class TelegramContact extends FormzInput<String, NoValidationError?> {
  const TelegramContact.pure([super.value = '']) : super.pure();
  const TelegramContact.dirty([super.value = '']) : super.dirty();

  @override
  NoValidationError? validator(String value) {
    return null; // Optional field, no validation needed
  }
}

class PhoneContact extends FormzInput<String, NoValidationError?> {
  const PhoneContact.pure([super.value = '']) : super.pure();
  const PhoneContact.dirty([super.value = '']) : super.dirty();

  @override
  NoValidationError? validator(String value) {
    return null; // Optional field, no validation needed
  }
}

class LostFoundFormState with FormzMixin {
  LostFoundFormState({
    this.title = const ItemTitle.pure(),
    this.description = const Description.pure(),
    this.telegramContact = const TelegramContact.pure(),
    this.phoneContact = const PhoneContact.pure(),
    this.status = LostFoundItemStatus.lost,
    this.images = const [],
    this.formStatus = FormzSubmissionStatus.initial,
  });

  final ItemTitle title;
  final Description description;
  final TelegramContact telegramContact;
  final PhoneContact phoneContact;
  final LostFoundItemStatus status;
  final List<dynamic> images;
  final FormzSubmissionStatus formStatus;

  LostFoundFormState copyWith({
    ItemTitle? title,
    Description? description,
    TelegramContact? telegramContact,
    PhoneContact? phoneContact,
    LostFoundItemStatus? status,
    List<dynamic>? images,
    FormzSubmissionStatus? formStatus,
  }) {
    return LostFoundFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      telegramContact: telegramContact ?? this.telegramContact,
      phoneContact: phoneContact ?? this.phoneContact,
      status: status ?? this.status,
      images: images ?? this.images,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [title, description, telegramContact, phoneContact];
}

extension TitleValidationErrorExtension on TitleValidationError {
  String text() {
    switch (this) {
      case TitleValidationError.empty:
        return 'Пожалуйста, введите название';
      case TitleValidationError.tooShort:
        return 'Название должно содержать хотя бы 3 символа';
    }
  }
}
