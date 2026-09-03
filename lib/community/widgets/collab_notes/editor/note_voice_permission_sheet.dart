import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

Future<bool> showNoteVoicePermissionSheet(BuildContext context) async {
  final allowed = await showAppSheet<bool>(
    context,
    title: context.l10n.noteVoicePermissionTitle,
    child: const _NoteVoicePermissionSheet(),
  );
  return allowed ?? false;
}

class _NoteVoicePermissionSheet extends StatelessWidget {
  const _NoteVoicePermissionSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIconTile(icon: AppLineIcon.mic, background: colors.tint),
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.noteVoicePermissionBody,
          style: AppText.body.copyWith(color: colors.muted, height: 1.5),
        ),
        const SizedBox(height: AppSpacing.fieldGap),
        AppButton.primary(
          label: l10n.noteVoicePermissionAllow,
          expanded: true,
          size: AppButtonSize.large,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
