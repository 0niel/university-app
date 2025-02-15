import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract class MiniApp {
  String get id;

  String get name;

  String get author => 'Unknown';

  List<GoRoute> get routes;

  List<BlocProvider>? get globalBlocProviders => [];

  List<LocalizationsDelegate<dynamic>>? get localizationsDelegates => [];

  Future<void> registerDependencies();

  bool get enabled => true;
}
