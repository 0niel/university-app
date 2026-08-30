import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/nfc_pass/widgets/nfc_how_it_works_step.dart';

class NfcHowItWorks extends StatelessWidget {
  const NfcHowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.ninja;
    final steps = [l10n.nfcPassStep1, l10n.nfcPassStep2, l10n.nfcPassStep3];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.nfcPassHowItWorksTitle,
          style: NinjaText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const .only(bottom: 10),
            child: NfcHowItWorksStep(index: i + 1, text: steps[i]),
          ),
      ],
    );
  }
}
