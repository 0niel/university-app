import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/schedule.dart';
import 'package:university_app_server_api/client.dart';

class SetCommentBottomSheetContent extends StatefulWidget {
  final (UID, dynamic, List<SchedulePart>) schedule;
  final Function(String?) onConfirm;
  final String? initialComment;

  const SetCommentBottomSheetContent({
    super.key,
    required this.schedule,
    required this.onConfirm,
    this.initialComment,
  });

  @override
  State<SetCommentBottomSheetContent> createState() => _SetCommentBottomSheetContentState();
}

class _SetCommentBottomSheetContentState extends State<SetCommentBottomSheetContent> {
  late final TextEditingController _commentController;
  String? _commentErrorText;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.initialComment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _setComment() {
    if (_commentController.text.isEmpty) {
      widget.onConfirm(null);
    } else {
      widget.onConfirm(_commentController.text);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextInput(
          hintText: 'Введите комментарий...',
          controller: _commentController,
          errorText: _commentErrorText,
          keyboardType: TextInputType.text,
          maxLines: 3,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          onClick: _setComment,
          text: 'Сохранить',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
