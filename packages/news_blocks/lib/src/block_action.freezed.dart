// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'block_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NavigateToArticleAction {

 String get articleId; String get type;@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType get actionType;
/// Create a copy of NavigateToArticleAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigateToArticleActionCopyWith<NavigateToArticleAction> get copyWith => _$NavigateToArticleActionCopyWithImpl<NavigateToArticleAction>(this as NavigateToArticleAction, _$identity);

  /// Serializes this NavigateToArticleAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigateToArticleAction&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.actionType, actionType) || other.actionType == actionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,type,actionType);

@override
String toString() {
  return 'NavigateToArticleAction(articleId: $articleId, type: $type, actionType: $actionType)';
}


}

/// @nodoc
abstract mixin class $NavigateToArticleActionCopyWith<$Res>  {
  factory $NavigateToArticleActionCopyWith(NavigateToArticleAction value, $Res Function(NavigateToArticleAction) _then) = _$NavigateToArticleActionCopyWithImpl;
@useResult
$Res call({
 String articleId, String type,@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType actionType
});




}
/// @nodoc
class _$NavigateToArticleActionCopyWithImpl<$Res>
    implements $NavigateToArticleActionCopyWith<$Res> {
  _$NavigateToArticleActionCopyWithImpl(this._self, this._then);

  final NavigateToArticleAction _self;
  final $Res Function(NavigateToArticleAction) _then;

/// Create a copy of NavigateToArticleAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleId = null,Object? type = null,Object? actionType = null,}) {
  return _then(_self.copyWith(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BlockActionType,
  ));
}

}


