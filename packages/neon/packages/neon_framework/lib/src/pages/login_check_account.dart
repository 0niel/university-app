import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/bloc/result.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/blocs/login_check_account.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/router.dart';
import 'package:neon_framework/src/theme/dialog.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/account_tile.dart';
import 'package:neon_framework/src/widgets/error.dart';
import 'package:neon_framework/src/widgets/validation_tile.dart';

@internal
class LoginCheckAccountPage extends StatefulWidget {
  const LoginCheckAccountPage({
    required this.serverURL,
    required this.loginName,
    required this.password,
    super.key,
  });

  final Uri serverURL;
  final String loginName;
  final String password;

  @override
  State<LoginCheckAccountPage> createState() => _LoginCheckAccountPageState();
}

class _LoginCheckAccountPageState extends State<LoginCheckAccountPage> {
  late final LoginCheckAccountBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = LoginCheckAccountBloc(
      widget.serverURL,
      widget.loginName,
      widget.password,
    );
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
                  builder: (context, state) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state.hasError) ...[
                        Builder(
                          builder: (context) {
                            final details = NeonError.getDetails(state.error);
                            return NeonValidationTile(
                              title: details.isUnauthorized
                                  ? NeonLocalizations.of(context).errorCredentialsForAccountNoLongerMatch
                                  : details.getText(context),
                              state: ValidationState.failure,
                            );
                          },
                        ),
                      ],
                      _buildAccountTile(state),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: state.hasData
                              ? () {
                                  NeonProvider.of<AccountsBloc>(context)
                                    ..updateAccount(state.requireData)
                                    ..setActiveAccount(state.requireData);

                                  const HomeRoute().go(context);
                                }
                              : () {
                                  if (state.hasError && NeonError.getDetails(state.error).isUnauthorized) {
                                    Navigator.pop(context);
                                    return;
                                  }

                                  unawaited(bloc.refresh());
                                },
                          child: Text(
                            state.hasData
                                ? NeonLocalizations.of(context).actionContinue
                                : NeonLocalizations.of(context).actionRetry,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildAccountTile(Result<Account> result) {
    if (result.hasError) {
      return NeonValidationTile(
        title: NeonLocalizations.of(context).loginCheckingAccount,
        state: ValidationState.canceled,
      );
    }

    if (result.hasData) {
      return NeonAccountTile(
        account: result.requireData,
        showStatus: false,
      );
    }

    return NeonValidationTile(
      title: NeonLocalizations.of(context).loginCheckingAccount,
      state: ValidationState.loading,
    );
  }
}
