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

@JsonKey(defaultValue: '') String get id;@JsonKey(defaultValue: '') String get title; String get description; String? get category; String? get authorId; String? get authorName; bool get isAnonymous;@JsonKey(fromJson: _visibilityFromJson, toJson: _visibilityToJson) PollResultsVisibility get resultsVisibility;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get expiresAt;@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? get createdAt; bool get isClosed; bool get allowChange; bool get isMine; int get participantsCount; bool get iParticipated; bool get canSeeResults;@JsonKey(fromJson: _questionsFromJson, toJson: _questionsToJson) List<PollQuestion> get questions;
/// Create a copy of Poll
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollCopyWith<Poll> get copyWith => _$PollCopyWithImpl<Poll>(this as Poll, _$identity);

  /// Serializes this Poll to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Poll&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.resultsVisibility, resultsVisibility) || other.resultsVisibility == resultsVisibility)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.allowChange, allowChange) || other.allowChange == allowChange)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.participantsCount, participantsCount) || other.participantsCount == participantsCount)&&(identical(other.iParticipated, iParticipated) || other.iParticipated == iParticipated)&&(identical(other.canSeeResults, canSeeResults) || other.canSeeResults == canSeeResults)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,authorId,authorName,isAnonymous,resultsVisibility,expiresAt,createdAt,isClosed,allowChange,isMine,participantsCount,iParticipated,canSeeResults,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'Poll(id: $id, title: $title, description: $description, category: $category, authorId: $authorId, authorName: $authorName, isAnonymous: $isAnonymous, resultsVisibility: $resultsVisibility, expiresAt: $expiresAt, createdAt: $createdAt, isClosed: $isClosed, allowChange: $allowChange, isMine: $isMine, participantsCount: $participantsCount, iParticipated: $iParticipated, canSeeResults: $canSeeResults, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $PollCopyWith<$Res>  {
  factory $PollCopyWith(Poll value, $Res Function(Poll) _then) = _$PollCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title, String description, String? category, String? authorId, String? authorName, bool isAnonymous,@JsonKey(fromJson: _visibilityFromJson, toJson: _visibilityToJson) PollResultsVisibility resultsVisibility,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? expiresAt,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isClosed, bool allowChange, bool isMine, int participantsCount, bool iParticipated, bool canSeeResults,@JsonKey(fromJson: _questionsFromJson, toJson: _questionsToJson) List<PollQuestion> questions
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? category = freezed,Object? authorId = freezed,Object? authorName = freezed,Object? isAnonymous = null,Object? resultsVisibility = null,Object? expiresAt = freezed,Object? createdAt = freezed,Object? isClosed = null,Object? allowChange = null,Object? isMine = null,Object? participantsCount = null,Object? iParticipated = null,Object? canSeeResults = null,Object? questions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,resultsVisibility: null == resultsVisibility ? _self.resultsVisibility : resultsVisibility // ignore: cast_nullable_to_non_nullable
as PollResultsVisibility,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,allowChange: null == allowChange ? _self.allowChange : allowChange // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,participantsCount: null == participantsCount ? _self.participantsCount : participantsCount // ignore: cast_nullable_to_non_nullable
as int,iParticipated: null == iParticipated ? _self.iParticipated : iParticipated // ignore: cast_nullable_to_non_nullable
as bool,canSeeResults: null == canSeeResults ? _self.canSeeResults : canSeeResults // ignore: cast_nullable_to_non_nullable
as bool,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<PollQuestion>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String description,  String? category,  String? authorId,  String? authorName,  bool isAnonymous, @JsonKey(fromJson: _visibilityFromJson, toJson: _visibilityToJson)  PollResultsVisibility resultsVisibility, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? expiresAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isClosed,  bool allowChange,  bool isMine,  int participantsCount,  bool iParticipated,  bool canSeeResults, @JsonKey(fromJson: _questionsFromJson, toJson: _questionsToJson)  List<PollQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Poll() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.authorId,_that.authorName,_that.isAnonymous,_that.resultsVisibility,_that.expiresAt,_that.createdAt,_that.isClosed,_that.allowChange,_that.isMine,_that.participantsCount,_that.iParticipated,_that.canSeeResults,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String description,  String? category,  String? authorId,  String? authorName,  bool isAnonymous, @JsonKey(fromJson: _visibilityFromJson, toJson: _visibilityToJson)  PollResultsVisibility resultsVisibility, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? expiresAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isClosed,  bool allowChange,  bool isMine,  int participantsCount,  bool iParticipated,  bool canSeeResults, @JsonKey(fromJson: _questionsFromJson, toJson: _questionsToJson)  List<PollQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _Poll():
return $default(_that.id,_that.title,_that.description,_that.category,_that.authorId,_that.authorName,_that.isAnonymous,_that.resultsVisibility,_that.expiresAt,_that.createdAt,_that.isClosed,_that.allowChange,_that.isMine,_that.participantsCount,_that.iParticipated,_that.canSeeResults,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(defaultValue: '')  String title,  String description,  String? category,  String? authorId,  String? authorName,  bool isAnonymous, @JsonKey(fromJson: _visibilityFromJson, toJson: _visibilityToJson)  PollResultsVisibility resultsVisibility, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? expiresAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)  DateTime? createdAt,  bool isClosed,  bool allowChange,  bool isMine,  int participantsCount,  bool iParticipated,  bool canSeeResults, @JsonKey(fromJson: _questionsFromJson, toJson: _questionsToJson)  List<PollQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _Poll() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.authorId,_that.authorName,_that.isAnonymous,_that.resultsVisibility,_that.expiresAt,_that.createdAt,_that.isClosed,_that.allowChange,_that.isMine,_that.participantsCount,_that.iParticipated,_that.canSeeResults,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Poll extends Poll {
  const _Poll({@JsonKey(defaultValue: '') required this.id, @JsonKey(defaultValue: '') required this.title, this.description = '', this.category, this.authorId, this.authorName, this.isAnonymous = false, @JsonKey(fromJson: _visibilityFromJson, toJson: _visibilityToJson) this.resultsVisibility = PollResultsVisibility.always, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.expiresAt, @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) this.createdAt, this.isClosed = false, this.allowChange = false, this.isMine = false, this.participantsCount = 0, this.iParticipated = false, this.canSeeResults = false, @JsonKey(fromJson: _questionsFromJson, toJson: _questionsToJson) final  List<PollQuestion> questions = const <PollQuestion>[]}): _questions = questions,super._();
  factory _Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(defaultValue: '') final  String title;
