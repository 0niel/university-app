// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Poll {

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get question;@JsonKey(fromJson: _pollTypeFromJson, toJson: _pollTypeToJson) PollType get pollType;@JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson) List<PollOption> get options; String? get authorId; bool get isAnonymous; bool get showResults; bool get isMine; int get totalVotes;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get expiresAt;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt;
/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollCopyWith<Poll> get copyWith => _$PollCopyWithImpl<Poll>(this as Poll, _$identity);

  /// Serializes this Poll to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Poll&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.pollType, pollType) || other.pollType == pollType)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.showResults, showResults) || other.showResults == showResults)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.totalVotes, totalVotes) || other.totalVotes == totalVotes)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,pollType,const DeepCollectionEquality().hash(options),authorId,isAnonymous,showResults,isMine,totalVotes,expiresAt,createdAt);

@override
String toString() {
  return 'Poll(id: $id, question: $question, pollType: $pollType, options: $options, authorId: $authorId, isAnonymous: $isAnonymous, showResults: $showResults, isMine: $isMine, totalVotes: $totalVotes, expiresAt: $expiresAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PollCopyWith<$Res>  {
  factory $PollCopyWith(Poll value, $Res Function(Poll) _then) = _$PollCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String question,@JsonKey(fromJson: _pollTypeFromJson, toJson: _pollTypeToJson) PollType pollType,@JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson) List<PollOption> options, String? authorId, bool isAnonymous, bool showResults, bool isMine, int totalVotes,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? expiresAt,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class _$PollCopyWithImpl<$Res>
    implements $PollCopyWith<$Res> {
  _$PollCopyWithImpl(this._self, this._then);

  final Poll _self;
  final $Res Function(Poll) _then;

/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? question = null,Object? pollType = null,Object? options = null,Object? authorId = freezed,Object? isAnonymous = null,Object? showResults = null,Object? isMine = null,Object? totalVotes = null,Object? expiresAt = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,pollType: null == pollType ? _self.pollType : pollType // ignore: cast_nullable_to_non_nullable
as PollType,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<PollOption>,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,showResults: null == showResults ? _self.showResults : showResults // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,totalVotes: null == totalVotes ? _self.totalVotes : totalVotes // ignore: cast_nullable_to_non_nullable
as int,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Poll].
extension PollPatterns on Poll {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Poll value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Poll() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Poll value)  $default,){
final _that = this;
switch (_that) {
case _Poll():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Poll value)?  $default,){
final _that = this;
switch (_that) {
case _Poll() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String question, @JsonKey(fromJson: _pollTypeFromJson, toJson: _pollTypeToJson)  PollType pollType, @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson)  List<PollOption> options,  String? authorId,  bool isAnonymous,  bool showResults,  bool isMine,  int totalVotes, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? expiresAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Poll() when $default != null:
return $default(_that.id,_that.question,_that.pollType,_that.options,_that.authorId,_that.isAnonymous,_that.showResults,_that.isMine,_that.totalVotes,_that.expiresAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String question, @JsonKey(fromJson: _pollTypeFromJson, toJson: _pollTypeToJson)  PollType pollType, @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson)  List<PollOption> options,  String? authorId,  bool isAnonymous,  bool showResults,  bool isMine,  int totalVotes, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? expiresAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Poll():
return $default(_that.id,_that.question,_that.pollType,_that.options,_that.authorId,_that.isAnonymous,_that.showResults,_that.isMine,_that.totalVotes,_that.expiresAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String question, @JsonKey(fromJson: _pollTypeFromJson, toJson: _pollTypeToJson)  PollType pollType, @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson)  List<PollOption> options,  String? authorId,  bool isAnonymous,  bool showResults,  bool isMine,  int totalVotes, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? expiresAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Poll() when $default != null:
return $default(_that.id,_that.question,_that.pollType,_that.options,_that.authorId,_that.isAnonymous,_that.showResults,_that.isMine,_that.totalVotes,_that.expiresAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Poll extends Poll {
  const _Poll({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.question, @JsonKey(fromJson: _pollTypeFromJson, toJson: _pollTypeToJson) required this.pollType, @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson) required final  List<PollOption> options, this.authorId, this.isAnonymous = false, this.showResults = true, this.isMine = false, this.totalVotes = 0, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.expiresAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt}): _options = options,super._();
  factory _Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String question;
@override@JsonKey(fromJson: _pollTypeFromJson, toJson: _pollTypeToJson) final  PollType pollType;
 final  List<PollOption> _options;
@override@JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson) List<PollOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  String? authorId;
@override@JsonKey() final  bool isAnonymous;
@override@JsonKey() final  bool showResults;
@override@JsonKey() final  bool isMine;
@override@JsonKey() final  int totalVotes;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? expiresAt;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;

/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollCopyWith<_Poll> get copyWith => __$PollCopyWithImpl<_Poll>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Poll&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&(identical(other.pollType, pollType) || other.pollType == pollType)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.showResults, showResults) || other.showResults == showResults)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.totalVotes, totalVotes) || other.totalVotes == totalVotes)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,pollType,const DeepCollectionEquality().hash(_options),authorId,isAnonymous,showResults,isMine,totalVotes,expiresAt,createdAt);

