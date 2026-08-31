part of 'login_with_email_form.dart';

class _LoginWithEmailFormUniversityHint extends StatelessWidget {
  const _LoginWithEmailFormUniversityHint();

  @override
  Widget build(BuildContext context) {
    final colors = context.ninja;
    final universityConfig = context.read<UniversityConfig>();
    return Semantics(
      key: const Key('loginWithEmailForm_terms_and_privacy_policy'),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: .circular(NinjaRadius.card),
        ),
        child: Padding(
          padding: const .fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.brandTint,
                  shape: .circle,
                ),
                child: SizedBox.square(
                  dimension: NinjaMetrics.minTouchTarget,
                  child: AppLineIconWidget(
                    AppLineIcon.school,
                    size: 20,
                    color: colors.brand,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  context.l10n.authUniversityEmailHint(
                    universityConfig.emailDomainHint,
                  ),
                  style: NinjaText.subtext.copyWith(color: colors.mutedDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
