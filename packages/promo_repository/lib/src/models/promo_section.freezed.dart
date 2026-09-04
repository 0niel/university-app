// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PromoFact {

 String get label; String get value; String? get emoji;
/// Create a copy of PromoFact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoFactCopyWith<PromoFact> get copyWith => _$PromoFactCopyWithImpl<PromoFact>(this as PromoFact, _$identity);

  /// Serializes this PromoFact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoFact&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,value,emoji);

@override
String toString() {
  return 'PromoFact(label: $label, value: $value, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class $PromoFactCopyWith<$Res>  {
  factory $PromoFactCopyWith(PromoFact value, $Res Function(PromoFact) _then) = _$PromoFactCopyWithImpl;
@useResult
$Res call({
 String label, String value, String? emoji
});




}
/// @nodoc
class _$PromoFactCopyWithImpl<$Res>
    implements $PromoFactCopyWith<$Res> {
  _$PromoFactCopyWithImpl(this._self, this._then);

  final PromoFact _self;
  final $Res Function(PromoFact) _then;

/// Create a copy of PromoFact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,Object? emoji = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoFact].
extension PromoFactPatterns on PromoFact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoFact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoFact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoFact value)  $default,){
final _that = this;
switch (_that) {
case _PromoFact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoFact value)?  $default,){
final _that = this;
switch (_that) {
case _PromoFact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String value,  String? emoji)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoFact() when $default != null:
return $default(_that.label,_that.value,_that.emoji);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String value,  String? emoji)  $default,) {final _that = this;
switch (_that) {
case _PromoFact():
return $default(_that.label,_that.value,_that.emoji);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String value,  String? emoji)?  $default,) {final _that = this;
switch (_that) {
case _PromoFact() when $default != null:
return $default(_that.label,_that.value,_that.emoji);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromoFact implements PromoFact {
  const _PromoFact({required this.label, this.value = '', this.emoji});
  factory _PromoFact.fromJson(Map<String, dynamic> json) => _$PromoFactFromJson(json);

@override final  String label;
@override@JsonKey() final  String value;
@override final  String? emoji;

/// Create a copy of PromoFact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoFactCopyWith<_PromoFact> get copyWith => __$PromoFactCopyWithImpl<_PromoFact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoFactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoFact&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.emoji, emoji) || other.emoji == emoji));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,value,emoji);

@override
String toString() {
  return 'PromoFact(label: $label, value: $value, emoji: $emoji)';
}


}

/// @nodoc
abstract mixin class _$PromoFactCopyWith<$Res> implements $PromoFactCopyWith<$Res> {
  factory _$PromoFactCopyWith(_PromoFact value, $Res Function(_PromoFact) _then) = __$PromoFactCopyWithImpl;
@override @useResult
$Res call({
 String label, String value, String? emoji
});




}
/// @nodoc
class __$PromoFactCopyWithImpl<$Res>
    implements _$PromoFactCopyWith<$Res> {
  __$PromoFactCopyWithImpl(this._self, this._then);

  final _PromoFact _self;
  final $Res Function(_PromoFact) _then;

/// Create a copy of PromoFact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? emoji = freezed,}) {
  return _then(_PromoFact(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PromoStep {

 String get title; String get text;
/// Create a copy of PromoStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoStepCopyWith<PromoStep> get copyWith => _$PromoStepCopyWithImpl<PromoStep>(this as PromoStep, _$identity);

  /// Serializes this PromoStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoStep&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,text);

@override
String toString() {
  return 'PromoStep(title: $title, text: $text)';
}


}

/// @nodoc
abstract mixin class $PromoStepCopyWith<$Res>  {
  factory $PromoStepCopyWith(PromoStep value, $Res Function(PromoStep) _then) = _$PromoStepCopyWithImpl;
@useResult
$Res call({
 String title, String text
});




}
/// @nodoc
class _$PromoStepCopyWithImpl<$Res>
    implements $PromoStepCopyWith<$Res> {
  _$PromoStepCopyWithImpl(this._self, this._then);

  final PromoStep _self;
  final $Res Function(PromoStep) _then;

/// Create a copy of PromoStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? text = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoStep].
extension PromoStepPatterns on PromoStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoStep value)  $default,){
final _that = this;
switch (_that) {
case _PromoStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoStep value)?  $default,){
final _that = this;
switch (_that) {
case _PromoStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoStep() when $default != null:
return $default(_that.title,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String text)  $default,) {final _that = this;
switch (_that) {
case _PromoStep():
return $default(_that.title,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String text)?  $default,) {final _that = this;
switch (_that) {
case _PromoStep() when $default != null:
return $default(_that.title,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromoStep implements PromoStep {
  const _PromoStep({required this.title, this.text = ''});
  factory _PromoStep.fromJson(Map<String, dynamic> json) => _$PromoStepFromJson(json);

@override final  String title;
@override@JsonKey() final  String text;

/// Create a copy of PromoStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoStepCopyWith<_PromoStep> get copyWith => __$PromoStepCopyWithImpl<_PromoStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoStep&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,text);

@override
String toString() {
  return 'PromoStep(title: $title, text: $text)';
}


}

/// @nodoc
abstract mixin class _$PromoStepCopyWith<$Res> implements $PromoStepCopyWith<$Res> {
  factory _$PromoStepCopyWith(_PromoStep value, $Res Function(_PromoStep) _then) = __$PromoStepCopyWithImpl;
@override @useResult
$Res call({
 String title, String text
});




}
/// @nodoc
class __$PromoStepCopyWithImpl<$Res>
    implements _$PromoStepCopyWith<$Res> {
  __$PromoStepCopyWithImpl(this._self, this._then);

  final _PromoStep _self;
  final $Res Function(_PromoStep) _then;

/// Create a copy of PromoStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? text = null,}) {
  return _then(_PromoStep(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PromoFaqItem {

@JsonKey(name: 'q') String get question;@JsonKey(name: 'a') String get answer;
/// Create a copy of PromoFaqItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoFaqItemCopyWith<PromoFaqItem> get copyWith => _$PromoFaqItemCopyWithImpl<PromoFaqItem>(this as PromoFaqItem, _$identity);

  /// Serializes this PromoFaqItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoFaqItem&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,answer);

@override
String toString() {
  return 'PromoFaqItem(question: $question, answer: $answer)';
}


}

/// @nodoc
abstract mixin class $PromoFaqItemCopyWith<$Res>  {
  factory $PromoFaqItemCopyWith(PromoFaqItem value, $Res Function(PromoFaqItem) _then) = _$PromoFaqItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'q') String question,@JsonKey(name: 'a') String answer
});




}
/// @nodoc
class _$PromoFaqItemCopyWithImpl<$Res>
    implements $PromoFaqItemCopyWith<$Res> {
  _$PromoFaqItemCopyWithImpl(this._self, this._then);

  final PromoFaqItem _self;
  final $Res Function(PromoFaqItem) _then;

/// Create a copy of PromoFaqItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? question = null,Object? answer = null,}) {
  return _then(_self.copyWith(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoFaqItem].
extension PromoFaqItemPatterns on PromoFaqItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoFaqItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoFaqItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoFaqItem value)  $default,){
final _that = this;
switch (_that) {
case _PromoFaqItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoFaqItem value)?  $default,){
final _that = this;
switch (_that) {
case _PromoFaqItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'q')  String question, @JsonKey(name: 'a')  String answer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoFaqItem() when $default != null:
return $default(_that.question,_that.answer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'q')  String question, @JsonKey(name: 'a')  String answer)  $default,) {final _that = this;
switch (_that) {
case _PromoFaqItem():
return $default(_that.question,_that.answer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'q')  String question, @JsonKey(name: 'a')  String answer)?  $default,) {final _that = this;
switch (_that) {
case _PromoFaqItem() when $default != null:
return $default(_that.question,_that.answer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromoFaqItem implements PromoFaqItem {
  const _PromoFaqItem({@JsonKey(name: 'q') required this.question, @JsonKey(name: 'a') this.answer = ''});
  factory _PromoFaqItem.fromJson(Map<String, dynamic> json) => _$PromoFaqItemFromJson(json);

@override@JsonKey(name: 'q') final  String question;
@override@JsonKey(name: 'a') final  String answer;

/// Create a copy of PromoFaqItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoFaqItemCopyWith<_PromoFaqItem> get copyWith => __$PromoFaqItemCopyWithImpl<_PromoFaqItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoFaqItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoFaqItem&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,answer);

@override
String toString() {
  return 'PromoFaqItem(question: $question, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$PromoFaqItemCopyWith<$Res> implements $PromoFaqItemCopyWith<$Res> {
  factory _$PromoFaqItemCopyWith(_PromoFaqItem value, $Res Function(_PromoFaqItem) _then) = __$PromoFaqItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'q') String question,@JsonKey(name: 'a') String answer
});




}
/// @nodoc
class __$PromoFaqItemCopyWithImpl<$Res>
    implements _$PromoFaqItemCopyWith<$Res> {
  __$PromoFaqItemCopyWithImpl(this._self, this._then);

  final _PromoFaqItem _self;
  final $Res Function(_PromoFaqItem) _then;

/// Create a copy of PromoFaqItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? question = null,Object? answer = null,}) {
  return _then(_PromoFaqItem(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PromoLink {

 String get label; String get url;
/// Create a copy of PromoLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoLinkCopyWith<PromoLink> get copyWith => _$PromoLinkCopyWithImpl<PromoLink>(this as PromoLink, _$identity);

  /// Serializes this PromoLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoLink&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'PromoLink(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class $PromoLinkCopyWith<$Res>  {
  factory $PromoLinkCopyWith(PromoLink value, $Res Function(PromoLink) _then) = _$PromoLinkCopyWithImpl;
@useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class _$PromoLinkCopyWithImpl<$Res>
    implements $PromoLinkCopyWith<$Res> {
  _$PromoLinkCopyWithImpl(this._self, this._then);

  final PromoLink _self;
  final $Res Function(PromoLink) _then;

/// Create a copy of PromoLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? url = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoLink].
extension PromoLinkPatterns on PromoLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoLink value)  $default,){
final _that = this;
switch (_that) {
case _PromoLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoLink value)?  $default,){
final _that = this;
switch (_that) {
case _PromoLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoLink() when $default != null:
return $default(_that.label,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String url)  $default,) {final _that = this;
switch (_that) {
case _PromoLink():
return $default(_that.label,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String url)?  $default,) {final _that = this;
switch (_that) {
case _PromoLink() when $default != null:
return $default(_that.label,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromoLink implements PromoLink {
  const _PromoLink({required this.label, required this.url});
  factory _PromoLink.fromJson(Map<String, dynamic> json) => _$PromoLinkFromJson(json);

@override final  String label;
@override final  String url;

/// Create a copy of PromoLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoLinkCopyWith<_PromoLink> get copyWith => __$PromoLinkCopyWithImpl<_PromoLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoLinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoLink&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'PromoLink(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class _$PromoLinkCopyWith<$Res> implements $PromoLinkCopyWith<$Res> {
  factory _$PromoLinkCopyWith(_PromoLink value, $Res Function(_PromoLink) _then) = __$PromoLinkCopyWithImpl;
@override @useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class __$PromoLinkCopyWithImpl<$Res>
    implements _$PromoLinkCopyWith<$Res> {
  __$PromoLinkCopyWithImpl(this._self, this._then);

  final _PromoLink _self;
  final $Res Function(_PromoLink) _then;

/// Create a copy of PromoLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? url = null,}) {
  return _then(_PromoLink(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

PromoSection _$PromoSectionFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'facts':
          return PromoFactsSection.fromJson(
            json
          );
                case 'steps':
          return PromoStepsSection.fromJson(
            json
          );
                case 'checklist':
          return PromoChecklistSection.fromJson(
            json
          );
                case 'faq':
          return PromoFaqSection.fromJson(
            json
          );
                case 'text':
          return PromoTextSection.fromJson(
            json
          );
                case 'links':
          return PromoLinksSection.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'PromoSection',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$PromoSection {

 String get title;
/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoSectionCopyWith<PromoSection> get copyWith => _$PromoSectionCopyWithImpl<PromoSection>(this as PromoSection, _$identity);

  /// Serializes this PromoSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoSection&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title);

@override
String toString() {
  return 'PromoSection(title: $title)';
}


}

/// @nodoc
abstract mixin class $PromoSectionCopyWith<$Res>  {
  factory $PromoSectionCopyWith(PromoSection value, $Res Function(PromoSection) _then) = _$PromoSectionCopyWithImpl;
@useResult
$Res call({
 String title
});




}
/// @nodoc
class _$PromoSectionCopyWithImpl<$Res>
    implements $PromoSectionCopyWith<$Res> {
  _$PromoSectionCopyWithImpl(this._self, this._then);

  final PromoSection _self;
  final $Res Function(PromoSection) _then;

/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoSection].
extension PromoSectionPatterns on PromoSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PromoFactsSection value)?  facts,TResult Function( PromoStepsSection value)?  steps,TResult Function( PromoChecklistSection value)?  checklist,TResult Function( PromoFaqSection value)?  faq,TResult Function( PromoTextSection value)?  text,TResult Function( PromoLinksSection value)?  links,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PromoFactsSection() when facts != null:
return facts(_that);case PromoStepsSection() when steps != null:
return steps(_that);case PromoChecklistSection() when checklist != null:
return checklist(_that);case PromoFaqSection() when faq != null:
return faq(_that);case PromoTextSection() when text != null:
return text(_that);case PromoLinksSection() when links != null:
return links(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PromoFactsSection value)  facts,required TResult Function( PromoStepsSection value)  steps,required TResult Function( PromoChecklistSection value)  checklist,required TResult Function( PromoFaqSection value)  faq,required TResult Function( PromoTextSection value)  text,required TResult Function( PromoLinksSection value)  links,}){
final _that = this;
switch (_that) {
case PromoFactsSection():
return facts(_that);case PromoStepsSection():
return steps(_that);case PromoChecklistSection():
return checklist(_that);case PromoFaqSection():
return faq(_that);case PromoTextSection():
return text(_that);case PromoLinksSection():
return links(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PromoFactsSection value)?  facts,TResult? Function( PromoStepsSection value)?  steps,TResult? Function( PromoChecklistSection value)?  checklist,TResult? Function( PromoFaqSection value)?  faq,TResult? Function( PromoTextSection value)?  text,TResult? Function( PromoLinksSection value)?  links,}){
final _that = this;
switch (_that) {
case PromoFactsSection() when facts != null:
return facts(_that);case PromoStepsSection() when steps != null:
return steps(_that);case PromoChecklistSection() when checklist != null:
return checklist(_that);case PromoFaqSection() when faq != null:
return faq(_that);case PromoTextSection() when text != null:
return text(_that);case PromoLinksSection() when links != null:
return links(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String title,  List<PromoFact> items)?  facts,TResult Function( String title,  List<PromoStep> items)?  steps,TResult Function( String title,  List<String> items)?  checklist,TResult Function( String title,  List<PromoFaqItem> items)?  faq,TResult Function( String title,  String body)?  text,TResult Function( String title,  List<PromoLink> items)?  links,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PromoFactsSection() when facts != null:
return facts(_that.title,_that.items);case PromoStepsSection() when steps != null:
return steps(_that.title,_that.items);case PromoChecklistSection() when checklist != null:
return checklist(_that.title,_that.items);case PromoFaqSection() when faq != null:
return faq(_that.title,_that.items);case PromoTextSection() when text != null:
return text(_that.title,_that.body);case PromoLinksSection() when links != null:
return links(_that.title,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String title,  List<PromoFact> items)  facts,required TResult Function( String title,  List<PromoStep> items)  steps,required TResult Function( String title,  List<String> items)  checklist,required TResult Function( String title,  List<PromoFaqItem> items)  faq,required TResult Function( String title,  String body)  text,required TResult Function( String title,  List<PromoLink> items)  links,}) {final _that = this;
switch (_that) {
case PromoFactsSection():
return facts(_that.title,_that.items);case PromoStepsSection():
return steps(_that.title,_that.items);case PromoChecklistSection():
return checklist(_that.title,_that.items);case PromoFaqSection():
return faq(_that.title,_that.items);case PromoTextSection():
return text(_that.title,_that.body);case PromoLinksSection():
return links(_that.title,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String title,  List<PromoFact> items)?  facts,TResult? Function( String title,  List<PromoStep> items)?  steps,TResult? Function( String title,  List<String> items)?  checklist,TResult? Function( String title,  List<PromoFaqItem> items)?  faq,TResult? Function( String title,  String body)?  text,TResult? Function( String title,  List<PromoLink> items)?  links,}) {final _that = this;
switch (_that) {
case PromoFactsSection() when facts != null:
return facts(_that.title,_that.items);case PromoStepsSection() when steps != null:
return steps(_that.title,_that.items);case PromoChecklistSection() when checklist != null:
return checklist(_that.title,_that.items);case PromoFaqSection() when faq != null:
return faq(_that.title,_that.items);case PromoTextSection() when text != null:
return text(_that.title,_that.body);case PromoLinksSection() when links != null:
return links(_that.title,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class PromoFactsSection extends PromoSection {
  const PromoFactsSection({this.title = '', final  List<PromoFact> items = const <PromoFact>[], final  String? $type}): _items = items,$type = $type ?? 'facts',super._();
  factory PromoFactsSection.fromJson(Map<String, dynamic> json) => _$PromoFactsSectionFromJson(json);

@override@JsonKey() final  String title;
 final  List<PromoFact> _items;
@JsonKey() List<PromoFact> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoFactsSectionCopyWith<PromoFactsSection> get copyWith => _$PromoFactsSectionCopyWithImpl<PromoFactsSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoFactsSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoFactsSection&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PromoSection.facts(title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class $PromoFactsSectionCopyWith<$Res> implements $PromoSectionCopyWith<$Res> {
  factory $PromoFactsSectionCopyWith(PromoFactsSection value, $Res Function(PromoFactsSection) _then) = _$PromoFactsSectionCopyWithImpl;
@override @useResult
$Res call({
 String title, List<PromoFact> items
});




}
/// @nodoc
class _$PromoFactsSectionCopyWithImpl<$Res>
    implements $PromoFactsSectionCopyWith<$Res> {
  _$PromoFactsSectionCopyWithImpl(this._self, this._then);

  final PromoFactsSection _self;
  final $Res Function(PromoFactsSection) _then;

/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? items = null,}) {
  return _then(PromoFactsSection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PromoFact>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PromoStepsSection extends PromoSection {
  const PromoStepsSection({this.title = '', final  List<PromoStep> items = const <PromoStep>[], final  String? $type}): _items = items,$type = $type ?? 'steps',super._();
  factory PromoStepsSection.fromJson(Map<String, dynamic> json) => _$PromoStepsSectionFromJson(json);

@override@JsonKey() final  String title;
 final  List<PromoStep> _items;
@JsonKey() List<PromoStep> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoStepsSectionCopyWith<PromoStepsSection> get copyWith => _$PromoStepsSectionCopyWithImpl<PromoStepsSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoStepsSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoStepsSection&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PromoSection.steps(title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class $PromoStepsSectionCopyWith<$Res> implements $PromoSectionCopyWith<$Res> {
  factory $PromoStepsSectionCopyWith(PromoStepsSection value, $Res Function(PromoStepsSection) _then) = _$PromoStepsSectionCopyWithImpl;
@override @useResult
$Res call({
 String title, List<PromoStep> items
});




}
/// @nodoc
class _$PromoStepsSectionCopyWithImpl<$Res>
    implements $PromoStepsSectionCopyWith<$Res> {
  _$PromoStepsSectionCopyWithImpl(this._self, this._then);

  final PromoStepsSection _self;
  final $Res Function(PromoStepsSection) _then;

/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? items = null,}) {
  return _then(PromoStepsSection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PromoStep>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PromoChecklistSection extends PromoSection {
  const PromoChecklistSection({this.title = '', final  List<String> items = const <String>[], final  String? $type}): _items = items,$type = $type ?? 'checklist',super._();
  factory PromoChecklistSection.fromJson(Map<String, dynamic> json) => _$PromoChecklistSectionFromJson(json);

@override@JsonKey() final  String title;
 final  List<String> _items;
@JsonKey() List<String> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoChecklistSectionCopyWith<PromoChecklistSection> get copyWith => _$PromoChecklistSectionCopyWithImpl<PromoChecklistSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoChecklistSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoChecklistSection&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PromoSection.checklist(title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class $PromoChecklistSectionCopyWith<$Res> implements $PromoSectionCopyWith<$Res> {
  factory $PromoChecklistSectionCopyWith(PromoChecklistSection value, $Res Function(PromoChecklistSection) _then) = _$PromoChecklistSectionCopyWithImpl;
@override @useResult
$Res call({
 String title, List<String> items
});




}
/// @nodoc
class _$PromoChecklistSectionCopyWithImpl<$Res>
    implements $PromoChecklistSectionCopyWith<$Res> {
  _$PromoChecklistSectionCopyWithImpl(this._self, this._then);

  final PromoChecklistSection _self;
  final $Res Function(PromoChecklistSection) _then;

/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? items = null,}) {
  return _then(PromoChecklistSection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PromoFaqSection extends PromoSection {
  const PromoFaqSection({this.title = '', final  List<PromoFaqItem> items = const <PromoFaqItem>[], final  String? $type}): _items = items,$type = $type ?? 'faq',super._();
  factory PromoFaqSection.fromJson(Map<String, dynamic> json) => _$PromoFaqSectionFromJson(json);

@override@JsonKey() final  String title;
 final  List<PromoFaqItem> _items;
@JsonKey() List<PromoFaqItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoFaqSectionCopyWith<PromoFaqSection> get copyWith => _$PromoFaqSectionCopyWithImpl<PromoFaqSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoFaqSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoFaqSection&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PromoSection.faq(title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class $PromoFaqSectionCopyWith<$Res> implements $PromoSectionCopyWith<$Res> {
  factory $PromoFaqSectionCopyWith(PromoFaqSection value, $Res Function(PromoFaqSection) _then) = _$PromoFaqSectionCopyWithImpl;
@override @useResult
$Res call({
 String title, List<PromoFaqItem> items
});




}
/// @nodoc
class _$PromoFaqSectionCopyWithImpl<$Res>
    implements $PromoFaqSectionCopyWith<$Res> {
  _$PromoFaqSectionCopyWithImpl(this._self, this._then);

  final PromoFaqSection _self;
  final $Res Function(PromoFaqSection) _then;

/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? items = null,}) {
  return _then(PromoFaqSection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PromoFaqItem>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PromoTextSection extends PromoSection {
  const PromoTextSection({this.title = '', this.body = '', final  String? $type}): $type = $type ?? 'text',super._();
  factory PromoTextSection.fromJson(Map<String, dynamic> json) => _$PromoTextSectionFromJson(json);

@override@JsonKey() final  String title;
@JsonKey() final  String body;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoTextSectionCopyWith<PromoTextSection> get copyWith => _$PromoTextSectionCopyWithImpl<PromoTextSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoTextSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoTextSection&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,body);

@override
String toString() {
  return 'PromoSection.text(title: $title, body: $body)';
}


}

/// @nodoc
abstract mixin class $PromoTextSectionCopyWith<$Res> implements $PromoSectionCopyWith<$Res> {
  factory $PromoTextSectionCopyWith(PromoTextSection value, $Res Function(PromoTextSection) _then) = _$PromoTextSectionCopyWithImpl;
@override @useResult
$Res call({
 String title, String body
});




}
/// @nodoc
class _$PromoTextSectionCopyWithImpl<$Res>
    implements $PromoTextSectionCopyWith<$Res> {
  _$PromoTextSectionCopyWithImpl(this._self, this._then);

  final PromoTextSection _self;
  final $Res Function(PromoTextSection) _then;

/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? body = null,}) {
  return _then(PromoTextSection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PromoLinksSection extends PromoSection {
  const PromoLinksSection({this.title = '', final  List<PromoLink> items = const <PromoLink>[], final  String? $type}): _items = items,$type = $type ?? 'links',super._();
  factory PromoLinksSection.fromJson(Map<String, dynamic> json) => _$PromoLinksSectionFromJson(json);

@override@JsonKey() final  String title;
 final  List<PromoLink> _items;
@JsonKey() List<PromoLink> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


@JsonKey(name: 'type')
final String $type;


/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoLinksSectionCopyWith<PromoLinksSection> get copyWith => _$PromoLinksSectionCopyWithImpl<PromoLinksSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoLinksSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoLinksSection&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PromoSection.links(title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class $PromoLinksSectionCopyWith<$Res> implements $PromoSectionCopyWith<$Res> {
  factory $PromoLinksSectionCopyWith(PromoLinksSection value, $Res Function(PromoLinksSection) _then) = _$PromoLinksSectionCopyWithImpl;
@override @useResult
$Res call({
 String title, List<PromoLink> items
});




}
/// @nodoc
class _$PromoLinksSectionCopyWithImpl<$Res>
    implements $PromoLinksSectionCopyWith<$Res> {
  _$PromoLinksSectionCopyWithImpl(this._self, this._then);

  final PromoLinksSection _self;
  final $Res Function(PromoLinksSection) _then;

/// Create a copy of PromoSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? items = null,}) {
  return _then(PromoLinksSection(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PromoLink>,
  ));
}


}

// dart format on
