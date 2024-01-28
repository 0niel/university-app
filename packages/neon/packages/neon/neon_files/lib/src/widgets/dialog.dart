import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neon_files/l10n/localizations.dart';
import 'package:neon_files/src/blocs/browser.dart';
import 'package:neon_files/src/blocs/files.dart';
import 'package:neon_files/src/utils/dialog.dart';
import 'package:neon_files/src/widgets/browser_view.dart';
import 'package:neon_framework/platform.dart';
import 'package:neon_framework/theme.dart';
import 'package:neon_framework/utils.dart';
import 'package:neon_framework/widgets.dart';
import 'package:nextcloud/nextcloud.dart';
import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';

/// Creates an adaptive bottom sheet to select an action to add a file.
class FilesChooseCreateModal extends StatefulWidget {
  /// Creates a new add files modal.
  const FilesChooseCreateModal({
    required this.bloc,
    super.key,
  });

  /// The bloc of the flies client.
  final FilesBloc bloc;

  @override
  State<FilesChooseCreateModal> createState() => _FilesChooseCreateModalState();
}

class _FilesChooseCreateModalState extends State<FilesChooseCreateModal> {
  late PathUri baseUri;

  @override
  void initState() {
    baseUri = widget.bloc.browser.uri.value;

    super.initState();
  }

  Future<void> uploadFromPick(FileType type) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: type,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }

    if (result != null) {
      for (final file in result.files) {
        await upload(File(file.path!));
      }
    }
  }

  Future<void> upload(File file) async {
    final sizeWarning = widget.bloc.options.uploadSizeWarning.value;
    if (sizeWarning != null) {
      final stat = file.statSync();
      if (stat.size > sizeWarning) {
        final result = await showUploadConfirmationDialog(context, sizeWarning, stat.size);

        if (!result) {
          return;
        }
      }
    }
    widget.bloc.uploadFile(
      baseUri.join(PathUri.parse(p.basename(file.path))),
      file.path,
    );
  }

  Widget wrapAction({
    required Widget icon,
    required Widget message,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return ListTile(
          leading: icon,
          title: message,
          onTap: onPressed,
        );

      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoActionSheetAction(
          onPressed: onPressed,
          child: message,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = FilesLocalizations.of(context).filesChooseCreate;

    final actions = [
      wrapAction(
        icon: Icon(
          MdiIcons.filePlus,
          color: Theme.of(context).colorScheme.primary,
        ),
        message: Text(FilesLocalizations.of(context).uploadFiles),
        onPressed: () async => uploadFromPick(FileType.any),
      ),
      wrapAction(
        icon: Icon(
          MdiIcons.fileImagePlus,
          color: Theme.of(context).colorScheme.primary,
        ),
        message: Text(FilesLocalizations.of(context).uploadImages),
        onPressed: () async => uploadFromPick(FileType.image),
      ),
      if (NeonPlatform.instance.canUseCamera)
        wrapAction(
          icon: Icon(
            MdiIcons.cameraPlus,
            color: Theme.of(context).colorScheme.primary,
          ),
          message: Text(FilesLocalizations.of(context).uploadCamera),
          onPressed: () async {
            Navigator.of(context).pop();

            final picker = ImagePicker();
            final result = await picker.pickImage(source: ImageSource.camera);
            if (result != null) {
              await upload(File(result.path));
            }
          },
        ),
      wrapAction(
        icon: Icon(
          MdiIcons.folderPlus,
          color: Theme.of(context).colorScheme.primary,
        ),
        message: Text(FilesLocalizations.of(context).folderCreate),
        onPressed: () async {
          Navigator.of(context).pop();

          final result = await showFolderCreateDialog(context: context);
          if (result != null) {
            widget.bloc.browser.createFolder(baseUri.join(PathUri.parse(result)));
          }
        },
      ),
    ];

    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return BottomSheet(
          onClosing: () {},
          builder: (context) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
                ...actions,
              ],
            ),
          ),
        );

      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoActionSheet(
          actions: actions,
          title: Text(title),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDestructiveAction: true,
            child: Text(NeonLocalizations.of(context).actionCancel),
          ),
        );
    }
  }
}

/// A dialog for choosing a folder.
///
/// This dialog is not adaptive and always builds a material design dialog.
class FilesChooseFolderDialog extends StatelessWidget {
  /// Creates a new folder chooser dialog.
  const FilesChooseFolderDialog({
    required this.bloc,
    required this.filesBloc,
    this.originalPath,
    super.key,
  });

  final FilesBrowserBloc bloc;
  final FilesBloc filesBloc;

  /// The initial path to start at.
  final PathUri? originalPath;

  @override
  Widget build(BuildContext context) {
    final dialogTheme = NeonDialogTheme.of(context);

    return StreamBuilder<PathUri>(
      stream: bloc.uri,
      builder: (context, uriSnapshot) {
        final actions = [
          OutlinedButton(
            onPressed: () async {
              final result = await showFolderCreateDialog(context: context);

              if (result != null) {
                bloc.createFolder(uriSnapshot.requireData.join(PathUri.parse(result)));
              }
            },
            child: Text(
              FilesLocalizations.of(context).folderCreate,
              textAlign: TextAlign.end,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(uriSnapshot.data),
            child: Text(
              FilesLocalizations.of(context).folderChoose,
              textAlign: TextAlign.end,
            ),
          ),
        ];

        return AlertDialog(
          title: Text(FilesLocalizations.of(context).folderChoose),
          content: ConstrainedBox(
            constraints: dialogTheme.constraints,
            child: SizedBox(
              width: double.maxFinite,
              child: FilesBrowserView(
                bloc: bloc,
                filesBloc: filesBloc,
              ),
            ),
          ),
          actions: uriSnapshot.hasData ? actions : null,
        );
      },
    );
  }
}

/// A [NeonDialog] that shows for renaming creating a new folder.
///
/// Use `showFolderCreateDialog` to display this dialog.
///
/// When submitted the folder name will be popped as a `String`.
class FilesCreateFolderDialog extends StatefulWidget {
  /// Creates a new NeonDialog for creating a folder.
  const FilesCreateFolderDialog({
    super.key,
  });

  @override
  State<FilesCreateFolderDialog> createState() => _FilesCreateFolderDialogState();
}

class _FilesCreateFolderDialogState extends State<FilesCreateFolderDialog> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      Navigator.of(context).pop(controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Material(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: FilesLocalizations.of(context).folderName,
        ),
        autofocus: true,
        validator: (input) => validateNotEmpty(context, input),
        onFieldSubmitted: (_) {
          submit();
        },
      ),
    );

    return NeonDialog(
      title: Text(FilesLocalizations.of(context).folderCreate),
      content: Form(
        key: formKey,
        child: content,
      ),
      actions: [
        NeonDialogAction(
          isDefaultAction: true,
          onPressed: submit,
          child: Text(
            FilesLocalizations.of(context).folderCreate,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
