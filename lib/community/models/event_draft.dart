import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rtu_mirea_app/community/models/event_category.dart';

part 'event_draft.freezed.dart';

@freezed
abstract class EventDraft with _$EventDraft {
  const factory EventDraft({
    required String title,
    required DateTime startsAt,
    required String emoji,
    required EventCategory category,
    @Default('') String place,
    @Default('') String description,
  }) = _EventDraft;
}
