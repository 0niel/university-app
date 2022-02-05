import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rtu_mirea_app/data/datasources/app_settings_local.dart';
import 'package:rtu_mirea_app/data/datasources/forum_local.dart';
import 'package:rtu_mirea_app/data/datasources/forum_remote.dart';
import 'package:rtu_mirea_app/data/datasources/news_remote.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_local.dart';
import 'package:rtu_mirea_app/data/datasources/schedule_remote.dart';
import 'package:rtu_mirea_app/data/datasources/strapi_remote.dart';
import 'package:rtu_mirea_app/data/datasources/user_local.dart';
import 'package:rtu_mirea_app/data/datasources/user_remote.dart';
import 'package:rtu_mirea_app/data/datasources/widget_data.dart';
import 'package:rtu_mirea_app/data/repositories/app_settings_repository_impl.dart';
import 'package:rtu_mirea_app/data/repositories/forum_repository_impl.dart';
import 'package:rtu_mirea_app/data/repositories/news_repository_impl.dart';
import 'package:rtu_mirea_app/data/repositories/strapi_repository_impl.dart';
import 'package:rtu_mirea_app/data/repositories/user_repository_impl.dart';
import 'package:rtu_mirea_app/domain/repositories/app_settings_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/forum_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';
import 'package:rtu_mirea_app/data/datasources/github_local.dart';
import 'package:rtu_mirea_app/data/datasources/github_remote.dart';
import 'package:rtu_mirea_app/data/repositories/github_repository_impl.dart';
import 'package:rtu_mirea_app/domain/repositories/github_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/schedule_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/strapi_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/delete_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/get_active_group.dart';
import 'package:rtu_mirea_app/domain/usecases/get_announces.dart';
import 'package:rtu_mirea_app/domain/usecases/get_app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/get_attendance.dart';
import 'package:rtu_mirea_app/domain/usecases/get_auth_token.dart';
import 'package:rtu_mirea_app/domain/usecases/get_contributors.dart';
import 'package:rtu_mirea_app/domain/usecases/get_downloaded_schedules.dart';
import 'package:rtu_mirea_app/domain/usecases/get_employees.dart';
import 'package:rtu_mirea_app/domain/usecases/get_groups.dart';
import 'package:rtu_mirea_app/domain/usecases/get_news.dart';
import 'package:rtu_mirea_app/domain/usecases/get_news_tags.dart';
import 'package:rtu_mirea_app/domain/usecases/get_patrons.dart';
import 'package:rtu_mirea_app/domain/usecases/get_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/get_schedule_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/get_scores.dart';
import 'package:rtu_mirea_app/domain/usecases/get_stories.dart';
import 'package:rtu_mirea_app/domain/usecases/get_update_info.dart';
import 'package:rtu_mirea_app/domain/usecases/get_user_data.dart';
import 'package:rtu_mirea_app/domain/usecases/log_in.dart';
import 'package:rtu_mirea_app/domain/usecases/log_out.dart';
import 'package:rtu_mirea_app/domain/usecases/set_active_group.dart';
import 'package:rtu_mirea_app/domain/usecases/set_app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/set_schedule_settings.dart';
import 'package:rtu_mirea_app/presentation/bloc/about_app_bloc/about_app_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/announces_bloc/announces_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/app_cubit/app_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/attendance_bloc/attendance_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/map_cubit/map_cubit.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/schedule_bloc/schedule_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/stories_bloc/stories_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/update_info_bloc/update_info_bloc.dart';
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
        getScheduleSettings: getIt(),
        setScheduleSettings: getIt()),
  );
  getIt.registerFactory(() => NewsBloc(getNews: getIt(), getNewsTags: getIt()));
  getIt.registerFactory(
      () => AboutAppBloc(getContributors: getIt(), getForumPatrons: getIt()));
  getIt.registerFactory(() => MapCubit());
  getIt.registerFactory(
    () => AuthBloc(
        logOut: getIt(),
        getAuthToken: getIt(),
        logIn: getIt(),
        getUserData: getIt()),
  );
  getIt.registerFactory(() => ProfileBloc(getUserData: getIt()));
  getIt.registerFactory(() => AnnouncesBloc(getAnnounces: getIt()));
  getIt.registerFactory(() => EmployeeBloc(getEmployees: getIt()));
  getIt.registerFactory(() => ScoresBloc(getScores: getIt()));
  getIt.registerFactory(() => AttendanceBloc(getAttendance: getIt()));
  getIt.registerFactory(() => StoriesBloc(getStories: getIt()));
  getIt.registerFactory(
    () => UpdateInfoBloc(
      getUpdateInfo: getIt(),
      getAppSettings: getIt(),
      setAppSettings: getIt(),
    )..init(),
  );
  getIt.registerFactory(
    () => AppCubit(
      getAppSettings: getIt(),
      setAppSettings: getIt(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton(() => GetStories(getIt()));
  getIt.registerLazySingleton(() => GetUpdateInfo(getIt()));
  getIt.registerLazySingleton(() => GetAttendance(getIt()));
  getIt.registerLazySingleton(() => GetScores(getIt()));
  getIt.registerLazySingleton(() => GetEmployees(getIt()));
  getIt.registerLazySingleton(() => GetAnnounces(getIt()));
  getIt.registerLazySingleton(() => GetAuthToken(getIt()));
  getIt.registerLazySingleton(() => GetUserData(getIt()));
  getIt.registerLazySingleton(() => LogOut(getIt()));
  getIt.registerLazySingleton(() => LogIn(getIt()));
  getIt.registerLazySingleton(() => GetGroups(getIt()));
  getIt.registerLazySingleton(() => GetSchedule(getIt()));
  getIt.registerLazySingleton(() => SetActiveGroup(getIt()));
  getIt.registerLazySingleton(() => GetActiveGroup(getIt()));
  getIt.registerLazySingleton(() => GetDownloadedSchedules(getIt()));
  getIt.registerLazySingleton(() => DeleteSchedule(getIt()));
  getIt.registerLazySingleton(() => GetNews(getIt()));
  getIt.registerLazySingleton(() => GetNewsTags(getIt()));
  getIt.registerLazySingleton(() => GetContributors(getIt()));
  getIt.registerLazySingleton(() => GetForumPatrons(getIt()));
  getIt.registerLazySingleton(() => GetScheduleSettings(getIt()));
  getIt.registerLazySingleton(() => SetScheduleSettings(getIt()));
  getIt.registerLazySingleton(() => SetAppSettings(getIt()));
  getIt.registerLazySingleton(() => GetAppSettings(getIt()));

  // Repositories
  getIt.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: getIt(),
      connectionChecker: getIt(),
    ),
  );

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

  getIt.registerLazySingleton<ForumRepository>(() => ForumRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        connectionChecker: getIt(),
      ));

  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        connectionChecker: getIt(),
      ));

  getIt.registerLazySingleton<StrapiRepository>(() => StrapiRepositoryImpl(
        remoteDataSource: getIt(),
        connectionChecker: getIt(),
        packageInfo: getIt(),
      ));

  getIt.registerLazySingleton<AppSettingsRepository>(
      () => AppSettingsRepositoryImpl(
            localDataSource: getIt(),
          ));

  getIt.registerLazySingleton<UserLocalData>(
      () => UserLocalDataImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<UserRemoteData>(
      () => UserRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<ScheduleRemoteData>(
      () => ScheduleRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<ScheduleLocalData>(
      () => ScheduleLocalDataImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<NewsRemoteData>(
      () => NewsRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<GithubRemoteData>(
      () => GithubRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<GithubLocalData>(
      () => GithubLocalDataImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<ForumRemoteData>(
      () => ForumRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<ForumLocalData>(
      () => ForumLocalDataImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<StrapiRemoteData>(
      () => StrapiRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<AppSettingsLocal>(
      () => AppSettingsLocalImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<WidgetData>(() => WidgetDataImpl());

  // Common / Core

  // External Dependency
  getIt.registerLazySingleton(
      () => Dio(BaseOptions(connectTimeout: 30000, receiveTimeout: 30000)));
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => InternetConnectionChecker());
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  getIt.registerLazySingleton(() => packageInfo);
}
