import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/runtime/mini_app_accent.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_skeleton.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_refresh_surface.dart';
import 'package:stac_bridge/stac_bridge.dart';

class MiniAppRunnerBody extends StatelessWidget {
  const MiniAppRunnerBody({
    required this.state,
    super.key,
    this.offline = false,
  });

  final MiniAppRunnerState state;
  final bool offline;

  @override
  Widget build(BuildContext context) {
    return NinjaStateSwitcher(child: _body(context));
  }

  Widget _body(BuildContext context) {
    final l10n = context.l10n;
    switch (state.status) {
      case .initial:
      case .loading:
      case .consentRequired:
        return const MiniAppRunnerSkeleton(key: ValueKey('runner-loading'));
      case .notFound:
        return _framed(
          context,
          const ValueKey('runner-not-found'),
          AppEmptyState(
            lineIcon: AppLineIcon.grid,
            title: l10n.miniAppsRunnerNotFound,
            subtitle: l10n.miniAppsRunnerNotFoundSubtitle,
            actionLabel: l10n.miniAppsCatalogSection,
            onAction: () => context.go('/services/apps'),
          ).animateEmptyState(),
        );
      case .failure:
        return _framed(
          context,
          const ValueKey('runner-failure'),
          AppErrorState(
            title: l10n.loadingError,
            message: l10n.tryAgain,
            primaryLabel: l10n.retry,
            footnote: null,
            onPrimary: () => unawaited(_reload(context)),
          ).animateEmptyState(),
        );
      case .ready:
        final screen = state.screen;
        if (screen == null) return _renderError(context);
        return KeyedSubtree(
          key: const ValueKey('runner-ready'),
          child: MiniAppAccentTheme(
            accentColor: state.app?.accentColor,
            child: MiniAppRefreshSurface(
              refreshing: state.refreshing,
              failed: state.refreshFailed,
              offline: offline,
              onRetry: () => unawaited(_reload(context)),
              child: Builder(
                builder: (themedContext) =>
                    StacBridge.render(screen, themedContext) ??
                    _renderError(themedContext),
              ),
            ),
          ),
        );
    }
  }

  Future<void> _reload(BuildContext context) =>
      context.read<MiniAppRunnerCubit>().load();

  Widget _renderError(BuildContext context) => _framed(
    context,
    const ValueKey('runner-render-error'),
    AppErrorState(
      lineIcon: AppLineIcon.grid,
      title: context.l10n.miniAppsRunnerError,
      message: null,
      footnote: null,
      primaryLabel: context.l10n.retry,
      onPrimary: () => unawaited(_reload(context)),
    ).animateEmptyState(),
  );

  Widget _framed(BuildContext context, Key key, Widget child) => Center(
    key: key,
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.xlg,
        AppSpacing.screen,
        ninjaBottomInset(context) + AppSpacing.lg,
      ),
      child: child,
    ),
  );
}
