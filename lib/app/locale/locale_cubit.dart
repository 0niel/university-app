import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rtu_mirea_app/app/locale/app_language.dart';

export 'app_language.dart';

class LocaleCubit extends HydratedCubit<AppLanguage> {
  LocaleCubit() : super(AppLanguage.ru);

  void setLanguage(AppLanguage language) => emit(language);

  @override
  AppLanguage fromJson(Map<String, dynamic> json) {
    final name = json['language'] as String?;
    return AppLanguage.values.firstWhere(
      (value) => value.name == name,
      orElse: () => AppLanguage.ru,
    );
  }

  @override
  Map<String, dynamic> toJson(AppLanguage state) => {'language': state.name};
}
