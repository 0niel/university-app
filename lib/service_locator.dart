import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_remote.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/get_groups.dart';
import 'package:rtu_mirea_app/domain/usecases/get_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/is_group_exist.dart';
import 'package:rtu_mirea_app/presentation/bloc/home_navigator_bloc/home_navigator_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/onboarding_cubit/onboarding_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/schedule_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // BloC / Cubit
  getIt.registerFactory(() => HomeNavigatorBloc());
  getIt.registerFactory(() => OnboardingCubit());

  // Usecases
  getIt.registerLazySingleton(() => GetGroups(getIt()));
  getIt.registerLazySingleton(() => GetSchedule(getIt()));
  getIt.registerLazySingleton(() => IsGroupExist(getIt()));

  // Repositories
  getIt.registerLazySingleton<ScheduleRepository>(() => ScheduleRepositoryImpl(
      remoteDataSource: getIt(), localDataSource: getIt()));

  getIt.registerLazySingleton<ScheduleRemoteData>(
      () => ScheduleRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<ScheduleLocalData>(
      () => ScheduleLocalDataImpl(sharedPreferences: getIt()));

  // Common / Core

  // External Dependency
  getIt.registerLazySingleton(() => Dio());
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
}
