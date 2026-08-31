import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/config/config.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class ServicesSearchBar extends StatelessWidget {
  const ServicesSearchBar({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final isNfcPassEnabled = context.read<UniversityConfig>().isEnabled(
      .nfcPass,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        NinjaMetrics.screenPadding,
        0,
        NinjaMetrics.screenPadding,
        16,
      ),
      child: NinjaInput(
        controller: controller,
        placeholder: context.l10n.servicesSearchHint,
        leadingIcon: NinjaGlyphIcon(
          NinjaGlyph.search,
          size: 17,
          color: colors.muted,
        ),
        trailing: isNfcPassEnabled
            ? AppPressable(
                onTap: () => context.go('/services/nfc'),
                child: SizedBox.square(
                  dimension: NinjaMetrics.minTouchTarget,
                  child: Center(
                    child: AppLineIconWidget(
                      AppLineIcon.qr,
                      size: 19,
                      color: colors.muted,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
