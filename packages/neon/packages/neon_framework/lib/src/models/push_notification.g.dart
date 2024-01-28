// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotification _$PushNotificationFromJson(Map<String, dynamic> json) => PushNotification(
      accountID: json['accountID'] as String,
      priority: json['priority'] as String,
      type: json['type'] as String,
      subject: DecryptedSubject.fromJson(json['subject'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PushNotificationToJson(PushNotification instance) => <String, dynamic>{
      'accountID': instance.accountID,
      'priority': instance.priority,
      'type': instance.type,
      'subject': instance.subject,
    };
