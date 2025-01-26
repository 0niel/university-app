// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScheduleChange {
  ChangeType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<DateTime> get dates => throw _privateConstructorUsedError;
  LessonBells get lessonBells => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleChangeCopyWith<ScheduleChange> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleChangeCopyWith<$Res> {
  factory $ScheduleChangeCopyWith(ScheduleChange value, $Res Function(ScheduleChange) then) =
      _$ScheduleChangeCopyWithImpl<$Res, ScheduleChange>;
  @useResult
  $Res call({ChangeType type, String title, String description, List<DateTime> dates, LessonBells lessonBells});
}

/// @nodoc
class _$ScheduleChangeCopyWithImpl<$Res, $Val extends ScheduleChange> implements $ScheduleChangeCopyWith<$Res> {
  _$ScheduleChangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? dates = null,
    Object? lessonBells = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChangeType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dates: null == dates
          ? _value.dates
          : dates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      lessonBells: null == lessonBells
          ? _value.lessonBells
          : lessonBells // ignore: cast_nullable_to_non_nullable
              as LessonBells,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleChangeImplCopyWith<$Res> implements $ScheduleChangeCopyWith<$Res> {
  factory _$$ScheduleChangeImplCopyWith(_$ScheduleChangeImpl value, $Res Function(_$ScheduleChangeImpl) then) =
      __$$ScheduleChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ChangeType type, String title, String description, List<DateTime> dates, LessonBells lessonBells});
}

/// @nodoc
class __$$ScheduleChangeImplCopyWithImpl<$Res> extends _$ScheduleChangeCopyWithImpl<$Res, _$ScheduleChangeImpl>
    implements _$$ScheduleChangeImplCopyWith<$Res> {
  __$$ScheduleChangeImplCopyWithImpl(_$ScheduleChangeImpl _value, $Res Function(_$ScheduleChangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleChange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? description = null,
    Object? dates = null,
    Object? lessonBells = null,
  }) {
    return _then(_$ScheduleChangeImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChangeType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      dates: null == dates
          ? _value._dates
          : dates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      lessonBells: null == lessonBells
          ? _value.lessonBells
          : lessonBells // ignore: cast_nullable_to_non_nullable
              as LessonBells,
    ));
  }
}

/// @nodoc

class _$ScheduleChangeImpl implements _ScheduleChange {
  const _$ScheduleChangeImpl(
      {required this.type,
      required this.title,
      required this.description,
      required final List<DateTime> dates,
      required this.lessonBells})
      : _dates = dates;

  @override
  final ChangeType type;
  @override
  final String title;
  @override
  final String description;
  final List<DateTime> _dates;
  @override
  List<DateTime> get dates {
    if (_dates is EqualUnmodifiableListView) return _dates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dates);
  }

  @override
  final LessonBells lessonBells;

  @override
  String toString() {
    return 'ScheduleChange(type: $type, title: $title, description: $description, dates: $dates, lessonBells: $lessonBells)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleChangeImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) || other.description == description) &&
            const DeepCollectionEquality().equals(other._dates, _dates) &&
            (identical(other.lessonBells, lessonBells) || other.lessonBells == lessonBells));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, type, title, description, const DeepCollectionEquality().hash(_dates), lessonBells);

  /// Create a copy of ScheduleChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleChangeImplCopyWith<_$ScheduleChangeImpl> get copyWith =>
      __$$ScheduleChangeImplCopyWithImpl<_$ScheduleChangeImpl>(this, _$identity);
}

abstract class _ScheduleChange implements ScheduleChange {
  const factory _ScheduleChange(
      {required final ChangeType type,
      required final String title,
      required final String description,
      required final List<DateTime> dates,
      required final LessonBells lessonBells}) = _$ScheduleChangeImpl;

  @override
  ChangeType get type;
  @override
  String get title;
  @override
  String get description;
  @override
  List<DateTime> get dates;
  @override
  LessonBells get lessonBells;

