import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/pages/settings.dart';
import 'package:neon_framework/src/router.dart';
import 'package:neon_framework/src/utils/provider.dart';
import 'package:neon_framework/src/widgets/adaptive_widgets/list_tile.dart';
import 'package:neon_framework/src/widgets/dialog.dart';
import 'package:neon_framework/src/widgets/user_avatar.dart';

@internal
class AccountSwitcherButton extends StatelessWidget {
  const AccountSwitcherButton({
    super.key,
  });

  Future<void> _onPressed(BuildContext context) async {
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);

    final account = await showDialog<Account>(
      context: context,
      builder: (context) => NeonAccountSelectionDialog(
        highlightActiveAccount: true,
        children: [
          AdaptiveListTile(
            leading: const Icon(Icons.settings),
            title: Text(NeonLocalizations.of(context).settingsAccountManage),
            onTap: () {
              Navigator.of(context).pop();
              const SettingsRoute(initialCategory: SettingsCategories.accounts).push<void>(context);
            },
          ),
        ],
      ),
    );

    if (account != null) {
      accountsBloc.setActiveAccount(account);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final account = accountsBloc.activeAccount.value!;

    return IconButton(
      onPressed: () async => _onPressed(context),
      tooltip: NeonLocalizations.of(context).settingsAccount,
      icon: NeonUserAvatar(
        account: account,
      ),
    );
  }
}
