part of '../view/onboarding_page.dart';

class _IdentityBody extends StatelessWidget {
  const _IdentityBody({
    required this.nameController,
    required this.handleController,
    required this.check,
    required this.onNameChanged,
    required this.onHandleChanged,
  });

  final TextEditingController nameController;
  final TextEditingController handleController;
  final _HandleCheck check;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onHandleChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final l10n = context.l10n;

    final (String? error, String? helper) = switch (check) {
      .taken => (l10n.identityHandleTaken, null),
      .invalid => (l10n.identityHandleInvalid, null),
      .available => (null, l10n.identityHandleAvailable),
      .idle || .checking => (null, l10n.identityHandleHelp),
    };

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        const _OnboardingLeadIcon(AppLineIcon.user),
        const SizedBox(height: 18),
        Text(
          l10n.onboardingIdentityTitle,
          style: NinjaText.title.copyWith(color: colors.ink),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.onboardingIdentitySubtitle,
          style: NinjaText.body.copyWith(color: colors.mutedDark),
        ),
        const SizedBox(height: 22),
        NinjaInput(
          controller: nameController,
          label: l10n.identityNameLabel,
          placeholder: l10n.identityNameHint,
          textInputAction: .next,
          textCapitalization: TextCapitalization.words,
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 16),
        NinjaInput(
          controller: handleController,
          label: l10n.identityHandleLabel,
          placeholder: l10n.identityHandleHint,
          leadingIcon: const AppLineIconWidget(AppLineIcon.at),
          clearable: false,
          success: check == .available,
          inputFormatters: [
            const _HandleInputFormatter(),
            LengthLimitingTextInputFormatter(20),
          ],
          onChanged: onHandleChanged,
          errorText: error,
          helperText: helper,
        ),
      ],
    );
  }
}

class _HandleInputFormatter extends TextInputFormatter {
  const _HandleInputFormatter();
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final filtered = newValue.text.toLowerCase().replaceAll(
      RegExp('[^a-z0-9_]'),
      '',
    );
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}
