import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/login_check_server_status.dart';
import 'package:neon_framework/src/router.dart';
import 'package:neon_framework/src/theme/dialog.dart';
import 'package:neon_framework/src/widgets/error.dart';
import 'package:neon_framework/src/widgets/validation_tile.dart';
import 'package:nextcloud/core.dart' as core;

@internal
class LoginCheckServerStatusPage extends StatefulWidget {
  const LoginCheckServerStatusPage({
    required this.serverURL,
    super.key,
  })  : loginName = null,
        password = null;

  const LoginCheckServerStatusPage.withCredentials({
    required this.serverURL,
    required String this.loginName,
    required String this.password,
    super.key,
  });

  final Uri serverURL;
  final String? loginName;
  final String? password;

  @override
  State<LoginCheckServerStatusPage> createState() => _LoginCheckServerStatusPageState();
}

class _LoginCheckServerStatusPageState extends State<LoginCheckServerStatusPage> {
  late final LoginCheckServerStatusBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = LoginCheckServerStatusBloc(widget.serverURL);
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
              child: ConstrainedBox(
                constraints: NeonDialogTheme.of(context).constraints,
                child: ResultBuilder.behaviorSubject(
                  subject: bloc.state,
                  builder: (context, state) {
                    final success =
                        state.hasData && _isServerVersionAllowed(state.requireData) && !state.requireData.maintenance;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state.hasError) ...[
                          NeonValidationTile(
                            title: NeonError.getDetails(state.error).getText(context),
                            state: ValidationState.failure,
                          ),
                        ],
                        _buildServerVersionTile(state),
                        _buildMaintenanceModeTile(state),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: success ? _onContinue : bloc.refresh,
                            child: Text(
                              success
                                  ? NeonLocalizations.of(context).actionContinue
                                  : NeonLocalizations.of(context).actionRetry,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );

  void _onContinue() {
    if (widget.loginName != null) {
      LoginCheckAccountRoute(
        serverUrl: widget.serverURL,
        loginName: widget.loginName!,
        password: widget.password!,
      ).pushReplacement(context);
    } else {
      LoginFlowRoute(serverUrl: widget.serverURL).pushReplacement(context);
    }
  }

  bool _isServerVersionAllowed(core.Status status) =>
      status.versionCheck.isSupported || status.versionstring.contains('dev');

  Widget _buildServerVersionTile(Result<core.Status> result) {
    if (result.hasError) {
      return NeonValidationTile(
        title: NeonLocalizations.of(context).loginCheckingServerVersion,
        state: ValidationState.canceled,
      );
    }

    if (!result.hasData) {
      return NeonValidationTile(
        title: NeonLocalizations.of(context).loginCheckingServerVersion,
        state: ValidationState.loading,
      );
    }

    if (_isServerVersionAllowed(result.requireData)) {
      return NeonValidationTile(
        title: NeonLocalizations.of(context).loginSupportedServerVersion(result.requireData.versionstring),
        state: ValidationState.success,
      );
    }

    return NeonValidationTile(
      title: NeonLocalizations.of(context).loginUnsupportedServerVersion(result.requireData.versionstring),
      state: ValidationState.failure,
    );
  }

  Widget _buildMaintenanceModeTile(Result<core.Status> result) {
    if (result.hasError) {
      return NeonValidationTile(
        title: NeonLocalizations.of(context).loginCheckingMaintenanceMode,
        state: ValidationState.canceled,
      );
    }

    if (!result.hasData) {
      return NeonValidationTile(
        title: NeonLocalizations.of(context).loginCheckingMaintenanceMode,
        state: ValidationState.loading,
      );
    }

    if (result.requireData.maintenance) {
      return NeonValidationTile(
        title: NeonLocalizations.of(context).loginMaintenanceModeEnabled,
        state: ValidationState.failure,
      );
    }

    return NeonValidationTile(
      title: NeonLocalizations.of(context).loginMaintenanceModeDisabled,
      state: ValidationState.success,
    );
  }
}
