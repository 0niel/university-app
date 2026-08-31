import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth_client/src/biometric_kind.dart';

part 'biometric_capability.freezed.dart';

@freezed
abstract class BiometricCapability with _$BiometricCapability {
  const factory BiometricCapability({
    required bool available,
    required BiometricKind kind,
  }) = _BiometricCapability;

  const BiometricCapability._();

  static const unavailable = BiometricCapability(
    available: false,
    kind: .none,
  );
}
