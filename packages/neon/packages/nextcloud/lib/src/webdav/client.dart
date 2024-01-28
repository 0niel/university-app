import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dynamite_runtime/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:nextcloud/src/webdav/path_uri.dart';
import 'package:nextcloud/src/webdav/props.dart';
import 'package:nextcloud/src/webdav/webdav.dart';
import 'package:universal_io/io.dart' hide HttpClient;

/// Base path used on the server
final webdavBase = PathUri.parse('/remote.php/webdav');

@internal
class WebDavRequest extends http.BaseRequest {
  WebDavRequest(
    super.method,
    super.url, {
    this.dataStream,
    this.data,
    Map<String, String>? headers,
  }) : assert(dataStream == null || data == null, 'Only one of dataStream or data can be specified.') {
    this.headers.addAll({
      ...?headers,
      HttpHeaders.contentTypeHeader: 'application/xml',
    });
  }

  final Stream<List<int>>? dataStream;
  final Uint8List? data;

  @override
  http.ByteStream finalize() {
    super.finalize();

    if (dataStream != null) {
      return http.ByteStream(dataStream!);
    }

    if (data != null) {
      return http.ByteStream.fromBytes(data!);
    }

    return http.ByteStream.fromBytes(Uint8List(0));
  }
}

/// WebDavClient class
class WebDavClient {
  // ignore: public_member_api_docs
  WebDavClient(this.rootClient);

  // ignore: public_member_api_docs
  final DynamiteClient rootClient;

  Future<http.StreamedResponse> _send(
    String method,
    Uri url, {
    Stream<List<int>>? dataStream,
    Uint8List? data,
    Map<String, String>? headers,
  }) async {
    final request = WebDavRequest(
      method,
      url,
      data: data,
      dataStream: dataStream,
      headers: headers,
    );

    request.headers.addAll({
      ...?rootClient.baseHeaders,
      ...?rootClient.authentications?.firstOrNull?.headers,
    });

    final response = await rootClient.httpClient.send(request);

    if (response.statusCode >= 300) {
      throw DynamiteStatusCodeException(
        response.statusCode,
      );
    }

    return response;
  }

  Uri _constructUri([PathUri? path]) => constructUri(rootClient.baseURL, path);

  @visibleForTesting
  // ignore: public_member_api_docs
  static Uri constructUri(Uri baseURL, [PathUri? path]) {
    final segments = baseURL.pathSegments.toList()..addAll(webdavBase.pathSegments);
    if (path != null) {
      segments.addAll(path.pathSegments);
    }
    return baseURL.replace(pathSegments: segments.where((s) => s.isNotEmpty));
  }

  Future<WebDavMultistatus> _parseResponse(http.StreamedResponse response) async =>
      WebDavMultistatus.fromXmlElement(await response.stream.xml);

  Map<String, String> _getUploadHeaders({
    required DateTime? lastModified,
    required DateTime? created,
    required int? contentLength,
  }) =>
      {
        if (lastModified != null) 'X-OC-Mtime': (lastModified.millisecondsSinceEpoch ~/ 1000).toString(),
        if (created != null) 'X-OC-CTime': (created.millisecondsSinceEpoch ~/ 1000).toString(),
        if (contentLength != null) HttpHeaders.contentLengthHeader: contentLength.toString(),
      };

  /// Gets the WebDAV capabilities of the server.
  Future<WebDavOptions> options() async {
    final response = await _send(
      'OPTIONS',
      _constructUri(),
    );

    final davCapabilities = response.headers['dav'];
    final davSearchCapabilities = response.headers['dasl'];
    return WebDavOptions(
      davCapabilities?.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toSet(),
      davSearchCapabilities?.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toSet(),
    );
  }

  /// Creates a collection at [path].
  ///
  /// See http://www.webdav.org/specs/rfc2518.html#METHOD_MKCOL for more information.
  Future<http.StreamedResponse> mkcol(PathUri path) async => _send(
        'MKCOL',
        _constructUri(path),
      );

  /// Deletes the resource at [path].
  ///
  /// See http://www.webdav.org/specs/rfc2518.html#METHOD_DELETE for more information.
  Future<http.StreamedResponse> delete(PathUri path) => _send(
        'DELETE',
        _constructUri(path),
      );

