import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/design_preview/fixtures/preview_map_fixture.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_page.dart';
import 'package:rtu_mirea_app/design_preview/widgets/preview_text_sheet.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_guidance.dart';
import 'package:rtu_mirea_app/map/widgets/map_route_sheet.dart';

class PreviewMapPage extends StatefulWidget {
  const PreviewMapPage({super.key});

  @override
  State<PreviewMapPage> createState() => _PreviewMapPageState();
}

class _PreviewMapPageState extends State<PreviewMapPage> {
  int _step = 0;
  String _correction = '';

  Future<void> _correctPassages() async {
    final value = await showAppSheet<String>(
      context,
      title: context.l10n.mapRouteCorrectPassages,
      child: PreviewTextSheet(
        label: context.l10n.mapRouteCorrectPassages,
        initialValue: _correction,
      ),
    );
    if (value != null && mounted) setState(() => _correction = value);
  }

  @override
  Widget build(BuildContext context) {
    final route = PreviewMapFixture.route;
    final l10n = context.l10n;
    return PreviewPage(
      children: [
        NinjaDisplayHeader(
          title: l10n.navMap,
          summary: l10n.serviceMapSub,
          padding: EdgeInsets.zero,
        ),
        MapRouteGuidance(
          campus: PreviewMapFixture.campus,
          route: route,
          stepIndex: _step,
          onClose: () => setState(() => _step = 0),
          onNext: () =>
              setState(() => _step = (_step + 1) % route.instructions.length),
          onPrevious: _step == 0 ? null : () => setState(() => _step--),
          onStepSelected: (index) => setState(() => _step = index),
        ),
        AppButton.primary(
          label: l10n.lessonDetailsRoute,
          icon: const AppLineIconWidget(AppLineIcon.pin),
          onPressed: () => unawaited(
            showAppSheet<void>(
              context,
              child: MapRouteSheet(
                campus: PreviewMapFixture.campus,
                startRoomId: 'start',
                destinationRoomId: 'finish',
                onClose: () => Navigator.of(context).pop(),
                onApply: (_) => setState(() => _step = 0),
                onContribute: () => unawaited(_correctPassages()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
