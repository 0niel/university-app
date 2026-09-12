import 'package:nfc_pass_client/src/nfc_verification_exception.dart';
import 'package:nfc_pass_client/src/nfc_verification_result.dart';
import 'package:nfc_pass_client/src/protos/human_pass.pb.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

abstract final class NfcVerificationCodec {
  static NfcVerificationResult decodeCode(List<int> bytes) {
    final response = SendVerificationCodeResponse.fromBuffer(bytes);
    return switch (response.whichResult()) {
      SendVerificationCodeResponse_Result.success => NfcVerificationCodeSent(
          retryAt: response.success.hasWaitForToNextAttempt()
              ? _timestamp(response.success.waitForToNextAttempt)
              : null,
        ),
      SendVerificationCodeResponse_Result.waitForToNextAttempt =>
        NfcVerificationCooldown(
          retryAt: _timestamp(response.waitForToNextAttempt),
        ),
      SendVerificationCodeResponse_Result.noDigitalPassOrVerificationMethod =>
        const NfcVerificationUnavailable(),
      SendVerificationCodeResponse_Result.notSet =>
        throw const FormatException('Missing verification response outcome.'),
    };
  }

  static int decodePass(List<int> bytes) {
    final response = GetDigitalPassResponse.fromBuffer(bytes);
    switch (response.whichResult()) {
      case GetDigitalPassResponse_Result.success:
        final passId = response.success.cardNumber.toInt();
        if (passId <= 0) {
          throw const FormatException('Missing digital-pass identifier.');
        }
        return passId;
      case GetDigitalPassResponse_Result.wrongCode:
        throw const NfcVerificationException(NfcVerificationFailure.wrongCode);
      case GetDigitalPassResponse_Result.nfcError:
        throw const NfcVerificationException(NfcVerificationFailure.nfcError);
      case GetDigitalPassResponse_Result.notSet:
        throw const FormatException('Missing digital-pass response outcome.');
    }
  }

  static DateTime _timestamp(Timestamp value) {
    final seconds = value.seconds.toInt();
    if (seconds < -62135596800 ||
        seconds > 253402300799 ||
        value.nanos < 0 ||
        value.nanos > 999999999) {
      throw const FormatException('Invalid verification retry timestamp.');
    }
    return DateTime.fromMicrosecondsSinceEpoch(
      seconds * Duration.microsecondsPerSecond + (value.nanos + 999) ~/ 1000,
      isUtc: true,
    );
  }
}
