import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'info_row.dart';

class NfcCardInfo extends StatelessWidget {
  const NfcCardInfo({required this.passId, super.key});

  final String? passId;

  @override
  Widget build(BuildContext context) {
    final id = passId;
    if (id == null) return const SizedBox.shrink();

    final l10n = context.l10n;
    final colors = context.ninja;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.nfcPassInfoTitle,
          style: NinjaText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 6),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(NinjaRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(label: l10n.nfcPassIdField, value: _obfuscate(id)),
                const SizedBox(height: 14),
                _InfoRow(
                  label: l10n.nfcPassStatusField,
                  value: l10n.nfcPassActiveStatus,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _obfuscate(String id) {
    if (id.length <= 6) return id;
    return '${id.substring(0, 3)}•••${id.substring(id.length - 3)}';
  }
}