@override
String toString() {
  return 'Poll(id: $id, question: $question, pollType: $pollType, options: $options, authorId: $authorId, isAnonymous: $isAnonymous, showResults: $showResults, isMine: $isMine, totalVotes: $totalVotes, expiresAt: $expiresAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PollCopyWith<$Res> implements $PollCopyWith<$Res> {
  factory _$PollCopyWith(_Poll value, $Res Function(_Poll) _then) = __$PollCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String question,@JsonKey(fromJson: _pollTypeFromJson, toJson: _pollTypeToJson) PollType pollType,@JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson) List<PollOption> options, String? authorId, bool isAnonymous, bool showResults, bool isMine, int totalVotes,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? expiresAt,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class __$PollCopyWithImpl<$Res>
    implements _$PollCopyWith<$Res> {
  __$PollCopyWithImpl(this._self, this._then);

  final _Poll _self;
  final $Res Function(_Poll) _then;

/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? pollType = null,Object? options = null,Object? authorId = freezed,Object? isAnonymous = null,Object? showResults = null,Object? isMine = null,Object? totalVotes = null,Object? expiresAt = freezed,Object? createdAt = freezed,}) {
  return _then(_Poll(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,pollType: null == pollType ? _self.pollType : pollType // ignore: cast_nullable_to_non_nullable
as PollType,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<PollOption>,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,showResults: null == showResults ? _self.showResults : showResults // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,totalVotes: null == totalVotes ? _self.totalVotes : totalVotes // ignore: cast_nullable_to_non_nullable
as int,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PollOption {

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get text; int get position; bool get isCorrect; int get votes; bool get votedByMe;
/// Create a copy of PollOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollOptionCopyWith<PollOption> get copyWith => _$PollOptionCopyWithImpl<PollOption>(this as PollOption, _$identity);

  /// Serializes this PollOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollOption&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.position, position) || other.position == position)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.votes, votes) || other.votes == votes)&&(identical(other.votedByMe, votedByMe) || other.votedByMe == votedByMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,position,isCorrect,votes,votedByMe);

@override
String toString() {
  return 'PollOption(id: $id, text: $text, position: $position, isCorrect: $isCorrect, votes: $votes, votedByMe: $votedByMe)';
}


}

/// @nodoc
abstract mixin class $PollOptionCopyWith<$Res>  {
  factory $PollOptionCopyWith(PollOption value, $Res Function(PollOption) _then) = _$PollOptionCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String text, int position, bool isCorrect, int votes, bool votedByMe
});




}
/// @nodoc
class _$PollOptionCopyWithImpl<$Res>
    implements $PollOptionCopyWith<$Res> {
  _$PollOptionCopyWithImpl(this._self, this._then);

  final PollOption _self;
  final $Res Function(PollOption) _then;

/// Create a copy of PollOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? position = null,Object? isCorrect = null,Object? votes = null,Object? votedByMe = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,votedByMe: null == votedByMe ? _self.votedByMe : votedByMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PollOption].
extension PollOptionPatterns on PollOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollOption value)  $default,){
final _that = this;
switch (_that) {
case _PollOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollOption value)?  $default,){
final _that = this;
switch (_that) {
case _PollOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String text,  int position,  bool isCorrect,  int votes,  bool votedByMe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollOption() when $default != null:
return $default(_that.id,_that.text,_that.position,_that.isCorrect,_that.votes,_that.votedByMe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String text,  int position,  bool isCorrect,  int votes,  bool votedByMe)  $default,) {final _that = this;
switch (_that) {
case _PollOption():
return $default(_that.id,_that.text,_that.position,_that.isCorrect,_that.votes,_that.votedByMe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String text,  int position,  bool isCorrect,  int votes,  bool votedByMe)?  $default,) {final _that = this;
switch (_that) {
case _PollOption() when $default != null:
return $default(_that.id,_that.text,_that.position,_that.isCorrect,_that.votes,_that.votedByMe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollOption extends PollOption {
  const _PollOption({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.text, this.position = 0, this.isCorrect = false, this.votes = 0, this.votedByMe = false}): super._();
  factory _PollOption.fromJson(Map<String, dynamic> json) => _$PollOptionFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String text;
@override@JsonKey() final  int position;
@override@JsonKey() final  bool isCorrect;
@override@JsonKey() final  int votes;
@override@JsonKey() final  bool votedByMe;

/// Create a copy of PollOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollOptionCopyWith<_PollOption> get copyWith => __$PollOptionCopyWithImpl<_PollOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollOption&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.position, position) || other.position == position)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.votes, votes) || other.votes == votes)&&(identical(other.votedByMe, votedByMe) || other.votedByMe == votedByMe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,position,isCorrect,votes,votedByMe);

@override
String toString() {
  return 'PollOption(id: $id, text: $text, position: $position, isCorrect: $isCorrect, votes: $votes, votedByMe: $votedByMe)';
}


}

/// @nodoc
abstract mixin class _$PollOptionCopyWith<$Res> implements $PollOptionCopyWith<$Res> {
  factory _$PollOptionCopyWith(_PollOption value, $Res Function(_PollOption) _then) = __$PollOptionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String text, int position, bool isCorrect, int votes, bool votedByMe
});




}
/// @nodoc
class __$PollOptionCopyWithImpl<$Res>
    implements _$PollOptionCopyWith<$Res> {
  __$PollOptionCopyWithImpl(this._self, this._then);

  final _PollOption _self;
  final $Res Function(_PollOption) _then;

/// Create a copy of PollOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? position = null,Object? isCorrect = null,Object? votes = null,Object? votedByMe = null,}) {
  return _then(_PollOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,votes: null == votes ? _self.votes : votes // ignore: cast_nullable_to_non_nullable
as int,votedByMe: null == votedByMe ? _self.votedByMe : votedByMe // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
