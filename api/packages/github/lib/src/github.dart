import 'dart:convert';
import 'dart:io';

import 'package:github/src/models/contributor.dart';
import 'package:http/http.dart' as http;

/// {@template github_api_malformed_response}
/// Thrown when the response body is not a valid JSON object.
/// {@endtemplate}
class GithubApiMalformedResponse implements Exception {
  /// {@macro github_api_malformed_response}
  const GithubApiMalformedResponse({required this.error});

  /// Associated error.
  final Object error;
}

/// {@template github_api_request_failure}
/// Thrown when the request fails.
/// {@endtemplate}
class GithubApiRequestFailure implements Exception {
  /// {@macro github_api_request_failure}
  const GithubApiRequestFailure({
    required this.statusCode,
    required this.body,
  });

  /// The response status code.
  final int statusCode;

  /// The response body.
  final String body;
}

/// {@template github_api_client}
/// Client for interacting with the GitHub API.
/// {@endtemplate}
class GithubClient {
  /// {@macro github_api_client}
  GithubClient({
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://api.github.com',
          httpClient: httpClient,
        );

  GithubClient._({
    required String baseUrl,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  /// Returns a list of contributors for the given [owner] and [repo].
  ///
  /// Throws a [GithubApiRequestFailure] if the request fails.
  /// Throws a [GithubApiMalformedResponse] if the response body is not a
  /// valid JSON object.
  Future<List<Contributor>> getContributors({
    String owner = '0niel',
    String repo = 'university-app',
  }) async {
    final uri = Uri.parse('$_baseUrl/repos/$owner/$repo/contributors');

    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    final body = response.jsonArray();

    if (response.statusCode != HttpStatus.ok) {
      throw GithubApiRequestFailure(
        body: response.body,
        statusCode: response.statusCode,
      );
    }

    return body.map(Contributor.fromJson).toList();
  }

  Future<Map<String, String>> _getRequestHeaders() async {
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
    };
  }
}

extension on http.Response {
  List<Map<String, dynamic>> jsonArray() {
    try {
      return (jsonDecode(body) as List<dynamic>).cast<Map<String, dynamic>>().toList();
    } on FormatException catch (e) {
      throw GithubApiMalformedResponse(error: e);
    }
  }
}
