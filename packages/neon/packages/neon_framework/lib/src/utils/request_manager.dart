import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:xml/xml.dart' as xml;

/// A callback that unwraps elements of type [R] into [T].
///
/// This is commonly used to get the relevant information from a broader response.
typedef UnwrapCallback<T, R> = T Function(R);

/// A callback to serialize a value of type [T] into a string.
///
/// This is used to store a value in the cache.
@internal
typedef SerializeCallback<T> = String Function(T);

/// A callback to revive cached values [String] into their original type [T].
@internal
typedef DeserializeCallback<T> = T Function(String);

/// How often a request will be tried.
///
/// A request will not be retried if the returned status code is in the `500`
/// range or if the request has timed out.
const kMaxRetries = 3;

/// The default timeout for requests.
///
/// Requests that take longer than this duration will be canceled.
const kDefaultTimeout = Duration(seconds: 30);

/// A singleton class that handles requests to the Nextcloud API.
///
/// Requests need to be made through the [nextcloud](https://pub.dev/packages/nextcloud)
/// package.
///
/// Requests can be persisted in the local cache if enabled. The local cache
/// must be initialized through [initCache]. A network request is always made,
/// even if a value already exists in the cache. The cached value will only be
/// emitted when the network request has not yet finished.
class RequestManager {
  RequestManager._();

  /// Mocks the singleton instance for testing.
  @visibleForTesting
  factory RequestManager.mocked(RequestManager requestManager) => _requestManager = requestManager;

  static RequestManager? _requestManager;

  /// Gets the current instance of [RequestManager].
  // ignore: prefer_constructors_over_static_methods
  static RequestManager get instance => _requestManager ??= RequestManager._();

  @visibleForTesting
  static set instance(RequestManager? requestManager) => _requestManager = requestManager;

  /// Initializes the cache.
  ///
  /// Requests made before this method has completed will not be persisted in the cache.
  Future<void> initCache() async {
    final cache = Cache();
    await cache.init();

    _cache = cache;
  }

  Cache? _cache;

  /// Executes a request to a Nextcloud API endpoint.
  Future<void> wrapNextcloud<T, B, H>({
    required Account account,
    required String cacheKey,
    required BehaviorSubject<Result<T>> subject,
    required DynamiteRawResponse<B, H> rawResponse,
    required UnwrapCallback<T, DynamiteResponse<B, H>> unwrap,
    bool disableTimeout = false,
  }) async =>
      wrap<T, DynamiteRawResponse<B, H>>(
        account: account,
        cacheKey: cacheKey,
        subject: subject,
        request: () async {
          await rawResponse.future;

          return rawResponse;
        },
        unwrap: (rawResponse) => unwrap(rawResponse.response),
        serialize: (data) => json.encode(data),
        deserialize: (data) => DynamiteRawResponse<B, H>.fromJson(
          json.decode(data) as Map<String, Object?>,
          serializers: rawResponse.serializers,
          bodyType: rawResponse.bodyType,
          headersType: rawResponse.headersType,
        ),
        disableTimeout: disableTimeout,
      );

  /// Executes a WebDAV request.
  Future<void> wrapWebDav<T>({
    required Account account,
    required String cacheKey,
    required BehaviorSubject<Result<T>> subject,
    required AsyncValueGetter<WebDavMultistatus> request,
    required UnwrapCallback<T, WebDavMultistatus> unwrap,
    bool disableTimeout = false,
  }) async =>
      wrap<T, WebDavMultistatus>(
        account: account,
        cacheKey: cacheKey,
        subject: subject,
        request: request,
        unwrap: unwrap,
        serialize: (data) => data.toXmlElement(namespaces: namespaces).toXmlString(),
        deserialize: (data) => WebDavMultistatus.fromXmlElement(xml.XmlDocument.parse(data).rootElement),
        disableTimeout: disableTimeout,
      );