  /// Create a copy of ScheduleChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleChangeImplCopyWith<_$ScheduleChangeImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScheduleDiff {
  Set<ScheduleChange> get changes => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleDiff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleDiffCopyWith<ScheduleDiff> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleDiffCopyWith<$Res> {
  factory $ScheduleDiffCopyWith(ScheduleDiff value, $Res Function(ScheduleDiff) then) =
      _$ScheduleDiffCopyWithImpl<$Res, ScheduleDiff>;
  @useResult
  $Res call({Set<ScheduleChange> changes});
}

/// @nodoc
class _$ScheduleDiffCopyWithImpl<$Res, $Val extends ScheduleDiff> implements $ScheduleDiffCopyWith<$Res> {
  _$ScheduleDiffCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleDiff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? changes = null,
  }) {
    return _then(_value.copyWith(
      changes: null == changes
          ? _value.changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Set<ScheduleChange>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleDiffImplCopyWith<$Res> implements $ScheduleDiffCopyWith<$Res> {
  factory _$$ScheduleDiffImplCopyWith(_$ScheduleDiffImpl value, $Res Function(_$ScheduleDiffImpl) then) =
      __$$ScheduleDiffImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Set<ScheduleChange> changes});
}

/// @nodoc
class __$$ScheduleDiffImplCopyWithImpl<$Res> extends _$ScheduleDiffCopyWithImpl<$Res, _$ScheduleDiffImpl>
    implements _$$ScheduleDiffImplCopyWith<$Res> {
  __$$ScheduleDiffImplCopyWithImpl(_$ScheduleDiffImpl _value, $Res Function(_$ScheduleDiffImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleDiff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? changes = null,
  }) {
    return _then(_$ScheduleDiffImpl(
      changes: null == changes
          ? _value._changes
          : changes // ignore: cast_nullable_to_non_nullable
              as Set<ScheduleChange>,
    ));
  }
}

/// @nodoc

class _$ScheduleDiffImpl implements _ScheduleDiff {
  const _$ScheduleDiffImpl({required final Set<ScheduleChange> changes}) : _changes = changes;

  final Set<ScheduleChange> _changes;
  @override
  Set<ScheduleChange> get changes {
    if (_changes is EqualUnmodifiableSetView) return _changes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_changes);
  }

  @override
  String toString() {
    return 'ScheduleDiff(changes: $changes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleDiffImpl &&
            const DeepCollectionEquality().equals(other._changes, _changes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(_changes));

  /// Create a copy of ScheduleDiff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleDiffImplCopyWith<_$ScheduleDiffImpl> get copyWith =>
      __$$ScheduleDiffImplCopyWithImpl<_$ScheduleDiffImpl>(this, _$identity);
}

abstract class _ScheduleDiff implements ScheduleDiff {
  const factory _ScheduleDiff({required final Set<ScheduleChange> changes}) = _$ScheduleDiffImpl;

  @override
  Set<ScheduleChange> get changes;

  /// Create a copy of ScheduleDiff
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleDiffImplCopyWith<_$ScheduleDiffImpl> get copyWith => throw _privateConstructorUsedError;
}

ScheduleState _$ScheduleStateFromJson(Map<String, dynamic> json) {
  return _ScheduleState.fromJson(json);
}

/// @nodoc
mixin _$ScheduleState {
  @JsonKey(includeFromJson: false, includeToJson: false)
  ScheduleStatus get status => throw _privateConstructorUsedError;
  List<(String, Classroom, List<SchedulePart>)> get classroomsSchedule => throw _privateConstructorUsedError;
  List<(String, Teacher, List<SchedulePart>)> get teachersSchedule => throw _privateConstructorUsedError;
  List<(String, Group, List<SchedulePart>)> get groupsSchedule => throw _privateConstructorUsedError;
  bool get isMiniature => throw _privateConstructorUsedError;
  List<LessonComment> get comments => throw _privateConstructorUsedError;
  bool get showEmptyLessons => throw _privateConstructorUsedError;
  bool get showCommentsIndicators => throw _privateConstructorUsedError;
  bool get isListModeEnabled => throw _privateConstructorUsedError;
  List<ScheduleComment> get scheduleComments => throw _privateConstructorUsedError;
  @SelectedScheduleConverter()
  SelectedSchedule? get selectedSchedule => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Set<SelectedSchedule> get comparisonSchedules => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isComparisonModeEnabled => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  ScheduleDiff? get latestDiff => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get showScheduleDiffDialog => throw _privateConstructorUsedError;

  /// Serializes this ScheduleState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScheduleStateCopyWith<ScheduleState> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleStateCopyWith<$Res> {
  factory $ScheduleStateCopyWith(ScheduleState value, $Res Function(ScheduleState) then) =
      _$ScheduleStateCopyWithImpl<$Res, ScheduleState>;
  @useResult
  $Res call(
      {@JsonKey(includeFromJson: false, includeToJson: false) ScheduleStatus status,
      List<(String, Classroom, List<SchedulePart>)> classroomsSchedule,
      List<(String, Teacher, List<SchedulePart>)> teachersSchedule,
      List<(String, Group, List<SchedulePart>)> groupsSchedule,
      bool isMiniature,
      List<LessonComment> comments,
      bool showEmptyLessons,
      bool showCommentsIndicators,
      bool isListModeEnabled,
      List<ScheduleComment> scheduleComments,
      @SelectedScheduleConverter() SelectedSchedule? selectedSchedule,
      @JsonKey(includeFromJson: false, includeToJson: false) Set<SelectedSchedule> comparisonSchedules,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isComparisonModeEnabled,
      @JsonKey(includeFromJson: false, includeToJson: false) ScheduleDiff? latestDiff,
      @JsonKey(includeFromJson: false, includeToJson: false) bool showScheduleDiffDialog});

  $ScheduleDiffCopyWith<$Res>? get latestDiff;
}

/// @nodoc
class _$ScheduleStateCopyWithImpl<$Res, $Val extends ScheduleState> implements $ScheduleStateCopyWith<$Res> {
  _$ScheduleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? classroomsSchedule = null,
    Object? teachersSchedule = null,
    Object? groupsSchedule = null,
    Object? isMiniature = null,
    Object? comments = null,
    Object? showEmptyLessons = null,
    Object? showCommentsIndicators = null,
    Object? isListModeEnabled = null,
    Object? scheduleComments = null,
    Object? selectedSchedule = freezed,
    Object? comparisonSchedules = null,
    Object? isComparisonModeEnabled = null,
    Object? latestDiff = freezed,
    Object? showScheduleDiffDialog = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScheduleStatus,
      classroomsSchedule: null == classroomsSchedule
          ? _value.classroomsSchedule
          : classroomsSchedule // ignore: cast_nullable_to_non_nullable
              as List<(String, Classroom, List<SchedulePart>)>,
      teachersSchedule: null == teachersSchedule
          ? _value.teachersSchedule
          : teachersSchedule // ignore: cast_nullable_to_non_nullable
              as List<(String, Teacher, List<SchedulePart>)>,
      groupsSchedule: null == groupsSchedule
          ? _value.groupsSchedule
          : groupsSchedule // ignore: cast_nullable_to_non_nullable
              as List<(String, Group, List<SchedulePart>)>,
      isMiniature: null == isMiniature
          ? _value.isMiniature
          : isMiniature // ignore: cast_nullable_to_non_nullable
              as bool,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<LessonComment>,
      showEmptyLessons: null == showEmptyLessons
          ? _value.showEmptyLessons
          : showEmptyLessons // ignore: cast_nullable_to_non_nullable
              as bool,
      showCommentsIndicators: null == showCommentsIndicators
          ? _value.showCommentsIndicators
          : showCommentsIndicators // ignore: cast_nullable_to_non_nullable
              as bool,
      isListModeEnabled: null == isListModeEnabled
          ? _value.isListModeEnabled
          : isListModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      scheduleComments: null == scheduleComments
          ? _value.scheduleComments
          : scheduleComments // ignore: cast_nullable_to_non_nullable
              as List<ScheduleComment>,
      selectedSchedule: freezed == selectedSchedule
          ? _value.selectedSchedule
          : selectedSchedule // ignore: cast_nullable_to_non_nullable
              as SelectedSchedule?,
      comparisonSchedules: null == comparisonSchedules
          ? _value.comparisonSchedules
          : comparisonSchedules // ignore: cast_nullable_to_non_nullable
              as Set<SelectedSchedule>,
      isComparisonModeEnabled: null == isComparisonModeEnabled
          ? _value.isComparisonModeEnabled
          : isComparisonModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      latestDiff: freezed == latestDiff
          ? _value.latestDiff
          : latestDiff // ignore: cast_nullable_to_non_nullable
              as ScheduleDiff?,
      showScheduleDiffDialog: null == showScheduleDiffDialog
          ? _value.showScheduleDiffDialog
          : showScheduleDiffDialog // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScheduleDiffCopyWith<$Res>? get latestDiff {
    if (_value.latestDiff == null) {
      return null;
    }

    return $ScheduleDiffCopyWith<$Res>(_value.latestDiff!, (value) {
      return _then(_value.copyWith(latestDiff: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScheduleStateImplCopyWith<$Res> implements $ScheduleStateCopyWith<$Res> {
  factory _$$ScheduleStateImplCopyWith(_$ScheduleStateImpl value, $Res Function(_$ScheduleStateImpl) then) =
      __$$ScheduleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(includeFromJson: false, includeToJson: false) ScheduleStatus status,
      List<(String, Classroom, List<SchedulePart>)> classroomsSchedule,
      List<(String, Teacher, List<SchedulePart>)> teachersSchedule,
      List<(String, Group, List<SchedulePart>)> groupsSchedule,
      bool isMiniature,
      List<LessonComment> comments,
      bool showEmptyLessons,
      bool showCommentsIndicators,
      bool isListModeEnabled,
      List<ScheduleComment> scheduleComments,
      @SelectedScheduleConverter() SelectedSchedule? selectedSchedule,
      @JsonKey(includeFromJson: false, includeToJson: false) Set<SelectedSchedule> comparisonSchedules,
      @JsonKey(includeFromJson: false, includeToJson: false) bool isComparisonModeEnabled,
      @JsonKey(includeFromJson: false, includeToJson: false) ScheduleDiff? latestDiff,
      @JsonKey(includeFromJson: false, includeToJson: false) bool showScheduleDiffDialog});

  @override
  $ScheduleDiffCopyWith<$Res>? get latestDiff;
}

/// @nodoc
class __$$ScheduleStateImplCopyWithImpl<$Res> extends _$ScheduleStateCopyWithImpl<$Res, _$ScheduleStateImpl>
    implements _$$ScheduleStateImplCopyWith<$Res> {
  __$$ScheduleStateImplCopyWithImpl(_$ScheduleStateImpl _value, $Res Function(_$ScheduleStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? classroomsSchedule = null,
    Object? teachersSchedule = null,
    Object? groupsSchedule = null,
    Object? isMiniature = null,
    Object? comments = null,
    Object? showEmptyLessons = null,
    Object? showCommentsIndicators = null,
    Object? isListModeEnabled = null,
    Object? scheduleComments = null,
    Object? selectedSchedule = freezed,
    Object? comparisonSchedules = null,
    Object? isComparisonModeEnabled = null,
    Object? latestDiff = freezed,
    Object? showScheduleDiffDialog = null,
  }) {
    return _then(_$ScheduleStateImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ScheduleStatus,
      classroomsSchedule: null == classroomsSchedule
          ? _value._classroomsSchedule
          : classroomsSchedule // ignore: cast_nullable_to_non_nullable
              as List<(String, Classroom, List<SchedulePart>)>,
      teachersSchedule: null == teachersSchedule
          ? _value._teachersSchedule
          : teachersSchedule // ignore: cast_nullable_to_non_nullable
              as List<(String, Teacher, List<SchedulePart>)>,
      groupsSchedule: null == groupsSchedule
          ? _value._groupsSchedule
          : groupsSchedule // ignore: cast_nullable_to_non_nullable
              as List<(String, Group, List<SchedulePart>)>,
      isMiniature: null == isMiniature
          ? _value.isMiniature
          : isMiniature // ignore: cast_nullable_to_non_nullable
              as bool,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<LessonComment>,
      showEmptyLessons: null == showEmptyLessons
          ? _value.showEmptyLessons
          : showEmptyLessons // ignore: cast_nullable_to_non_nullable
              as bool,
      showCommentsIndicators: null == showCommentsIndicators
          ? _value.showCommentsIndicators
          : showCommentsIndicators // ignore: cast_nullable_to_non_nullable
              as bool,
      isListModeEnabled: null == isListModeEnabled
          ? _value.isListModeEnabled
          : isListModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      scheduleComments: null == scheduleComments
          ? _value._scheduleComments
          : scheduleComments // ignore: cast_nullable_to_non_nullable
              as List<ScheduleComment>,
      selectedSchedule: freezed == selectedSchedule
          ? _value.selectedSchedule
          : selectedSchedule // ignore: cast_nullable_to_non_nullable
              as SelectedSchedule?,
      comparisonSchedules: null == comparisonSchedules
          ? _value._comparisonSchedules
          : comparisonSchedules // ignore: cast_nullable_to_non_nullable
              as Set<SelectedSchedule>,
      isComparisonModeEnabled: null == isComparisonModeEnabled
          ? _value.isComparisonModeEnabled
          : isComparisonModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      latestDiff: freezed == latestDiff
          ? _value.latestDiff
          : latestDiff // ignore: cast_nullable_to_non_nullable
              as ScheduleDiff?,
      showScheduleDiffDialog: null == showScheduleDiffDialog
          ? _value.showScheduleDiffDialog
          : showScheduleDiffDialog // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleStateImpl extends _ScheduleState {
  const _$ScheduleStateImpl(
      {@JsonKey(includeFromJson: false, includeToJson: false) this.status = ScheduleStatus.initial,
      final List<(String, Classroom, List<SchedulePart>)> classroomsSchedule = const [],
      final List<(String, Teacher, List<SchedulePart>)> teachersSchedule = const [],
      final List<(String, Group, List<SchedulePart>)> groupsSchedule = const [],
      this.isMiniature = false,
      final List<LessonComment> comments = const [],
      this.showEmptyLessons = false,
      this.showCommentsIndicators = true,
      this.isListModeEnabled = false,
      final List<ScheduleComment> scheduleComments = const [],
      @SelectedScheduleConverter() this.selectedSchedule,
      @JsonKey(includeFromJson: false, includeToJson: false) final Set<SelectedSchedule> comparisonSchedules = const {},
      @JsonKey(includeFromJson: false, includeToJson: false) this.isComparisonModeEnabled = false,
      @JsonKey(includeFromJson: false, includeToJson: false) this.latestDiff = null,
      @JsonKey(includeFromJson: false, includeToJson: false) this.showScheduleDiffDialog = false})
      : _classroomsSchedule = classroomsSchedule,
        _teachersSchedule = teachersSchedule,
        _groupsSchedule = groupsSchedule,
        _comments = comments,
        _scheduleComments = scheduleComments,
        _comparisonSchedules = comparisonSchedules,
        super._();

  factory _$ScheduleStateImpl.fromJson(Map<String, dynamic> json) => _$$ScheduleStateImplFromJson(json);

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ScheduleStatus status;
  final List<(String, Classroom, List<SchedulePart>)> _classroomsSchedule;
  @override
  @JsonKey()
  List<(String, Classroom, List<SchedulePart>)> get classroomsSchedule {
    if (_classroomsSchedule is EqualUnmodifiableListView) return _classroomsSchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_classroomsSchedule);
  }

  final List<(String, Teacher, List<SchedulePart>)> _teachersSchedule;
  @override
  @JsonKey()
  List<(String, Teacher, List<SchedulePart>)> get teachersSchedule {
    if (_teachersSchedule is EqualUnmodifiableListView) return _teachersSchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_teachersSchedule);
  }

  final List<(String, Group, List<SchedulePart>)> _groupsSchedule;
  @override
  @JsonKey()
  List<(String, Group, List<SchedulePart>)> get groupsSchedule {
    if (_groupsSchedule is EqualUnmodifiableListView) return _groupsSchedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groupsSchedule);
  }

  @override
  @JsonKey()
  final bool isMiniature;
  final List<LessonComment> _comments;
  @override
  @JsonKey()
  List<LessonComment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  @JsonKey()
  final bool showEmptyLessons;
  @override
  @JsonKey()
  final bool showCommentsIndicators;
  @override
  @JsonKey()
  final bool isListModeEnabled;
  final List<ScheduleComment> _scheduleComments;
  @override
  @JsonKey()
  List<ScheduleComment> get scheduleComments {
    if (_scheduleComments is EqualUnmodifiableListView) return _scheduleComments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scheduleComments);
  }

  @override
  @SelectedScheduleConverter()
  final SelectedSchedule? selectedSchedule;
  final Set<SelectedSchedule> _comparisonSchedules;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Set<SelectedSchedule> get comparisonSchedules {
    if (_comparisonSchedules is EqualUnmodifiableSetView) return _comparisonSchedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_comparisonSchedules);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isComparisonModeEnabled;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ScheduleDiff? latestDiff;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool showScheduleDiffDialog;

  @override
  String toString() {
    return 'ScheduleState(status: $status, classroomsSchedule: $classroomsSchedule, teachersSchedule: $teachersSchedule, groupsSchedule: $groupsSchedule, isMiniature: $isMiniature, comments: $comments, showEmptyLessons: $showEmptyLessons, showCommentsIndicators: $showCommentsIndicators, isListModeEnabled: $isListModeEnabled, scheduleComments: $scheduleComments, selectedSchedule: $selectedSchedule, comparisonSchedules: $comparisonSchedules, isComparisonModeEnabled: $isComparisonModeEnabled, latestDiff: $latestDiff, showScheduleDiffDialog: $showScheduleDiffDialog)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._classroomsSchedule, _classroomsSchedule) &&
            const DeepCollectionEquality().equals(other._teachersSchedule, _teachersSchedule) &&
            const DeepCollectionEquality().equals(other._groupsSchedule, _groupsSchedule) &&
            (identical(other.isMiniature, isMiniature) || other.isMiniature == isMiniature) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.showEmptyLessons, showEmptyLessons) || other.showEmptyLessons == showEmptyLessons) &&
            (identical(other.showCommentsIndicators, showCommentsIndicators) ||
                other.showCommentsIndicators == showCommentsIndicators) &&
            (identical(other.isListModeEnabled, isListModeEnabled) || other.isListModeEnabled == isListModeEnabled) &&
            const DeepCollectionEquality().equals(other._scheduleComments, _scheduleComments) &&
            (identical(other.selectedSchedule, selectedSchedule) || other.selectedSchedule == selectedSchedule) &&
            const DeepCollectionEquality().equals(other._comparisonSchedules, _comparisonSchedules) &&
            (identical(other.isComparisonModeEnabled, isComparisonModeEnabled) ||
                other.isComparisonModeEnabled == isComparisonModeEnabled) &&
            (identical(other.latestDiff, latestDiff) || other.latestDiff == latestDiff) &&
            (identical(other.showScheduleDiffDialog, showScheduleDiffDialog) ||
                other.showScheduleDiffDialog == showScheduleDiffDialog));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_classroomsSchedule),
      const DeepCollectionEquality().hash(_teachersSchedule),
      const DeepCollectionEquality().hash(_groupsSchedule),
      isMiniature,
      const DeepCollectionEquality().hash(_comments),
      showEmptyLessons,
      showCommentsIndicators,
      isListModeEnabled,
      const DeepCollectionEquality().hash(_scheduleComments),
      selectedSchedule,
      const DeepCollectionEquality().hash(_comparisonSchedules),
      isComparisonModeEnabled,
      latestDiff,
      showScheduleDiffDialog);

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleStateImplCopyWith<_$ScheduleStateImpl> get copyWith =>
      __$$ScheduleStateImplCopyWithImpl<_$ScheduleStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleStateImplToJson(
      this,
    );
  }
}

