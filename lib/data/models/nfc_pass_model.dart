import 'package:rtu_mirea_app/domain/entities/nfc_pass.dart';

class NfcPassModel extends NfcPass {
  const NfcPassModel({
    required code,
    required studentId,
    required deviceName,
    required deviceId,
    required connected,
  }) : super(
          code: code,
          studentId: studentId,
          deviceName: deviceName,
          connected: connected,
          deviceId: deviceId,
        );

  factory NfcPassModel.fromJson(Map<String, dynamic> json) => NfcPassModel(
        code: json["code"],
        studentId: json["studentId"],
        deviceName: json["deviceName"],
        connected: json["connected"],
        deviceId: json["deviceId"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "studentId": studentId,
        "deviceName": deviceName,
        "connected": connected,
        "deviceId": deviceId,
      };
}
