// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_banner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PromoBanner {

 String get id; String get slug; String get title; String get ctaUrl;@JsonKey(fromJson: _placementsFromJson, toJson: _placementsToJson) List<PromoPlacement> get placements;@JsonKey(unknownEnumValue: PromoHomeSlot.afterToday) PromoHomeSlot get homeSlot; int get priority; int get version;@JsonKey(unknownEnumValue: PromoStyle.solid) PromoStyle get style; String get accentColor; String get emoji; String? get kicker; String? get subtitle; String get ctaLabel; String get registerLabel; String? get contactTelegram; bool get allowSnooze; int get snoozeHours; bool get allowHideForever; PromoDetails get details;
/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoBannerCopyWith<PromoBanner> get copyWith => _$PromoBannerCopyWithImpl<PromoBanner>(this as PromoBanner, _$identity);

  /// Serializes this PromoBanner to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.ctaUrl, ctaUrl) || other.ctaUrl == ctaUrl)&&const DeepCollectionEquality().equals(other.placements, placements)&&(identical(other.homeSlot, homeSlot) || other.homeSlot == homeSlot)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.version, version) || other.version == version)&&(identical(other.style, style) || other.style == style)&&(identical(other.accentColor, accentColor) || other.accentColor == accentColor)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.kicker, kicker) || other.kicker == kicker)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.ctaLabel, ctaLabel) || other.ctaLabel == ctaLabel)&&(identical(other.registerLabel, registerLabel) || other.registerLabel == registerLabel)&&(identical(other.contactTelegram, contactTelegram) || other.contactTelegram == contactTelegram)&&(identical(other.allowSnooze, allowSnooze) || other.allowSnooze == allowSnooze)&&(identical(other.snoozeHours, snoozeHours) || other.snoozeHours == snoozeHours)&&(identical(other.allowHideForever, allowHideForever) || other.allowHideForever == allowHideForever)&&(identical(other.details, details) || other.details == details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,slug,title,ctaUrl,const DeepCollectionEquality().hash(placements),homeSlot,priority,version,style,accentColor,emoji,kicker,subtitle,ctaLabel,registerLabel,contactTelegram,allowSnooze,snoozeHours,allowHideForever,details]);

@override
String toString() {
  return 'PromoBanner(id: $id, slug: $slug, title: $title, ctaUrl: $ctaUrl, placements: $placements, homeSlot: $homeSlot, priority: $priority, version: $version, style: $style, accentColor: $accentColor, emoji: $emoji, kicker: $kicker, subtitle: $subtitle, ctaLabel: $ctaLabel, registerLabel: $registerLabel, contactTelegram: $contactTelegram, allowSnooze: $allowSnooze, snoozeHours: $snoozeHours, allowHideForever: $allowHideForever, details: $details)';
}


}

/// @nodoc
abstract mixin class $PromoBannerCopyWith<$Res>  {
  factory $PromoBannerCopyWith(PromoBanner value, $Res Function(PromoBanner) _then) = _$PromoBannerCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String title, String ctaUrl,@JsonKey(fromJson: _placementsFromJson, toJson: _placementsToJson) List<PromoPlacement> placements,@JsonKey(unknownEnumValue: PromoHomeSlot.afterToday) PromoHomeSlot homeSlot, int priority, int version,@JsonKey(unknownEnumValue: PromoStyle.solid) PromoStyle style, String accentColor, String emoji, String? kicker, String? subtitle, String ctaLabel, String registerLabel, String? contactTelegram, bool allowSnooze, int snoozeHours, bool allowHideForever, PromoDetails details
});


