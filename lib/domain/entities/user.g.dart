// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      login: json['login'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      lastName: json['lastName'] as String,
      secondName: json['secondName'] as String,
      birthday: json['birthday'] as String,
      photoUrl: json['photoUrl'] as String,
      registerDate: json['registerDate'] as String,
      lastLoginDate: json['lastLoginDate'] as String,
      students: (json['students'] as List<dynamic>).map((e) => Student.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'login': instance.login,
      'email': instance.email,
      'name': instance.name,
      'lastName': instance.lastName,
      'secondName': instance.secondName,
      'birthday': instance.birthday,
      'photoUrl': instance.photoUrl,
      'registerDate': instance.registerDate,
      'lastLoginDate': instance.lastLoginDate,
      'students': instance.students,
    };
