// GET /api/v1/lost_and_found - list items, filter by status, pagination
// POST /api/v1/lost_and_found - create item
import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:university_app_server_api/src/data/lost_and_found/lost_and_found_data_source.dart';
import 'package:university_app_server_api/src/data/lost_and_found/models/lost_and_found_item.dart';
import 'package:university_app_server_api/src/models/lost_and_found/lost_found_items_response.dart';

FutureOr<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _get(context);
    case HttpMethod.post:
      return _post(context);
    case HttpMethod.delete:
    case HttpMethod.head:
    case HttpMethod.options:
    case HttpMethod.patch:
    case HttpMethod.put:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _get(RequestContext context) async {
  final dataSource = context.read<LostAndFoundDataSource>();
  final query = context.request.uri.queryParameters;

  // Parse query parameters
  final status =
      query['status'] != null ? LostFoundItemStatus.values.firstWhere((e) => e.name == query['status']) : null;
  final limit = query['limit'] != null ? int.tryParse(query['limit']!) : null;
  final offset = query['offset'] != null ? int.tryParse(query['offset']!) : null;

  final items = await dataSource.getItems(
    status: status,
    limit: limit,
    offset: offset,
  );

  final response = LostFoundItemsResponse(items: items);
  return Response.json(body: response.toJson());
}

Future<Response> _post(RequestContext context) async {
  final dataSource = context.read<LostAndFoundDataSource>();

  final body = await context.request.json() as Map<String, dynamic>;
  final item = LostFoundItem.fromJson(body);
  final created = await dataSource.createItem(item);

  return Response.json(
    body: created.toJson(),
    statusCode: HttpStatus.created,
  );
}
