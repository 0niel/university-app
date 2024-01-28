import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:nextcloud/notifications.dart' show DecryptedSubject, RSAPrivateKey, decryptPushNotificationSubject;

part 'push_notification.g.dart';

/// The json key for [PushNotification.accountID].
const String _accountIDKey = 'accountID';

/// The json key for [PushNotification.priority].
const String _priorityKey = 'priority';

/// The json key for [PushNotification.type].
const String _typeKey = 'type';

/// The json key for [PushNotification.subject].
const String _subjectKey = 'subject';

/// Data for a push notification.
@JsonSerializable()
@internal
class PushNotification {
  /// Creates a new push notification.
  const PushNotification({
    required this.accountID,
    required this.priority,
    required this.type,
    required this.subject,
  });

  /// Creates a new PushNotification object from the given [json] data.
  ///
  /// Use [PushNotification.fromEncrypted] when you the [subject] is still encrypted.
  factory PushNotification.fromJson(Map<String, dynamic> json) => _$PushNotificationFromJson(json);

  /// Creates a new PushNotification object from the given [json] data containing an encrypted [subject].
  ///
  /// Use [PushNotification.fromJson] when the [subject] is not encrypted.
  factory PushNotification.fromEncrypted(
    Map<String, dynamic> json,
    String accountID,
    RSAPrivateKey privateKey,
  ) {
    final subject = decryptPushNotificationSubject(privateKey, json[_subjectKey] as String);

    return PushNotification(
      accountID: accountID,
      priority: json[_priorityKey] as String,
      type: json[_typeKey] as String,
      subject: subject,
    );
  }

  /// Parses this object into a json like map.
  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);

  /// The account associated to this notification.
  @JsonKey(name: _accountIDKey)
  final String accountID;

  /// The priority of the notification.
  @JsonKey(name: _priorityKey)
  final String priority;

  /// The type of the notification.
  @JsonKey(name: _typeKey)
  final String type;

  /// The subject of this notification.
  @JsonKey(name: _subjectKey)
  final DecryptedSubject subject;
}