@override@JsonKey() final  String description;
@override final  String? category;
@override final  String? authorId;
@override final  String? authorName;
@override@JsonKey() final  bool isAnonymous;
@override@JsonKey(fromJson: _visibilityFromJson, toJson: _visibilityToJson) final  PollResultsVisibility resultsVisibility;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? expiresAt;
@override@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) final  DateTime? createdAt;
@override@JsonKey() final  bool isClosed;
@override@JsonKey() final  bool allowChange;
@override@JsonKey() final  bool isMine;
@override@JsonKey() final  int participantsCount;
@override@JsonKey() final  bool iParticipated;
@override@JsonKey() final  bool canSeeResults;
 final  List<PollQuestion> _questions;
@override@JsonKey(fromJson: _questionsFromJson, toJson: _questionsToJson) List<PollQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Poll&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.isAnonymous, isAnonymous) || other.isAnonymous == isAnonymous)&&(identical(other.resultsVisibility, resultsVisibility) || other.resultsVisibility == resultsVisibility)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isClosed, isClosed) || other.isClosed == isClosed)&&(identical(other.allowChange, allowChange) || other.allowChange == allowChange)&&(identical(other.isMine, isMine) || other.isMine == isMine)&&(identical(other.participantsCount, participantsCount) || other.participantsCount == participantsCount)&&(identical(other.iParticipated, iParticipated) || other.iParticipated == iParticipated)&&(identical(other.canSeeResults, canSeeResults) || other.canSeeResults == canSeeResults)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,authorId,authorName,isAnonymous,resultsVisibility,expiresAt,createdAt,isClosed,allowChange,isMine,participantsCount,iParticipated,canSeeResults,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'Poll(id: $id, title: $title, description: $description, category: $category, authorId: $authorId, authorName: $authorName, isAnonymous: $isAnonymous, resultsVisibility: $resultsVisibility, expiresAt: $expiresAt, createdAt: $createdAt, isClosed: $isClosed, allowChange: $allowChange, isMine: $isMine, participantsCount: $participantsCount, iParticipated: $iParticipated, canSeeResults: $canSeeResults, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$PollCopyWith<$Res> implements $PollCopyWith<$Res> {
  factory _$PollCopyWith(_Poll value, $Res Function(_Poll) _then) = __$PollCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(defaultValue: '') String title, String description, String? category, String? authorId, String? authorName, bool isAnonymous,@JsonKey(fromJson: _visibilityFromJson, toJson: _visibilityToJson) PollResultsVisibility resultsVisibility,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? expiresAt,@JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson) DateTime? createdAt, bool isClosed, bool allowChange, bool isMine, int participantsCount, bool iParticipated, bool canSeeResults,@JsonKey(fromJson: _questionsFromJson, toJson: _questionsToJson) List<PollQuestion> questions
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? category = freezed,Object? authorId = freezed,Object? authorName = freezed,Object? isAnonymous = null,Object? resultsVisibility = null,Object? expiresAt = freezed,Object? createdAt = freezed,Object? isClosed = null,Object? allowChange = null,Object? isMine = null,Object? participantsCount = null,Object? iParticipated = null,Object? canSeeResults = null,Object? questions = null,}) {
  return _then(_Poll(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,isAnonymous: null == isAnonymous ? _self.isAnonymous : isAnonymous // ignore: cast_nullable_to_non_nullable
as bool,resultsVisibility: null == resultsVisibility ? _self.resultsVisibility : resultsVisibility // ignore: cast_nullable_to_non_nullable
as PollResultsVisibility,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,allowChange: null == allowChange ? _self.allowChange : allowChange // ignore: cast_nullable_to_non_nullable
as bool,isMine: null == isMine ? _self.isMine : isMine // ignore: cast_nullable_to_non_nullable
as bool,participantsCount: null == participantsCount ? _self.participantsCount : participantsCount // ignore: cast_nullable_to_non_nullable
as int,iParticipated: null == iParticipated ? _self.iParticipated : iParticipated // ignore: cast_nullable_to_non_nullable
as bool,canSeeResults: null == canSeeResults ? _self.canSeeResults : canSeeResults // ignore: cast_nullable_to_non_nullable
as bool,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<PollQuestion>,
  ));
}


}


