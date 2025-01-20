import 'dart:async';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:nfc_pass_client/src/protos/human_pass.pb.dart';
import 'package:random_user_agents/random_user_agents.dart';

/// {@template cookie_provider}
/// A function that provides a cookie for the gRPC-Web request.
/// {@endtemplate}
typedef CookieProvider = FutureOr<String> Function();

/// {@template nfc_pass_client}
/// A class that encapsulates  access to gRPC endpoints:
///  - GetAccessTokenForDigitalPass
///  - SendVerificationCode
///  - GetDigitalPass
/// {@endtemplate}
class NfcPassClient {
  /// {@macro nfc_pass_client}
  NfcPassClient({
    required this.cookieProvider,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  /// {@macro cookie_provider}
  final CookieProvider cookieProvider;

  /// The HTTP client used to send requests.
  final http.Client httpClient;

  /// Creates a gRPC-Web frame from the specified protobuf message.
  Uint8List _makeGrpcWebFrame(Uint8List protobufMessage) {
    final header = Uint8List(5);
    header[0] = 0; // flags
    final length = protobufMessage.length;
    header[1] = (length >> 24) & 0xFF;
    header[2] = (length >> 16) & 0xFF;
    header[3] = (length >> 8) & 0xFF;
    header[4] = length & 0xFF;
    return Uint8List.fromList([...header, ...protobufMessage]);
  }

  /// Parses the gRPC-Web response.
  Uint8List _parseGrpcWebResponse(Uint8List responseBody) {
    developer.log(
      'hex response: ${responseBody.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}',
    );

    if (responseBody.length < 5) {
      throw const FormatException('Слишком короткий ответ, нет gRPC header.');
    }

    final flags = responseBody[0];
    if (flags != 0) {
      throw FormatException('Неподдерживаемые gRPC flags: $flags');
    }

    final length = (responseBody[1] << 24) | (responseBody[2] << 16) | (responseBody[3] << 8) | responseBody[4];

    if (responseBody.length < 5 + length) {
      throw FormatException(
        'Длина gRPC payload $length не совпадает с фактической ${responseBody.length - 5}',
      );
    }

    final payload = responseBody.sublist(5, 5 + length);

    if (responseBody.length > 5 + length) {
      developer.log(
        'Внимание: Дополнительные байты в ответе: ${responseBody.length - (5 + length)}',
      );
    }

    return payload;
  }

  /// Sends a gRPC-Web request to the specified URL.
  Future<Uint8List> _sendGrpcWebRequest({
    required String url,
    required Uint8List protobufMessage,
    Map<String, String>? headers,
  }) async {
    final frame = _makeGrpcWebFrame(protobufMessage);
    final ua = RandomUserAgents.random();
    final response = await httpClient.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/grpc-web+proto',
        'x-grpc-web': '1',
        'User-Agent': ua,
        if (headers != null) ...headers,
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
    final cookie = await cookieProvider();
    const url = 'https://attendance.mirea.ru/rtu.pulse_app.LongTimeTokenService/GetAccessTokenForDigitalPass';

    final request = GetAccessTokenForDigitalPassRequest();
    final protobufBytes = request.writeToBuffer();

    final responseBytes = await _sendGrpcWebRequest(
      url: url,
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
    final cookie = await cookieProvider();
    const url = 'https://attendance.mirea.ru/rtu_tc.rtu_attend.humanpass.HumanPassService/SendVerificationCode';

    final request = SendVerificationCodeRequest();
    final protobufBytes = request.writeToBuffer();

    await _sendGrpcWebRequest(
      url: url,
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
    final cookie = await cookieProvider();
    const url = 'https://attendance.mirea.ru/rtu_tc.rtu_attend.humanpass.HumanPassService/GetDigitalPass';

    final request = GetDigitalPassRequest()
      ..code = sixDigitCode
      ..deviceInfo = (DeviceInfo()..deviceName = deviceName);
    final protobufBytes = request.writeToBuffer();

    final responseBytes = await _sendGrpcWebRequest(
      url: url,
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