$PromoDetailsCopyWith<$Res> get details;

}
/// @nodoc
class _$PromoBannerCopyWithImpl<$Res>
    implements $PromoBannerCopyWith<$Res> {
  _$PromoBannerCopyWithImpl(this._self, this._then);

  final PromoBanner _self;
  final $Res Function(PromoBanner) _then;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? ctaUrl = null,Object? placements = null,Object? homeSlot = null,Object? priority = null,Object? version = null,Object? style = null,Object? accentColor = null,Object? emoji = null,Object? kicker = freezed,Object? subtitle = freezed,Object? ctaLabel = null,Object? registerLabel = null,Object? contactTelegram = freezed,Object? allowSnooze = null,Object? snoozeHours = null,Object? allowHideForever = null,Object? details = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,ctaUrl: null == ctaUrl ? _self.ctaUrl : ctaUrl // ignore: cast_nullable_to_non_nullable
as String,placements: null == placements ? _self.placements : placements // ignore: cast_nullable_to_non_nullable
as List<PromoPlacement>,homeSlot: null == homeSlot ? _self.homeSlot : homeSlot // ignore: cast_nullable_to_non_nullable
as PromoHomeSlot,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as PromoStyle,accentColor: null == accentColor ? _self.accentColor : accentColor // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,kicker: freezed == kicker ? _self.kicker : kicker // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,ctaLabel: null == ctaLabel ? _self.ctaLabel : ctaLabel // ignore: cast_nullable_to_non_nullable
as String,registerLabel: null == registerLabel ? _self.registerLabel : registerLabel // ignore: cast_nullable_to_non_nullable
as String,contactTelegram: freezed == contactTelegram ? _self.contactTelegram : contactTelegram // ignore: cast_nullable_to_non_nullable
as String?,allowSnooze: null == allowSnooze ? _self.allowSnooze : allowSnooze // ignore: cast_nullable_to_non_nullable
as bool,snoozeHours: null == snoozeHours ? _self.snoozeHours : snoozeHours // ignore: cast_nullable_to_non_nullable
as int,allowHideForever: null == allowHideForever ? _self.allowHideForever : allowHideForever // ignore: cast_nullable_to_non_nullable
as bool,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as PromoDetails,
  ));
}
/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoDetailsCopyWith<$Res> get details {
  
  return $PromoDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}


