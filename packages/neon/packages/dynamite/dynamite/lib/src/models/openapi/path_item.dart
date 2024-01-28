import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:dynamite/src/models/openapi/operation.dart';
import 'package:dynamite/src/models/openapi/parameter.dart';

part 'path_item.g.dart';

abstract class PathItem implements Built<PathItem, PathItemBuilder> {
  factory PathItem([void Function(PathItemBuilder) updates]) = _$PathItem;

  const PathItem._();

  static Serializer<PathItem> get serializer => _$pathItemSerializer;

  @BuiltValueField(compare: false)
  String? get description;

  BuiltList<Parameter>? get parameters;

  Operation? get get;

  Operation? get put;

  Operation? get post;

  Operation? get delete;

  Operation? get options;

  Operation? get head;

  Operation? get patch;

  Operation? get trace;

  Map<PathItemOperation, Operation> get operations => <PathItemOperation, Operation>{
        if (get != null) PathItemOperation.get: get!,
        if (put != null) PathItemOperation.put: put!,
        if (post != null) PathItemOperation.post: post!,
        if (delete != null) PathItemOperation.delete: delete!,
        if (options != null) PathItemOperation.options: options!,
        if (head != null) PathItemOperation.head: head!,
        if (patch != null) PathItemOperation.patch: patch!,
        if (trace != null) PathItemOperation.trace: trace!,
      };
}

enum PathItemOperation {
  get,
  put,
  post,
  delete,
  options,
  head,
  patch,
  trace,
}
