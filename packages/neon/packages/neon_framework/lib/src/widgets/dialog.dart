import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/blocs.dart';
import 'package:neon_framework/src/blocs/accounts.dart';
import 'package:neon_framework/src/theme/dialog.dart';
import 'package:neon_framework/src/utils/global_options.dart';
import 'package:neon_framework/src/widgets/account_tile.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// An button typically used in an [AlertDialog.adaptive].
///
/// It adaptively creates an [CupertinoDialogAction] based on the closest
/// [ThemeData.platform].

class NeonDialogAction extends StatelessWidget {
  /// Creates a new adaptive Neon dialog action.
  const NeonDialogAction({
    required this.onPressed,
    required this.child,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    super.key,
  });

  /// The callback that is called when the button is tapped or otherwise
  /// activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// Set to true if button is the default choice in the dialog.
  ///
  /// Default buttons have higher emphasis. Similar to
  /// [CupertinoDialogAction.isDefaultAction]. More than one action can have
  /// this attribute set to true in the same [Dialog].
  ///
  /// This parameters defaults to false and cannot be null.
  final bool isDefaultAction;

  /// Whether this action destroys an object.
  ///
  /// For example, an action that deletes an email is destructive.
  ///
  /// Defaults to false and cannot be null.
  final bool isDestructiveAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        if (isDestructiveAction) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.errorContainer,
              foregroundColor: colorScheme.onErrorContainer,
            ),
            onPressed: onPressed,
            child: child,
          );
        }

        if (isDefaultAction) {
          return ElevatedButton(onPressed: onPressed, child: child);
        }

        return OutlinedButton(onPressed: onPressed, child: child);

      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoDialogAction(
          onPressed: onPressed,
          isDefaultAction: isDefaultAction,
          isDestructiveAction: isDestructiveAction,
          child: child,
        );
    }
  }
}

/// A Neon design dialog based on [AlertDialog.adaptive].
///
/// THis widget enforces the closest [NeonDialogTheme] and constraints the
/// [content] width accordingly. The [title] should never be larger than the
/// [NeonDialogTheme.constraints] and it it up to the caller to handle this.
class NeonDialog extends StatelessWidget {
  /// Creates a Neon dialog.
  ///
  /// Typically used in conjunction with [showDialog].
  const NeonDialog({
    this.icon,
    this.title,
    this.content,
    this.actions,
    this.automaticallyShowCancel = true,
    super.key,
  });

  /// {@template NeonDialog.icon}
  /// An optional icon to display at the top of the dialog.
  ///
  /// Typically, an [Icon] widget. Providing an icon centers the [title]'s text.
  /// {@endtemplate}
  final Widget? icon;

  /// The (optional) title of the dialog is displayed in a large font at the top
  /// of the dialog.
  ///
  /// It is up to the caller to enforce [NeonDialogTheme.constraints] is meat.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// {@template NeonDialog.content}
  /// The (optional) content of the dialog is displayed in the center of the
  /// dialog in a lighter font.
  ///
  /// Typically this is a [SingleChildScrollView] that contains the dialog's
  /// message. As noted in the [AlertDialog] documentation, it's important
  /// to use a [SingleChildScrollView] if there's any risk that the content
  /// will not fit, as the contents will otherwise overflow the dialog.
  ///
  /// The horizontal dimension of this widget is constrained by the closest
  /// [NeonDialogTheme.constraints].
  /// {@endtemplate}
  final Widget? content;

  /// The (optional) set of actions that are displayed at the bottom of the
  /// dialog with an [OverflowBar].
  ///
  /// Typically this is a list of [NeonDialogAction] widgets. It is recommended
  /// to set the [Text.textAlign] to [TextAlign.end] for the [Text] within the
  /// [TextButton], so that buttons whose labels wrap to an extra line align
  /// with the overall [OverflowBar]'s alignment within the dialog.
  ///
  /// If the [title] is not null but the [content] _is_ null, then an extra 20
  /// pixels of padding is added above the [OverflowBar] to separate the [title]
  /// from the [actions].
  final List<Widget>? actions;

  /// Whether to automatically show a cancel button when only less than two
  /// actions are supplied.
  ///
  /// This is needed for the ios where dialogs are not dismissible by tapping
  /// outside their boundary.
  ///
  /// Defaults to `true`.
  final bool automaticallyShowCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dialogTheme = NeonDialogTheme.of(context);

