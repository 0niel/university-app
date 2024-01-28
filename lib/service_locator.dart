import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_notifications_client/firebase_notifications_client.dart';
import 'package:get_it/get_it.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_client/permission_client.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:rtu_mirea_app/common/oauth.dart';
import 'package:rtu_mirea_app/common/utils/connection_checker.dart';
import 'package:rtu_mirea_app/data/datasources/app_settings_local.dart';
import 'package:rtu_mirea_app/data/datasources/forum_local.dart';
import 'package:rtu_mirea_app/data/datasources/forum_remote.dart';
import 'package:rtu_mirea_app/data/datasources/news_remote.dart';
import 'package:rtu_mirea_app/data/datasources/strapi_remote.dart';
import 'package:rtu_mirea_app/data/datasources/user_local.dart';
import 'package:rtu_mirea_app/data/datasources/user_remote.dart';
import 'package:rtu_mirea_app/data/datasources/widget_data.dart';
import 'package:rtu_mirea_app/data/repositories/app_settings_repository_impl.dart';
import 'package:rtu_mirea_app/data/repositories/news_repository_impl.dart';
import 'package:rtu_mirea_app/data/repositories/user_repository_impl.dart';
import 'package:rtu_mirea_app/domain/repositories/app_settings_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/news_repository.dart';
import 'package:rtu_mirea_app/domain/repositories/user_repository.dart';
import 'package:rtu_mirea_app/domain/usecases/delete_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/get_announces.dart';
import 'package:rtu_mirea_app/domain/usecases/get_app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/get_attendance.dart';
import 'package:rtu_mirea_app/domain/usecases/get_auth_token.dart';
import 'package:rtu_mirea_app/domain/usecases/get_downloaded_schedules.dart';
import 'package:rtu_mirea_app/domain/usecases/get_employees.dart';
import 'package:rtu_mirea_app/domain/usecases/get_groups.dart';
import 'package:rtu_mirea_app/domain/usecases/get_news.dart';
import 'package:rtu_mirea_app/domain/usecases/get_news_tags.dart';
import 'package:rtu_mirea_app/domain/usecases/get_patrons.dart';
import 'package:rtu_mirea_app/domain/usecases/get_schedule.dart';
import 'package:rtu_mirea_app/domain/usecases/get_schedule_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/get_scores.dart';
import 'package:rtu_mirea_app/domain/usecases/get_user_data.dart';
import 'package:rtu_mirea_app/domain/usecases/log_in.dart';
import 'package:rtu_mirea_app/domain/usecases/log_out.dart';
import 'package:rtu_mirea_app/domain/usecases/set_app_settings.dart';
import 'package:rtu_mirea_app/domain/usecases/set_schedule_settings.dart';
import 'package:rtu_mirea_app/home/home.dart';
import 'package:rtu_mirea_app/presentation/bloc/announces_bloc/announces_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/attendance_bloc/attendance_bloc.dart';

import 'package:rtu_mirea_app/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/notification_preferences/notification_preferences_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/scores_bloc/scores_bloc.dart';
import 'package:rtu_mirea_app/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  // BloC / Cubit
  getIt.registerFactory(() => NewsBloc(getNews: getIt(), getNewsTags: getIt()));
  getIt.registerLazySingleton(
      () => UserBloc(logIn: getIt(), logOut: getIt(), getUserData: getIt(), getAuthToken: getIt()));
  getIt.registerFactory(() => AnnouncesBloc(getAnnounces: getIt()));
  getIt.registerFactory(() => EmployeeBloc(getEmployees: getIt()));
  getIt.registerFactory(() => ScoresBloc(getScores: getIt()));
  getIt.registerFactory(() => AttendanceBloc(getAttendance: getIt()));

  getIt.registerFactory(
    () => HomeCubit(
      getAppSettings: getIt(),
      setAppSettings: getIt(),
    ),
  );
  getIt.registerFactory(() => NotificationPreferencesBloc(notificationsRepository: getIt()));

  // Usecases
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
  getIt.registerLazySingleton(() => GetDownloadedSchedules(getIt()));
  getIt.registerLazySingleton(() => DeleteSchedule(getIt()));
  getIt.registerLazySingleton(() => GetNews(getIt()));
  getIt.registerLazySingleton(() => GetNewsTags(getIt()));
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

  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        connectionChecker: getIt(),
      ));

  getIt.registerLazySingleton<AppSettingsRepository>(() => AppSettingsRepositoryImpl(
        localDataSource: getIt(),
      ));

  getIt.registerLazySingleton<NotificationsRepository>(() => NotificationsRepository(
        permissionClient: getIt(),
        storage: getIt<NotificationsStorage>(),
        notificationsClient: getIt<FirebaseNotificationsClient>(),
      ));

  getIt.registerLazySingleton<UserLocalData>(() => UserLocalDataImpl(
      sharedPreferences: getIt(), secureStorage: getIt(), oauthHelper: getIt<LksOauth2>().oauth2Helper));
  getIt.registerLazySingleton<UserRemoteData>(() => UserRemoteDataImpl(httpClient: getIt(), lksOauth2: getIt()));
  getIt.registerLazySingleton<NewsRemoteData>(() => NewsRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<ForumRemoteData>(() => ForumRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<ForumLocalData>(() => ForumLocalDataImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<StrapiRemoteData>(() => StrapiRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton<AppSettingsLocal>(() => AppSettingsLocalImpl(sharedPreferences: getIt()));
  getIt.registerLazySingleton<WidgetData>(() => WidgetDataImpl());

  // Common / Core

  // External Dependency
  final dio = Dio(BaseOptions(receiveTimeout: const Duration(seconds: 30)));
  getIt.registerLazySingleton(() => dio);
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));
  getIt.registerLazySingleton(() => secureStorage);
  getIt.registerLazySingleton(() => InternetConnectionChecker.getInstance());
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  getIt.registerLazySingleton(() => packageInfo);
  getIt.registerLazySingleton(() => LksOauth2());
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  getIt.registerLazySingleton(() => deviceInfo);

  getIt.registerLazySingleton(() => FirebaseNotificationsClient(firebaseMessaging: FirebaseMessaging.instance));
  getIt.registerLazySingleton(() => const PermissionClient());
  getIt.registerLazySingleton(() => PersistentStorage(sharedPreferences: getIt()));
  getIt.registerLazySingleton(() => NotificationsStorage(
        storage: getIt<PersistentStorage>(),
      ));
}
