// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collab_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollabNote {

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get title; String get content; String get updatedByName; bool get isMine; bool get isPersonal; int get revision; int get documentRevision; List<Object?>? get document;@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get collaboratorNames;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get updatedAt;
/// Create a copy of CollabNote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollabNoteCopyWith<CollabNote> get copyWith => _$CollabNoteCopyWithImpl<CollabNote>(this as CollabNote, _$identity);

  /// Serializes this CollabNote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollabNote&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.updatedByName, updatedByName) || other.updatedByName == updatedByName)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.isPersonal, isPersonal) || other.isPersonal == isPersonal)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.documentRevision, documentRevision) || other.documentRevision == documentRevision)&&const DeepCollectionEquality().equals(other.document, document)&&const DeepCollectionEquality().equals(other.collaboratorNames, collaboratorNames)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,updatedByName,isMine,isPersonal,revision,documentRevision,const DeepCollectionEquality().hash(document),const DeepCollectionEquality().hash(collaboratorNames),createdAt,updatedAt);

@override
String toString() {
  return 'CollabNote(id: $id, title: $title, content: $content, updatedByName: $updatedByName, isMine: $isMine, isPersonal: $isPersonal, revision: $revision, documentRevision: $documentRevision, document: $document, collaboratorNames: $collaboratorNames, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CollabNoteCopyWith<$Res>  {
  factory $CollabNoteCopyWith(CollabNote value, $Res Function(CollabNote) _then) = _$CollabNoteCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title, String content, String updatedByName, bool isMine, bool isPersonal, int revision, int documentRevision, List<Object?>? document,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> collaboratorNames,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class _$CollabNoteCopyWithImpl<$Res>
    implements $CollabNoteCopyWith<$Res> {
  _$CollabNoteCopyWithImpl(this._self, this._then);

  final CollabNote _self;
  final $Res Function(CollabNote) _then;

/// Create a copy of CollabNote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? content = null,Object? updatedByName = null,Object? isMine = null,Object? isPersonal = null,Object? revision = null,Object? documentRevision = null,Object? document = freezed,Object? collaboratorNames = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,updatedByName: null == updatedByName ? _self.updatedByName : updatedByName // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,isPersonal: null == isPersonal ? _self.isPersonal : isPersonal // ignore: cast_nullable_to_non_nullable
as bool,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,documentRevision: null == documentRevision ? _self.documentRevision : documentRevision // ignore: cast_nullable_to_non_nullable
as int,document: freezed == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as List<Object?>?,collaboratorNames: null == collaboratorNames ? _self.collaboratorNames : collaboratorNames // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollabNote].
extension CollabNotePatterns on CollabNote {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollabNote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollabNote() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollabNote value)  $default,){
final _that = this;
switch (_that) {
case _CollabNote():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollabNote value)?  $default,){
final _that = this;
switch (_that) {
case _CollabNote() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String content,  String updatedByName,  bool isMine,  bool isPersonal,  int revision,  int documentRevision,  List<Object?>? document, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> collaboratorNames, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollabNote() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.updatedByName,_that.isMine,_that.isPersonal,_that.revision,_that.documentRevision,_that.document,_that.collaboratorNames,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String content,  String updatedByName,  bool isMine,  bool isPersonal,  int revision,  int documentRevision,  List<Object?>? document, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> collaboratorNames, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CollabNote():
return $default(_that.id,_that.title,_that.content,_that.updatedByName,_that.isMine,_that.isPersonal,_that.revision,_that.documentRevision,_that.document,_that.collaboratorNames,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String content,  String updatedByName,  bool isMine,  bool isPersonal,  int revision,  int documentRevision,  List<Object?>? document, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> collaboratorNames, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CollabNote() when $default != null:
return $default(_that.id,_that.title,_that.content,_that.updatedByName,_that.isMine,_that.isPersonal,_that.revision,_that.documentRevision,_that.document,_that.collaboratorNames,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollabNote implements CollabNote {
  const _CollabNote({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.title, this.content = '', this.updatedByName = '', this.isMine = false, this.isPersonal = false, this.revision = 0, this.documentRevision = 0, final  List<Object?>? document, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) final  List<String> collaboratorNames = const <String>[], @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.updatedAt}): _document = document,_collaboratorNames = collaboratorNames;
  factory _CollabNote.fromJson(Map<String, dynamic> json) => _$CollabNoteFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String title;
@override@JsonKey() final  String content;
@override@JsonKey() final  String updatedByName;
@override@JsonKey() final  bool isMine;
@override@JsonKey() final  bool isPersonal;
@override@JsonKey() final  int revision;
@override@JsonKey() final  int documentRevision;
 final  List<Object?>? _document;
@override List<Object?>? get document {
  final value = _document;
  if (value == null) return null;
  if (_document is EqualUnmodifiableListView) return _document;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String> _collaboratorNames;
@override@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get collaboratorNames {
  if (_collaboratorNames is EqualUnmodifiableListView) return _collaboratorNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_collaboratorNames);
}

@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? updatedAt;

/// Create a copy of CollabNote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollabNoteCopyWith<_CollabNote> get copyWith => __$CollabNoteCopyWithImpl<_CollabNote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollabNoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollabNote&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.updatedByName, updatedByName) || other.updatedByName == updatedByName)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.isPersonal, isPersonal) || other.isPersonal == isPersonal)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.documentRevision, documentRevision) || other.documentRevision == documentRevision)&&const DeepCollectionEquality().equals(other._document, _document)&&const DeepCollectionEquality().equals(other._collaboratorNames, _collaboratorNames)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,content,updatedByName,isMine,isPersonal,revision,documentRevision,const DeepCollectionEquality().hash(_document),const DeepCollectionEquality().hash(_collaboratorNames),createdAt,updatedAt);

@override
String toString() {
  return 'CollabNote(id: $id, title: $title, content: $content, updatedByName: $updatedByName, isMine: $isMine, isPersonal: $isPersonal, revision: $revision, documentRevision: $documentRevision, document: $document, collaboratorNames: $collaboratorNames, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CollabNoteCopyWith<$Res> implements $CollabNoteCopyWith<$Res> {
  factory _$CollabNoteCopyWith(_CollabNote value, $Res Function(_CollabNote) _then) = __$CollabNoteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title, String content, String updatedByName, bool isMine, bool isPersonal, int revision, int documentRevision, List<Object?>? document,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> collaboratorNames,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class __$CollabNoteCopyWithImpl<$Res>
    implements _$CollabNoteCopyWith<$Res> {
  __$CollabNoteCopyWithImpl(this._self, this._then);

  final _CollabNote _self;
  final $Res Function(_CollabNote) _then;

/// Create a copy of CollabNote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? content = null,Object? updatedByName = null,Object? isMine = null,Object? isPersonal = null,Object? revision = null,Object? documentRevision = null,Object? document = freezed,Object? collaboratorNames = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_CollabNote(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,updatedByName: null == updatedByName ? _self.updatedByName : updatedByName // ignore: cast_nullable_to_non_nullable
as String,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,isPersonal: null == isPersonal ? _self.isPersonal : isPersonal // ignore: cast_nullable_to_non_nullable
as bool,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,documentRevision: null == documentRevision ? _self.documentRevision : documentRevision // ignore: cast_nullable_to_non_nullable
as int,document: freezed == document ? _self._document : document // ignore: cast_nullable_to_non_nullable
as List<Object?>?,collaboratorNames: null == collaboratorNames ? _self._collaboratorNames : collaboratorNames // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