abstract class _ScheduleState extends ScheduleState {
  const factory _ScheduleState(
      {@JsonKey(includeFromJson: false, includeToJson: false) final ScheduleStatus status,
      final List<(String, Classroom, List<SchedulePart>)> classroomsSchedule,
      final List<(String, Teacher, List<SchedulePart>)> teachersSchedule,
      final List<(String, Group, List<SchedulePart>)> groupsSchedule,
      final bool isMiniature,
      final List<LessonComment> comments,
      final bool showEmptyLessons,
      final bool showCommentsIndicators,
      final bool isListModeEnabled,
      final List<ScheduleComment> scheduleComments,
      @SelectedScheduleConverter() final SelectedSchedule? selectedSchedule,
      @JsonKey(includeFromJson: false, includeToJson: false) final Set<SelectedSchedule> comparisonSchedules,
      @JsonKey(includeFromJson: false, includeToJson: false) final bool isComparisonModeEnabled,
      @JsonKey(includeFromJson: false, includeToJson: false) final ScheduleDiff? latestDiff,
      @JsonKey(includeFromJson: false, includeToJson: false) final bool showScheduleDiffDialog}) = _$ScheduleStateImpl;
  const _ScheduleState._() : super._();

  factory _ScheduleState.fromJson(Map<String, dynamic> json) = _$ScheduleStateImpl.fromJson;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  ScheduleStatus get status;
  @override
  List<(String, Classroom, List<SchedulePart>)> get classroomsSchedule;
  @override
  List<(String, Teacher, List<SchedulePart>)> get teachersSchedule;
  @override
  List<(String, Group, List<SchedulePart>)> get groupsSchedule;
  @override
  bool get isMiniature;
  @override
  List<LessonComment> get comments;
  @override
  bool get showEmptyLessons;
  @override
  bool get showCommentsIndicators;
  @override
  bool get isListModeEnabled;
  @override
  List<ScheduleComment> get scheduleComments;
  @override
  @SelectedScheduleConverter()
  SelectedSchedule? get selectedSchedule;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Set<SelectedSchedule> get comparisonSchedules;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isComparisonModeEnabled;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  ScheduleDiff? get latestDiff;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get showScheduleDiffDialog;

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleStateImplCopyWith<_$ScheduleStateImpl> get copyWith => throw _privateConstructorUsedError;
}
