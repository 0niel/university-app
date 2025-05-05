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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FieldDiff {
  /// Имя поля (например, "Даты", "Аудитории", "Преподаватели", "Время/номер пары")
  String get fieldName => throw _privateConstructorUsedError;

  /// Для не-дата полей можно оставить старое и новое значение в виде строки
  String? get oldValue => throw _privateConstructorUsedError;
  String? get newValue => throw _privateConstructorUsedError;

  /// Для поля «Даты»—детальный diff: какие даты добавлены
  List<DateTime>? get addedDates => throw _privateConstructorUsedError;

  /// Для поля «Даты»—детальный diff: какие даты удалены
  List<DateTime>? get removedDates => throw _privateConstructorUsedError;

  /// И какие даты остались без изменений (можно их просто вывести без подсветки)
  List<DateTime>? get unchangedDates => throw _privateConstructorUsedError;

  /// Create a copy of FieldDiff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FieldDiffCopyWith<FieldDiff> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FieldDiffCopyWith<$Res> {
  factory $FieldDiffCopyWith(FieldDiff value, $Res Function(FieldDiff) then) = _$FieldDiffCopyWithImpl<$Res, FieldDiff>;
  @useResult
  $Res call({
    String fieldName,
    String? oldValue,
    String? newValue,
    List<DateTime>? addedDates,
    List<DateTime>? removedDates,
    List<DateTime>? unchangedDates,
  });
}

/// @nodoc
class _$FieldDiffCopyWithImpl<$Res, $Val extends FieldDiff> implements $FieldDiffCopyWith<$Res> {
  _$FieldDiffCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FieldDiff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldName = null,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? addedDates = freezed,
    Object? removedDates = freezed,
    Object? unchangedDates = freezed,
  }) {
    return _then(
      _value.copyWith(
            fieldName:
                null == fieldName
                    ? _value.fieldName
                    : fieldName // ignore: cast_nullable_to_non_nullable
                        as String,
            oldValue:
                freezed == oldValue
                    ? _value.oldValue
                    : oldValue // ignore: cast_nullable_to_non_nullable
                        as String?,
            newValue:
                freezed == newValue
                    ? _value.newValue
                    : newValue // ignore: cast_nullable_to_non_nullable
                        as String?,
            addedDates:
                freezed == addedDates
                    ? _value.addedDates
                    : addedDates // ignore: cast_nullable_to_non_nullable
                        as List<DateTime>?,
            removedDates:
                freezed == removedDates
                    ? _value.removedDates
                    : removedDates // ignore: cast_nullable_to_non_nullable
                        as List<DateTime>?,
            unchangedDates:
                freezed == unchangedDates
                    ? _value.unchangedDates
                    : unchangedDates // ignore: cast_nullable_to_non_nullable
                        as List<DateTime>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FieldDiffImplCopyWith<$Res> implements $FieldDiffCopyWith<$Res> {
  factory _$$FieldDiffImplCopyWith(_$FieldDiffImpl value, $Res Function(_$FieldDiffImpl) then) =
      __$$FieldDiffImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String fieldName,
    String? oldValue,
    String? newValue,
    List<DateTime>? addedDates,
    List<DateTime>? removedDates,
    List<DateTime>? unchangedDates,
  });
}

/// @nodoc
class __$$FieldDiffImplCopyWithImpl<$Res> extends _$FieldDiffCopyWithImpl<$Res, _$FieldDiffImpl>
    implements _$$FieldDiffImplCopyWith<$Res> {
  __$$FieldDiffImplCopyWithImpl(_$FieldDiffImpl _value, $Res Function(_$FieldDiffImpl) _then) : super(_value, _then);

  /// Create a copy of FieldDiff
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fieldName = null,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? addedDates = freezed,
    Object? removedDates = freezed,
    Object? unchangedDates = freezed,
  }) {
    return _then(
      _$FieldDiffImpl(
        fieldName:
            null == fieldName
                ? _value.fieldName
                : fieldName // ignore: cast_nullable_to_non_nullable
                    as String,
        oldValue:
            freezed == oldValue
                ? _value.oldValue
                : oldValue // ignore: cast_nullable_to_non_nullable
                    as String?,
        newValue:
            freezed == newValue
                ? _value.newValue
                : newValue // ignore: cast_nullable_to_non_nullable
                    as String?,
        addedDates:
            freezed == addedDates
                ? _value._addedDates
                : addedDates // ignore: cast_nullable_to_non_nullable
                    as List<DateTime>?,
        removedDates:
            freezed == removedDates
                ? _value._removedDates
                : removedDates // ignore: cast_nullable_to_non_nullable
                    as List<DateTime>?,
        unchangedDates:
            freezed == unchangedDates
                ? _value._unchangedDates
                : unchangedDates // ignore: cast_nullable_to_non_nullable
                    as List<DateTime>?,
      ),
    );
  }
}

