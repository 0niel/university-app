import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/runtime/mini_app_accent.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_skeleton.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_scaffold.dart';
import 'package:stac_bridge/stac_bridge.dart';

class MiniAppInnerScreen extends StatefulWidget {
  const MiniAppInnerScreen({
    required this.path,
    required this.title,
    super.key,
    this.accentColor,
  });

  final String path;
  final String title;
  final String? accentColor;

  @override
  State<MiniAppInnerScreen> createState() => _MiniAppInnerScreenState();
}

class _MiniAppInnerScreenState extends State<MiniAppInnerScreen> {
  late Future<Map<String, dynamic>?> _screen;

  @override
  void initState() {
    super.initState();
    _screen = _fetchScreen();
  }

  Future<Map<String, dynamic>?> _fetchScreen() =>
      context.read<MiniAppRunnerCubit>().fetchPage(widget.path);

  void _retry() {
    final screen = _fetchScreen();
    setState(() {
      _screen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.accentColor;
    return MiniAppScaffold(
      title: widget.title,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _screen,
        builder: (context, snapshot) {
          if (snapshot.connectionState != .done) {
            return const MiniAppRunnerSkeleton(key: ValueKey('inner-loading'));
          }
          final screen = snapshot.hasError ? null : snapshot.data;
          if (screen == null) {
            return _error(context, key: const ValueKey('inner-failure'));
          }
          return KeyedSubtree(
            key: const ValueKey('inner-ready'),
            child: MiniAppAccentTheme(
              accentColor: accentColor,
              child: Builder(
                builder: (themedContext) =>
                    StacBridge.render(screen, themedContext) ??
                    _error(
                      themedContext,
                      key: const ValueKey('inner-render-error'),
                      renderError: true,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _error(
    BuildContext context, {
    required Key key,
    bool renderError = false,
  }) {
    final l10n = context.l10n;
    return Center(
      key: key,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.xlg,
          AppSpacing.screen,
          ninjaBottomInset(context) + AppSpacing.lg,
        ),
        child: AppErrorState(
          lineIcon: renderError ? AppLineIcon.grid : AppLineIcon.wifiOff,
          title: renderError ? l10n.miniAppsRunnerError : l10n.loadingError,
          message: renderError ? null : l10n.tryAgain,
          footnote: null,
          primaryLabel: l10n.retry,
          onPrimary: _retry,
        ),
      ),
    );
  }
}
