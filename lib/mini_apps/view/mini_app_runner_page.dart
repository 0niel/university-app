import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth_client/local_auth_client.dart';
import 'package:local_notifications_client/local_notifications_client.dart';
import 'package:mini_apps_repository/mini_apps_repository.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/runtime/mini_apps_runtime.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_inner_screen.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_body.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_skeleton.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_scan_page.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_scope_prompt_dialog.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/widgets.dart';
import 'package:rtu_mirea_app/navigation/deep_links.dart';
import 'package:stac_bridge/stac_bridge.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

part 'mini_app_runner_view.dart';
part 'runner_app_bar.dart';

typedef MiniAppsRuntimeInitializer = Future<void> Function();

class MiniAppRunnerPage extends StatefulWidget {
  const MiniAppRunnerPage({
    required this.slug,
    super.key,
    this.initialPage,
    this.runtimeInitializerBuilder,
  });

  final String slug;
  final String? initialPage;

  final MiniAppsRuntimeInitializer? runtimeInitializerBuilder;

  @override
  State<MiniAppRunnerPage> createState() => _MiniAppRunnerPageState();
}

class _MiniAppRunnerPageState extends State<MiniAppRunnerPage> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeRuntime();
  }

  Future<void> _initializeRuntime() =>
      (widget.runtimeInitializerBuilder ?? MiniAppsRuntime.ensureInitialized)();

  void _retryInitialization() {
    final initialization = _initializeRuntime();
    setState(() {
      _initialization = initialization;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != .done) {
          return Scaffold(
            backgroundColor: context.ninja.canvas,
            body: const MiniAppRunnerSkeleton(),
          );
        }
        if (snapshot.hasError) {
          final l10n = context.l10n;
          return Scaffold(
            backgroundColor: context.ninja.canvas,
            body: Center(
              child: Padding(
                padding: const .symmetric(
                  horizontal: NinjaMetrics.screenPadding,
                ),
                child: NinjaErrorState(
                  title: l10n.miniAppsRunnerError,
                  retryLabel: l10n.retry,
                  onRetry: _retryInitialization,
                ),
              ),
            ),
          );
        }
        return BlocProvider(
          create: (context) {
            final cubit = MiniAppRunnerCubit(
              miniAppsRepository: context.read(),
              slug: widget.slug,
            );
            unawaited(cubit.load());
            return cubit;
          },
          child: _MiniAppRunnerView(
            slug: widget.slug,
            initialPage: widget.initialPage,
          ),
        );
      },
    );
  }
}
