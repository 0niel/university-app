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
      child: _ToolsNumberSheet(
        value: value,
        min: min,
        max: max,
        onSave: onSave,
      ),
    ),
  );
}

class _ToolsNumberSheet extends StatefulWidget {
  const _ToolsNumberSheet({
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
  State<_ToolsNumberSheet> createState() => _ToolsNumberSheetState();
}

class _ToolsNumberSheetState extends State<_ToolsNumberSheet> {
  late final controller = TextEditingController(text: '${widget.value}');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, textValue, child) {
          final value = int.tryParse(textValue.text);
          final valid =
              value != null && value >= widget.min && value <= widget.max;
          return Column(
            children: [
              AppInputField(
                controller: controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
        },
      );
}