  /// Executes a generic request.
  ///
  /// This method is only meant to be used in testing.
  @visibleForTesting
  Future<void> wrap<T, R>({
    required Account account,
    required String cacheKey,
    required BehaviorSubject<Result<T>> subject,
    required AsyncValueGetter<R> request,
    required UnwrapCallback<T, R> unwrap,
    required SerializeCallback<R> serialize,
    required DeserializeCallback<R> deserialize,
    bool disableTimeout = false,
    Duration timeLimit = kDefaultTimeout,
    int retries = 0,
  }) async {
    final key = '${account.id}-$cacheKey';

    Future<void>? cacheFuture;
    if (retries == 0) {
      // emit loading state with the current value if present
      final value = subject.valueOrNull?.asLoading() ?? Result.loading();
      subject.add(value);

      cacheFuture = _emitCached(
        key,
        subject,
        unwrap,
        deserialize,
      );
    }

    try {
      final response = await timeout(
        request,
        disableTimeout: disableTimeout,
        timeLimit: timeLimit,
      );
      subject.add(Result.success(unwrap(response)));

      final serialized = serialize(response);
      await _cache?.set(key, serialized);
    } on TimeoutException catch (e, s) {
      debugPrint('Request timed out ...');
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s, maxFrames: 5);

      _emitError<T>(e, subject);
    } on http.ClientException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s, maxFrames: 5);

      if (e is DynamiteStatusCodeException && e.statusCode >= 500 && retries < kMaxRetries) {
        debugPrint('Retrying...');
        await wrap(
          account: account,
          cacheKey: cacheKey,
          subject: subject,
          request: request,
          unwrap: unwrap,
          serialize: serialize,
          deserialize: deserialize,
          disableTimeout: disableTimeout,
          timeLimit: timeLimit,
          retries: retries + 1,
        );
      } else {
        _emitError<T>(e, subject);
      }
    }

    await cacheFuture;
  }

  /// Re emits the current result with the given [error].
  ///
  /// Defaults to a [Result.error] if none has been emitted yet.
  void _emitError<T>(
    Object error,
    BehaviorSubject<Result<T>> subject,
  ) {
    final value = subject.valueOrNull?.copyWith(error: error, isLoading: false) ?? Result.error(error);
    subject.add(value);
  }

  /// Retrieves the cached value for the given [key].
  ///
  /// After deserialization and unwrapping it the retrieved value is emitted in
  /// the given [subject] as a cached `Result`.
  ///
  /// Requires the subject to have a value present. If this value is a
  /// successful result no value is emitted.
  Future<void> _emitCached<T, R>(
    String key,
    BehaviorSubject<Result<T>> subject,
    UnwrapCallback<T, R> unwrap,
    DeserializeCallback<R> deserialize,
  ) async {
    final cacheValue = await _cache?.get(key);

    // If the network fetch is faster than fetching the cached value the
    // subject can be closed before emitting.
    if (subject.value.hasSuccessfulData) {
      return;
    }

    if (cacheValue != null) {
      final cached = unwrap(deserialize(cacheValue));

      subject.add(
        subject.value.copyWith(
          data: cached,
          isCached: true,
        ),
      );
    }
  }

  /// Calls a [callback] that is canceled after a given [timeLimit].
  ///
  /// If the callback completes in time the resulting value is returned.
  /// Otherwise the returned future will be completed with a [TimeoutException].
  /// If the timeout is disabled through [disableTimeout] the future of the
  /// callback is returned immediately.
  Future<T> timeout<T>(
    AsyncValueGetter<T> callback, {
    bool disableTimeout = false,
    Duration timeLimit = kDefaultTimeout,
  }) {
    if (disableTimeout) {
      return callback();
    }

    return callback().timeout(timeLimit);
  }
}

@internal
class Cache {
  factory Cache() => instance ??= Cache._();

  Cache._();

  @visibleForTesting
  factory Cache.mocked(Cache mocked) => instance = mocked;

  @visibleForTesting
  static Cache? instance;

  Database? _database;

  Future<void> init() async {
    if (_database != null) {
      return;
    }

    final cacheDir = await getApplicationCacheDirectory();
    _database = await openDatabase(
      p.join(cacheDir.path, 'cache.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE cache (id INTEGER PRIMARY KEY, key TEXT, value TEXT, UNIQUE(key))');
      },
    );
  }

  Database get _requireDatabase {
    final database = _database;
    if (database == null) {
      throw StateError(
        'Cache has not been set up yet. Please make sure Cache.init() has been called before and completed.',
      );
    }

    return database;
  }

  Future<String?> get(String key) async {
    List<Map<String, Object?>>? result;
    try {
      result = await _requireDatabase.rawQuery('SELECT value FROM cache WHERE key = ?', [key]);
    } on DatabaseException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s, maxFrames: 5);
    }

    return result?.firstOrNull?['value'] as String?;
  }

  Future<void> set(String key, String value) async {
    try {
      // UPSERT is only available since SQLite 3.24.0 (June 4, 2018).
      // Using a manual solution from https://stackoverflow.com/a/38463024
      final batch = _requireDatabase.batch()
        ..update('cache', {'key': key, 'value': value}, where: 'key = ?', whereArgs: [key])
        ..rawInsert('INSERT INTO cache (key, value) SELECT ?, ? WHERE (SELECT changes() = 0)', [key, value]);
      await batch.commit(noResult: true);
    } on DatabaseException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s, maxFrames: 5);
    }
  }
}
