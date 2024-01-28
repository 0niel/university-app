// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<PathItem> _$pathItemSerializer = _$PathItemSerializer();

class _$PathItemSerializer implements StructuredSerializer<PathItem> {
  @override
  final Iterable<Type> types = const [PathItem, _$PathItem];
  @override
  final String wireName = 'PathItem';

  @override
  Iterable<Object?> serialize(Serializers serializers, PathItem object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.parameters;
    if (value != null) {
      result
        ..add('parameters')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(Parameter)])));
    }
    value = object.get;
    if (value != null) {
      result
        ..add('get')
        ..add(serializers.serialize(value, specifiedType: const FullType(Operation)));
    }
    value = object.put;
    if (value != null) {
      result
        ..add('put')
        ..add(serializers.serialize(value, specifiedType: const FullType(Operation)));
    }
    value = object.post;
    if (value != null) {
      result
        ..add('post')
        ..add(serializers.serialize(value, specifiedType: const FullType(Operation)));
    }
    value = object.delete;
    if (value != null) {
      result
        ..add('delete')
        ..add(serializers.serialize(value, specifiedType: const FullType(Operation)));
    }
    value = object.options;
    if (value != null) {
      result
        ..add('options')
        ..add(serializers.serialize(value, specifiedType: const FullType(Operation)));
    }
    value = object.head;
    if (value != null) {
      result
        ..add('head')
        ..add(serializers.serialize(value, specifiedType: const FullType(Operation)));
    }
    value = object.patch;
    if (value != null) {
      result
        ..add('patch')
        ..add(serializers.serialize(value, specifiedType: const FullType(Operation)));
    }
    value = object.trace;
    if (value != null) {
      result
        ..add('trace')
        ..add(serializers.serialize(value, specifiedType: const FullType(Operation)));
    }
    return result;
  }

  @override
  PathItem deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = PathItemBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'parameters':
          result.parameters.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(Parameter)]))! as BuiltList<Object?>);
          break;
        case 'get':
          result.get.replace(serializers.deserialize(value, specifiedType: const FullType(Operation))! as Operation);
          break;
        case 'put':
          result.put.replace(serializers.deserialize(value, specifiedType: const FullType(Operation))! as Operation);
          break;
        case 'post':
          result.post.replace(serializers.deserialize(value, specifiedType: const FullType(Operation))! as Operation);
          break;
        case 'delete':
          result.delete.replace(serializers.deserialize(value, specifiedType: const FullType(Operation))! as Operation);
          break;
        case 'options':
          result.options
              .replace(serializers.deserialize(value, specifiedType: const FullType(Operation))! as Operation);
          break;
        case 'head':
          result.head.replace(serializers.deserialize(value, specifiedType: const FullType(Operation))! as Operation);
          break;
        case 'patch':
          result.patch.replace(serializers.deserialize(value, specifiedType: const FullType(Operation))! as Operation);
          break;
        case 'trace':
          result.trace.replace(serializers.deserialize(value, specifiedType: const FullType(Operation))! as Operation);
          break;
      }
    }

    return result.build();
  }
}

class _$PathItem extends PathItem {
  @override
  final String? description;
  @override
  final BuiltList<Parameter>? parameters;
  @override
  final Operation? get;
  @override
  final Operation? put;
  @override
  final Operation? post;
  @override
  final Operation? delete;
  @override
  final Operation? options;
  @override
  final Operation? head;
  @override
  final Operation? patch;
  @override
  final Operation? trace;

  factory _$PathItem([void Function(PathItemBuilder)? updates]) => (PathItemBuilder()..update(updates))._build();

  _$PathItem._(
      {this.description,
      this.parameters,
      this.get,
      this.put,
      this.post,
      this.delete,
      this.options,
      this.head,
      this.patch,
      this.trace})
      : super._();

