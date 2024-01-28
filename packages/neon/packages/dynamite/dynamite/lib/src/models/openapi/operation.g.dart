// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Operation> _$operationSerializer = _$OperationSerializer();

class _$OperationSerializer implements StructuredSerializer<Operation> {
  @override
  final Iterable<Type> types = const [Operation, _$Operation];
  @override
  final String wireName = 'Operation';

  @override
  Iterable<Object?> serialize(Serializers serializers, Operation object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'deprecated',
      serializers.serialize(object.deprecated, specifiedType: const FullType(bool)),
    ];
    Object? value;
    value = object.operationId;
    if (value != null) {
      result
        ..add('operationId')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.summary;
    if (value != null) {
      result
        ..add('summary')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value, specifiedType: const FullType(String)));
    }
    value = object.tags;
    if (value != null) {
      result
        ..add('tags')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltSet, [FullType(String)])));
    }
    value = object.parameters;
    if (value != null) {
      result
        ..add('parameters')
        ..add(serializers.serialize(value, specifiedType: const FullType(BuiltList, [FullType(Parameter)])));
    }
    value = object.requestBody;
    if (value != null) {
      result
        ..add('requestBody')
        ..add(serializers.serialize(value, specifiedType: const FullType(RequestBody)));
    }
    value = object.responses;
    if (value != null) {
      result
        ..add('responses')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltMap, [FullType(String), FullType(Response)])));
    }
    value = object.security;
    if (value != null) {
      result
        ..add('security')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList, [
              FullType(BuiltMap, [
                FullType(String),
                FullType(BuiltList, [FullType(String)])
              ])
            ])));
    }
    return result;
  }

  @override
  Operation deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = OperationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'operationId':
          result.operationId = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'summary':
          result.summary = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'description':
          result.description = serializers.deserialize(value, specifiedType: const FullType(String)) as String?;
          break;
        case 'deprecated':
          result.deprecated = serializers.deserialize(value, specifiedType: const FullType(bool))! as bool;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltSet, [FullType(String)]))! as BuiltSet<Object?>);
          break;
        case 'parameters':
          result.parameters.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [FullType(Parameter)]))! as BuiltList<Object?>);
          break;
        case 'requestBody':
          result.requestBody
              .replace(serializers.deserialize(value, specifiedType: const FullType(RequestBody))! as RequestBody);
          break;
        case 'responses':
          result.responses.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltMap, [FullType(String), FullType(Response)]))!);
          break;
        case 'security':
          result.security.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, [
                FullType(BuiltMap, [
                  FullType(String),
                  FullType(BuiltList, [FullType(String)])
                ])
              ]))! as BuiltList<Object?>);
          break;
      }
    }

    return result.build();
  }
}

class _$Operation extends Operation {
  @override
  final String? operationId;
  @override
  final String? summary;
  @override
  final String? description;
  @override
  final bool deprecated;
  @override
  final BuiltSet<String>? tags;
  @override
  final BuiltList<Parameter>? parameters;
  @override
  final RequestBody? requestBody;
  @override
  final BuiltMap<String, Response>? responses;
  @override
  final BuiltList<BuiltMap<String, BuiltList<String>>>? security;

  factory _$Operation([void Function(OperationBuilder)? updates]) => (OperationBuilder()..update(updates))._build();

  _$Operation._(
      {this.operationId,
      this.summary,
      this.description,
      required this.deprecated,
      this.tags,
      this.parameters,
      this.requestBody,
      this.responses,
      this.security})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(deprecated, r'Operation', 'deprecated');
  }

  @override
  Operation rebuild(void Function(OperationBuilder) updates) => (toBuilder()..update(updates)).build();

  @override
  OperationBuilder toBuilder() => OperationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Operation &&
        operationId == other.operationId &&
        deprecated == other.deprecated &&
        tags == other.tags &&
        parameters == other.parameters &&
        requestBody == other.requestBody &&
        responses == other.responses &&
        security == other.security;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, operationId.hashCode);
    _$hash = $jc(_$hash, deprecated.hashCode);
    _$hash = $jc(_$hash, tags.hashCode);
    _$hash = $jc(_$hash, parameters.hashCode);
    _$hash = $jc(_$hash, requestBody.hashCode);
    _$hash = $jc(_$hash, responses.hashCode);
    _$hash = $jc(_$hash, security.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Operation')
          ..add('operationId', operationId)
          ..add('summary', summary)
          ..add('description', description)
          ..add('deprecated', deprecated)
          ..add('tags', tags)
          ..add('parameters', parameters)
          ..add('requestBody', requestBody)
          ..add('responses', responses)
          ..add('security', security))
        .toString();
  }
}

class OperationBuilder implements Builder<Operation, OperationBuilder> {
  _$Operation? _$v;

  String? _operationId;
  String? get operationId => _$this._operationId;
  set operationId(String? operationId) => _$this._operationId = operationId;

  String? _summary;
  String? get summary => _$this._summary;
  set summary(String? summary) => _$this._summary = summary;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  bool? _deprecated;
  bool? get deprecated => _$this._deprecated;
  set deprecated(bool? deprecated) => _$this._deprecated = deprecated;

  SetBuilder<String>? _tags;
  SetBuilder<String> get tags => _$this._tags ??= SetBuilder<String>();
  set tags(SetBuilder<String>? tags) => _$this._tags = tags;

  ListBuilder<Parameter>? _parameters;
  ListBuilder<Parameter> get parameters => _$this._parameters ??= ListBuilder<Parameter>();
  set parameters(ListBuilder<Parameter>? parameters) => _$this._parameters = parameters;

  RequestBodyBuilder? _requestBody;
  RequestBodyBuilder get requestBody => _$this._requestBody ??= RequestBodyBuilder();
  set requestBody(RequestBodyBuilder? requestBody) => _$this._requestBody = requestBody;

  MapBuilder<String, Response>? _responses;
  MapBuilder<String, Response> get responses => _$this._responses ??= MapBuilder<String, Response>();
  set responses(MapBuilder<String, Response>? responses) => _$this._responses = responses;

  ListBuilder<BuiltMap<String, BuiltList<String>>>? _security;
  ListBuilder<BuiltMap<String, BuiltList<String>>> get security =>
      _$this._security ??= ListBuilder<BuiltMap<String, BuiltList<String>>>();
  set security(ListBuilder<BuiltMap<String, BuiltList<String>>>? security) => _$this._security = security;

  OperationBuilder();

  OperationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _operationId = $v.operationId;
      _summary = $v.summary;
      _description = $v.description;
      _deprecated = $v.deprecated;
      _tags = $v.tags?.toBuilder();
      _parameters = $v.parameters?.toBuilder();
      _requestBody = $v.requestBody?.toBuilder();
      _responses = $v.responses?.toBuilder();
      _security = $v.security?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Operation other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Operation;
  }

  @override
  void update(void Function(OperationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Operation build() => _build();

  _$Operation _build() {
    Operation._defaults(this);
    _$Operation _$result;
    try {
      _$result = _$v ??
          _$Operation._(
              operationId: operationId,
              summary: summary,
              description: description,
              deprecated: BuiltValueNullFieldError.checkNotNull(deprecated, r'Operation', 'deprecated'),
              tags: _tags?.build(),
              parameters: _parameters?.build(),
              requestBody: _requestBody?.build(),
              responses: _responses?.build(),
              security: _security?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'tags';
        _tags?.build();
        _$failedField = 'parameters';
        _parameters?.build();
        _$failedField = 'requestBody';
        _requestBody?.build();
        _$failedField = 'responses';
        _responses?.build();
        _$failedField = 'security';
        _security?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Operation', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
