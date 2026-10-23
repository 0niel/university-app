import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/bloc/map_bloc.dart';

class MapSelectionFeedback extends StatelessWidget {
  const MapSelectionFeedback({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => BlocListener<MapBloc, MapState>(
    listenWhen: (previous, current) =>
        current.status == MapStatus.loaded &&
        current.errorMessage != null &&
        (previous.status != current.status ||
            previous.errorMessage != current.errorMessage),
    listener: (context, _) {
      if (!TickerMode.valuesOf(context).enabled) return;
      showNinjaToast(
        context,
        message: context.l10n.mapPlanLoadFailed,
        showCheck: false,
      );
    },
    child: child,
  );
}
