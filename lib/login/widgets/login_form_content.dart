part of 'login_form.dart';

class _LoginFormContent extends StatelessWidget {
  const _LoginFormContent();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: .fromLTRB(
        NinjaMetrics.screenPadding,
        NinjaMetrics.screenPadding,
        NinjaMetrics.screenPadding,
        32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _LoginFormTitle(),
          SizedBox(height: 20),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: NinjaLogoBadge(size: 56, spin: false),
          ),
          SizedBox(height: 20),
          _LoginFormSubtitle(),
          SizedBox(height: 24),
          _LoginFormContinueButton(),
        ],
      ),
    );
  }
}