  @override
  PathItem rebuild(void Function(PathItemBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  PathItemBuilder toBuilder() => PathItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PathItem &&
        parameters == other.parameters &&
        get == other.get &&
        put == other.put &&
        post == other.post &&
        delete == other.delete &&
        options == other.options &&
        head == other.head &&
        patch == other.patch &&
        trace == other.trace;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, parameters.hashCode);
    _$hash = $jc(_$hash, get.hashCode);
    _$hash = $jc(_$hash, put.hashCode);
    _$hash = $jc(_$hash, post.hashCode);
    _$hash = $jc(_$hash, delete.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, head.hashCode);
    _$hash = $jc(_$hash, patch.hashCode);
    _$hash = $jc(_$hash, trace.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PathItem')
          ..add('description', description)
          ..add('parameters', parameters)
          ..add('get', get)
          ..add('put', put)
          ..add('post', post)
          ..add('delete', delete)
          ..add('options', options)
          ..add('head', head)
          ..add('patch', patch)
          ..add('trace', trace))
        .toString();
  }
}

class PathItemBuilder implements Builder<PathItem, PathItemBuilder> {
  _$PathItem? _$v;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  ListBuilder<Parameter>? _parameters;
  ListBuilder<Parameter> get parameters => _$this._parameters ??= ListBuilder<Parameter>();
  set parameters(ListBuilder<Parameter>? parameters) => _$this._parameters = parameters;

  OperationBuilder? _get;
  OperationBuilder get get => _$this._get ??= OperationBuilder();
  set get(OperationBuilder? get) => _$this._get = get;

  OperationBuilder? _put;
  OperationBuilder get put => _$this._put ??= OperationBuilder();
  set put(OperationBuilder? put) => _$this._put = put;

  OperationBuilder? _post;
  OperationBuilder get post => _$this._post ??= OperationBuilder();
  set post(OperationBuilder? post) => _$this._post = post;

  OperationBuilder? _delete;
  OperationBuilder get delete => _$this._delete ??= OperationBuilder();
  set delete(OperationBuilder? delete) => _$this._delete = delete;

  OperationBuilder? _options;
  OperationBuilder get options => _$this._options ??= OperationBuilder();
  set options(OperationBuilder? options) => _$this._options = options;

  OperationBuilder? _head;
  OperationBuilder get head => _$this._head ??= OperationBuilder();
  set head(OperationBuilder? head) => _$this._head = head;

  OperationBuilder? _patch;
  OperationBuilder get patch => _$this._patch ??= OperationBuilder();
  set patch(OperationBuilder? patch) => _$this._patch = patch;

  OperationBuilder? _trace;
  OperationBuilder get trace => _$this._trace ??= OperationBuilder();
  set trace(OperationBuilder? trace) => _$this._trace = trace;

  PathItemBuilder();

  PathItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _description = $v.description;
      _parameters = $v.parameters?.toBuilder();
      _get = $v.get?.toBuilder();
      _put = $v.put?.toBuilder();
      _post = $v.post?.toBuilder();
      _delete = $v.delete?.toBuilder();
      _options = $v.options?.toBuilder();
      _head = $v.head?.toBuilder();
      _patch = $v.patch?.toBuilder();
      _trace = $v.trace?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PathItem other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$PathItem;
  }

  @override
  void update(void Function(PathItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PathItem build() => _build();

  _$PathItem _build() {
    _$PathItem _$result;
    try {
      _$result = _$v ??
          _$PathItem._(
              description: description,
              parameters: _parameters?.build(),
              get: _get?.build(),
              put: _put?.build(),
              post: _post?.build(),
              delete: _delete?.build(),
              options: _options?.build(),
              head: _head?.build(),
              patch: _patch?.build(),
              trace: _trace?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'parameters';
        _parameters?.build();
        _$failedField = 'get';
        _get?.build();
        _$failedField = 'put';
        _put?.build();
        _$failedField = 'post';
        _post?.build();
        _$failedField = 'delete';
        _delete?.build();
        _$failedField = 'options';
        _options?.build();
        _$failedField = 'head';
        _head?.build();
        _$failedField = 'patch';
        _patch?.build();
        _$failedField = 'trace';
        _trace?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'PathItem', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
