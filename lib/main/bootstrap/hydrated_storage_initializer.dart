import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/common/hydrated_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yx_scope/yx_scope.dart';

class HydratedStorageInitializer implements AsyncLifecycle {
  HydratedStorageInitializer({required SharedPreferences sharedPreferences})
    : _storage = CustomHydratedStorage(sharedPreferences: sharedPreferences);

  final CustomHydratedStorage _storage;

  @override
  Future<void> init() async {
    HydratedBloc.storage = _storage;
  }

  @override
  Future<void> dispose() async {
    await HydratedBloc.storage.close();
  }
}