/// @nodoc

class _$FieldDiffImpl implements _FieldDiff {
  const _$FieldDiffImpl({
    required this.fieldName,
    this.oldValue,
    this.newValue,
    final List<DateTime>? addedDates,
    final List<DateTime>? removedDates,
    final List<DateTime>? unchangedDates,
  }) : _addedDates = addedDates,
       _removedDates = removedDates,
       _unchangedDates = unchangedDates;

  /// Имя поля (например, "Даты", "Аудитории", "Преподаватели", "Время/номер пары")
  @override
  final String fieldName;

  /// Для не-дата полей можно оставить старое и новое значение в виде строки
  @override
  final String? oldValue;
  @override
  final String? newValue;

  /// Для поля «Даты»—детальный diff: какие даты добавлены
  final List<DateTime>? _addedDates;

  /// Для поля «Даты»—детальный diff: какие даты добавлены
  @override
  List<DateTime>? get addedDates {
    final value = _addedDates;
    if (value == null) return null;
    if (_addedDates is EqualUnmodifiableListView) return _addedDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Для поля «Даты»—детальный diff: какие даты удалены
  final List<DateTime>? _removedDates;

  /// Для поля «Даты»—детальный diff: какие даты удалены
  @override
  List<DateTime>? get removedDates {
    final value = _removedDates;
    if (value == null) return null;
    if (_removedDates is EqualUnmodifiableListView) return _removedDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// И какие даты остались без изменений (можно их просто вывести без подсветки)
  final List<DateTime>? _unchangedDates;

  /// И какие даты остались без изменений (можно их просто вывести без подсветки)
  @override
  List<DateTime>? get unchangedDates {
    final value = _unchangedDates;
    if (value == null) return null;
    if (_unchangedDates is EqualUnmodifiableListView) return _unchangedDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FieldDiff(fieldName: $fieldName, oldValue: $oldValue, newValue: $newValue, addedDates: $addedDates, removedDates: $removedDates, unchangedDates: $unchangedDates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FieldDiffImpl &&
            (identical(other.fieldName, fieldName) || other.fieldName == fieldName) &&
            (identical(other.oldValue, oldValue) || other.oldValue == oldValue) &&
            (identical(other.newValue, newValue) || other.newValue == newValue) &&
            const DeepCollectionEquality().equals(other._addedDates, _addedDates) &&
            const DeepCollectionEquality().equals(other._removedDates, _removedDates) &&
            const DeepCollectionEquality().equals(other._unchangedDates, _unchangedDates));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    fieldName,
    oldValue,
    newValue,
    const DeepCollectionEquality().hash(_addedDates),
    const DeepCollectionEquality().hash(_removedDates),
    const DeepCollectionEquality().hash(_unchangedDates),
  );

  /// Create a copy of FieldDiff
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FieldDiffImplCopyWith<_$FieldDiffImpl> get copyWith =>
      __$$FieldDiffImplCopyWithImpl<_$FieldDiffImpl>(this, _$identity);
}

abstract class _FieldDiff implements FieldDiff {
  const factory _FieldDiff({
    required final String fieldName,
    final String? oldValue,
    final String? newValue,
    final List<DateTime>? addedDates,
    final List<DateTime>? removedDates,
    final List<DateTime>? unchangedDates,
  }) = _$FieldDiffImpl;

  /// Имя поля (например, "Даты", "Аудитории", "Преподаватели", "Время/номер пары")
  @override
  String get fieldName;

  /// Для не-дата полей можно оставить старое и новое значение в виде строки
  @override
  String? get oldValue;
  @override
  String? get newValue;

  /// Для поля «Даты»—детальный diff: какие даты добавлены
  @override
  List<DateTime>? get addedDates;

  /// Для поля «Даты»—детальный diff: какие даты удалены
  @override
  List<DateTime>? get removedDates;

  /// И какие даты остались без изменений (можно их просто вывести без подсветки)
  @override
  List<DateTime>? get unchangedDates;

  /// Create a copy of FieldDiff
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FieldDiffImplCopyWith<_$FieldDiffImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScheduleChange {
  /// Тип изменения: добавление, удаление, модификация
  ChangeType get type => throw _privateConstructorUsedError;

  /// Название предмета, служащее заголовком для данного diff‑блока
  String get subject => throw _privateConstructorUsedError;

  /// Список изменений по полям: для добавленных и удалённых уроков здесь будут все поля,
  /// для модифицированных – только те, что изменились.
  List<FieldDiff> get fieldDiffs => throw _privateConstructorUsedError;

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
  $Res call({ChangeType type, String subject, List<FieldDiff> fieldDiffs});
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
  $Res call({Object? type = null, Object? subject = null, Object? fieldDiffs = null}) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as ChangeType,
            subject:
                null == subject
                    ? _value.subject
                    : subject // ignore: cast_nullable_to_non_nullable
                        as String,
            fieldDiffs:
                null == fieldDiffs
                    ? _value.fieldDiffs
                    : fieldDiffs // ignore: cast_nullable_to_non_nullable
                        as List<FieldDiff>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScheduleChangeImplCopyWith<$Res> implements $ScheduleChangeCopyWith<$Res> {
  factory _$$ScheduleChangeImplCopyWith(_$ScheduleChangeImpl value, $Res Function(_$ScheduleChangeImpl) then) =
      __$$ScheduleChangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ChangeType type, String subject, List<FieldDiff> fieldDiffs});
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
  $Res call({Object? type = null, Object? subject = null, Object? fieldDiffs = null}) {
    return _then(
      _$ScheduleChangeImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as ChangeType,
        subject:
            null == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                    as String,
        fieldDiffs:
            null == fieldDiffs
                ? _value._fieldDiffs
                : fieldDiffs // ignore: cast_nullable_to_non_nullable
                    as List<FieldDiff>,
      ),
    );
  }
}

/// @nodoc

class _$ScheduleChangeImpl implements _ScheduleChange {
  const _$ScheduleChangeImpl({required this.type, required this.subject, required final List<FieldDiff> fieldDiffs})
    : _fieldDiffs = fieldDiffs;

