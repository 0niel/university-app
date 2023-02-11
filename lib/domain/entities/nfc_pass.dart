import 'package:equatable/equatable.dart';

class NfcPass extends Equatable {
  const NfcPass({
    required this.code,
    required this.studentId,
    required this.deviceName,
    required this.deviceId,
    required this.connected,
  });

  final String code;
  final String studentId;
  final String deviceName;
  final String deviceId;
  final bool connected;

  @override
  List<Object> get props => [code, studentId, deviceName, deviceId, connected];
}
