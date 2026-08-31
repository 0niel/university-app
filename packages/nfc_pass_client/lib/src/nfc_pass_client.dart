import 'dart:async';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:nfc_pass_client/src/nfc_pass_endpoints.dart';
import 'package:nfc_pass_client/src/protos/human_pass.pb.dart';
import 'package:random_user_agents/random_user_agents.dart';

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
  })  : _onCookieRequested = cookieProvider,
        httpClient = httpClient ?? http.Client();

  final CookieProvider _onCookieRequested;

  /// Institution-specific gRPC-Web endpoints.
  final NfcPassEndpoints endpoints;

  /// The HTTP client used to send requests.
  final http.Client httpClient;

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

  /// Parses the gRPC-Web response.
  Uint8List _parseGrpcWebResponse(Uint8List responseBody) {
    final responseHex = responseBody
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join(' ');
    developer.log('hex response: $responseHex');

    if (responseBody.length < 5) {
      throw const FormatException('Слишком короткий ответ, нет gRPC header.');
    }

    final [flags, lengthByte1, lengthByte2, lengthByte3, lengthByte4, ...] =
        responseBody;
    if (flags != 0) {
      throw FormatException('Неподдерживаемые gRPC flags: $flags');
    }

    final length = (lengthByte1 << 24) |
        (lengthByte2 << 16) |
        (lengthByte3 << 8) |
        lengthByte4;

    if (responseBody.length < 5 + length) {
      throw FormatException(
        'Длина gRPC payload $length не совпадает с фактической '
        '${responseBody.length - 5}',
      );
    }

    final payload = responseBody.sublist(5, 5 + length);

    if (responseBody.length > 5 + length) {
      developer.log(
        'Внимание: Дополнительные байты в ответе: '
        '${responseBody.length - (5 + length)}',
      );
    }

    return payload;
  }

  /// Sends a gRPC-Web request to the specified URL.
  Future<Uint8List> _sendGrpcWebRequest({
    required String url,
    required Uint8List protobufMessage,
    Map<String, String> headers = const {},
  }) async {
    final frame = _makeGrpcWebFrame(protobufMessage);
    final ua = RandomUserAgents.random();
    final response = await httpClient.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/grpc-web+proto',
        'x-grpc-web': '1',
        'User-Agent': ua,
        ...headers,
      },
      body: frame,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'HTTP ${response.statusCode} – Ошибка при вызове gRPC-Web метода',
      );
    }

    final responseBytes = response.bodyBytes;
    return _parseGrpcWebResponse(responseBytes);
  }

  /// Obtaining JWT token for DigitalPass.
  ///
  /// This token is used to authenticate subsequent requests.
  Future<String> getAccessTokenForDigitalPass() async {
    final cookie = await _onCookieRequested();
    final request = GetAccessTokenForDigitalPassRequest();
    final protobufBytes = request.writeToBuffer();

    final responseBytes = await _sendGrpcWebRequest(
      url: endpoints.accessTokenUrl.toString(),
      protobufMessage: protobufBytes,
      headers: {
        'Cookie': '.AspNetCore.Cookies=$cookie',
      },
    );

    final response = GetAccessTokenForDigitalPassResponse.fromBuffer(
      responseBytes,
    );
    return response.jwt;
  }

  /// Sending a verification code to the user's email.
  Future<void> sendVerificationCode(String bearerToken) async {
    final cookie = await _onCookieRequested();
    final request = SendVerificationCodeRequest();
    final protobufBytes = request.writeToBuffer();

    await _sendGrpcWebRequest(
      url: endpoints.sendVerificationCodeUrl.toString(),
      protobufMessage: protobufBytes,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Cookie': '.AspNetCore.Cookies=$cookie',
      },
    );
  }

  /// Obtaining a digital pass.
  ///
  /// Returns the pass ID. This ID is used in the NFC pass.
  Future<int> getDigitalPass({
    required String bearerToken,
    required String sixDigitCode,
    required String deviceName,
  }) async {
    final cookie = await _onCookieRequested();
    final request = GetDigitalPassRequest()
      ..code = sixDigitCode
      ..deviceInfo = (DeviceInfo()..deviceName = deviceName);
    final protobufBytes = request.writeToBuffer();

    final responseBytes = await _sendGrpcWebRequest(
      url: endpoints.getDigitalPassUrl.toString(),
      protobufMessage: protobufBytes,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Cookie': '.AspNetCore.Cookies=$cookie',
      },
    );

    final response = GetDigitalPassResponse.fromBuffer(responseBytes);
    return response.inner.passId.toInt();
  }
}
