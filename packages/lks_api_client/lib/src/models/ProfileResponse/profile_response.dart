import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:schedule_api_client/src/models/ProfileResponse/student_in_response.dart';

part 'profile_response.g.dart';

/// {@template groups_response}
/// Ответ на запрос профиля студента
/// {@endtemplate}
@JsonSerializable()
class ProfileResponse extends Equatable {
  /// {@macro groups_response}
  const ProfileResponse({
    required this.id,
    required this.login,
    required this.email,
    required this.name,
    required this.lastName,
    required this.secondName,
    required this.birthday,
    required this.photoUrl,
    required this.lastLoginDate,
    required this.registerDate,
    required this.students,
  });

  /// Конвертирует `Map<String, dynamic>` в [ProfileResponse]
  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json["ID"],
      login: json["arUser"]["LOGIN"],
      email: json["arUser"]["EMAIL"],
      name: json["arUser"]["NAME"],
      lastName: json["arUser"]["LAST_NAME"],
      secondName: json["arUser"]["SECOND_NAME"],
      photoUrl: json["arUser"]["PHOTO"],
      lastLoginDate: json["arUser"]["LAST_LOGIN"],
      registerDate: json["arUser"]["DATE_REGISTER"],
      birthday: json["arUser"]["PERSONAL_BIRTHDAY"],
      students: StudentModel.fromJson(json),
    );
  }

  /// Уникальный айди аккаунта.
  final int id;

  /// Email в доменной зоне edu-mirea.ru.
  final String login;

  /// Персональный email.
  final String email;

  /// Имя.
  final String name;

  /// Фамилия.
  final String lastName;

  /// Отчество.
  final String secondName;

  /// Дата рождения.
  final DateTime birthday;

  /// Ссылка на фото.
  final String photoUrl;

  /// Дата последнего входа.
  final DateTime lastLoginDate;

  /// Дата регистрации.
  final DateTime registerDate;

  /// Информация о студенте. Может быть несколько. Например, если человек учится
  /// в магистратуре, то будет два объекта: один для бакалавриата (с неактивным
  /// статусом), второй для магистратуры (активный студент).
  ///
  /// Иногда также бывает, что студент одновременно учится на двух направлениях.
  /// В этом случае будет два объекта с активным статусом.
  final List<StudentInResponse> students;

  @override
  List<Object> get props => [
        id,
        login,
        email,
        name,
        lastName,
        secondName,
        birthday,
        photoUrl,
        lastLoginDate,
        registerDate,
      ];
}