  /// Тип изменения: добавление, удаление, модификация
  @override
  final ChangeType type;

  /// Название предмета, служащее заголовком для данного diff‑блока
  @override
  final String subject;

  /// Список изменений по полям: для добавленных и удалённых уроков здесь будут все поля,
  /// для модифицированных – только те, что изменились.
  final List<FieldDiff> _fieldDiffs;

  /// Список изменений по полям: для добавленных и удалённых уроков здесь будут все поля,
  /// для модифицированных – только те, что изменились.
  @override
  List<FieldDiff> get fieldDiffs {
    if (_fieldDiffs is EqualUnmodifiableListView) return _fieldDiffs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fieldDiffs);
  }

  @override
  String toString() {
    return 'ScheduleChange(type: $type, subject: $subject, fieldDiffs: $fieldDiffs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleChangeImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            const DeepCollectionEquality().equals(other._fieldDiffs, _fieldDiffs));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, subject, const DeepCollectionEquality().hash(_fieldDiffs));

  /// Create a copy of ScheduleChange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleChangeImplCopyWith<_$ScheduleChangeImpl> get copyWith =>
      __$$ScheduleChangeImplCopyWithImpl<_$ScheduleChangeImpl>(this, _$identity);
}

abstract class _ScheduleChange implements ScheduleChange {
  const factory _ScheduleChange({
    required final ChangeType type,
    required final String subject,
    required final List<FieldDiff> fieldDiffs,
  }) = _$ScheduleChangeImpl;

