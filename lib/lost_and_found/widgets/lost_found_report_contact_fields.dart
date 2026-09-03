import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class LostFoundReportContactFields extends StatelessWidget {
  const LostFoundReportContactFields({
    required this.telegramController,
    required this.phoneController,
    required this.showContact,
    required this.onShowContactChanged,
    super.key,
  });

  final TextEditingController telegramController;
  final TextEditingController phoneController;
  final bool showContact;
  final ValueChanged<bool> onShowContactChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Column(
      children: [
        NinjaInput(
          controller: telegramController,
          maxLength: 33,
          leadingIcon: const AppLineIconWidget(AppLineIcon.send),
          placeholder: l10n.lostFoundTelegramHint,
        ),
        const SizedBox(height: AppSpacing.gap),
        NinjaInput(
          controller: phoneController,
          maxLength: 24,
          keyboardType: TextInputType.phone,
          leadingIcon: const AppLineIconWidget(AppLineIcon.phone),
          placeholder: l10n.lostFoundPhoneHint,
        ),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          button: true,
          toggled: showContact,
          label: l10n.lostFoundContactConsent,
          child: AppPressable(
            onTap: () => onShowContactChanged(!showContact),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: AppControlSize.iconButton,
              ),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.gap,
                AppSpacing.md,
                AppSpacing.gap,
              ),
              decoration: BoxDecoration(
                color: colors.surface2,
                borderRadius: BorderRadius.circular(AppRadius.field),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.lostFoundContactConsent,
                      style: AppText.body.copyWith(color: colors.ink),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ExcludeSemantics(
                    child: NinjaSwitch(
                      value: showContact,
                      onChanged: onShowContactChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
