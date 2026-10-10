import 'package:gamification_repository/gamification_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class AccountEntryIntentCubit extends HydratedCubit<AccountRole?> {
  AccountEntryIntentCubit() : super(null);

  @override
  String get storagePrefix => 'AccountEntryIntentCubit';

  void select(AccountRole? role) => emit(role);

  AccountRole? consume() {
    final role = state;
    emit(null);
    return role;
  }

  @override
  AccountRole? fromJson(Map<String, dynamic> json) =>
      AccountRole.values.where((role) => role.name == json['role']).firstOrNull;

  @override
  Map<String, dynamic>? toJson(AccountRole? state) => {'role': state?.name};
}
