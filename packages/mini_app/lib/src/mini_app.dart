import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class MiniApp {
  /// Идентификатор модуля
  String get id;

  /// Название модуля
  String get name;

  /// Автор модуля
  String get author;

  /// Версия модуля
  String get version;

  /// Маршруты для go_router
  List<GoRoute> get routes;

  /// Локализационные делегаты
  List<LocalizationsDelegate> get localizationDelegates;

  /// Bloc-провайдеры для модуля
  List<BlocProvider> get blocProviders;

  /// Регистрация зависимостей (например, через DI)
  void registerDependencies();

  /// Построение основного виджета модуля
  Widget buildWidget(BuildContext context);

  /// Хуки жизненного цикла
  void onInit();
  void onPause();
  void onResume();
  void onDispose();
}
