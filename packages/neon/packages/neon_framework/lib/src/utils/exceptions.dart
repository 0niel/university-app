import 'package:flutter/material.dart';
import 'package:neon_framework/l10n/localizations.dart';
import 'package:neon_framework/src/models/label_builder.dart';
import 'package:permission_handler/permission_handler.dart';

/// Details of a [NeonException].
class NeonExceptionDetails {
  /// Creates new [NeonExceptionDetails].
  ///
  /// [isUnauthorized] defaults to false.
  const NeonExceptionDetails({
    required this.getText,
    this.isUnauthorized = false,
  });

  /// Text that will be displayed in the UI
  final LabelBuilder getText;

  /// If the [Exception] is the result of an unauthorized API request this should be set to `true`.
  ///
  /// The user will then be shown a button to update the credentials of the account instead of retrying the action.
  final bool isUnauthorized;
}

/// Extensible [Exception] to be used for displaying custom errors in the UI.
@immutable
abstract class NeonException implements Exception {
  /// Creates a NeonException
  const NeonException();

  /// Details that will be rendered by the UI.
  NeonExceptionDetails get details;
}

/// [Exception] that should be thrown when a native permission is denied.
class MissingPermissionException extends NeonException {
  /// Creates a MissingPermissionException
  const MissingPermissionException(this.permission);

  /// Permission that was denied
  final Permission permission;

  @override
  NeonExceptionDetails get details => NeonExceptionDetails(
        getText: (context) => NeonLocalizations.of(context).errorMissingPermission(permission.toString().split('.')[1]),
      );
}
