import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'sync_policy.dart';

class SyncPreferencesCubit extends HydratedCubit<SyncPolicy> {
  SyncPreferencesCubit() : super(SyncPolicy.always);

  void setPolicy(SyncPolicy policy) => emit(policy);

  @override
  SyncPolicy fromJson(Map<String, dynamic> json) {
    final name = json['policy'] as String?;
    return SyncPolicy.values.firstWhere(
      (value) => value.name == name,
      orElse: () => SyncPolicy.always,
    );
  }

  @override
  Map<String, dynamic> toJson(SyncPolicy state) => {'policy': state.name};
}