  /// Тип изменения: добавление, удаление, модификация
  @override
  ChangeType get type;

  /// Название предмета, служащее заголовком для данного diff‑блока
  @override
  String get subject;

  /// Список изменений по полям: для добавленных и удалённых уроков здесь будут все поля,
  /// для модифицированных – только те, что изменились.
  @override
  List<FieldDiff> get fieldDiffs;

  /// Create a copy of ScheduleChange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleChangeImplCopyWith<_$ScheduleChangeImpl> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ScheduleDiff {
  /// Множество изменений в расписании (можно преобразовать в список для удобства отображения)
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
  $Res call({Object? changes = null}) {
    return _then(
      _value.copyWith(
            changes:
                null == changes
                    ? _value.changes
                    : changes // ignore: cast_nullable_to_non_nullable
                        as Set<ScheduleChange>,
          )
          as $Val,
    );
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
  $Res call({Object? changes = null}) {
    return _then(
      _$ScheduleDiffImpl(
        changes:
            null == changes
                ? _value._changes
                : changes // ignore: cast_nullable_to_non_nullable
                    as Set<ScheduleChange>,
      ),
    );
  }
}

/// @nodoc

class _$ScheduleDiffImpl implements _ScheduleDiff {
  const _$ScheduleDiffImpl({required final Set<ScheduleChange> changes}) : _changes = changes;

  /// Множество изменений в расписании (можно преобразовать в список для удобства отображения)
  final Set<ScheduleChange> _changes;

  /// Множество изменений в расписании (можно преобразовать в список для удобства отображения)
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

