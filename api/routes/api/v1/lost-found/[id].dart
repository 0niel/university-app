// GET /api/v1/lost_and_found/[id] - get item by id
// PUT /api/v1/lost_and_found/[id] - update item
// DELETE /api/v1/lost_and_found/[id] - delete item
import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/src/data/lost_and_found/lost_and_found_data_source.dart';
import 'package:university_app_server_api/src/data/lost_and_found/models/lost_and_found_item.dart';

FutureOr<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context, id);
    case HttpMethod.put:
      return _put(context, id);
    case HttpMethod.delete:
      return _delete(context, id);
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.post:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context, String id) async {
  final dataSource = context.read<LostAndFoundDataSource>();
  final item = await dataSource.getItemById(id);

  if (item == null) {
    return Response(statusCode: HttpStatus.notFound);
  }

  return Response.json(body: item.toJson());
}

Future<Response> _put(RequestContext context, String id) async {
  final dataSource = context.read<LostAndFoundDataSource>();

  final body = await context.request.json() as Map<String, dynamic>;
  final item = LostFoundItem.fromJson(body);
  final updated = await dataSource.updateItem(id, item);

  return Response.json(body: updated.toJson());
}

Future<Response> _delete(RequestContext context, String id) async {
  final dataSource = context.read<LostAndFoundDataSource>();
  await dataSource.deleteItem(id);

  return Response(statusCode: HttpStatus.noContent);
}
