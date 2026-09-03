import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/mini_apps/widgets/mini_app_scan_glass_button.dart';

class MiniAppScanTopBar extends StatelessWidget {
  const MiniAppScanTopBar({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const .all(12),
      child: Row(
        children: [
          MiniAppScanGlassButton(
            icon: .close,
            onTap: () => Navigator.of(context).pop(),
            tooltip: MaterialLocalizations.of(context).closeButtonLabel,
          ),
          const Spacer(),
          Text(
            context.l10n.miniAppsScanTitle,
            style: AppText.body.copyWith(color: colors.white),
          ),
          const Spacer(),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: controller,
            builder: (context, state, _) => MiniAppScanGlassButton(
              icon: .bolt,
              active: state.torchState == .on,
              onTap: () => unawaited(controller.toggleTorch()),
            ),
          ),
        ],
      ),
    );
  }
}