/// Adds pattern-matching-related methods to [PromoBanner].
extension PromoBannerPatterns on PromoBanner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoBanner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoBanner value)  $default,){
final _that = this;
switch (_that) {
case _PromoBanner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoBanner value)?  $default,){
final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String ctaUrl, @JsonKey(fromJson: _placementsFromJson, toJson: _placementsToJson)  List<PromoPlacement> placements, @JsonKey(unknownEnumValue: PromoHomeSlot.afterToday)  PromoHomeSlot homeSlot,  int priority,  int version, @JsonKey(unknownEnumValue: PromoStyle.solid)  PromoStyle style,  String accentColor,  String emoji,  String? kicker,  String? subtitle,  String ctaLabel,  String registerLabel,  String? contactTelegram,  bool allowSnooze,  int snoozeHours,  bool allowHideForever,  PromoDetails details)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.ctaUrl,_that.placements,_that.homeSlot,_that.priority,_that.version,_that.style,_that.accentColor,_that.emoji,_that.kicker,_that.subtitle,_that.ctaLabel,_that.registerLabel,_that.contactTelegram,_that.allowSnooze,_that.snoozeHours,_that.allowHideForever,_that.details);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String title,  String ctaUrl, @JsonKey(fromJson: _placementsFromJson, toJson: _placementsToJson)  List<PromoPlacement> placements, @JsonKey(unknownEnumValue: PromoHomeSlot.afterToday)  PromoHomeSlot homeSlot,  int priority,  int version, @JsonKey(unknownEnumValue: PromoStyle.solid)  PromoStyle style,  String accentColor,  String emoji,  String? kicker,  String? subtitle,  String ctaLabel,  String registerLabel,  String? contactTelegram,  bool allowSnooze,  int snoozeHours,  bool allowHideForever,  PromoDetails details)  $default,) {final _that = this;
switch (_that) {
case _PromoBanner():
return $default(_that.id,_that.slug,_that.title,_that.ctaUrl,_that.placements,_that.homeSlot,_that.priority,_that.version,_that.style,_that.accentColor,_that.emoji,_that.kicker,_that.subtitle,_that.ctaLabel,_that.registerLabel,_that.contactTelegram,_that.allowSnooze,_that.snoozeHours,_that.allowHideForever,_that.details);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String title,  String ctaUrl, @JsonKey(fromJson: _placementsFromJson, toJson: _placementsToJson)  List<PromoPlacement> placements, @JsonKey(unknownEnumValue: PromoHomeSlot.afterToday)  PromoHomeSlot homeSlot,  int priority,  int version, @JsonKey(unknownEnumValue: PromoStyle.solid)  PromoStyle style,  String accentColor,  String emoji,  String? kicker,  String? subtitle,  String ctaLabel,  String registerLabel,  String? contactTelegram,  bool allowSnooze,  int snoozeHours,  bool allowHideForever,  PromoDetails details)?  $default,) {final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
return $default(_that.id,_that.slug,_that.title,_that.ctaUrl,_that.placements,_that.homeSlot,_that.priority,_that.version,_that.style,_that.accentColor,_that.emoji,_that.kicker,_that.subtitle,_that.ctaLabel,_that.registerLabel,_that.contactTelegram,_that.allowSnooze,_that.snoozeHours,_that.allowHideForever,_that.details);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromoBanner extends PromoBanner {
  const _PromoBanner({required this.id, required this.slug, required this.title, required this.ctaUrl, @JsonKey(fromJson: _placementsFromJson, toJson: _placementsToJson) final  List<PromoPlacement> placements = const <PromoPlacement>[PromoPlacement.home], @JsonKey(unknownEnumValue: PromoHomeSlot.afterToday) this.homeSlot = PromoHomeSlot.afterToday, this.priority = 0, this.version = 1, @JsonKey(unknownEnumValue: PromoStyle.solid) this.style = PromoStyle.solid, this.accentColor = '#FC3F1D', this.emoji = '✨', this.kicker, this.subtitle, this.ctaLabel = 'Подробнее', this.registerLabel = 'Зарегистрироваться', this.contactTelegram, this.allowSnooze = true, this.snoozeHours = 72, this.allowHideForever = true, this.details = const PromoDetails()}): _placements = placements,super._();
  factory _PromoBanner.fromJson(Map<String, dynamic> json) => _$PromoBannerFromJson(json);

@override final  String id;
@override final  String slug;
@override final  String title;
@override final  String ctaUrl;
 final  List<PromoPlacement> _placements;
@override@JsonKey(fromJson: _placementsFromJson, toJson: _placementsToJson) List<PromoPlacement> get placements {
  if (_placements is EqualUnmodifiableListView) return _placements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_placements);
}

@override@JsonKey(unknownEnumValue: PromoHomeSlot.afterToday) final  PromoHomeSlot homeSlot;
@override@JsonKey() final  int priority;
@override@JsonKey() final  int version;
@override@JsonKey(unknownEnumValue: PromoStyle.solid) final  PromoStyle style;
@override@JsonKey() final  String accentColor;
@override@JsonKey() final  String emoji;
@override final  String? kicker;
@override final  String? subtitle;
@override@JsonKey() final  String ctaLabel;
@override@JsonKey() final  String registerLabel;
@override final  String? contactTelegram;
@override@JsonKey() final  bool allowSnooze;
@override@JsonKey() final  int snoozeHours;
@override@JsonKey() final  bool allowHideForever;
@override@JsonKey() final  PromoDetails details;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoBannerCopyWith<_PromoBanner> get copyWith => __$PromoBannerCopyWithImpl<_PromoBanner>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoBannerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.ctaUrl, ctaUrl) || other.ctaUrl == ctaUrl)&&const DeepCollectionEquality().equals(other._placements, _placements)&&(identical(other.homeSlot, homeSlot) || other.homeSlot == homeSlot)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.version, version) || other.version == version)&&(identical(other.style, style) || other.style == style)&&(identical(other.accentColor, accentColor) || other.accentColor == accentColor)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.kicker, kicker) || other.kicker == kicker)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.ctaLabel, ctaLabel) || other.ctaLabel == ctaLabel)&&(identical(other.registerLabel, registerLabel) || other.registerLabel == registerLabel)&&(identical(other.contactTelegram, contactTelegram) || other.contactTelegram == contactTelegram)&&(identical(other.allowSnooze, allowSnooze) || other.allowSnooze == allowSnooze)&&(identical(other.snoozeHours, snoozeHours) || other.snoozeHours == snoozeHours)&&(identical(other.allowHideForever, allowHideForever) || other.allowHideForever == allowHideForever)&&(identical(other.details, details) || other.details == details));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,slug,title,ctaUrl,const DeepCollectionEquality().hash(_placements),homeSlot,priority,version,style,accentColor,emoji,kicker,subtitle,ctaLabel,registerLabel,contactTelegram,allowSnooze,snoozeHours,allowHideForever,details]);

