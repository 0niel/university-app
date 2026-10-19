import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

class PreviewTextSheet extends StatefulWidget {
  const PreviewTextSheet({
    required this.label,
    this.initialValue = '',
    super.key,
  });

  final String label;
  final String initialValue;

  @override
  State<PreviewTextSheet> createState() => _PreviewTextSheetState();
}

class _PreviewTextSheetState extends State<PreviewTextSheet> {
  late final _controller = TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      TextField(
        controller: _controller,
        minLines: 4,
        maxLines: 8,
        decoration: InputDecoration(labelText: widget.label),
      ),
      const SizedBox(height: AppSpacing.lg),
      AppButton.primary(
        label: context.l10n.save,
        expanded: true,
        onPressed: () => Navigator.of(context).pop(_controller.text),
      ),
    ],
  );
}
