import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rtu_mirea_app/friends/view/ninja_qr_glass_button.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NinjaQrScanTopBar extends StatelessWidget {
  const NinjaQrScanTopBar({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Padding(
      padding: const .fromLTRB(16, 8, 16, 0),
      child: Row(
        spacing: 12,
        children: [
          NinjaQrGlassButton(
            icon: .close,
            label: MaterialLocalizations.of(context).closeButtonLabel,
            onTap: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              l10n.friendsScanTitle,
              maxLines: 1,
              overflow: .ellipsis,
              textAlign: .center,
              style: AppText.headline.copyWith(color: colors.white),
            ),
          ),
          ValueListenableBuilder<MobileScannerState>(
            valueListenable: controller,
            builder: (context, state, _) => NinjaQrGlassButton(
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
