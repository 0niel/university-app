import 'dart:convert';
import 'dart:io';

import 'package:discourse_api_client/src/discourse_api_exceptions.dart';
import 'package:discourse_api_client/src/models/models.dart';
import 'package:http/http.dart' as http;

/// {@template discourse_api_client}
/// A thin HTTP client over a Discourse forum, fetching top topics, individual
/// posts and a topic's full post stream as typed models.
/// {@endtemplate}
class DiscourseApiClient {
  /// {@macro discourse_api_client}
  DiscourseApiClient({required String baseUrl, http.Client? httpClient})
    : this._(baseUrl: baseUrl, httpClient: httpClient);

  DiscourseApiClient._({
    required this._baseUrl,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;

  Future<Top> getTop() async {
    final uri = Uri.parse('$_baseUrl/top.json?period=monthly');
    final response = await _httpClient.get(
      uri,
      headers: _requestHeaders,
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
      headers: _requestHeaders,
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

  /// Fetches the posts of a topic (the whole thread: first post + replies)
  /// from `/t/{topicId}.json`, mapping `post_stream.posts[]` to [TopicPost].
  Future<List<TopicPost>> getTopicPosts(int topicId) async {
    final uri = Uri.parse('$_baseUrl/t/$topicId.json');
    final response = await _httpClient.get(
      uri,
      headers: _requestHeaders,
    );

    final body = response.json();

    if (response.statusCode != HttpStatus.ok) {
      throw DiscourseApiRequestFailure(
        body: body,
        statusCode: response.statusCode,
      );
    }

    final postStream = body['post_stream'];
    final posts = postStream is Map<String, dynamic>
        ? postStream['posts']
        : null;
    if (posts is! List) {
      throw DiscourseApiMalformedResponse(
        error: 'post_stream.posts missing in topic $topicId response',
      );
    }

    return posts
        .whereType<Map<String, dynamic>>()
        .map(TopicPost.fromJson)
        .toList();
  }

  Map<String, String> get _requestHeaders {
    return {
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
