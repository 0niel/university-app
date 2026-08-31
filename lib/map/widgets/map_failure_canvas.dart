import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_action_button.dart';
import 'package:rtu_mirea_app/map/widgets/map_failure_message.dart';

class MapFailureCanvas extends StatelessWidget {
  const MapFailureCanvas({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        ColoredBox(color: context.ninja.canvas),
        SafeArea(
          child: Padding(
            padding: const .all(NinjaMetrics.screenPadding),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: MapActionButton(
                    tooltip: context.l10n.back,
                    icon: .chevronL,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ),
                Expanded(child: MapFailureMessage(message: message)),
              ],
            ),
          ),
        ).animatePageEntrance(),
      ],
    );
  }
}