/// @nodoc
mixin _$PollQuestion {

@JsonKey(defaultValue: '') String get id; int get position;@JsonKey(defaultValue: '') String get text;@JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) PollQuestionKind get kind; bool get isRequired;@JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson) List<PollOption> get options;@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get myOptionIds; String? get myTextAnswer; int? get myRating; double? get ratingAverage; int get ratingCount;@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get textAnswers;
/// Create a copy of PollQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollQuestionCopyWith<PollQuestion> get copyWith => _$PollQuestionCopyWithImpl<PollQuestion>(this as PollQuestion, _$identity);

  /// Serializes this PollQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.text, text) || other.text == text)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other.options, options)&&const DeepCollectionEquality().equals(other.myOptionIds, myOptionIds)&&(identical(other.myTextAnswer, myTextAnswer) || other.myTextAnswer == myTextAnswer)&&(identical(other.myRating, myRating) || other.myRating == myRating)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&const DeepCollectionEquality().equals(other.textAnswers, textAnswers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,position,text,kind,isRequired,const DeepCollectionEquality().hash(options),const DeepCollectionEquality().hash(myOptionIds),myTextAnswer,myRating,ratingAverage,ratingCount,const DeepCollectionEquality().hash(textAnswers));

@override
String toString() {
  return 'PollQuestion(id: $id, position: $position, text: $text, kind: $kind, isRequired: $isRequired, options: $options, myOptionIds: $myOptionIds, myTextAnswer: $myTextAnswer, myRating: $myRating, ratingAverage: $ratingAverage, ratingCount: $ratingCount, textAnswers: $textAnswers)';
}


}

