import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Future<ImageSource?> showNoteImageSourceSheet(BuildContext context) {
  return showAppSheet<ImageSource>(
    context,
    title: context.l10n.noteImageSourceTitle,
    child: const _NoteImageSourceSheet(),
  );
}

class _NoteImageSourceSheet extends StatelessWidget {
  const _NoteImageSourceSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppListGroup(
      children: [
        AppListRow(
          leading: const AppIconTile(icon: AppLineIcon.camera),
          title: l10n.noteImageSourceCamera,
          isFirst: true,
          onTap: () => Navigator.of(context).pop(ImageSource.camera),
        ),
        AppListRow(
          leading: const AppIconTile(icon: AppLineIcon.image),
          title: l10n.noteImageSourceGallery,
          onTap: () => Navigator.of(context).pop(ImageSource.gallery),
        ),
      ],
    );
  }
}
