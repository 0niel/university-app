part of 'pass_security_cubit.dart';

@freezed
abstract class PassSecurityState with _$PassSecurityState {
  const factory PassSecurityState({
    @Default(false) bool enabled,
    @Default(false) bool available,
    @Default(BiometricKind.none) BiometricKind kind,
  }) = _PassSecurityState;

  const PassSecurityState._();

  bool get isActive => enabled && available;
}
