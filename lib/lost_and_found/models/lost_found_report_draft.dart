import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lost_and_found_repository/lost_and_found_repository.dart';

part 'lost_found_report_draft.freezed.dart';

@freezed
abstract class LostFoundReportDraft with _$LostFoundReportDraft {
  const factory LostFoundReportDraft({
    @Default('') String title,
    @Default(LostFoundItemStatus.found) LostFoundItemStatus status,
    @Default('other') String category,
    @Default('') String description,
    @Default('') String telegram,
    @Default('') String phoneNumber,
    @Default('') String location,
    @Default(false) bool showContact,
    @Default(<LostFoundImageUpload>[]) List<LostFoundImageUpload> images,
  }) = _LostFoundReportDraft;

  const LostFoundReportDraft._();

  bool get isValid {
    final normalizedTitle = title.trim();
    final normalizedCategory = category.trim();
    final normalizedTelegram = telegram.trim();
    final normalizedPhone = phoneNumber.trim();
    return normalizedTitle.isNotEmpty &&
        normalizedTitle.length <= 120 &&
        description.trim().length <= 4000 &&
        location.trim().length <= 200 &&
        RegExp(r'^[a-z][a-z0-9_]{0,39}$').hasMatch(normalizedCategory) &&
        images.length <= 5 &&
        (!showContact ||
            normalizedTelegram.isNotEmpty ||
            normalizedPhone.isNotEmpty);
  }
}
