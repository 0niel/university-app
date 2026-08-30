import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_skeleton.dart';
import 'package:stac_bridge/stac_bridge.dart';

class MiniAppInnerScreen extends StatefulWidget {
  const MiniAppInnerScreen({
    required this.path,
    required this.title,
    super.key,
  });

  final String path;
  final String title;

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
    final colors = context.ninja;
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: colors.canvas,
      appBar: NinjaAppBar.inner(
        title: widget.title,
        onBack: () => Navigator.of(context).maybePop(),
        backSemanticLabel: l10n.back,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _screen,
        builder: (context, snapshot) {
          if (snapshot.connectionState != .done) {
            return const MiniAppRunnerSkeleton();
          }
          final screen = snapshot.hasError ? null : snapshot.data;
          if (screen == null) return _error(context, retry: true);
          return StacBridge.render(screen, context) ??
              _error(context, retry: false);
        },
      ),
    );
  }

  Widget _error(BuildContext context, {required bool retry}) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const .symmetric(horizontal: NinjaMetrics.screenPadding),
        child: NinjaErrorState(
          title: l10n.miniAppsRunnerError,
          retryLabel: retry ? l10n.retry : null,
          onRetry: retry ? _retry : null,
        ),
      ),
    );
  }
}
