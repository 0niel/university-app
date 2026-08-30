import 'package:campus_repository/src/models/group_link_address.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_link.freezed.dart';
part 'group_link.g.dart';

@freezed
abstract class GroupLink with _$GroupLink {
  const factory GroupLink({
    required String id,
    required String title,
    required String url,
    @Default('🔗') String emoji,
    @Default('link') String kind,
    @Default('') String addedBy,
    @Default(false) bool isMine,
  }) = _GroupLink;

  const GroupLink._();

  factory GroupLink.fromJson(Map<String, Object?> json) {
    for (final field in const ['id', 'title', 'url']) {
      final value = json[field];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('GroupLink $field must be a non-empty string');
      }
    }
    return _$GroupLinkFromJson(json);
  }

  bool get isTelegram => kind == 'telegram';

  Uri? get safeUri => GroupLinkAddress.tryParse(
    url,
    telegramOnly: isTelegram,
  )?.uri;
}
