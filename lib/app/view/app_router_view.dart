import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/app/bloc/app_bloc.dart';
import 'package:rtu_mirea_app/app/widgets/adaptive_theme_wrapper.dart';
import 'package:rtu_mirea_app/navigation/navigation.dart';

class AppRouterView extends StatefulWidget {
  const AppRouterView({super.key});

  @override
  State<AppRouterView> createState() => _AppRouterViewState();
}

class _AppRouterViewState extends State<AppRouterView> {
  late final GoRouter _router;
  late final GoRouterRefreshStream _routerRefreshStream;

  @override
  void initState() {
    super.initState();
    final appBloc = context.read<AppBloc>();
    _routerRefreshStream = GoRouterRefreshStream.auth(appBloc);
    _router = createRouter(
      appBloc: appBloc,
      homeCubit: context.read(),
      refreshListenable: _routerRefreshStream,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    _routerRefreshStream.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveThemeWrapper(router: _router);
  }
}
