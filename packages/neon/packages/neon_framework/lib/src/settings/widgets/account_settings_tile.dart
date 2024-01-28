import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/models/account.dart';
import 'package:neon_framework/src/settings/widgets/settings_tile.dart';
import 'package:neon_framework/src/widgets/account_tile.dart';

/// An [NeonAccountTile] used inside a settings list.
@internal
class AccountSettingsTile extends SettingsTile {
  /// Creates a new account settings tile.
  const AccountSettingsTile({
    required this.account,
    this.trailing,
    this.onTap,
    super.key,
  });

  /// {@macro neon_framework.AccountTile.account}
  final Account account;

  /// {@macro neon_framework.AdaptiveListTile.trailing}
  final Widget? trailing;

  /// {@macro neon_framework.AdaptiveListTile.onTap}
  final FutureOr<void> Function()? onTap;

  @override
  Widget build(BuildContext context) => NeonAccountTile(
        account: account,
        trailing: trailing,
        onTap: onTap,
      );
}
