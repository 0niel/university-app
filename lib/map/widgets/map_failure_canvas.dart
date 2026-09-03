import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';

class MapFailureCanvas extends StatelessWidget {
  const MapFailureCanvas({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(AppSpacing.screen),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppBackButton(
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          Expanded(
            child: Center(
              child: NinjaErrorState(
                title: context.l10n.loadingError,
                message: context.l10n.tryAgain,
                retryLabel: context.l10n.retry,
                onRetry: () =>
                    context.read<MapBloc>().add(const MapEvent.initialized()),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
