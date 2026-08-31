// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_feed_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsFeedItem {

 String get id; String get title; DateTime get publishedAt; String get sourceName; String get sourceType; String? get sourceId; String? get originalUrl; List<Map<String, dynamic>> get newsBlocks; int get totalCount;
/// Create a copy of NewsFeedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsFeedItemCopyWith<NewsFeedItem> get copyWith => _$NewsFeedItemCopyWithImpl<NewsFeedItem>(this as NewsFeedItem, _$identity);

  /// Serializes this NewsFeedItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsFeedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.originalUrl, originalUrl) || other.originalUrl == originalUrl)&&const DeepCollectionEquality().equals(other.newsBlocks, newsBlocks)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,publishedAt,sourceName,sourceType,sourceId,originalUrl,const DeepCollectionEquality().hash(newsBlocks),totalCount);

@override
String toString() {
  return 'NewsFeedItem(id: $id, title: $title, publishedAt: $publishedAt, sourceName: $sourceName, sourceType: $sourceType, sourceId: $sourceId, originalUrl: $originalUrl, newsBlocks: $newsBlocks, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class $NewsFeedItemCopyWith<$Res>  {
  factory $NewsFeedItemCopyWith(NewsFeedItem value, $Res Function(NewsFeedItem) _then) = _$NewsFeedItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime publishedAt, String sourceName, String sourceType, String? sourceId, String? originalUrl, List<Map<String, dynamic>> newsBlocks, int totalCount
});




}
/// @nodoc
class _$NewsFeedItemCopyWithImpl<$Res>
    implements $NewsFeedItemCopyWith<$Res> {
  _$NewsFeedItemCopyWithImpl(this._self, this._then);

  final NewsFeedItem _self;
  final $Res Function(NewsFeedItem) _then;

/// Create a copy of NewsFeedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? publishedAt = null,Object? sourceName = null,Object? sourceType = null,Object? sourceId = freezed,Object? originalUrl = freezed,Object? newsBlocks = null,Object? totalCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,originalUrl: freezed == originalUrl ? _self.originalUrl : originalUrl // ignore: cast_nullable_to_non_nullable
as String?,newsBlocks: null == newsBlocks ? _self.newsBlocks : newsBlocks // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsFeedItem].
extension NewsFeedItemPatterns on NewsFeedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsFeedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsFeedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsFeedItem value)  $default,){
final _that = this;
switch (_that) {
case _NewsFeedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsFeedItem value)?  $default,){
final _that = this;
switch (_that) {
case _NewsFeedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime publishedAt,  String sourceName,  String sourceType,  String? sourceId,  String? originalUrl,  List<Map<String, dynamic>> newsBlocks,  int totalCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsFeedItem() when $default != null:
return $default(_that.id,_that.title,_that.publishedAt,_that.sourceName,_that.sourceType,_that.sourceId,_that.originalUrl,_that.newsBlocks,_that.totalCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime publishedAt,  String sourceName,  String sourceType,  String? sourceId,  String? originalUrl,  List<Map<String, dynamic>> newsBlocks,  int totalCount)  $default,) {final _that = this;
switch (_that) {
case _NewsFeedItem():
return $default(_that.id,_that.title,_that.publishedAt,_that.sourceName,_that.sourceType,_that.sourceId,_that.originalUrl,_that.newsBlocks,_that.totalCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime publishedAt,  String sourceName,  String sourceType,  String? sourceId,  String? originalUrl,  List<Map<String, dynamic>> newsBlocks,  int totalCount)?  $default,) {final _that = this;
switch (_that) {
case _NewsFeedItem() when $default != null:
return $default(_that.id,_that.title,_that.publishedAt,_that.sourceName,_that.sourceType,_that.sourceId,_that.originalUrl,_that.newsBlocks,_that.totalCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsFeedItem implements NewsFeedItem {
  const _NewsFeedItem({required this.id, required this.title, required this.publishedAt, this.sourceName = '', this.sourceType = 'social', this.sourceId, this.originalUrl, final  List<Map<String, dynamic>> newsBlocks = const <Map<String, dynamic>>[], this.totalCount = 0}): _newsBlocks = newsBlocks;
  factory _NewsFeedItem.fromJson(Map<String, dynamic> json) => _$NewsFeedItemFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime publishedAt;
@override@JsonKey() final  String sourceName;
@override@JsonKey() final  String sourceType;
@override final  String? sourceId;
@override final  String? originalUrl;
 final  List<Map<String, dynamic>> _newsBlocks;
@override@JsonKey() List<Map<String, dynamic>> get newsBlocks {
  if (_newsBlocks is EqualUnmodifiableListView) return _newsBlocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_newsBlocks);
}

@override@JsonKey() final  int totalCount;

/// Create a copy of NewsFeedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsFeedItemCopyWith<_NewsFeedItem> get copyWith => __$NewsFeedItemCopyWithImpl<_NewsFeedItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsFeedItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsFeedItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.originalUrl, originalUrl) || other.originalUrl == originalUrl)&&const DeepCollectionEquality().equals(other._newsBlocks, _newsBlocks)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,publishedAt,sourceName,sourceType,sourceId,originalUrl,const DeepCollectionEquality().hash(_newsBlocks),totalCount);

@override
String toString() {
  return 'NewsFeedItem(id: $id, title: $title, publishedAt: $publishedAt, sourceName: $sourceName, sourceType: $sourceType, sourceId: $sourceId, originalUrl: $originalUrl, newsBlocks: $newsBlocks, totalCount: $totalCount)';
}


}

/// @nodoc
abstract mixin class _$NewsFeedItemCopyWith<$Res> implements $NewsFeedItemCopyWith<$Res> {
  factory _$NewsFeedItemCopyWith(_NewsFeedItem value, $Res Function(_NewsFeedItem) _then) = __$NewsFeedItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime publishedAt, String sourceName, String sourceType, String? sourceId, String? originalUrl, List<Map<String, dynamic>> newsBlocks, int totalCount
});




}
/// @nodoc
class __$NewsFeedItemCopyWithImpl<$Res>
    implements _$NewsFeedItemCopyWith<$Res> {
  __$NewsFeedItemCopyWithImpl(this._self, this._then);

  final _NewsFeedItem _self;
  final $Res Function(_NewsFeedItem) _then;

/// Create a copy of NewsFeedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? publishedAt = null,Object? sourceName = null,Object? sourceType = null,Object? sourceId = freezed,Object? originalUrl = freezed,Object? newsBlocks = null,Object? totalCount = null,}) {
  return _then(_NewsFeedItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceId: freezed == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String?,originalUrl: freezed == originalUrl ? _self.originalUrl : originalUrl // ignore: cast_nullable_to_non_nullable
as String?,newsBlocks: null == newsBlocks ? _self._newsBlocks : newsBlocks // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NewsSourceItem {

 String get sourceType; String get sourceId; String get sourceName; String? get sourceUrl; String? get avatarUrl; String? get subscribers;
/// Create a copy of NewsSourceItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsSourceItemCopyWith<NewsSourceItem> get copyWith => _$NewsSourceItemCopyWithImpl<NewsSourceItem>(this as NewsSourceItem, _$identity);

  /// Serializes this NewsSourceItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsSourceItem&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.subscribers, subscribers) || other.subscribers == subscribers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceType,sourceId,sourceName,sourceUrl,avatarUrl,subscribers);

@override
String toString() {
  return 'NewsSourceItem(sourceType: $sourceType, sourceId: $sourceId, sourceName: $sourceName, sourceUrl: $sourceUrl, avatarUrl: $avatarUrl, subscribers: $subscribers)';
}


}

/// @nodoc
abstract mixin class $NewsSourceItemCopyWith<$Res>  {
  factory $NewsSourceItemCopyWith(NewsSourceItem value, $Res Function(NewsSourceItem) _then) = _$NewsSourceItemCopyWithImpl;
@useResult
$Res call({
 String sourceType, String sourceId, String sourceName, String? sourceUrl, String? avatarUrl, String? subscribers
});




}
/// @nodoc
class _$NewsSourceItemCopyWithImpl<$Res>
    implements $NewsSourceItemCopyWith<$Res> {
  _$NewsSourceItemCopyWithImpl(this._self, this._then);

  final NewsSourceItem _self;
  final $Res Function(NewsSourceItem) _then;

/// Create a copy of NewsSourceItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceType = null,Object? sourceId = null,Object? sourceName = null,Object? sourceUrl = freezed,Object? avatarUrl = freezed,Object? subscribers = freezed,}) {
  return _then(_self.copyWith(
sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,subscribers: freezed == subscribers ? _self.subscribers : subscribers // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsSourceItem].
extension NewsSourceItemPatterns on NewsSourceItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsSourceItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsSourceItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsSourceItem value)  $default,){
final _that = this;
switch (_that) {
case _NewsSourceItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsSourceItem value)?  $default,){
final _that = this;
switch (_that) {
case _NewsSourceItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceType,  String sourceId,  String sourceName,  String? sourceUrl,  String? avatarUrl,  String? subscribers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsSourceItem() when $default != null:
return $default(_that.sourceType,_that.sourceId,_that.sourceName,_that.sourceUrl,_that.avatarUrl,_that.subscribers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceType,  String sourceId,  String sourceName,  String? sourceUrl,  String? avatarUrl,  String? subscribers)  $default,) {final _that = this;
switch (_that) {
case _NewsSourceItem():
return $default(_that.sourceType,_that.sourceId,_that.sourceName,_that.sourceUrl,_that.avatarUrl,_that.subscribers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceType,  String sourceId,  String sourceName,  String? sourceUrl,  String? avatarUrl,  String? subscribers)?  $default,) {final _that = this;
switch (_that) {
case _NewsSourceItem() when $default != null:
return $default(_that.sourceType,_that.sourceId,_that.sourceName,_that.sourceUrl,_that.avatarUrl,_that.subscribers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsSourceItem implements NewsSourceItem {
  const _NewsSourceItem({required this.sourceType, required this.sourceId, this.sourceName = '', this.sourceUrl, this.avatarUrl, this.subscribers});
  factory _NewsSourceItem.fromJson(Map<String, dynamic> json) => _$NewsSourceItemFromJson(json);

@override final  String sourceType;
@override final  String sourceId;
@override@JsonKey() final  String sourceName;
@override final  String? sourceUrl;
@override final  String? avatarUrl;
@override final  String? subscribers;

/// Create a copy of NewsSourceItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsSourceItemCopyWith<_NewsSourceItem> get copyWith => __$NewsSourceItemCopyWithImpl<_NewsSourceItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsSourceItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsSourceItem&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&(identical(other.sourceUrl, sourceUrl) || other.sourceUrl == sourceUrl)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.subscribers, subscribers) || other.subscribers == subscribers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceType,sourceId,sourceName,sourceUrl,avatarUrl,subscribers);

@override
String toString() {
  return 'NewsSourceItem(sourceType: $sourceType, sourceId: $sourceId, sourceName: $sourceName, sourceUrl: $sourceUrl, avatarUrl: $avatarUrl, subscribers: $subscribers)';
}


}

/// @nodoc
abstract mixin class _$NewsSourceItemCopyWith<$Res> implements $NewsSourceItemCopyWith<$Res> {
  factory _$NewsSourceItemCopyWith(_NewsSourceItem value, $Res Function(_NewsSourceItem) _then) = __$NewsSourceItemCopyWithImpl;
@override @useResult
$Res call({
 String sourceType, String sourceId, String sourceName, String? sourceUrl, String? avatarUrl, String? subscribers
});




}
/// @nodoc
class __$NewsSourceItemCopyWithImpl<$Res>
    implements _$NewsSourceItemCopyWith<$Res> {
  __$NewsSourceItemCopyWithImpl(this._self, this._then);

  final _NewsSourceItem _self;
  final $Res Function(_NewsSourceItem) _then;

/// Create a copy of NewsSourceItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceType = null,Object? sourceId = null,Object? sourceName = null,Object? sourceUrl = freezed,Object? avatarUrl = freezed,Object? subscribers = freezed,}) {
  return _then(_NewsSourceItem(
sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,sourceUrl: freezed == sourceUrl ? _self.sourceUrl : sourceUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,subscribers: freezed == subscribers ? _self.subscribers : subscribers // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
