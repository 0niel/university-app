import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/login_flow.dart';
import 'package:neon_framework/src/router.dart';
import 'package:neon_framework/src/widgets/error.dart';
import 'package:neon_framework/src/widgets/linear_progress_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

@internal
class LoginFlowPage extends StatefulWidget {
  const LoginFlowPage({
    required this.serverURL,
    super.key,
  });

  final Uri serverURL;

  @override
  State<LoginFlowPage> createState() => _LoginFlowPageState();
}

class _LoginFlowPageState extends State<LoginFlowPage> {
  late final LoginFlowBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = LoginFlowBloc(widget.serverURL);

    bloc.init.listen((result) async {
      if (result.hasData) {
        await launchUrlString(
          result.requireData.login,
          mode: LaunchMode.externalApplication,
        );
      }
    });

    bloc.result.listen((result) {
      LoginCheckAccountRoute(
        serverUrl: Uri.parse(result.server),
        loginName: result.loginName,
        password: result.appPassword,
      ).pushReplacement(context);
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ResultBuilder.behaviorSubject(
                subject: bloc.init,
                builder: (context, init) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeonLinearProgressIndicator(
                      visible: init.isLoading,
                    ),
                    NeonError(
                      init.error,
                      onRetry: bloc.refresh,
                    ),
                    if (init.hasData) ...[
                      Text(NeonLocalizations.of(context).loginSwitchToBrowserWindow),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: bloc.refresh,
                        child: Text(NeonLocalizations.of(context).loginOpenAgain),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
