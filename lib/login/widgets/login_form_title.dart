part of 'login_form.dart';

class _LoginFormTitle extends StatelessWidget {
  const _LoginFormTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: Text(
            context.l10n.authSignInTitle,
            style: NinjaText.title.copyWith(color: context.ninja.ink),
          ),
        ),
        const SizedBox(width: 12),
        AppSheetCloseButton(
          key: const Key('loginForm_closeModal_iconButton'),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
