import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/bloc/nfc_pass_cubit.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_card_info.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_media_preview.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_media_selector.dart';

class NfcCardSettingsSheet extends StatelessWidget {
  const NfcCardSettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.ninja;

    return BlocBuilder<NfcPassCubit, NfcPassState>(
      builder: (context, state) {
        final cubit = context.read<NfcPassCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.settingsNfcDescription,
              style: NinjaText.subtext.copyWith(
                height: 1.45,
                color: colors.mutedDark,
              ),
            ),
            const SizedBox(height: 22),
            NfcMediaSelector(
              hasMedia: state.localFilePath != null,
              isVideo: state.isVideo,
              onSelectMedia: () => unawaited(cubit.pickFile()),
              onRemoveMedia: state.localFilePath != null
                  ? cubit.removeFile
                  : null,
            ),
            const SizedBox(height: 22),
            NfcMediaPreview(
              filePath: state.localFilePath,
              isVideo: state.isVideo,
            ),
            if (state.status == .bound) ...[
              const SizedBox(height: 22),
              NfcCardInfo(passId: state.passId?.toString()),
            ],
            const SizedBox(height: 22),
            NinjaButton.primary(
              label: l10n.done,
              size: NinjaButtonSize.large,
              expanded: true,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
