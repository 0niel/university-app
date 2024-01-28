// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserState _$UserStateFromJson(Map<String, dynamic> json) => UserState(
      user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']) ?? UserStatus.initial,
    );

Map<String, dynamic> _$UserStateToJson(UserState instance) => <String, dynamic>{
      'user': instance.user,
      'status': _$UserStatusEnumMap[instance.status]!,
    };

const _$UserStatusEnumMap = {
  UserStatus.initial: 'initial',
  UserStatus.unauthorized: 'unauthorized',
  UserStatus.loading: 'loading',
  UserStatus.authorized: 'authorized',
  UserStatus.authorizeError: 'authorizeError',
};