    var content = this.content;
    if (content != null) {
      content = ConstrainedBox(
        constraints: dialogTheme.constraints,
        child: content,
      );
    }

    final needsCancelAction = automaticallyShowCancel &&
        (actions == null || actions!.length <= 1) &&
        (theme.platform == TargetPlatform.iOS || theme.platform == TargetPlatform.macOS);

    return AlertDialog.adaptive(
      icon: icon,
      title: title,
      content: content,
      actions: [
        if (needsCancelAction)
          NeonDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              NeonLocalizations.of(context).actionCancel,
              textAlign: TextAlign.end,
            ),
          ),
        ...?actions,
      ],
    );
  }
}

/// A [NeonDialog] with predefined `actions` to confirm or decline.
class NeonConfirmationDialog extends StatelessWidget {
  /// Creates a new confirmation dialog.
  const NeonConfirmationDialog({
    required this.title,
    this.content,
    this.icon,
    this.confirmAction,
    this.declineAction,
    this.isDestructive = true,
    super.key,
  });

  /// The title of the dialog is displayed in a large font at the top of the
  /// dialog.
  ///
  /// It is up to the caller to enforce [NeonDialogTheme.constraints] is meat
  /// and the text does not overflow.
  final String title;

  /// {@macro NeonDialog.icon}
  final Widget? icon;

  /// {@macro NeonDialog.content}
  final Widget? content;

  /// An optional override for the confirming action.
  ///
  /// It is advised to wrap the action in a [Builder] to retain an up to date
  /// `context` for the Navigator.
  ///
  /// Typically this is a [NeonDialogAction] widget.
  final Widget? confirmAction;

  /// An optional override for the declining action.
  ///
  /// It is advised to wrap the action in a [Builder] to retain an up to date
  /// `context` for the Navigator.
  ///
  /// Typically this is a [NeonDialogAction] widget.
  final Widget? declineAction;

  /// Whether confirming this dialog destroys an object.
  ///
  /// For example, a warning dialog that when accepted deletes an email is
  /// considered destructive.
  /// This value will set the default confirming action to being destructive.
  ///
  /// Defaults to true and cannot be null.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final confirm = confirmAction ??
        NeonDialogAction(
          isDestructiveAction: isDestructive,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(
            NeonLocalizations.of(context).actionContinue,
            textAlign: TextAlign.end,
          ),
        );

    final decline = declineAction ??
        NeonDialogAction(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            NeonLocalizations.of(context).actionCancel,
            textAlign: TextAlign.end,
          ),
        );

    return NeonDialog(
      icon: icon,
      title: Text(title),
      content: content,
      actions: [
        decline,
        confirm,
      ],
    );
  }
}

/// A [NeonDialog] that shows for renaming an object.
///
/// Use `showRenameDialog` to display this dialog.
///
/// When submitted the new value will be popped as a `String`.
/// If the new value is equal to the provided one `null` will be popped.
class NeonRenameDialog extends StatefulWidget {
  /// Creates a new Neon rename dialog.
  const NeonRenameDialog({
    required this.title,
    required this.value,
    super.key,
  });

  /// The title of the dialog.
  final String title;

  /// The initial value of the rename field.
  ///
  /// This is the current name of the object to be renamed.
  final String value;

  @override
  State<NeonRenameDialog> createState() => _NeonRenameDialogState();
}

