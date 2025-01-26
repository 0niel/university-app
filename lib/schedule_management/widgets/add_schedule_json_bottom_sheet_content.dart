import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

class AddScheduleJsonBottomSheetContent extends StatefulWidget {
  final Function(String) onConfirm;

  const AddScheduleJsonBottomSheetContent({
    super.key,
    required this.onConfirm,
  });

  @override
  State<AddScheduleJsonBottomSheetContent> createState() => _AddScheduleJsonBottomSheetContentState();
}

class _AddScheduleJsonBottomSheetContentState extends State<AddScheduleJsonBottomSheetContent> {
  final _jsonController = TextEditingController();
  String? _jsonErrorText;

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  void _addScheduleFromJson() {
    if (_jsonController.text.isEmpty) {
      setState(() {
        _jsonErrorText = 'Пожалуйста, введите JSON строку';
      });
    } else {
      widget.onConfirm(_jsonController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextInput(
          hintText: 'Введите JSON строку...',
          controller: _jsonController,
          errorText: _jsonErrorText,
          keyboardType: TextInputType.multiline,
          maxLines: 8,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          onClick: _addScheduleFromJson,
          text: 'Добавить',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