/// @nodoc
abstract mixin class $PollQuestionCopyWith<$Res>  {
  factory $PollQuestionCopyWith(PollQuestion value, $Res Function(PollQuestion) _then) = _$PollQuestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id, int position,@JsonKey(defaultValue: '') String text,@JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) PollQuestionKind kind, bool isRequired,@JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson) List<PollOption> options,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> myOptionIds, String? myTextAnswer, int? myRating, double? ratingAverage, int ratingCount,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> textAnswers
});




}
/// @nodoc
class _$PollQuestionCopyWithImpl<$Res>
    implements $PollQuestionCopyWith<$Res> {
  _$PollQuestionCopyWithImpl(this._self, this._then);

  final PollQuestion _self;
  final $Res Function(PollQuestion) _then;

/// Create a copy of PollQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? position = null,Object? text = null,Object? kind = null,Object? isRequired = null,Object? options = null,Object? myOptionIds = null,Object? myTextAnswer = freezed,Object? myRating = freezed,Object? ratingAverage = freezed,Object? ratingCount = null,Object? textAnswers = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PollQuestionKind,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<PollOption>,myOptionIds: null == myOptionIds ? _self.myOptionIds : myOptionIds // ignore: cast_nullable_to_non_nullable
as List<String>,myTextAnswer: freezed == myTextAnswer ? _self.myTextAnswer : myTextAnswer // ignore: cast_nullable_to_non_nullable
as String?,myRating: freezed == myRating ? _self.myRating : myRating // ignore: cast_nullable_to_non_nullable
as int?,ratingAverage: freezed == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,textAnswers: null == textAnswers ? _self.textAnswers : textAnswers // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PollQuestion].
extension PollQuestionPatterns on PollQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollQuestion value)  $default,){
final _that = this;
switch (_that) {
case _PollQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _PollQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id,  int position, @JsonKey(defaultValue: '')  String text, @JsonKey(fromJson: _kindFromJson, toJson: _kindToJson)  PollQuestionKind kind,  bool isRequired, @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson)  List<PollOption> options, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> myOptionIds,  String? myTextAnswer,  int? myRating,  double? ratingAverage,  int ratingCount, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> textAnswers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollQuestion() when $default != null:
return $default(_that.id,_that.position,_that.text,_that.kind,_that.isRequired,_that.options,_that.myOptionIds,_that.myTextAnswer,_that.myRating,_that.ratingAverage,_that.ratingCount,_that.textAnswers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id,  int position, @JsonKey(defaultValue: '')  String text, @JsonKey(fromJson: _kindFromJson, toJson: _kindToJson)  PollQuestionKind kind,  bool isRequired, @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson)  List<PollOption> options, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> myOptionIds,  String? myTextAnswer,  int? myRating,  double? ratingAverage,  int ratingCount, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> textAnswers)  $default,) {final _that = this;
switch (_that) {
case _PollQuestion():
return $default(_that.id,_that.position,_that.text,_that.kind,_that.isRequired,_that.options,_that.myOptionIds,_that.myTextAnswer,_that.myRating,_that.ratingAverage,_that.ratingCount,_that.textAnswers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id,  int position, @JsonKey(defaultValue: '')  String text, @JsonKey(fromJson: _kindFromJson, toJson: _kindToJson)  PollQuestionKind kind,  bool isRequired, @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson)  List<PollOption> options, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> myOptionIds,  String? myTextAnswer,  int? myRating,  double? ratingAverage,  int ratingCount, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson)  List<String> textAnswers)?  $default,) {final _that = this;
switch (_that) {
case _PollQuestion() when $default != null:
return $default(_that.id,_that.position,_that.text,_that.kind,_that.isRequired,_that.options,_that.myOptionIds,_that.myTextAnswer,_that.myRating,_that.ratingAverage,_that.ratingCount,_that.textAnswers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PollQuestion extends PollQuestion {
  const _PollQuestion({@JsonKey(defaultValue: '') required this.id, this.position = 0, @JsonKey(defaultValue: '') required this.text, @JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) required this.kind, this.isRequired = true, @JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson) final  List<PollOption> options = const <PollOption>[], @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) final  List<String> myOptionIds = const <String>[], this.myTextAnswer, this.myRating, this.ratingAverage, this.ratingCount = 0, @JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) final  List<String> textAnswers = const <String>[]}): _options = options,_myOptionIds = myOptionIds,_textAnswers = textAnswers,super._();
  factory _PollQuestion.fromJson(Map<String, dynamic> json) => _$PollQuestionFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey() final  int position;
@override@JsonKey(defaultValue: '') final  String text;
@override@JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) final  PollQuestionKind kind;
@override@JsonKey() final  bool isRequired;
 final  List<PollOption> _options;
@override@JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson) List<PollOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

 final  List<String> _myOptionIds;
@override@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get myOptionIds {
  if (_myOptionIds is EqualUnmodifiableListView) return _myOptionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_myOptionIds);
}

