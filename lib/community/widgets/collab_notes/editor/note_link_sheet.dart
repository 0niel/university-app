import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class NoteLinkInput {
  const NoteLinkInput({required this.url, required this.text});

  final String url;
  final String text;
}

Future<NoteLinkInput?> showNoteLinkSheet(
  BuildContext context, {
  String initialText = '',
  bool showTextField = true,
}) {
  return showAppSheet<NoteLinkInput>(
    context,
    title: context.l10n.noteLinkTitle,
    child: _NoteLinkSheet(
      initialText: initialText,
      showTextField: showTextField,
    ),
  );
}

class _NoteLinkSheet extends StatefulWidget {
  const _NoteLinkSheet({
    required this.initialText,
    required this.showTextField,
  });

  final String initialText;
  final bool showTextField;

  @override
  State<_NoteLinkSheet> createState() => _NoteLinkSheetState();
}

class _NoteLinkSheetState extends State<_NoteLinkSheet> {
  late final _urlController = TextEditingController();
  late final _textController = TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _urlController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;
    final text = _textController.text.trim();
    Navigator.of(context).pop(
      NoteLinkInput(url: url, text: text.isEmpty ? url : text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInputField(
          controller: _urlController,
          label: l10n.noteLinkUrlLabel,
          placeholder: l10n.noteLinkUrlHint,
          keyboardType: TextInputType.url,
          autofocus: true,
          textInputAction: widget.showTextField
              ? TextInputAction.next
              : TextInputAction.done,
          onSubmitted: widget.showTextField ? null : (_) => _submit(),
        ),
        if (widget.showTextField) ...[
          const SizedBox(height: AppSpacing.fieldGap),
          AppInputField(
            controller: _textController,
            label: l10n.noteLinkTextLabel,
            placeholder: l10n.noteLinkTextHint,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
        ],
        const SizedBox(height: AppSpacing.fieldGap),
        AppButton.primary(
          label: l10n.noteLinkInsert,
          expanded: true,
          size: AppButtonSize.large,
          onPressed: _submit,
        ),
      ],
    );
  }
}