  /// Puts a new file at [path] with [localData] as content.
  ///
  /// [lastModified] sets the date when the file was last modified on the server.
  /// [created] sets the date when the file was created on the server.
  /// See http://www.webdav.org/specs/rfc2518.html#METHOD_PUT for more information.
  Future<http.StreamedResponse> put(
    Uint8List localData,
    PathUri path, {
    DateTime? lastModified,
    DateTime? created,
  }) =>
      _send(
        'PUT',
        _constructUri(path),
        data: localData,
        headers: _getUploadHeaders(
          lastModified: lastModified,
          created: created,
          contentLength: localData.length,
        ),
      );

  /// Puts a new file at [path] with [localData] as content.
  ///
  /// [lastModified] sets the date when the file was last modified on the server.
  /// [created] sets the date when the file was created on the server.
  /// [contentLength] sets the length of the [localData] that is uploaded.
  /// [onProgress] can be used to watch the upload progress. Possible values range from 0.0 to 1.0. [contentLength] needs to be set for it to work.
  /// See http://www.webdav.org/specs/rfc2518.html#METHOD_PUT for more information.
  Future<http.StreamedResponse> putStream(
    Stream<List<int>> localData,
    PathUri path, {
    DateTime? lastModified,
    DateTime? created,
    int? contentLength,
    void Function(double progress)? onProgress,
  }) async {
    var uploaded = 0;
    return _send(
      'PUT',
      _constructUri(path),
      dataStream: contentLength != null && onProgress != null
          ? localData.map((chunk) {
              uploaded += chunk.length;
              onProgress.call(uploaded / contentLength);
              return chunk;
            })
          : localData,
      headers: _getUploadHeaders(
        lastModified: lastModified,
        created: created,
        contentLength: contentLength,
      ),
    );
  }

  /// Puts a new file at [path] with [file] as content.
  ///
  /// [lastModified] sets the date when the file was last modified on the server.
  /// [created] sets the date when the file was created on the server.
  /// [onProgress] can be used to watch the upload progress. Possible values range from 0.0 to 1.0.
  /// See http://www.webdav.org/specs/rfc2518.html#METHOD_PUT for more information.
  Future<http.StreamedResponse> putFile(
    File file,
    FileStat fileStat,
    PathUri path, {
    DateTime? lastModified,
    DateTime? created,
    void Function(double progress)? onProgress,
  }) async =>
      putStream(
        file.openRead(),
        path,
        lastModified: lastModified,
        created: created,
        contentLength: fileStat.size,
        onProgress: onProgress,
      );

  /// Gets the content of the file at [path].
  Future<Uint8List> get(PathUri path) async => (await getStream(path)).stream.bytes;

  /// Gets the content of the file at [path].
  Future<http.StreamedResponse> getStream(PathUri path) async => _send(
        'GET',
        _constructUri(path),
      );

  /// Gets the content of the file at [path].
  ///
  /// If the response is empty the file will be created with no data.
  Future<void> getFile(
    PathUri path,
    File file, {
    void Function(double progress)? onProgress,
  }) async {
    final response = await getStream(path);
    final contentLength = response.contentLength;

    if (contentLength == null || contentLength <= 0) {
      await file.create();
      onProgress?.call(1);
      return;
    }

    final sink = file.openWrite();
    final completer = Completer<void>();
    var downloaded = 0;

    response.stream.listen((chunk) async {
      sink.add(chunk);
      downloaded += chunk.length;
      onProgress?.call(downloaded / contentLength);
      if (downloaded >= contentLength) {
        completer.complete();
      }
    });
    await completer.future;
    await sink.close();
  }

  /// Retrieves the props for the resource at [path].
  ///
  /// Optionally populates the given [prop]s on the returned resources.
  /// [depth] can be used to limit scope of the returned resources.
  /// See http://www.webdav.org/specs/rfc2518.html#METHOD_PROPFIND for more information.
  Future<WebDavMultistatus> propfind(
    PathUri path, {
    WebDavPropWithoutValues? prop,
    WebDavDepth? depth,
  }) async =>
      _parseResponse(
        await _send(
          'PROPFIND',
          _constructUri(path),
          data: utf8.encode(
            WebDavPropfind(prop: prop ?? const WebDavPropWithoutValues())
                .toXmlElement(namespaces: namespaces)
                .toXmlString(),
          ),
          headers: depth != null ? {'Depth': depth.value} : null,
        ),
      );

