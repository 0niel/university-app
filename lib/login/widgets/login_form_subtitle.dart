part of 'login_form.dart';

class _LoginFormSubtitle extends StatelessWidget {
  const _LoginFormSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.authSignInSubtitle,
      style: NinjaText.body.copyWith(color: context.ninja.mutedDark),
    );
  }
}
