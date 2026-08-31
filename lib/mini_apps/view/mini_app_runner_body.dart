import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/cubit/mini_app_runner_cubit.dart';
import 'package:rtu_mirea_app/mini_apps/view/mini_app_runner_skeleton.dart';
import 'package:stac_bridge/stac_bridge.dart';

class MiniAppRunnerBody extends StatelessWidget {
  const MiniAppRunnerBody({required this.state, super.key});

  final MiniAppRunnerState state;

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
          const ValueKey('runner-not-found'),
          NinjaEmptyState(
            icon: const AppLineIconWidget(AppLineIcon.alert),
            title: l10n.miniAppsRunnerNotFound,
            message: l10n.miniAppsRunnerNotFoundSubtitle,
            actionLabel: l10n.miniAppsCatalogSection,
            onAction: () => context.go('/services/apps'),
          ).animateEmptyState(),
        );
      case .failure:
        return _framed(
          const ValueKey('runner-failure'),
          NinjaErrorState(
            title: l10n.loadingError,
            message: l10n.tryAgain,
            retryLabel: l10n.retry,
            onRetry: () => unawaited(context.read<MiniAppRunnerCubit>().load()),
          ).animateEmptyState(),
        );
      case .ready:
        final screen = state.screen;
        if (screen == null) return _renderError(context);
        return KeyedSubtree(
          key: const ValueKey('runner-ready'),
          child: StacBridge.render(screen, context) ?? _renderError(context),
        );
    }
  }

  Widget _renderError(BuildContext context) => _framed(
    const ValueKey('runner-render-error'),
    NinjaEmptyState(
      icon: const AppLineIconWidget(AppLineIcon.grid),
      title: context.l10n.miniAppsRunnerError,
      actionLabel: context.l10n.retry,
      onAction: () => unawaited(context.read<MiniAppRunnerCubit>().load()),
    ).animateEmptyState(),
  );

  Widget _framed(Key key, Widget child) => Center(
    key: key,
    child: SingleChildScrollView(
      padding: const .symmetric(
        horizontal: NinjaMetrics.screenPadding,
        vertical: 24,
      ),
      child: child,
    ),
  );
}
