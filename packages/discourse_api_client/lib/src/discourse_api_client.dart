import 'dart:convert';
import 'dart:io';

import 'package:discourse_api_client/src/models/models.dart';
import 'package:http/http.dart' as http;

class DiscourseApiMalformedResponse implements Exception {
  const DiscourseApiMalformedResponse({required this.error});

  final Object error;
}

class DiscourseApiRequestFailure implements Exception {
  const DiscourseApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;

  final Map<String, dynamic> body;
}

class DiscourseApiClient {
  DiscourseApiClient({
    required String baseUrl,
    http.Client? httpClient,
  }) : this._(
          baseUrl: baseUrl,
          httpClient: httpClient,
        );

  DiscourseApiClient._({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  Future<Top> getTop() async {
    final uri = Uri.parse('$_baseUrl/top.json?period=monthly');
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw DiscourseApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return Top.fromJson(body);
  }

  Future<Post> getPost(int id) async {
    final uri = Uri.parse('$_baseUrl/posts/$id.json');
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw DiscourseApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    return Post.fromJson(body);
  }

  Future<Map<String, String>> _getRequestHeaders() async {
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
    };
  }
}

extension on http.Response {
  Map<String, dynamic> json() {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        DiscourseApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}