@override final  String? myTextAnswer;
@override final  int? myRating;
@override final  double? ratingAverage;
@override@JsonKey() final  int ratingCount;
 final  List<String> _textAnswers;
@override@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> get textAnswers {
  if (_textAnswers is EqualUnmodifiableListView) return _textAnswers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_textAnswers);
}


/// Create a copy of PollQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollQuestionCopyWith<_PollQuestion> get copyWith => __$PollQuestionCopyWithImpl<_PollQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PollQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.position, position) || other.position == position)&&(identical(other.text, text) || other.text == text)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other._options, _options)&&const DeepCollectionEquality().equals(other._myOptionIds, _myOptionIds)&&(identical(other.myTextAnswer, myTextAnswer) || other.myTextAnswer == myTextAnswer)&&(identical(other.myRating, myRating) || other.myRating == myRating)&&(identical(other.ratingAverage, ratingAverage) || other.ratingAverage == ratingAverage)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&const DeepCollectionEquality().equals(other._textAnswers, _textAnswers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,position,text,kind,isRequired,const DeepCollectionEquality().hash(_options),const DeepCollectionEquality().hash(_myOptionIds),myTextAnswer,myRating,ratingAverage,ratingCount,const DeepCollectionEquality().hash(_textAnswers));

@override
String toString() {
  return 'PollQuestion(id: $id, position: $position, text: $text, kind: $kind, isRequired: $isRequired, options: $options, myOptionIds: $myOptionIds, myTextAnswer: $myTextAnswer, myRating: $myRating, ratingAverage: $ratingAverage, ratingCount: $ratingCount, textAnswers: $textAnswers)';
}


}

