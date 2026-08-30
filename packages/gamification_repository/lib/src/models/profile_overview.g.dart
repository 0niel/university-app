// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileOverview _$ProfileOverviewFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ProfileOverview', json, ($checkedConvert) {
      final val = _ProfileOverview(
        academic: $checkedConvert(
          'academic',
          (v) => v == null
              ? AcademicProfile.empty
              : AcademicProfile.fromJson(v as Map<String, dynamic>),
        ),
        semester: $checkedConvert(
          'semester',
          (v) => v == null
              ? SemesterStats.empty
              : SemesterStats.fromJson(v as Map<String, dynamic>),
        ),
        groupRank: $checkedConvert('groupRank', (v) => (v as num?)?.toInt()),
        groupSize: $checkedConvert('groupSize', (v) => (v as num?)?.toInt()),
        streakHistory: $checkedConvert(
          'streakHistory',
          (v) => v == null ? const <bool>[] : _streakHistoryFromJson(v),
        ),
        earnedBadges: $checkedConvert(
          'earnedBadges',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
        totalBadges: $checkedConvert(
          'totalBadges',
          (v) => (v as num?)?.toInt() ?? 0,
        ),
      );
      return val;
    });

Map<String, dynamic> _$ProfileOverviewToJson(_ProfileOverview instance) =>
    <String, dynamic>{
      'academic': instance.academic.toJson(),
      'semester': instance.semester.toJson(),
      'groupRank': instance.groupRank,
      'groupSize': instance.groupSize,
      'streakHistory': instance.streakHistory,
      'earnedBadges': instance.earnedBadges,
      'totalBadges': instance.totalBadges,
    };

_SemesterStats _$SemesterStatsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SemesterStats', json, ($checkedConvert) {
      final val = _SemesterStats(
        label: $checkedConvert('label', (v) => v as String?),
        moduleLabel: $checkedConvert('moduleLabel', (v) => v as String?),
        gpa: $checkedConvert('gpa', (v) => (v as num?)?.toDouble()),
      );
      return val;
    });

Map<String, dynamic> _$SemesterStatsToJson(_SemesterStats instance) =>
    <String, dynamic>{
      'label': instance.label,
      'moduleLabel': instance.moduleLabel,
      'gpa': instance.gpa,
    };