  /// Runs the filter-files report with the [filterRules] on the resource at [path].
  ///
  /// Optionally populates the [prop]s on the returned resources.
  /// See https://github.com/owncloud/docs/issues/359 for more information.
  Future<WebDavMultistatus> report(
    PathUri path,
    WebDavOcFilterRules filterRules, {
    WebDavPropWithoutValues? prop,
  }) async =>
      _parseResponse(
        await _send(
          'REPORT',
          _constructUri(path),
          data: utf8.encode(
            WebDavOcFilterFiles(
              filterRules: filterRules,
              prop: prop ?? const WebDavPropWithoutValues(), // coverage:ignore-line
            ).toXmlElement(namespaces: namespaces).toXmlString(),
          ),
        ),
      );

  /// Updates the props of the resource at [path].
  ///
  /// The props in [set] will be updated.
  /// The props in [remove] will be removed.
  /// Returns true if the update was successful.
  /// See http://www.webdav.org/specs/rfc2518.html#METHOD_PROPPATCH for more information.
  Future<bool> proppatch(
    PathUri path, {
    WebDavProp? set,
    WebDavPropWithoutValues? remove,
  }) async {
    final response = await _send(
      'PROPPATCH',
      _constructUri(path),
      data: utf8.encode(
        WebDavPropertyupdate(
          set: set != null ? WebDavSet(prop: set) : null,
          remove: remove != null ? WebDavRemove(prop: remove) : null,
        ).toXmlElement(namespaces: namespaces).toXmlString(),
      ),
    );
    final data = await _parseResponse(response);
    for (final a in data.responses) {
      for (final b in a.propstats) {
        if (!b.status.contains('200')) {
          return false;
        }
      }
    }
    return true;
  }

  /// Moves the resource from [sourcePath] to [destinationPath].
  ///
  /// If [overwrite] is set any existing resource will be replaced.
  /// See http://www.webdav.org/specs/rfc2518.html#METHOD_MOVE for more information.
  Future<http.StreamedResponse> move(
    PathUri sourcePath,
    PathUri destinationPath, {
    bool overwrite = false,
  }) =>
      _send(
        'MOVE',
        _constructUri(sourcePath),
        headers: {
          'Destination': _constructUri(destinationPath).toString(),
          'Overwrite': overwrite ? 'T' : 'F',
        },
      );

  /// Copies the resource from [sourcePath] to [destinationPath].
  ///
  /// If [overwrite] is set any existing resource will be replaced.
  /// See http://www.webdav.org/specs/rfc2518.html#METHOD_COPY for more information.
  Future<http.StreamedResponse> copy(
    PathUri sourcePath,
    PathUri destinationPath, {
    bool overwrite = false,
  }) =>
      _send(
        'COPY',
        _constructUri(sourcePath),
        headers: {
          'Destination': _constructUri(destinationPath).toString(),
          'Overwrite': overwrite ? 'T' : 'F',
        },
      );
}

/// WebDAV capabilities
class WebDavOptions {
  /// Creates a new WebDavStatus.
  WebDavOptions(
    Set<String>? capabilities,
    Set<String>? searchCapabilities,
  )   : capabilities = capabilities ?? {},
        searchCapabilities = searchCapabilities ?? {};

  /// DAV capabilities as advertised by the server in the 'dav' header.
  Set<String> capabilities;

  /// DAV search and locating capabilities as advertised by the server in the 'dasl' header.
  Set<String> searchCapabilities;
}

/// Depth used for [WebDavClient.propfind].
///
/// See http://www.webdav.org/specs/rfc2518.html#HEADER_Depth for more information.
enum WebDavDepth {
  /// Returns props of the resource.
  zero('0'),

  /// Returns props of the resource and its immediate children.
  ///
  /// Only works on collections and returns the same as [WebDavDepth.zero] for other resources.
  one('1'),

  /// Returns props of the resource and all its progeny.
  ///
  /// Only works on collections and returns the same as [WebDavDepth.zero] for other resources.
  infinity('infinity');

  const WebDavDepth(this.value);

  // ignore: public_member_api_docs
  final String value;
}