  /// Множество изменений в расписании (можно преобразовать в список для удобства отображения)
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
  bool get showScheduleDiffDialog => throw _privateConstructorUsedError; // Desktop mode state properties
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSplitViewEnabled => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get showAnalytics => throw _privateConstructorUsedError; // Custom schedules
  List<CustomSchedule> get customSchedules => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isCustomScheduleModeEnabled => throw _privateConstructorUsedError;

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
  $Res call({
    @JsonKey(includeFromJson: false, includeToJson: false) ScheduleStatus status,
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
    @JsonKey(includeFromJson: false, includeToJson: false) bool showScheduleDiffDialog,
    @JsonKey(includeFromJson: false, includeToJson: false) bool isSplitViewEnabled,
    @JsonKey(includeFromJson: false, includeToJson: false) bool showAnalytics,
    List<CustomSchedule> customSchedules,
    @JsonKey(includeFromJson: false, includeToJson: false) bool isCustomScheduleModeEnabled,
  });

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
    Object? isSplitViewEnabled = null,
    Object? showAnalytics = null,
    Object? customSchedules = null,
    Object? isCustomScheduleModeEnabled = null,
  }) {
    return _then(
      _value.copyWith(
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as ScheduleStatus,
            classroomsSchedule:
                null == classroomsSchedule
                    ? _value.classroomsSchedule
                    : classroomsSchedule // ignore: cast_nullable_to_non_nullable
                        as List<(String, Classroom, List<SchedulePart>)>,
            teachersSchedule:
                null == teachersSchedule
                    ? _value.teachersSchedule
                    : teachersSchedule // ignore: cast_nullable_to_non_nullable
                        as List<(String, Teacher, List<SchedulePart>)>,
            groupsSchedule:
                null == groupsSchedule
                    ? _value.groupsSchedule
                    : groupsSchedule // ignore: cast_nullable_to_non_nullable
                        as List<(String, Group, List<SchedulePart>)>,
            isMiniature:
                null == isMiniature
                    ? _value.isMiniature
                    : isMiniature // ignore: cast_nullable_to_non_nullable
                        as bool,
            comments:
                null == comments
                    ? _value.comments
                    : comments // ignore: cast_nullable_to_non_nullable
                        as List<LessonComment>,
            showEmptyLessons:
                null == showEmptyLessons
                    ? _value.showEmptyLessons
                    : showEmptyLessons // ignore: cast_nullable_to_non_nullable
                        as bool,
            showCommentsIndicators:
                null == showCommentsIndicators
                    ? _value.showCommentsIndicators
                    : showCommentsIndicators // ignore: cast_nullable_to_non_nullable
                        as bool,
            isListModeEnabled:
                null == isListModeEnabled
                    ? _value.isListModeEnabled
                    : isListModeEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            scheduleComments:
                null == scheduleComments
                    ? _value.scheduleComments
                    : scheduleComments // ignore: cast_nullable_to_non_nullable
                        as List<ScheduleComment>,
            selectedSchedule:
                freezed == selectedSchedule
                    ? _value.selectedSchedule
                    : selectedSchedule // ignore: cast_nullable_to_non_nullable
                        as SelectedSchedule?,
            comparisonSchedules:
                null == comparisonSchedules
                    ? _value.comparisonSchedules
                    : comparisonSchedules // ignore: cast_nullable_to_non_nullable
                        as Set<SelectedSchedule>,
            isComparisonModeEnabled:
                null == isComparisonModeEnabled
                    ? _value.isComparisonModeEnabled
                    : isComparisonModeEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            latestDiff:
                freezed == latestDiff
                    ? _value.latestDiff
                    : latestDiff // ignore: cast_nullable_to_non_nullable
                        as ScheduleDiff?,
            showScheduleDiffDialog:
                null == showScheduleDiffDialog
                    ? _value.showScheduleDiffDialog
                    : showScheduleDiffDialog // ignore: cast_nullable_to_non_nullable
                        as bool,
            isSplitViewEnabled:
                null == isSplitViewEnabled
                    ? _value.isSplitViewEnabled
                    : isSplitViewEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
            showAnalytics:
                null == showAnalytics
                    ? _value.showAnalytics
                    : showAnalytics // ignore: cast_nullable_to_non_nullable
                        as bool,
            customSchedules:
                null == customSchedules
                    ? _value.customSchedules
                    : customSchedules // ignore: cast_nullable_to_non_nullable
                        as List<CustomSchedule>,
            isCustomScheduleModeEnabled:
                null == isCustomScheduleModeEnabled
                    ? _value.isCustomScheduleModeEnabled
                    : isCustomScheduleModeEnabled // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
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
  $Res call({
    @JsonKey(includeFromJson: false, includeToJson: false) ScheduleStatus status,
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
    @JsonKey(includeFromJson: false, includeToJson: false) bool showScheduleDiffDialog,
    @JsonKey(includeFromJson: false, includeToJson: false) bool isSplitViewEnabled,
    @JsonKey(includeFromJson: false, includeToJson: false) bool showAnalytics,
    List<CustomSchedule> customSchedules,
    @JsonKey(includeFromJson: false, includeToJson: false) bool isCustomScheduleModeEnabled,
  });

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
    Object? isSplitViewEnabled = null,
    Object? showAnalytics = null,
    Object? customSchedules = null,
    Object? isCustomScheduleModeEnabled = null,
  }) {
    return _then(
      _$ScheduleStateImpl(
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as ScheduleStatus,
        classroomsSchedule:
            null == classroomsSchedule
                ? _value._classroomsSchedule
                : classroomsSchedule // ignore: cast_nullable_to_non_nullable
                    as List<(String, Classroom, List<SchedulePart>)>,
        teachersSchedule:
            null == teachersSchedule
                ? _value._teachersSchedule
                : teachersSchedule // ignore: cast_nullable_to_non_nullable
                    as List<(String, Teacher, List<SchedulePart>)>,
        groupsSchedule:
            null == groupsSchedule
                ? _value._groupsSchedule
                : groupsSchedule // ignore: cast_nullable_to_non_nullable
                    as List<(String, Group, List<SchedulePart>)>,
        isMiniature:
            null == isMiniature
                ? _value.isMiniature
                : isMiniature // ignore: cast_nullable_to_non_nullable
                    as bool,
        comments:
            null == comments
                ? _value._comments
                : comments // ignore: cast_nullable_to_non_nullable
                    as List<LessonComment>,
        showEmptyLessons:
            null == showEmptyLessons
                ? _value.showEmptyLessons
                : showEmptyLessons // ignore: cast_nullable_to_non_nullable
                    as bool,
        showCommentsIndicators:
            null == showCommentsIndicators
                ? _value.showCommentsIndicators
                : showCommentsIndicators // ignore: cast_nullable_to_non_nullable
                    as bool,
        isListModeEnabled:
            null == isListModeEnabled
                ? _value.isListModeEnabled
                : isListModeEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        scheduleComments:
            null == scheduleComments
                ? _value._scheduleComments
                : scheduleComments // ignore: cast_nullable_to_non_nullable
                    as List<ScheduleComment>,
        selectedSchedule:
            freezed == selectedSchedule
                ? _value.selectedSchedule
                : selectedSchedule // ignore: cast_nullable_to_non_nullable
                    as SelectedSchedule?,
        comparisonSchedules:
            null == comparisonSchedules
                ? _value._comparisonSchedules
                : comparisonSchedules // ignore: cast_nullable_to_non_nullable
                    as Set<SelectedSchedule>,
        isComparisonModeEnabled:
            null == isComparisonModeEnabled
                ? _value.isComparisonModeEnabled
                : isComparisonModeEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        latestDiff:
            freezed == latestDiff
                ? _value.latestDiff
                : latestDiff // ignore: cast_nullable_to_non_nullable
                    as ScheduleDiff?,
        showScheduleDiffDialog:
            null == showScheduleDiffDialog
                ? _value.showScheduleDiffDialog
                : showScheduleDiffDialog // ignore: cast_nullable_to_non_nullable
                    as bool,
        isSplitViewEnabled:
            null == isSplitViewEnabled
                ? _value.isSplitViewEnabled
                : isSplitViewEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
        showAnalytics:
            null == showAnalytics
                ? _value.showAnalytics
                : showAnalytics // ignore: cast_nullable_to_non_nullable
                    as bool,
        customSchedules:
            null == customSchedules
                ? _value._customSchedules
                : customSchedules // ignore: cast_nullable_to_non_nullable
                    as List<CustomSchedule>,
        isCustomScheduleModeEnabled:
            null == isCustomScheduleModeEnabled
                ? _value.isCustomScheduleModeEnabled
                : isCustomScheduleModeEnabled // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleStateImpl extends _ScheduleState {
  const _$ScheduleStateImpl({
    @JsonKey(includeFromJson: false, includeToJson: false) this.status = ScheduleStatus.initial,
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
    @JsonKey(includeFromJson: false, includeToJson: false) this.showScheduleDiffDialog = false,
    @JsonKey(includeFromJson: false, includeToJson: false) this.isSplitViewEnabled = false,
    @JsonKey(includeFromJson: false, includeToJson: false) this.showAnalytics = true,
    final List<CustomSchedule> customSchedules = const [],
    @JsonKey(includeFromJson: false, includeToJson: false) this.isCustomScheduleModeEnabled = false,
  }) : _classroomsSchedule = classroomsSchedule,
       _teachersSchedule = teachersSchedule,
       _groupsSchedule = groupsSchedule,
       _comments = comments,
       _scheduleComments = scheduleComments,
       _comparisonSchedules = comparisonSchedules,
       _customSchedules = customSchedules,
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
  // Desktop mode state properties
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isSplitViewEnabled;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool showAnalytics;
  // Custom schedules
  final List<CustomSchedule> _customSchedules;
  // Custom schedules
  @override
  @JsonKey()
  List<CustomSchedule> get customSchedules {
    if (_customSchedules is EqualUnmodifiableListView) return _customSchedules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customSchedules);
  }

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool isCustomScheduleModeEnabled;

  @override
  String toString() {
    return 'ScheduleState(status: $status, classroomsSchedule: $classroomsSchedule, teachersSchedule: $teachersSchedule, groupsSchedule: $groupsSchedule, isMiniature: $isMiniature, comments: $comments, showEmptyLessons: $showEmptyLessons, showCommentsIndicators: $showCommentsIndicators, isListModeEnabled: $isListModeEnabled, scheduleComments: $scheduleComments, selectedSchedule: $selectedSchedule, comparisonSchedules: $comparisonSchedules, isComparisonModeEnabled: $isComparisonModeEnabled, latestDiff: $latestDiff, showScheduleDiffDialog: $showScheduleDiffDialog, isSplitViewEnabled: $isSplitViewEnabled, showAnalytics: $showAnalytics, customSchedules: $customSchedules, isCustomScheduleModeEnabled: $isCustomScheduleModeEnabled)';
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
                other.showScheduleDiffDialog == showScheduleDiffDialog) &&
            (identical(other.isSplitViewEnabled, isSplitViewEnabled) ||
                other.isSplitViewEnabled == isSplitViewEnabled) &&
            (identical(other.showAnalytics, showAnalytics) || other.showAnalytics == showAnalytics) &&
            const DeepCollectionEquality().equals(other._customSchedules, _customSchedules) &&
            (identical(other.isCustomScheduleModeEnabled, isCustomScheduleModeEnabled) ||
                other.isCustomScheduleModeEnabled == isCustomScheduleModeEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
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
    showScheduleDiffDialog,
    isSplitViewEnabled,
    showAnalytics,
    const DeepCollectionEquality().hash(_customSchedules),
    isCustomScheduleModeEnabled,
  ]);

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleStateImplCopyWith<_$ScheduleStateImpl> get copyWith =>
      __$$ScheduleStateImplCopyWithImpl<_$ScheduleStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleStateImplToJson(this);
  }
}

abstract class _ScheduleState extends ScheduleState {
  const factory _ScheduleState({
    @JsonKey(includeFromJson: false, includeToJson: false) final ScheduleStatus status,
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
    @JsonKey(includeFromJson: false, includeToJson: false) final bool showScheduleDiffDialog,
    @JsonKey(includeFromJson: false, includeToJson: false) final bool isSplitViewEnabled,
    @JsonKey(includeFromJson: false, includeToJson: false) final bool showAnalytics,
    final List<CustomSchedule> customSchedules,
    @JsonKey(includeFromJson: false, includeToJson: false) final bool isCustomScheduleModeEnabled,
  }) = _$ScheduleStateImpl;
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
  bool get showScheduleDiffDialog; // Desktop mode state properties
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isSplitViewEnabled;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get showAnalytics; // Custom schedules
  @override
  List<CustomSchedule> get customSchedules;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isCustomScheduleModeEnabled;

  /// Create a copy of ScheduleState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScheduleStateImplCopyWith<_$ScheduleStateImpl> get copyWith => throw _privateConstructorUsedError;
}
