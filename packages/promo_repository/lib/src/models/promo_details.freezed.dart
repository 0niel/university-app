// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promo_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PromoHero {

 String? get badge; String? get title; String? get subtitle; List<String> get tags;
/// Create a copy of PromoHero
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoHeroCopyWith<PromoHero> get copyWith => _$PromoHeroCopyWithImpl<PromoHero>(this as PromoHero, _$identity);

  /// Serializes this PromoHero to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoHero&&(identical(other.badge, badge) || other.badge == badge)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,badge,title,subtitle,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'PromoHero(badge: $badge, title: $title, subtitle: $subtitle, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $PromoHeroCopyWith<$Res>  {
  factory $PromoHeroCopyWith(PromoHero value, $Res Function(PromoHero) _then) = _$PromoHeroCopyWithImpl;
@useResult
$Res call({
 String? badge, String? title, String? subtitle, List<String> tags
});




}
/// @nodoc
class _$PromoHeroCopyWithImpl<$Res>
    implements $PromoHeroCopyWith<$Res> {
  _$PromoHeroCopyWithImpl(this._self, this._then);

  final PromoHero _self;
  final $Res Function(PromoHero) _then;

/// Create a copy of PromoHero
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? badge = freezed,Object? title = freezed,Object? subtitle = freezed,Object? tags = null,}) {
  return _then(_self.copyWith(
badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoHero].
extension PromoHeroPatterns on PromoHero {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoHero value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoHero() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoHero value)  $default,){
final _that = this;
switch (_that) {
case _PromoHero():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoHero value)?  $default,){
final _that = this;
switch (_that) {
case _PromoHero() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? badge,  String? title,  String? subtitle,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoHero() when $default != null:
return $default(_that.badge,_that.title,_that.subtitle,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? badge,  String? title,  String? subtitle,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _PromoHero():
return $default(_that.badge,_that.title,_that.subtitle,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? badge,  String? title,  String? subtitle,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _PromoHero() when $default != null:
return $default(_that.badge,_that.title,_that.subtitle,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromoHero implements PromoHero {
  const _PromoHero({this.badge, this.title, this.subtitle, final  List<String> tags = const <String>[]}): _tags = tags;
  factory _PromoHero.fromJson(Map<String, dynamic> json) => _$PromoHeroFromJson(json);

@override final  String? badge;
@override final  String? title;
@override final  String? subtitle;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of PromoHero
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoHeroCopyWith<_PromoHero> get copyWith => __$PromoHeroCopyWithImpl<_PromoHero>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoHeroToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoHero&&(identical(other.badge, badge) || other.badge == badge)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,badge,title,subtitle,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'PromoHero(badge: $badge, title: $title, subtitle: $subtitle, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$PromoHeroCopyWith<$Res> implements $PromoHeroCopyWith<$Res> {
  factory _$PromoHeroCopyWith(_PromoHero value, $Res Function(_PromoHero) _then) = __$PromoHeroCopyWithImpl;
@override @useResult
$Res call({
 String? badge, String? title, String? subtitle, List<String> tags
});




}
/// @nodoc
class __$PromoHeroCopyWithImpl<$Res>
    implements _$PromoHeroCopyWith<$Res> {
  __$PromoHeroCopyWithImpl(this._self, this._then);

  final _PromoHero _self;
  final $Res Function(_PromoHero) _then;

/// Create a copy of PromoHero
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? badge = freezed,Object? title = freezed,Object? subtitle = freezed,Object? tags = null,}) {
  return _then(_PromoHero(
badge: freezed == badge ? _self.badge : badge // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PromoContact {

 String? get title; String? get subtitle;
/// Create a copy of PromoContact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoContactCopyWith<PromoContact> get copyWith => _$PromoContactCopyWithImpl<PromoContact>(this as PromoContact, _$identity);

  /// Serializes this PromoContact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoContact&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,subtitle);

@override
String toString() {
  return 'PromoContact(title: $title, subtitle: $subtitle)';
}


}

/// @nodoc
abstract mixin class $PromoContactCopyWith<$Res>  {
  factory $PromoContactCopyWith(PromoContact value, $Res Function(PromoContact) _then) = _$PromoContactCopyWithImpl;
@useResult
$Res call({
 String? title, String? subtitle
});




}
/// @nodoc
class _$PromoContactCopyWithImpl<$Res>
    implements $PromoContactCopyWith<$Res> {
  _$PromoContactCopyWithImpl(this._self, this._then);

  final PromoContact _self;
  final $Res Function(PromoContact) _then;

/// Create a copy of PromoContact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? subtitle = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoContact].
extension PromoContactPatterns on PromoContact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoContact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoContact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoContact value)  $default,){
final _that = this;
switch (_that) {
case _PromoContact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoContact value)?  $default,){
final _that = this;
switch (_that) {
case _PromoContact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? subtitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoContact() when $default != null:
return $default(_that.title,_that.subtitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? subtitle)  $default,) {final _that = this;
switch (_that) {
case _PromoContact():
return $default(_that.title,_that.subtitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? subtitle)?  $default,) {final _that = this;
switch (_that) {
case _PromoContact() when $default != null:
return $default(_that.title,_that.subtitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromoContact implements PromoContact {
  const _PromoContact({this.title, this.subtitle});
  factory _PromoContact.fromJson(Map<String, dynamic> json) => _$PromoContactFromJson(json);

@override final  String? title;
@override final  String? subtitle;

/// Create a copy of PromoContact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoContactCopyWith<_PromoContact> get copyWith => __$PromoContactCopyWithImpl<_PromoContact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoContact&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,subtitle);

@override
String toString() {
  return 'PromoContact(title: $title, subtitle: $subtitle)';
}


}

/// @nodoc
abstract mixin class _$PromoContactCopyWith<$Res> implements $PromoContactCopyWith<$Res> {
  factory _$PromoContactCopyWith(_PromoContact value, $Res Function(_PromoContact) _then) = __$PromoContactCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? subtitle
});




}
/// @nodoc
class __$PromoContactCopyWithImpl<$Res>
    implements _$PromoContactCopyWith<$Res> {
  __$PromoContactCopyWithImpl(this._self, this._then);

  final _PromoContact _self;
  final $Res Function(_PromoContact) _then;

/// Create a copy of PromoContact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? subtitle = freezed,}) {
  return _then(_PromoContact(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PromoDetails {

 PromoHero? get hero;@JsonKey(fromJson: _sectionsFromJson, toJson: _sectionsToJson) List<PromoSection> get sections; PromoContact? get contact; String? get footnote;
/// Create a copy of PromoDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoDetailsCopyWith<PromoDetails> get copyWith => _$PromoDetailsCopyWithImpl<PromoDetails>(this as PromoDetails, _$identity);

  /// Serializes this PromoDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoDetails&&(identical(other.hero, hero) || other.hero == hero)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.footnote, footnote) || other.footnote == footnote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hero,const DeepCollectionEquality().hash(sections),contact,footnote);

@override
String toString() {
  return 'PromoDetails(hero: $hero, sections: $sections, contact: $contact, footnote: $footnote)';
}


}

/// @nodoc
abstract mixin class $PromoDetailsCopyWith<$Res>  {
  factory $PromoDetailsCopyWith(PromoDetails value, $Res Function(PromoDetails) _then) = _$PromoDetailsCopyWithImpl;
@useResult
$Res call({
 PromoHero? hero,@JsonKey(fromJson: _sectionsFromJson, toJson: _sectionsToJson) List<PromoSection> sections, PromoContact? contact, String? footnote
});


$PromoHeroCopyWith<$Res>? get hero;$PromoContactCopyWith<$Res>? get contact;

}
/// @nodoc
class _$PromoDetailsCopyWithImpl<$Res>
    implements $PromoDetailsCopyWith<$Res> {
  _$PromoDetailsCopyWithImpl(this._self, this._then);

  final PromoDetails _self;
  final $Res Function(PromoDetails) _then;

/// Create a copy of PromoDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hero = freezed,Object? sections = null,Object? contact = freezed,Object? footnote = freezed,}) {
  return _then(_self.copyWith(
hero: freezed == hero ? _self.hero : hero // ignore: cast_nullable_to_non_nullable
as PromoHero?,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<PromoSection>,contact: freezed == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as PromoContact?,footnote: freezed == footnote ? _self.footnote : footnote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PromoDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoHeroCopyWith<$Res>? get hero {
    if (_self.hero == null) {
    return null;
  }

  return $PromoHeroCopyWith<$Res>(_self.hero!, (value) {
    return _then(_self.copyWith(hero: value));
  });
}/// Create a copy of PromoDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoContactCopyWith<$Res>? get contact {
    if (_self.contact == null) {
    return null;
  }

  return $PromoContactCopyWith<$Res>(_self.contact!, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}


/// Adds pattern-matching-related methods to [PromoDetails].
extension PromoDetailsPatterns on PromoDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoDetails value)  $default,){
final _that = this;
switch (_that) {
case _PromoDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoDetails value)?  $default,){
final _that = this;
switch (_that) {
case _PromoDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PromoHero? hero, @JsonKey(fromJson: _sectionsFromJson, toJson: _sectionsToJson)  List<PromoSection> sections,  PromoContact? contact,  String? footnote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoDetails() when $default != null:
return $default(_that.hero,_that.sections,_that.contact,_that.footnote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PromoHero? hero, @JsonKey(fromJson: _sectionsFromJson, toJson: _sectionsToJson)  List<PromoSection> sections,  PromoContact? contact,  String? footnote)  $default,) {final _that = this;
switch (_that) {
case _PromoDetails():
return $default(_that.hero,_that.sections,_that.contact,_that.footnote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PromoHero? hero, @JsonKey(fromJson: _sectionsFromJson, toJson: _sectionsToJson)  List<PromoSection> sections,  PromoContact? contact,  String? footnote)?  $default,) {final _that = this;
switch (_that) {
case _PromoDetails() when $default != null:
return $default(_that.hero,_that.sections,_that.contact,_that.footnote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PromoDetails implements PromoDetails {
  const _PromoDetails({this.hero, @JsonKey(fromJson: _sectionsFromJson, toJson: _sectionsToJson) final  List<PromoSection> sections = const <PromoSection>[], this.contact, this.footnote}): _sections = sections;
  factory _PromoDetails.fromJson(Map<String, dynamic> json) => _$PromoDetailsFromJson(json);

@override final  PromoHero? hero;
 final  List<PromoSection> _sections;
@override@JsonKey(fromJson: _sectionsFromJson, toJson: _sectionsToJson) List<PromoSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override final  PromoContact? contact;
@override final  String? footnote;

/// Create a copy of PromoDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoDetailsCopyWith<_PromoDetails> get copyWith => __$PromoDetailsCopyWithImpl<_PromoDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromoDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoDetails&&(identical(other.hero, hero) || other.hero == hero)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.contact, contact) || other.contact == contact)&&(identical(other.footnote, footnote) || other.footnote == footnote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hero,const DeepCollectionEquality().hash(_sections),contact,footnote);

@override
String toString() {
  return 'PromoDetails(hero: $hero, sections: $sections, contact: $contact, footnote: $footnote)';
}


}

/// @nodoc
abstract mixin class _$PromoDetailsCopyWith<$Res> implements $PromoDetailsCopyWith<$Res> {
  factory _$PromoDetailsCopyWith(_PromoDetails value, $Res Function(_PromoDetails) _then) = __$PromoDetailsCopyWithImpl;
@override @useResult
$Res call({
 PromoHero? hero,@JsonKey(fromJson: _sectionsFromJson, toJson: _sectionsToJson) List<PromoSection> sections, PromoContact? contact, String? footnote
});


@override $PromoHeroCopyWith<$Res>? get hero;@override $PromoContactCopyWith<$Res>? get contact;

}
/// @nodoc
class __$PromoDetailsCopyWithImpl<$Res>
    implements _$PromoDetailsCopyWith<$Res> {
  __$PromoDetailsCopyWithImpl(this._self, this._then);

  final _PromoDetails _self;
  final $Res Function(_PromoDetails) _then;

/// Create a copy of PromoDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hero = freezed,Object? sections = null,Object? contact = freezed,Object? footnote = freezed,}) {
  return _then(_PromoDetails(
hero: freezed == hero ? _self.hero : hero // ignore: cast_nullable_to_non_nullable
as PromoHero?,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<PromoSection>,contact: freezed == contact ? _self.contact : contact // ignore: cast_nullable_to_non_nullable
as PromoContact?,footnote: freezed == footnote ? _self.footnote : footnote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PromoDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoHeroCopyWith<$Res>? get hero {
    if (_self.hero == null) {
    return null;
  }

  return $PromoHeroCopyWith<$Res>(_self.hero!, (value) {
    return _then(_self.copyWith(hero: value));
  });
}/// Create a copy of PromoDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PromoContactCopyWith<$Res>? get contact {
    if (_self.contact == null) {
    return null;
  }

  return $PromoContactCopyWith<$Res>(_self.contact!, (value) {
    return _then(_self.copyWith(contact: value));
  });
}
}

// dart format on