/// @nodoc
abstract mixin class _$PollQuestionCopyWith<$Res> implements $PollQuestionCopyWith<$Res> {
  factory _$PollQuestionCopyWith(_PollQuestion value, $Res Function(_PollQuestion) _then) = __$PollQuestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id, int position,@JsonKey(defaultValue: '') String text,@JsonKey(fromJson: _kindFromJson, toJson: _kindToJson) PollQuestionKind kind, bool isRequired,@JsonKey(fromJson: _optionsFromJson, toJson: _optionsToJson) List<PollOption> options,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> myOptionIds, String? myTextAnswer, int? myRating, double? ratingAverage, int ratingCount,@JsonKey(fromJson: stringListFromJson, toJson: stringListToJson) List<String> textAnswers
});




}
/// @nodoc
class __$PollQuestionCopyWithImpl<$Res>
    implements _$PollQuestionCopyWith<$Res> {
  __$PollQuestionCopyWithImpl(this._self, this._then);

  final _PollQuestion _self;
  final $Res Function(_PollQuestion) _then;

/// Create a copy of PollQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? position = null,Object? text = null,Object? kind = null,Object? isRequired = null,Object? options = null,Object? myOptionIds = null,Object? myTextAnswer = freezed,Object? myRating = freezed,Object? ratingAverage = freezed,Object? ratingCount = null,Object? textAnswers = null,}) {
  return _then(_PollQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PollQuestionKind,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<PollOption>,myOptionIds: null == myOptionIds ? _self._myOptionIds : myOptionIds // ignore: cast_nullable_to_non_nullable
as List<String>,myTextAnswer: freezed == myTextAnswer ? _self.myTextAnswer : myTextAnswer // ignore: cast_nullable_to_non_nullable
as String?,myRating: freezed == myRating ? _self.myRating : myRating // ignore: cast_nullable_to_non_nullable
as int?,ratingAverage: freezed == ratingAverage ? _self.ratingAverage : ratingAverage // ignore: cast_nullable_to_non_nullable
as double?,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,textAnswers: null == textAnswers ? _self._textAnswers : textAnswers // ignore: cast_nullable_to_non_nullable
as List<String>,
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

/// @nodoc
mixin _$PollAnswer {

 String get questionId; List<String> get optionIds; String? get text; int? get rating;
/// Create a copy of PollAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollAnswerCopyWith<PollAnswer> get copyWith => _$PollAnswerCopyWithImpl<PollAnswer>(this as PollAnswer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&const DeepCollectionEquality().equals(other.optionIds, optionIds)&&(identical(other.text, text) || other.text == text)&&(identical(other.rating, rating) || other.rating == rating));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,const DeepCollectionEquality().hash(optionIds),text,rating);

@override
String toString() {
  return 'PollAnswer(questionId: $questionId, optionIds: $optionIds, text: $text, rating: $rating)';
}


}

/// @nodoc
abstract mixin class $PollAnswerCopyWith<$Res>  {
  factory $PollAnswerCopyWith(PollAnswer value, $Res Function(PollAnswer) _then) = _$PollAnswerCopyWithImpl;
@useResult
$Res call({
 String questionId, List<String> optionIds, String? text, int? rating
});




}
/// @nodoc
class _$PollAnswerCopyWithImpl<$Res>
    implements $PollAnswerCopyWith<$Res> {
  _$PollAnswerCopyWithImpl(this._self, this._then);

  final PollAnswer _self;
  final $Res Function(PollAnswer) _then;

/// Create a copy of PollAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? optionIds = null,Object? text = freezed,Object? rating = freezed,}) {
  return _then(_self.copyWith(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,optionIds: null == optionIds ? _self.optionIds : optionIds // ignore: cast_nullable_to_non_nullable
as List<String>,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PollAnswer].
extension PollAnswerPatterns on PollAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollAnswer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollAnswer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollAnswer value)  $default,){
final _that = this;
switch (_that) {
case _PollAnswer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollAnswer value)?  $default,){
final _that = this;
switch (_that) {
case _PollAnswer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questionId,  List<String> optionIds,  String? text,  int? rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollAnswer() when $default != null:
return $default(_that.questionId,_that.optionIds,_that.text,_that.rating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String questionId,  List<String> optionIds,  String? text,  int? rating)  $default,) {final _that = this;
switch (_that) {
case _PollAnswer():
return $default(_that.questionId,_that.optionIds,_that.text,_that.rating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String questionId,  List<String> optionIds,  String? text,  int? rating)?  $default,) {final _that = this;
switch (_that) {
case _PollAnswer() when $default != null:
return $default(_that.questionId,_that.optionIds,_that.text,_that.rating);case _:
  return null;

}
}

}

/// @nodoc


class _PollAnswer extends PollAnswer {
  const _PollAnswer({required this.questionId, final  List<String> optionIds = const <String>[], this.text, this.rating}): _optionIds = optionIds,super._();


@override final  String questionId;
 final  List<String> _optionIds;
@override@JsonKey() List<String> get optionIds {
  if (_optionIds is EqualUnmodifiableListView) return _optionIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_optionIds);
}

@override final  String? text;
@override final  int? rating;

/// Create a copy of PollAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollAnswerCopyWith<_PollAnswer> get copyWith => __$PollAnswerCopyWithImpl<_PollAnswer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&const DeepCollectionEquality().equals(other._optionIds, _optionIds)&&(identical(other.text, text) || other.text == text)&&(identical(other.rating, rating) || other.rating == rating));
}


@override
int get hashCode => Object.hash(runtimeType,questionId,const DeepCollectionEquality().hash(_optionIds),text,rating);

@override
String toString() {
  return 'PollAnswer(questionId: $questionId, optionIds: $optionIds, text: $text, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$PollAnswerCopyWith<$Res> implements $PollAnswerCopyWith<$Res> {
  factory _$PollAnswerCopyWith(_PollAnswer value, $Res Function(_PollAnswer) _then) = __$PollAnswerCopyWithImpl;
@override @useResult
$Res call({
 String questionId, List<String> optionIds, String? text, int? rating
});




}
/// @nodoc
class __$PollAnswerCopyWithImpl<$Res>
    implements _$PollAnswerCopyWith<$Res> {
  __$PollAnswerCopyWithImpl(this._self, this._then);

  final _PollAnswer _self;
  final $Res Function(_PollAnswer) _then;

/// Create a copy of PollAnswer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? optionIds = null,Object? text = freezed,Object? rating = freezed,}) {
  return _then(_PollAnswer(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,optionIds: null == optionIds ? _self._optionIds : optionIds // ignore: cast_nullable_to_non_nullable
as List<String>,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$PollQuestionDraft {

 String get text; PollQuestionKind get kind; bool get isRequired; List<String> get options; int? get correctIndex;
/// Create a copy of PollQuestionDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PollQuestionDraftCopyWith<PollQuestionDraft> get copyWith => _$PollQuestionDraftCopyWithImpl<PollQuestionDraft>(this as PollQuestionDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PollQuestionDraft&&(identical(other.text, text) || other.text == text)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}


@override
int get hashCode => Object.hash(runtimeType,text,kind,isRequired,const DeepCollectionEquality().hash(options),correctIndex);

@override
String toString() {
  return 'PollQuestionDraft(text: $text, kind: $kind, isRequired: $isRequired, options: $options, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class $PollQuestionDraftCopyWith<$Res>  {
  factory $PollQuestionDraftCopyWith(PollQuestionDraft value, $Res Function(PollQuestionDraft) _then) = _$PollQuestionDraftCopyWithImpl;
@useResult
$Res call({
 String text, PollQuestionKind kind, bool isRequired, List<String> options, int? correctIndex
});




}
/// @nodoc
class _$PollQuestionDraftCopyWithImpl<$Res>
    implements $PollQuestionDraftCopyWith<$Res> {
  _$PollQuestionDraftCopyWithImpl(this._self, this._then);

  final PollQuestionDraft _self;
  final $Res Function(PollQuestionDraft) _then;

/// Create a copy of PollQuestionDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? kind = null,Object? isRequired = null,Object? options = null,Object? correctIndex = freezed,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PollQuestionKind,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: freezed == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PollQuestionDraft].
extension PollQuestionDraftPatterns on PollQuestionDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PollQuestionDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PollQuestionDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PollQuestionDraft value)  $default,){
final _that = this;
switch (_that) {
case _PollQuestionDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PollQuestionDraft value)?  $default,){
final _that = this;
switch (_that) {
case _PollQuestionDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  PollQuestionKind kind,  bool isRequired,  List<String> options,  int? correctIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PollQuestionDraft() when $default != null:
return $default(_that.text,_that.kind,_that.isRequired,_that.options,_that.correctIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  PollQuestionKind kind,  bool isRequired,  List<String> options,  int? correctIndex)  $default,) {final _that = this;
switch (_that) {
case _PollQuestionDraft():
return $default(_that.text,_that.kind,_that.isRequired,_that.options,_that.correctIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  PollQuestionKind kind,  bool isRequired,  List<String> options,  int? correctIndex)?  $default,) {final _that = this;
switch (_that) {
case _PollQuestionDraft() when $default != null:
return $default(_that.text,_that.kind,_that.isRequired,_that.options,_that.correctIndex);case _:
  return null;

}
}

}

/// @nodoc


class _PollQuestionDraft extends PollQuestionDraft {
  const _PollQuestionDraft({required this.text, required this.kind, this.isRequired = true, final  List<String> options = const <String>[], this.correctIndex}): _options = options,super._();


@override final  String text;
@override final  PollQuestionKind kind;
@override@JsonKey() final  bool isRequired;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  int? correctIndex;

/// Create a copy of PollQuestionDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PollQuestionDraftCopyWith<_PollQuestionDraft> get copyWith => __$PollQuestionDraftCopyWithImpl<_PollQuestionDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PollQuestionDraft&&(identical(other.text, text) || other.text == text)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}


@override
int get hashCode => Object.hash(runtimeType,text,kind,isRequired,const DeepCollectionEquality().hash(_options),correctIndex);

@override
String toString() {
  return 'PollQuestionDraft(text: $text, kind: $kind, isRequired: $isRequired, options: $options, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class _$PollQuestionDraftCopyWith<$Res> implements $PollQuestionDraftCopyWith<$Res> {
  factory _$PollQuestionDraftCopyWith(_PollQuestionDraft value, $Res Function(_PollQuestionDraft) _then) = __$PollQuestionDraftCopyWithImpl;
@override @useResult
$Res call({
 String text, PollQuestionKind kind, bool isRequired, List<String> options, int? correctIndex
});




}
/// @nodoc
class __$PollQuestionDraftCopyWithImpl<$Res>
    implements _$PollQuestionDraftCopyWith<$Res> {
  __$PollQuestionDraftCopyWithImpl(this._self, this._then);

  final _PollQuestionDraft _self;
  final $Res Function(_PollQuestionDraft) _then;

/// Create a copy of PollQuestionDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? kind = null,Object? isRequired = null,Object? options = null,Object? correctIndex = freezed,}) {
  return _then(_PollQuestionDraft(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PollQuestionKind,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: freezed == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
