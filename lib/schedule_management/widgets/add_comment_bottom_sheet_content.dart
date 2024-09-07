import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/widgets/buttons/primary_button.dart';
import 'package:rtu_mirea_app/presentation/widgets/forms/text_input.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

class AddCommentBottomSheetContent extends StatefulWidget {
  final (UID, dynamic, List<SchedulePart>) schedule;
  final Function(String) onConfirm;

  const AddCommentBottomSheetContent({
    Key? key,
    required this.schedule,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<AddCommentBottomSheetContent> createState() => _AddCommentBottomSheetContentState();
}

class _AddCommentBottomSheetContentState extends State<AddCommentBottomSheetContent> {
  final _commentController = TextEditingController();
  String? _commentErrorText;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.isEmpty) {
      setState(() {
        _commentErrorText = 'Пожалуйста, введите текст комментария';
      });
    } else {
      widget.onConfirm(_commentController.text);
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
          hintText: 'Введите небольшой комментарий...',
          controller: _commentController,
          errorText: _commentErrorText,
          keyboardType: TextInputType.text,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          onClick: _addComment,
          text: 'Сохранить',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
