import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:local_auth_client/local_auth_client.dart';

part 'pass_security_cubit.freezed.dart';
part 'pass_security_state.dart';

class PassSecurityCubit extends HydratedCubit<PassSecurityState> {
  PassSecurityCubit({required LocalAuthClient localAuthClient})
    : _client = localAuthClient,
      super(const PassSecurityState());

  final LocalAuthClient _client;

  Future<void> refreshCapability() async {
    try {
      final capability = await _client.capability();
      emit(
        state.copyWith(
          available: capability.available,
          kind: capability.kind,
          enabled: capability.available && state.enabled,
        ),
      );
    } on LocalAuthFailure catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          available: false,
          kind: .none,
          enabled: false,
        ),
      );
    }
  }

  Future<bool> setEnabled({
    required bool enabled,
    required String reason,
  }) async {
    if (!state.available) return false;
    try {
      final authenticated = await _client.authenticate(reason: reason);
      if (!authenticated) return false;
      emit(state.copyWith(enabled: enabled));
      return true;
    } on LocalAuthFailure catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    }
  }

  Future<bool> authenticateForPass({required String reason}) async {
    if (!state.enabled) return true;
    try {
      return await _client.authenticate(reason: reason);
    } on BiometricUnavailableFailure catch (error, stackTrace) {
      addError(error, stackTrace);
      return true;
    } on LocalAuthFailure catch (error, stackTrace) {
      addError(error, stackTrace);
      return false;
    }
  }

  @override
  PassSecurityState? fromJson(Map<String, dynamic> json) {
    try {
      return PassSecurityState(enabled: json['enabled'] as bool? ?? false);
    } on Object catch (error, stackTrace) {
      addError(error, stackTrace);
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(PassSecurityState state) => {
    'enabled': state.enabled,
  };
}
