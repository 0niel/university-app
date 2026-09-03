import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

void showToolsNumberSheet(
  BuildContext context, {
  required String title,
  required int value,
  required int max,
  required ValueChanged<int> onSave,
  int min = 0,
}) {
  unawaited(
    showAppSheet<void>(
      context,
      title: title,
      child: _NumberForm(value: value, min: min, max: max, onSave: onSave),
    ),
  );
}

class _NumberForm extends StatefulWidget {
  const _NumberForm({
    required this.value,
    required this.min,
    required this.max,
    required this.onSave,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onSave;

  @override
  State<_NumberForm> createState() => _NumberFormState();
}

class _NumberFormState extends State<_NumberForm> {
  late final controller = TextEditingController(text: '${widget.value}');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = int.tryParse(controller.text);
    final valid = value != null && value >= widget.min && value <= widget.max;
    return Column(
      children: [
        AppInputField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => setState(() {}),
          helperText: '${widget.min}–${widget.max}',
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton.primary(
          label: context.l10n.save,
          expanded: true,
          onPressed: valid
              ? () {
                  widget.onSave(value);
                  Navigator.of(context).pop();
                }
              : null,
        ),
      ],
    );
  }
}
