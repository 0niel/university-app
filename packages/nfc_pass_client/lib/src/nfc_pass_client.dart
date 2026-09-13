import 'dart:async';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:nfc_pass_client/src/grpc_web_response.dart';
import 'package:nfc_pass_client/src/nfc_pass_endpoints.dart';
import 'package:nfc_pass_client/src/nfc_pass_transport_exception.dart';
import 'package:nfc_pass_client/src/nfc_session_cookie.dart';
import 'package:nfc_pass_client/src/nfc_verification_codec.dart';
import 'package:nfc_pass_client/src/nfc_verification_result.dart';
import 'package:nfc_pass_client/src/protos/human_pass.pb.dart';

/// {@template cookie_provider}
/// A function that provides a cookie for the gRPC-Web request.
/// {@endtemplate}
typedef CookieProvider = FutureOr<String> Function();

/// {@template nfc_pass_client}
/// A client that encapsulates access to gRPC endpoints:
///  - GetAccessTokenForDigitalPass
///  - SendVerificationCode
///  - GetDigitalPass
/// {@endtemplate}
class NfcPassClient {
  /// {@macro nfc_pass_client}
  NfcPassClient({
    required CookieProvider cookieProvider,
    required this.endpoints,
    http.Client? httpClient,
    this.requestTimeout = const Duration(seconds: 20),
    this.maxResponseBytes = 1024 * 1024,
  })  : assert(requestTimeout > Duration.zero, 'Timeout must be positive.'),
        assert(maxResponseBytes > 0, 'Response limit must be positive.'),
        _onCookieRequested = cookieProvider,
        httpClient = httpClient ?? http.Client();

  final CookieProvider _onCookieRequested;

  /// Institution-specific gRPC-Web endpoints.
  final NfcPassEndpoints endpoints;

  /// The HTTP client used to send requests.
  final http.Client httpClient;

  final Duration requestTimeout;
  final int maxResponseBytes;

  /// Creates a gRPC-Web frame from the specified protobuf message.
  Uint8List _makeGrpcWebFrame(Uint8List protobufMessage) {
    final header = Uint8List(5);
    header[0] = 0;
    final length = protobufMessage.length;
    header[1] = (length >> 24) & 0xFF;
    header[2] = (length >> 16) & 0xFF;
    header[3] = (length >> 8) & 0xFF;
    header[4] = length & 0xFF;
    return Uint8List.fromList([...header, ...protobufMessage]);
  }

  /// Sends a gRPC-Web request to the specified URL.
  Future<Uint8List> _sendGrpcWebRequest({
    required String url,
    required Uint8List protobufMessage,
    Map<String, String> headers = const {},
  }) async {
    final uri = Uri.parse(url);
    if (uri.scheme != 'https' || uri.host.isEmpty || uri.userInfo.isNotEmpty) {
      throw ArgumentError('NFC endpoints must use HTTPS without user info.');
    }
    final abort = Completer<void>();
    final request =
        http.AbortableRequest('POST', uri, abortTrigger: abort.future)
          ..followRedirects = false
          ..headers.addAll({
            'Content-Type': 'application/grpc-web+proto',
            'Accept': 'application/grpc-web+proto',
            'x-grpc-web': '1',
            ...headers,
          })
          ..bodyBytes = _makeGrpcWebFrame(protobufMessage);
    try {
      return await _readResponse(request).timeout(requestTimeout);
    } finally {
      if (!abort.isCompleted) abort.complete();
    }
  }

  Future<Uint8List> _readResponse(http.BaseRequest request) async {
    final response = await httpClient.send(request);
    if (response.statusCode != 200) {
      await response.stream.listen(null).cancel();
      throw NfcPassTransportException(
        'HTTP request failed with status ${response.statusCode}.',
        httpStatusCode: response.statusCode,
      );
    }
    if ((response.contentLength ?? 0) > maxResponseBytes) {
      await response.stream.listen(null).cancel();
      throw const FormatException('gRPC-Web response exceeds size limit.');
    }
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in response.stream) {
      if (chunk.length > maxResponseBytes - bytes.length) {
        throw const FormatException('gRPC-Web response exceeds size limit.');
      }
      bytes.add(chunk);
    }
    return parseGrpcWebResponse(
      bytes.takeBytes(),
      headers: response.headers,
    );
  }

  Future<String> _cookieHeader(String? sessionCookie) async {
    final cookie = sessionCookie ?? await _onCookieRequested();
    if (cookie.isEmpty) {
      throw const NfcPassTransportException(
        'An authenticated session is required.',
        grpcStatus: 16,
      );
    }
    return nfcSessionCookieHeader(cookie);
  }

  /// Obtaining JWT token for DigitalPass.
  ///
  /// This token is used to authenticate subsequent requests.
  Future<String> getAccessTokenForDigitalPass({String? sessionCookie}) async {
    final cookie = await _cookieHeader(sessionCookie);
    final request = GetAccessTokenForDigitalPassRequest();
    final protobufBytes = request.writeToBuffer();

    final responseBytes = await _sendGrpcWebRequest(
      url: endpoints.accessTokenUrl.toString(),
      protobufMessage: protobufBytes,
      headers: {
        'Cookie': cookie,
      },
    );

    final response = GetAccessTokenForDigitalPassResponse.fromBuffer(
      responseBytes,
    );
    if (!RegExp(r'^[A-Za-z0-9._~-]+$').hasMatch(response.jwt)) {
      throw const FormatException('Invalid digital-pass access token.');
    }
    return response.jwt;
  }

  /// Requests a code through the account's verification method.
  Future<NfcVerificationResult> sendVerificationCode(
    String bearerToken, {
    String? sessionCookie,
  }) async {
    final cookie = await _cookieHeader(sessionCookie);
    final request = SendVerificationCodeRequest();
    final protobufBytes = request.writeToBuffer();

    final response = await _sendGrpcWebRequest(
      url: endpoints.sendVerificationCodeUrl.toString(),
      protobufMessage: protobufBytes,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Cookie': cookie,
      },
    );
    return NfcVerificationCodec.decodeCode(response);
  }

  /// Obtaining a digital pass.
  ///
  /// Returns the pass ID. This ID is used in the NFC pass.
  Future<int> getDigitalPass({
    required String bearerToken,
    required String sixDigitCode,
    required String deviceName,
    String? sessionCookie,
  }) async {
    final cookie = await _cookieHeader(sessionCookie);
    final request = GetDigitalPassRequest()
      ..receivedCode = sixDigitCode
      ..deviceInfo = (DeviceInfo()..deviceInfoRaw = deviceName);
    final protobufBytes = request.writeToBuffer();

    final responseBytes = await _sendGrpcWebRequest(
      url: endpoints.getDigitalPassUrl.toString(),
      protobufMessage: protobufBytes,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Cookie': cookie,
      },
    );

    return NfcVerificationCodec.decodePass(responseBytes);
  }
}
