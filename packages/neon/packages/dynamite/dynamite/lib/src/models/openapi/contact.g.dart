// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Contact> _$contactSerializer = _$ContactSerializer();

class _$ContactSerializer implements StructuredSerializer<Contact> {
  @override
  final Iterable<Type> types = const [Contact, _$Contact];
  @override
  final String wireName = 'Contact';

  @override
  Iterable<Object?> serialize(Serializers serializers, Contact object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.url;
    if (value != null) {
      result
        ..add('url')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Contact deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = ContactBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'url':
          result.url = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'email':
          result.email = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$Contact extends Contact {
  @override
  final String? name;
  @override
  final String? url;
  @override
  final String? email;

  factory _$Contact([void Function(ContactBuilder)? updates]) => (ContactBuilder()..update(updates))._build();

  _$Contact._({this.name, this.url, this.email}) : super._();

  @override
  Contact rebuild(void Function(ContactBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  ContactBuilder toBuilder() => ContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Contact && name == other.name && url == other.url && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Contact')
          ..add('name', name)
          ..add('url', url)
          ..add('email', email))
        .toString();
  }
}

class ContactBuilder implements Builder<Contact, ContactBuilder> {
  _$Contact? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  ContactBuilder();

  ContactBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _url = $v.url;
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Contact other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Contact;
  }

  @override
  void update(void Function(ContactBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Contact build() => _build();

  _$Contact _build() {
    final _$result = _$v ?? _$Contact._(name: name, url: url, email: email);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
