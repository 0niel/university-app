// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      id: json['id'] as int,
      login: json['login'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
      secondName: json['secondName'] as String,
      birthday: DateTime.parse(json['birthday'] as String),
      photoUrl: json['photoUrl'] as String,
      lastLoginDate: DateTime.parse(json['lastLoginDate'] as String),
      registerDate: DateTime.parse(json['registerDate'] as String),
      students: (json['students'] as List<dynamic>)
          .map((e) => Student.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProfileResponseToJson(ProfileResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'email': instance.email,
      'name': instance.name,
      'lastName': instance.lastName,
      'secondName': instance.secondName,
      'birthday': instance.birthday.toIso8601String(),
      'photoUrl': instance.photoUrl,
      'lastLoginDate': instance.lastLoginDate.toIso8601String(),
      'registerDate': instance.registerDate.toIso8601String(),
      'students': instance.students,
    };
