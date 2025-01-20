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

ScheduleState _$ScheduleStateFromJson(Map<String, dynamic> json) {
  return _ScheduleState.fromJson(json);
}

/// @nodoc
mixin _$ScheduleState {
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
  Set<SelectedSchedule> get comparisonSchedules => throw _privateConstructorUsedError;
  bool get isComparisonModeEnabled => throw _privateConstructorUsedError;

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
      {ScheduleStatus status,
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
      Set<SelectedSchedule> comparisonSchedules,
      bool isComparisonModeEnabled});
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleStateImplCopyWith<$Res> implements $ScheduleStateCopyWith<$Res> {
  factory _$$ScheduleStateImplCopyWith(_$ScheduleStateImpl value, $Res Function(_$ScheduleStateImpl) then) =
      __$$ScheduleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ScheduleStatus status,
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
      Set<SelectedSchedule> comparisonSchedules,
      bool isComparisonModeEnabled});
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleStateImpl extends _ScheduleState {
  const _$ScheduleStateImpl(
      {this.status = ScheduleStatus.initial,
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
      final Set<SelectedSchedule> comparisonSchedules = const {},
      this.isComparisonModeEnabled = false})
      : _classroomsSchedule = classroomsSchedule,
        _teachersSchedule = teachersSchedule,
        _groupsSchedule = groupsSchedule,
        _comments = comments,
        _scheduleComments = scheduleComments,
        _comparisonSchedules = comparisonSchedules,
        super._();

  factory _$ScheduleStateImpl.fromJson(Map<String, dynamic> json) => _$$ScheduleStateImplFromJson(json);

  @override
  @JsonKey()
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
  @JsonKey()
  Set<SelectedSchedule> get comparisonSchedules {
    if (_comparisonSchedules is EqualUnmodifiableSetView) return _comparisonSchedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_comparisonSchedules);
  }

  @override
  @JsonKey()
  final bool isComparisonModeEnabled;

  @override
  String toString() {
    return 'ScheduleState(status: $status, classroomsSchedule: $classroomsSchedule, teachersSchedule: $teachersSchedule, groupsSchedule: $groupsSchedule, isMiniature: $isMiniature, comments: $comments, showEmptyLessons: $showEmptyLessons, showCommentsIndicators: $showCommentsIndicators, isListModeEnabled: $isListModeEnabled, scheduleComments: $scheduleComments, selectedSchedule: $selectedSchedule, comparisonSchedules: $comparisonSchedules, isComparisonModeEnabled: $isComparisonModeEnabled)';
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
                other.isComparisonModeEnabled == isComparisonModeEnabled));
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
      isComparisonModeEnabled);

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
      {final ScheduleStatus status,
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
      final Set<SelectedSchedule> comparisonSchedules,
      final bool isComparisonModeEnabled}) = _$ScheduleStateImpl;
  const _ScheduleState._() : super._();

  factory _ScheduleState.fromJson(Map<String, dynamic> json) = _$ScheduleStateImpl.fromJson;

  @override
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
  Set<SelectedSchedule> get comparisonSchedules;
  @override
  bool get isComparisonModeEnabled;

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleStateImplCopyWith<_$ScheduleStateImpl> get copyWith => throw _privateConstructorUsedError;
}