/// Adds pattern-matching-related methods to [NavigateToArticleAction].
extension NavigateToArticleActionPatterns on NavigateToArticleAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavigateToArticleAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavigateToArticleAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavigateToArticleAction value)  $default,){
final _that = this;
switch (_that) {
case _NavigateToArticleAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavigateToArticleAction value)?  $default,){
final _that = this;
switch (_that) {
case _NavigateToArticleAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String articleId,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavigateToArticleAction() when $default != null:
return $default(_that.articleId,_that.type,_that.actionType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String articleId,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)  $default,) {final _that = this;
switch (_that) {
case _NavigateToArticleAction():
return $default(_that.articleId,_that.type,_that.actionType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String articleId,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)?  $default,) {final _that = this;
switch (_that) {
case _NavigateToArticleAction() when $default != null:
return $default(_that.articleId,_that.type,_that.actionType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavigateToArticleAction implements NavigateToArticleAction {
  const _NavigateToArticleAction({required this.articleId, this.type = NavigateToArticleAction.identifier, @JsonKey(includeFromJson: false, includeToJson: false) this.actionType = BlockActionType.navigation});
  factory _NavigateToArticleAction.fromJson(Map<String, dynamic> json) => _$NavigateToArticleActionFromJson(json);

@override final  String articleId;
@override@JsonKey() final  String type;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  BlockActionType actionType;

/// Create a copy of NavigateToArticleAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavigateToArticleActionCopyWith<_NavigateToArticleAction> get copyWith => __$NavigateToArticleActionCopyWithImpl<_NavigateToArticleAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavigateToArticleActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToArticleAction&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.actionType, actionType) || other.actionType == actionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,type,actionType);

@override
String toString() {
  return 'NavigateToArticleAction(articleId: $articleId, type: $type, actionType: $actionType)';
}


}

/// @nodoc
abstract mixin class _$NavigateToArticleActionCopyWith<$Res> implements $NavigateToArticleActionCopyWith<$Res> {
  factory _$NavigateToArticleActionCopyWith(_NavigateToArticleAction value, $Res Function(_NavigateToArticleAction) _then) = __$NavigateToArticleActionCopyWithImpl;
@override @useResult
$Res call({
 String articleId, String type,@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType actionType
});




}
/// @nodoc
class __$NavigateToArticleActionCopyWithImpl<$Res>
    implements _$NavigateToArticleActionCopyWith<$Res> {
  __$NavigateToArticleActionCopyWithImpl(this._self, this._then);

  final _NavigateToArticleAction _self;
  final $Res Function(_NavigateToArticleAction) _then;

/// Create a copy of NavigateToArticleAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleId = null,Object? type = null,Object? actionType = null,}) {
  return _then(_NavigateToArticleAction(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BlockActionType,
  ));
}


}


/// @nodoc
mixin _$NavigateToVideoArticleAction {

 String get articleId; String get type;@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType get actionType;
/// Create a copy of NavigateToVideoArticleAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigateToVideoArticleActionCopyWith<NavigateToVideoArticleAction> get copyWith => _$NavigateToVideoArticleActionCopyWithImpl<NavigateToVideoArticleAction>(this as NavigateToVideoArticleAction, _$identity);

  /// Serializes this NavigateToVideoArticleAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigateToVideoArticleAction&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.actionType, actionType) || other.actionType == actionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,type,actionType);

@override
String toString() {
  return 'NavigateToVideoArticleAction(articleId: $articleId, type: $type, actionType: $actionType)';
}


}

/// @nodoc
abstract mixin class $NavigateToVideoArticleActionCopyWith<$Res>  {
  factory $NavigateToVideoArticleActionCopyWith(NavigateToVideoArticleAction value, $Res Function(NavigateToVideoArticleAction) _then) = _$NavigateToVideoArticleActionCopyWithImpl;
@useResult
$Res call({
 String articleId, String type,@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType actionType
});




}
/// @nodoc
class _$NavigateToVideoArticleActionCopyWithImpl<$Res>
    implements $NavigateToVideoArticleActionCopyWith<$Res> {
  _$NavigateToVideoArticleActionCopyWithImpl(this._self, this._then);

  final NavigateToVideoArticleAction _self;
  final $Res Function(NavigateToVideoArticleAction) _then;

/// Create a copy of NavigateToVideoArticleAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleId = null,Object? type = null,Object? actionType = null,}) {
  return _then(_self.copyWith(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BlockActionType,
  ));
}

}


/// Adds pattern-matching-related methods to [NavigateToVideoArticleAction].
extension NavigateToVideoArticleActionPatterns on NavigateToVideoArticleAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavigateToVideoArticleAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavigateToVideoArticleAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavigateToVideoArticleAction value)  $default,){
final _that = this;
switch (_that) {
case _NavigateToVideoArticleAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavigateToVideoArticleAction value)?  $default,){
final _that = this;
switch (_that) {
case _NavigateToVideoArticleAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String articleId,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavigateToVideoArticleAction() when $default != null:
return $default(_that.articleId,_that.type,_that.actionType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String articleId,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)  $default,) {final _that = this;
switch (_that) {
case _NavigateToVideoArticleAction():
return $default(_that.articleId,_that.type,_that.actionType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String articleId,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)?  $default,) {final _that = this;
switch (_that) {
case _NavigateToVideoArticleAction() when $default != null:
return $default(_that.articleId,_that.type,_that.actionType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavigateToVideoArticleAction implements NavigateToVideoArticleAction {
  const _NavigateToVideoArticleAction({required this.articleId, this.type = NavigateToVideoArticleAction.identifier, @JsonKey(includeFromJson: false, includeToJson: false) this.actionType = BlockActionType.navigation});
  factory _NavigateToVideoArticleAction.fromJson(Map<String, dynamic> json) => _$NavigateToVideoArticleActionFromJson(json);

@override final  String articleId;
@override@JsonKey() final  String type;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  BlockActionType actionType;

/// Create a copy of NavigateToVideoArticleAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavigateToVideoArticleActionCopyWith<_NavigateToVideoArticleAction> get copyWith => __$NavigateToVideoArticleActionCopyWithImpl<_NavigateToVideoArticleAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavigateToVideoArticleActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToVideoArticleAction&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.actionType, actionType) || other.actionType == actionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,type,actionType);

@override
String toString() {
  return 'NavigateToVideoArticleAction(articleId: $articleId, type: $type, actionType: $actionType)';
}


}

/// @nodoc
abstract mixin class _$NavigateToVideoArticleActionCopyWith<$Res> implements $NavigateToVideoArticleActionCopyWith<$Res> {
  factory _$NavigateToVideoArticleActionCopyWith(_NavigateToVideoArticleAction value, $Res Function(_NavigateToVideoArticleAction) _then) = __$NavigateToVideoArticleActionCopyWithImpl;
@override @useResult
$Res call({
 String articleId, String type,@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType actionType
});




}
/// @nodoc
class __$NavigateToVideoArticleActionCopyWithImpl<$Res>
    implements _$NavigateToVideoArticleActionCopyWith<$Res> {
  __$NavigateToVideoArticleActionCopyWithImpl(this._self, this._then);

  final _NavigateToVideoArticleAction _self;
  final $Res Function(_NavigateToVideoArticleAction) _then;

/// Create a copy of NavigateToVideoArticleAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleId = null,Object? type = null,Object? actionType = null,}) {
  return _then(_NavigateToVideoArticleAction(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BlockActionType,
  ));
}


}


/// @nodoc
mixin _$NavigateToFeedCategoryAction {

 Category get category; String get type;@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType get actionType;
/// Create a copy of NavigateToFeedCategoryAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigateToFeedCategoryActionCopyWith<NavigateToFeedCategoryAction> get copyWith => _$NavigateToFeedCategoryActionCopyWithImpl<NavigateToFeedCategoryAction>(this as NavigateToFeedCategoryAction, _$identity);

  /// Serializes this NavigateToFeedCategoryAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigateToFeedCategoryAction&&(identical(other.category, category) || other.category == category)&&(identical(other.type, type) || other.type == type)&&(identical(other.actionType, actionType) || other.actionType == actionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,type,actionType);

@override
String toString() {
  return 'NavigateToFeedCategoryAction(category: $category, type: $type, actionType: $actionType)';
}


}

/// @nodoc
abstract mixin class $NavigateToFeedCategoryActionCopyWith<$Res>  {
  factory $NavigateToFeedCategoryActionCopyWith(NavigateToFeedCategoryAction value, $Res Function(NavigateToFeedCategoryAction) _then) = _$NavigateToFeedCategoryActionCopyWithImpl;
@useResult
$Res call({
 Category category, String type,@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType actionType
});


$CategoryCopyWith<$Res> get category;

}
/// @nodoc
class _$NavigateToFeedCategoryActionCopyWithImpl<$Res>
    implements $NavigateToFeedCategoryActionCopyWith<$Res> {
  _$NavigateToFeedCategoryActionCopyWithImpl(this._self, this._then);

  final NavigateToFeedCategoryAction _self;
  final $Res Function(NavigateToFeedCategoryAction) _then;

/// Create a copy of NavigateToFeedCategoryAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? type = null,Object? actionType = null,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BlockActionType,
  ));
}
/// Create a copy of NavigateToFeedCategoryAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {

  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [NavigateToFeedCategoryAction].
extension NavigateToFeedCategoryActionPatterns on NavigateToFeedCategoryAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavigateToFeedCategoryAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavigateToFeedCategoryAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavigateToFeedCategoryAction value)  $default,){
final _that = this;
switch (_that) {
case _NavigateToFeedCategoryAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavigateToFeedCategoryAction value)?  $default,){
final _that = this;
switch (_that) {
case _NavigateToFeedCategoryAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Category category,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavigateToFeedCategoryAction() when $default != null:
return $default(_that.category,_that.type,_that.actionType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Category category,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)  $default,) {final _that = this;
switch (_that) {
case _NavigateToFeedCategoryAction():
return $default(_that.category,_that.type,_that.actionType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Category category,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)?  $default,) {final _that = this;
switch (_that) {
case _NavigateToFeedCategoryAction() when $default != null:
return $default(_that.category,_that.type,_that.actionType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavigateToFeedCategoryAction implements NavigateToFeedCategoryAction {
  const _NavigateToFeedCategoryAction({required this.category, this.type = NavigateToFeedCategoryAction.identifier, @JsonKey(includeFromJson: false, includeToJson: false) this.actionType = BlockActionType.navigation});
  factory _NavigateToFeedCategoryAction.fromJson(Map<String, dynamic> json) => _$NavigateToFeedCategoryActionFromJson(json);

@override final  Category category;
@override@JsonKey() final  String type;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  BlockActionType actionType;

/// Create a copy of NavigateToFeedCategoryAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavigateToFeedCategoryActionCopyWith<_NavigateToFeedCategoryAction> get copyWith => __$NavigateToFeedCategoryActionCopyWithImpl<_NavigateToFeedCategoryAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavigateToFeedCategoryActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToFeedCategoryAction&&(identical(other.category, category) || other.category == category)&&(identical(other.type, type) || other.type == type)&&(identical(other.actionType, actionType) || other.actionType == actionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,type,actionType);

@override
String toString() {
  return 'NavigateToFeedCategoryAction(category: $category, type: $type, actionType: $actionType)';
}


}

/// @nodoc
abstract mixin class _$NavigateToFeedCategoryActionCopyWith<$Res> implements $NavigateToFeedCategoryActionCopyWith<$Res> {
  factory _$NavigateToFeedCategoryActionCopyWith(_NavigateToFeedCategoryAction value, $Res Function(_NavigateToFeedCategoryAction) _then) = __$NavigateToFeedCategoryActionCopyWithImpl;
@override @useResult
$Res call({
 Category category, String type,@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType actionType
});


@override $CategoryCopyWith<$Res> get category;

}
/// @nodoc
class __$NavigateToFeedCategoryActionCopyWithImpl<$Res>
    implements _$NavigateToFeedCategoryActionCopyWith<$Res> {
  __$NavigateToFeedCategoryActionCopyWithImpl(this._self, this._then);

  final _NavigateToFeedCategoryAction _self;
  final $Res Function(_NavigateToFeedCategoryAction) _then;

/// Create a copy of NavigateToFeedCategoryAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? type = null,Object? actionType = null,}) {
  return _then(_NavigateToFeedCategoryAction(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BlockActionType,
  ));
}

/// Create a copy of NavigateToFeedCategoryAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {

  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// @nodoc
mixin _$NavigateToSlideshowAction {

 String get articleId; SlideshowBlock get slideshow; String get type;@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType get actionType;
/// Create a copy of NavigateToSlideshowAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NavigateToSlideshowActionCopyWith<NavigateToSlideshowAction> get copyWith => _$NavigateToSlideshowActionCopyWithImpl<NavigateToSlideshowAction>(this as NavigateToSlideshowAction, _$identity);

  /// Serializes this NavigateToSlideshowAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NavigateToSlideshowAction&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.slideshow, slideshow) || other.slideshow == slideshow)&&(identical(other.type, type) || other.type == type)&&(identical(other.actionType, actionType) || other.actionType == actionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,slideshow,type,actionType);

@override
String toString() {
  return 'NavigateToSlideshowAction(articleId: $articleId, slideshow: $slideshow, type: $type, actionType: $actionType)';
}


}

/// @nodoc
abstract mixin class $NavigateToSlideshowActionCopyWith<$Res>  {
  factory $NavigateToSlideshowActionCopyWith(NavigateToSlideshowAction value, $Res Function(NavigateToSlideshowAction) _then) = _$NavigateToSlideshowActionCopyWithImpl;
@useResult
$Res call({
 String articleId, SlideshowBlock slideshow, String type,@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType actionType
});


$SlideshowBlockCopyWith<$Res> get slideshow;

}
/// @nodoc
class _$NavigateToSlideshowActionCopyWithImpl<$Res>
    implements $NavigateToSlideshowActionCopyWith<$Res> {
  _$NavigateToSlideshowActionCopyWithImpl(this._self, this._then);

  final NavigateToSlideshowAction _self;
  final $Res Function(NavigateToSlideshowAction) _then;

/// Create a copy of NavigateToSlideshowAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleId = null,Object? slideshow = null,Object? type = null,Object? actionType = null,}) {
  return _then(_self.copyWith(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as String,slideshow: null == slideshow ? _self.slideshow : slideshow // ignore: cast_nullable_to_non_nullable
as SlideshowBlock,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BlockActionType,
  ));
}
/// Create a copy of NavigateToSlideshowAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlideshowBlockCopyWith<$Res> get slideshow {

  return $SlideshowBlockCopyWith<$Res>(_self.slideshow, (value) {
    return _then(_self.copyWith(slideshow: value));
  });
}
}


/// Adds pattern-matching-related methods to [NavigateToSlideshowAction].
extension NavigateToSlideshowActionPatterns on NavigateToSlideshowAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NavigateToSlideshowAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NavigateToSlideshowAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NavigateToSlideshowAction value)  $default,){
final _that = this;
switch (_that) {
case _NavigateToSlideshowAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NavigateToSlideshowAction value)?  $default,){
final _that = this;
switch (_that) {
case _NavigateToSlideshowAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String articleId,  SlideshowBlock slideshow,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NavigateToSlideshowAction() when $default != null:
return $default(_that.articleId,_that.slideshow,_that.type,_that.actionType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String articleId,  SlideshowBlock slideshow,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)  $default,) {final _that = this;
switch (_that) {
case _NavigateToSlideshowAction():
return $default(_that.articleId,_that.slideshow,_that.type,_that.actionType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String articleId,  SlideshowBlock slideshow,  String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)?  $default,) {final _that = this;
switch (_that) {
case _NavigateToSlideshowAction() when $default != null:
return $default(_that.articleId,_that.slideshow,_that.type,_that.actionType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NavigateToSlideshowAction implements NavigateToSlideshowAction {
  const _NavigateToSlideshowAction({required this.articleId, required this.slideshow, this.type = NavigateToSlideshowAction.identifier, @JsonKey(includeFromJson: false, includeToJson: false) this.actionType = BlockActionType.navigation});
  factory _NavigateToSlideshowAction.fromJson(Map<String, dynamic> json) => _$NavigateToSlideshowActionFromJson(json);

@override final  String articleId;
@override final  SlideshowBlock slideshow;
@override@JsonKey() final  String type;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  BlockActionType actionType;

/// Create a copy of NavigateToSlideshowAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NavigateToSlideshowActionCopyWith<_NavigateToSlideshowAction> get copyWith => __$NavigateToSlideshowActionCopyWithImpl<_NavigateToSlideshowAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NavigateToSlideshowActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NavigateToSlideshowAction&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.slideshow, slideshow) || other.slideshow == slideshow)&&(identical(other.type, type) || other.type == type)&&(identical(other.actionType, actionType) || other.actionType == actionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,slideshow,type,actionType);

@override
String toString() {
  return 'NavigateToSlideshowAction(articleId: $articleId, slideshow: $slideshow, type: $type, actionType: $actionType)';
}


}

/// @nodoc
abstract mixin class _$NavigateToSlideshowActionCopyWith<$Res> implements $NavigateToSlideshowActionCopyWith<$Res> {
  factory _$NavigateToSlideshowActionCopyWith(_NavigateToSlideshowAction value, $Res Function(_NavigateToSlideshowAction) _then) = __$NavigateToSlideshowActionCopyWithImpl;
@override @useResult
$Res call({
 String articleId, SlideshowBlock slideshow, String type,@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType actionType
});


@override $SlideshowBlockCopyWith<$Res> get slideshow;

}
/// @nodoc
class __$NavigateToSlideshowActionCopyWithImpl<$Res>
    implements _$NavigateToSlideshowActionCopyWith<$Res> {
  __$NavigateToSlideshowActionCopyWithImpl(this._self, this._then);

  final _NavigateToSlideshowAction _self;
  final $Res Function(_NavigateToSlideshowAction) _then;

/// Create a copy of NavigateToSlideshowAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleId = null,Object? slideshow = null,Object? type = null,Object? actionType = null,}) {
  return _then(_NavigateToSlideshowAction(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as String,slideshow: null == slideshow ? _self.slideshow : slideshow // ignore: cast_nullable_to_non_nullable
as SlideshowBlock,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BlockActionType,
  ));
}

/// Create a copy of NavigateToSlideshowAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SlideshowBlockCopyWith<$Res> get slideshow {

  return $SlideshowBlockCopyWith<$Res>(_self.slideshow, (value) {
    return _then(_self.copyWith(slideshow: value));
  });
}
}


/// @nodoc
mixin _$UnknownBlockAction {

 String get type;@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType get actionType;
/// Create a copy of UnknownBlockAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownBlockActionCopyWith<UnknownBlockAction> get copyWith => _$UnknownBlockActionCopyWithImpl<UnknownBlockAction>(this as UnknownBlockAction, _$identity);

  /// Serializes this UnknownBlockAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownBlockAction&&(identical(other.type, type) || other.type == type)&&(identical(other.actionType, actionType) || other.actionType == actionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,actionType);

@override
String toString() {
  return 'UnknownBlockAction(type: $type, actionType: $actionType)';
}


}

/// @nodoc
abstract mixin class $UnknownBlockActionCopyWith<$Res>  {
  factory $UnknownBlockActionCopyWith(UnknownBlockAction value, $Res Function(UnknownBlockAction) _then) = _$UnknownBlockActionCopyWithImpl;
@useResult
$Res call({
 String type,@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType actionType
});




}
/// @nodoc
class _$UnknownBlockActionCopyWithImpl<$Res>
    implements $UnknownBlockActionCopyWith<$Res> {
  _$UnknownBlockActionCopyWithImpl(this._self, this._then);

  final UnknownBlockAction _self;
  final $Res Function(UnknownBlockAction) _then;

/// Create a copy of UnknownBlockAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? actionType = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BlockActionType,
  ));
}

}


/// Adds pattern-matching-related methods to [UnknownBlockAction].
extension UnknownBlockActionPatterns on UnknownBlockAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnknownBlockAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnknownBlockAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnknownBlockAction value)  $default,){
final _that = this;
switch (_that) {
case _UnknownBlockAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnknownBlockAction value)?  $default,){
final _that = this;
switch (_that) {
case _UnknownBlockAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnknownBlockAction() when $default != null:
return $default(_that.type,_that.actionType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)  $default,) {final _that = this;
switch (_that) {
case _UnknownBlockAction():
return $default(_that.type,_that.actionType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type, @JsonKey(includeFromJson: false, includeToJson: false)  BlockActionType actionType)?  $default,) {final _that = this;
switch (_that) {
case _UnknownBlockAction() when $default != null:
return $default(_that.type,_that.actionType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnknownBlockAction implements UnknownBlockAction {
  const _UnknownBlockAction({this.type = UnknownBlockAction.identifier, @JsonKey(includeFromJson: false, includeToJson: false) this.actionType = BlockActionType.unknown});
  factory _UnknownBlockAction.fromJson(Map<String, dynamic> json) => _$UnknownBlockActionFromJson(json);

@override@JsonKey() final  String type;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  BlockActionType actionType;

/// Create a copy of UnknownBlockAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnknownBlockActionCopyWith<_UnknownBlockAction> get copyWith => __$UnknownBlockActionCopyWithImpl<_UnknownBlockAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnknownBlockActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnknownBlockAction&&(identical(other.type, type) || other.type == type)&&(identical(other.actionType, actionType) || other.actionType == actionType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,actionType);

@override
String toString() {
  return 'UnknownBlockAction(type: $type, actionType: $actionType)';
}


}

/// @nodoc
abstract mixin class _$UnknownBlockActionCopyWith<$Res> implements $UnknownBlockActionCopyWith<$Res> {
  factory _$UnknownBlockActionCopyWith(_UnknownBlockAction value, $Res Function(_UnknownBlockAction) _then) = __$UnknownBlockActionCopyWithImpl;
@override @useResult
$Res call({
 String type,@JsonKey(includeFromJson: false, includeToJson: false) BlockActionType actionType
});




}
/// @nodoc
class __$UnknownBlockActionCopyWithImpl<$Res>
    implements _$UnknownBlockActionCopyWith<$Res> {
  __$UnknownBlockActionCopyWithImpl(this._self, this._then);

  final _UnknownBlockAction _self;
  final $Res Function(_UnknownBlockAction) _then;

/// Create a copy of UnknownBlockAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? actionType = null,}) {
  return _then(_UnknownBlockAction(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as BlockActionType,
  ));
}


}

// dart format on
