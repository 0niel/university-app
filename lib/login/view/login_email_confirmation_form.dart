part of 'login_email_confirmation_page.dart';

class _LoginEmailConfirmationForm extends StatefulWidget {
  const _LoginEmailConfirmationForm({required this.email});

  final String email;

  @override
  State<_LoginEmailConfirmationForm> createState() =>
      _LoginEmailConfirmationFormState();
}

class _LoginEmailConfirmationFormState
    extends State<_LoginEmailConfirmationForm> {
  var _attempt = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        NinjaCodeInput(
          key: ValueKey('loginEmailConfirmation_code_$_attempt'),
          autofocus: true,
          onCompleted: (code) {
            context.read<LoginWithEmailLinkBloc>().add(
              LoginWithEmailCodeSubmitted(email: widget.email, code: code),
            );
          },
        ),
        const SizedBox(height: 18),
        _LoginEmailConfirmationStatus(
          onRetry: () => setState(() => _attempt++),
        ),
      ],
    );
  }
}
