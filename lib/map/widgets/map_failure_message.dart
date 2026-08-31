import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';

class MapFailureMessage extends StatelessWidget {
  const MapFailureMessage({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final details = message;
    return Center(
      child: SingleChildScrollView(
        padding: const .symmetric(vertical: NinjaMetrics.screenPadding),
        child: NinjaErrorState(
          title: l10n.loadingError,
          message: details != null && details.isNotEmpty
              ? details
              : l10n.tryAgain,
          retryLabel: l10n.retry,
          onRetry: () =>
              context.read<MapBloc>().add(const MapEvent.initialized()),
        ),
      ),
    );
  }
}
