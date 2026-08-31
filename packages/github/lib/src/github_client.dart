import 'dart:convert';
import 'dart:io';

import 'package:github/src/github_api_malformed_response.dart';
import 'package:github/src/github_api_request_failure.dart';
import 'package:github/src/models/contributor.dart';
import 'package:http/http.dart' as http;

class GithubClient {
  GithubClient({http.Client? httpClient})
    : this._(baseUrl: 'https://api.github.com', httpClient: httpClient);

  GithubClient._({required String baseUrl, http.Client? httpClient})
    : _baseUrl = baseUrl,
      _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  Future<List<Contributor>> getContributors({
    String owner = '0niel',
    String repo = 'university-app',
  }) async {
    final uri = Uri.parse('$_baseUrl/repos/$owner/$repo/contributors').replace(
      queryParameters: const {'per_page': '100'},
    );
    final response = await _httpClient.get(
      uri,
      headers: _requestHeaders,
    );
    if (response.statusCode != HttpStatus.ok) {
      throw GithubApiRequestFailure(
        body: response.body,
        statusCode: response.statusCode,
      );
    }

    return response.jsonArray().map(_contributorFromJson).toList();
  }

  static const Map<String, String> _requestHeaders = {
    HttpHeaders.acceptHeader: 'application/vnd.github+json',
    HttpHeaders.contentTypeHeader: 'application/json',
  };
}

Contributor _contributorFromJson(Map<String, Object?> json) =>
    Contributor.fromJson(json.cast());

extension on http.Response {
  List<Map<String, Object?>> jsonArray() {
    try {
      final decoded = jsonDecode(body);
      if (decoded is! List) {
        throw const FormatException('Expected a JSON array.');
      }

      return decoded.map(_jsonObject).toList();
    } on FormatException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        GithubApiMalformedResponse(error: error),
        stackTrace,
      );
    }
  }
}

Map<String, Object?> _jsonObject(Object? value) {
  if (value case final Map<String, Object?> object) return object;
  throw const FormatException('Expected every array item to be an object.');
}
