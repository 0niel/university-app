part of '../view/onboarding_page.dart';

class _GroupSearchField extends StatelessWidget {
  const _GroupSearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NinjaInput(
      controller: controller,
      placeholder: l10n.onboardingGroupSearchHint,
      leadingIcon: const NinjaGlyphIcon(NinjaGlyph.search),
      textCapitalization: TextCapitalization.characters,
    );
  }
}
