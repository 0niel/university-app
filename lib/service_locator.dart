import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rtu_mirea_app/data/datasources/github_local.dart';
import 'package:rtu_mirea_app/data/datasources/github_remote.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_remote.dart';
import 'package:rtu_mirea_app/data/repositories/github_repository_impl.dart';
import 'package:rtu_mirea_app/domain/repositories/github_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/delete_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/get_active_group.dart';
import 'package:rtu_mirea_app/domain/usecases/get_contributors.dart';
import 'package:rtu_mirea_app/domain/usecases/get_downloaded_schedules.dart';
import 'package:rtu_mirea_app/domain/usecases/get_groups.dart';
import 'package:rtu_mirea_app/domain/usecases/get_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/set_active_group.dart';
import 'package:rtu_mirea_app/presentation/bloc/about_app_bloc/about_app_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/home_navigator_bloc/home_navigator_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/onboarding_cubit/onboarding_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/schedule_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // BloC / Cubit
  getIt.registerFactory(
    () => ScheduleBloc(
      getSchedule: getIt(),
      getActiveGroup: getIt(),
      getGroups: getIt(),
      setActiveGroup: getIt(),
      getDownloadedSchedules: getIt(),
      deleteSchedule: getIt(),
    ),
  );
  getIt.registerFactory(() => AboutAppBloc(getContributors: getIt()));
  getIt.registerFactory(() => HomeNavigatorBloc());
  getIt.registerFactory(() => OnboardingCubit());
  getIt.registerFactory(() => MapCubit());

  // Usecases
  getIt.registerLazySingleton(() => GetGroups(getIt()));
  getIt.registerLazySingleton(() => GetSchedule(getIt()));
  getIt.registerLazySingleton(() => SetActiveGroup(getIt()));
  getIt.registerLazySingleton(() => GetActiveGroup(getIt()));
  getIt.registerLazySingleton(() => GetDownloadedSchedules(getIt()));
  getIt.registerLazySingleton(() => DeleteSchedule(getIt()));
  getIt.registerLazySingleton(() => GetContributors(getIt()));

  // Repositories
  getIt.registerLazySingleton<GithubRepository>(() => GithubRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        connectionChecker: getIt(),
      ));

  getIt.registerLazySingleton<ScheduleRepository>(() => ScheduleRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        connectionChecker: getIt(),
      ));

  getIt.registerLazySingleton<ScheduleRemoteData>(
      () => ScheduleRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<ScheduleLocalData>(
      () => ScheduleLocalDataImpl(sharedPreferences: getIt()));

  getIt.registerLazySingleton<GithubRemoteData>(
      () => GithubRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<GithubLocalData>(
      () => GithubLocalDataImpl(sharedPreferences: getIt()));

  // Common / Core

  // External Dependency
  getIt.registerLazySingleton(() => Dio());
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
