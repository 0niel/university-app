import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'proto_decoder.dart';

/// A function that returns a cookie when called (asynchronously or synchronously).
typedef CookieProvider = FutureOr<String> Function();

/// A class that encapsulates "raw" access to gRPC endpoints:
///  - GetAccessTokenForDigitalPass
///  - SendVerificationCode
///  - GetDigitalPass
///
/// Here we do not return high-level "models" (AccessTokenModel, etc.),
/// but only "raw" data (String JWT, int nfcCode) or nothing at all.
class NfcPassClient {
  NfcPassClient({
    required this.cookieProvider,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final CookieProvider cookieProvider;
  final http.Client _httpClient;

  /// Obtaining JWT token for DigitalPass.
  ///
  /// This token is used to authenticate subsequent requests.
  Future<String> getAccessTokenForDigitalPass() async {
    final cookie = await cookieProvider();
    const url = 'https://attendance.mirea.ru'
        '/rtu.pulse_app.LongTimeTokenService/GetAccessTokenForDigitalPass';

    final response = await _httpClient.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/grpc',
        'Cookie': cookie,
      },
      body: Uint8List(0),
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode} – ошибка при получении JWT');
    }

    final payload = ProtoDecoder.parseGrpcFrame(response.bodyBytes);

    final fields = ProtoDecoder.parseProtobufFields(payload);

    // field №1 -> JWT (string)
    final field1 = fields[1];
    if (field1 == null) {
      throw Exception('Не найдено поле #1 (JWT) в ответе');
    }
    final jwtBytes = field1 as Uint8List;
    final jwt = utf8.decode(jwtBytes);

    return jwt;
  }

  /// Sending a request to send a 6-digit code to email
  Future<void> sendVerificationCode(String bearerToken) async {
    final cookie = await cookieProvider();
    const url = 'https://attendance.mirea.ru'
        '/rtu_tc.rtu_attend.humanpass.HumanPassService/SendVerificationCode';

    // (gRPC header + 0-length?)
    final body = base64Decode('AAAAAAA=');

    final response = await _httpClient.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/grpc',
        'Authorization': 'Bearer $bearerToken',
        'Cookie': cookie,
      },
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode} – ошибка SendVerificationCode');
    }
  }

  /// Obtaining NFC code based on the entered 6-digit code and device name
  Future<int> getDigitalPass({
    required String bearerToken,
    required String sixDigitCode,
    required String deviceName,
  }) async {
    final cookie = await cookieProvider();
    const url = 'https://attendance.mirea.ru'
        '/rtu_tc.rtu_attend.humanpass.HumanPassService/GetDigitalPass';

    // field №1 (string) -> sixDigitCode
    final codeBytes = utf8.encode(sixDigitCode);
    final codeField = ProtoDecoder.makeLengthDelimitedField(
      fieldNumber: 1,
      data: codeBytes,
    );

    // field №2 (string) -> deviceName
    final deviceBytes = utf8.encode(deviceName);
    final deviceField = ProtoDecoder.makeLengthDelimitedField(
      fieldNumber: 2,
      data: deviceBytes,
    );

    final protobufMessage = <int>[...codeField, ...deviceField];

    final frame = ProtoDecoder.makeGrpcFrame(protobufMessage);

    final response = await _httpClient.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/grpc',
        'Authorization': 'Bearer $bearerToken',
        'Cookie': cookie,
      },
      body: frame,
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode} – ошибка GetDigitalPass');
    }

    final payload = ProtoDecoder.parseGrpcFrame(response.bodyBytes);
    final topFields = ProtoDecoder.parseProtobufFields(payload);

    // top-level message:
    //   field #1 => varint (nfcCode)
    final field1 = topFields[1];
    if (field1 == null) {
      throw Exception('Не найдено верхнеуровневое поле #1 (вложенное)');
    }
    final innerMsg = field1 as Uint8List;
    final innerFields = ProtoDecoder.parseProtobufFields(innerMsg);

    final nfcVarint = innerFields[1];
    if (nfcVarint == null) {
      throw Exception('Во вложенном сообщении нет field #1 (NFC код)');
    }

    return nfcVarint as int;
  }
}