@override
String toString() {
  return 'PromoBanner(id: $id, slug: $slug, title: $title, ctaUrl: $ctaUrl, placements: $placements, homeSlot: $homeSlot, priority: $priority, version: $version, style: $style, accentColor: $accentColor, emoji: $emoji, kicker: $kicker, subtitle: $subtitle, ctaLabel: $ctaLabel, registerLabel: $registerLabel, contactTelegram: $contactTelegram, allowSnooze: $allowSnooze, snoozeHours: $snoozeHours, allowHideForever: $allowHideForever, details: $details)';
}


}

/// @nodoc
abstract mixin class _$PromoBannerCopyWith<$Res> implements $PromoBannerCopyWith<$Res> {
  factory _$PromoBannerCopyWith(_PromoBanner value, $Res Function(_PromoBanner) _then) = __$PromoBannerCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String title, String ctaUrl,@JsonKey(fromJson: _placementsFromJson, toJson: _placementsToJson) List<PromoPlacement> placements,@JsonKey(unknownEnumValue: PromoHomeSlot.afterToday) PromoHomeSlot homeSlot, int priority, int version,@JsonKey(unknownEnumValue: PromoStyle.solid) PromoStyle style, String accentColor, String emoji, String? kicker, String? subtitle, String ctaLabel, String registerLabel, String? contactTelegram, bool allowSnooze, int snoozeHours, bool allowHideForever, PromoDetails details
});


@override $PromoDetailsCopyWith<$Res> get details;

}
/// @nodoc
class __$PromoBannerCopyWithImpl<$Res>
    implements _$PromoBannerCopyWith<$Res> {
  __$PromoBannerCopyWithImpl(this._self, this._then);

  final _PromoBanner _self;
  final $Res Function(_PromoBanner) _then;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? title = null,Object? ctaUrl = null,Object? placements = null,Object? homeSlot = null,Object? priority = null,Object? version = null,Object? style = null,Object? accentColor = null,Object? emoji = null,Object? kicker = freezed,Object? subtitle = freezed,Object? ctaLabel = null,Object? registerLabel = null,Object? contactTelegram = freezed,Object? allowSnooze = null,Object? snoozeHours = null,Object? allowHideForever = null,Object? details = null,}) {
  return _then(_PromoBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,ctaUrl: null == ctaUrl ? _self.ctaUrl : ctaUrl // ignore: cast_nullable_to_non_nullable
as String,placements: null == placements ? _self._placements : placements // ignore: cast_nullable_to_non_nullable
as List<PromoPlacement>,homeSlot: null == homeSlot ? _self.homeSlot : homeSlot // ignore: cast_nullable_to_non_nullable
as PromoHomeSlot,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as PromoStyle,accentColor: null == accentColor ? _self.accentColor : accentColor // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,kicker: freezed == kicker ? _self.kicker : kicker // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,ctaLabel: null == ctaLabel ? _self.ctaLabel : ctaLabel // ignore: cast_nullable_to_non_nullable
as String,registerLabel: null == registerLabel ? _self.registerLabel : registerLabel // ignore: cast_nullable_to_non_nullable
as String,contactTelegram: freezed == contactTelegram ? _self.contactTelegram : contactTelegram // ignore: cast_nullable_to_non_nullable
as String?,allowSnooze: null == allowSnooze ? _self.allowSnooze : allowSnooze // ignore: cast_nullable_to_non_nullable
as bool,snoozeHours: null == snoozeHours ? _self.snoozeHours : snoozeHours // ignore: cast_nullable_to_non_nullable
as int,allowHideForever: null == allowHideForever ? _self.allowHideForever : allowHideForever // ignore: cast_nullable_to_non_nullable
as bool,details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as PromoDetails,
  ));
}

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoDetailsCopyWith<$Res> get details {
  
  return $PromoDetailsCopyWith<$Res>(_self.details, (value) {
    return _then(_self.copyWith(details: value));
  });
}
}

// dart format on