class _NeonRenameDialogState extends State<NeonRenameDialog> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  void initState() {
    controller.text = widget.value;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (controller.text != widget.value) {
      Navigator.of(context).pop(controller.text);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Material(
      child: TextFormField(
        autofocus: true,
        controller: controller,
        validator: (input) => validateNotEmpty(context, input),
        onFieldSubmitted: (_) {
          submit();
        },
      ),
    );

    return NeonDialog(
      title: Text(widget.title),
      content: Form(key: formKey, child: content),
      actions: [
        NeonDialogAction(
          isDefaultAction: true,
          onPressed: submit,
          child: Text(
            widget.title,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

/// A [NeonDialog] that informs the user about an error.
///
/// Use `showErrorDialog` to display this dialog.
class NeonErrorDialog extends StatelessWidget {
  /// Creates a new error dialog.
  const NeonErrorDialog({
    required this.content,
    this.title,
    super.key,
  });

  /// The (optional) title for the dialog.
  ///
  /// Defaults to [NeonLocalizations.errorDialog].
  final String? title;

  /// The content of the dialog.
  final String content;

  @override
  Widget build(BuildContext context) {
    final title = this.title ?? NeonLocalizations.of(context).errorDialog;

    final closeAction = NeonDialogAction(
      isDestructiveAction: true,
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(
        NeonLocalizations.of(context).actionClose,
        textAlign: TextAlign.end,
      ),
    );

    return NeonDialog(
      automaticallyShowCancel: false,
      icon: const Icon(Icons.error),
      title: Text(title),
      content: Text(content),
      actions: [
        closeAction,
      ],
    );
  }
}

/// Account selection dialog.
///
/// Displays a list of all logged in accounts.
///
/// When one is selected the dialog gets pooped with the selected `Account`.
@internal
class NeonAccountSelectionDialog extends StatelessWidget {
  /// Creates a new account selection dialog.
  const NeonAccountSelectionDialog({
    this.highlightActiveAccount = false,
    this.children,
    super.key,
  });

  /// Whether the selected account is highlighted with a leading check icon.
  final bool highlightActiveAccount;

  /// The (optional) trailing children of this dialog.
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final dialogTheme = NeonDialogTheme.of(context);
    final accountsBloc = NeonProvider.of<AccountsBloc>(context);
    final accounts = accountsBloc.accounts.value;
    final activeAccount = accountsBloc.activeAccount.value!;

    final sortedAccounts = List.of(accounts)
      ..removeWhere((account) => account.id == activeAccount.id)
      ..insert(0, activeAccount);

    final tiles = sortedAccounts
        .map<Widget>(
          (account) => NeonAccountTile(
            account: account,
            trailing: highlightActiveAccount && account.id == activeAccount.id ? const Icon(Icons.check_circle) : null,
            onTap: () {
              Navigator.of(context).pop(account);
            },
          ),
        )
        .toList();
    if (highlightActiveAccount && accounts.length > 1) {
      tiles.insert(1, const Divider());
    }

    final body = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...tiles,
          ...?children,
        ],
      ),
    );

    return Dialog(
      child: IntrinsicHeight(
        child: Container(
          padding: dialogTheme.padding,
          constraints: dialogTheme.constraints,
          child: body,
        ),
      ),
    );
  }
}

/// A [NeonDialog] to inform the user about the UnifiedPush feature of neon.
@internal
class NeonUnifiedPushDialog extends StatelessWidget {
  /// Creates a new UnifiedPush dialog.
  const NeonUnifiedPushDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) => NeonDialog(
        title: Text(NeonLocalizations.of(context).nextPushSupported),
        content: Text(NeonLocalizations.of(context).nextPushSupportedText),
        actions: [
          NeonDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              NeonLocalizations.of(context).actionCancel,
              textAlign: TextAlign.end,
            ),
          ),
          NeonDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              Navigator.pop(context);
              await launchUrlString(
                'https://f-droid.org/packages/$unifiedPushNextPushID',
                mode: LaunchMode.externalApplication,
              );
            },
            child: Text(
              NeonLocalizations.of(context).nextPushSupportedInstall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
}

/// Shows an emoji picker.
///
/// When the user selects an emoji the dialog will pop and return the emoji as a `String`.
class NeonEmojiPickerDialog extends StatelessWidget {
  /// Creates a new emoji picker dialog.
  const NeonEmojiPickerDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constraints = NeonDialogTheme.of(context).constraints;

    return NeonDialog(
      content: SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxWidth * 1.5,
        child: EmojiPicker(
          config: Config(
            emojiSizeMax: 25,
            columns: 10,
            bgColor: Colors.transparent,
            indicatorColor: theme.colorScheme.primary,
            iconColorSelected: theme.colorScheme.primary,
            skinToneDialogBgColor: theme.dialogBackgroundColor,
            skinToneIndicatorColor: theme.colorScheme.primary,
          ),
          onEmojiSelected: (category, emoji) {
            Navigator.of(context).pop(emoji.emoji);
          },
        ),
      ),
    );
  }
}
