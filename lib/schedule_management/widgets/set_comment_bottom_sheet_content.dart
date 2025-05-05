import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/schedule/bloc/schedule_bloc.dart';
import 'package:university_app_server_api/client.dart';
import 'package:rtu_mirea_app/schedule/models/models.dart';

class SetCommentBottomSheetContent<T> extends StatefulWidget {
  final (UID, T, List<SchedulePart>) schedule;
  final String? initialComment;
  final Function(String?) onConfirm;

  const SetCommentBottomSheetContent({super.key, required this.schedule, this.initialComment, required this.onConfirm});

  @override
  State<SetCommentBottomSheetContent<T>> createState() => _SetCommentBottomSheetContentState<T>();
}

class _SetCommentBottomSheetContentState<T> extends State<SetCommentBottomSheetContent<T>> {
  late final TextEditingController _commentController;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.initialComment);
    _commentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasChanges = _commentController.text != widget.initialComment;
    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool _hasComment() {
    return widget.initialComment != null && widget.initialComment!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final scheduleName = (widget.schedule.$2 as SelectedSchedule).name;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Animate(
            effects: const [FadeEffect(duration: Duration(milliseconds: 300))],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: appColors.background01,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(HugeIcons.strokeRoundedCalendar02, color: appColors.active, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(scheduleName, style: AppTextStyle.titleM, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Комментарий', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
          const SizedBox(height: 8),
          TextInput(controller: _commentController, hintText: 'Введите текст комментария...', maxLines: 4),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_hasComment())
                TextButton.icon(
                  onPressed: () {
                    _commentController.clear();
                  },
                  icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                  label: Text('Удалить', style: TextStyle(color: theme.colorScheme.error)),
                ),
              if (!_hasComment()) const SizedBox.shrink(),
              Animate(
                effects: const [FadeEffect(duration: Duration(milliseconds: 300))],
                target: _hasChanges ? 1 : 0,
                child: ElevatedButton.icon(
                  onPressed:
                      _hasChanges
                          ? () {
                            widget.onConfirm(_commentController.text.isEmpty ? null : _commentController.text);
                            Navigator.of(context).pop();
                          }
                          : null,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Сохранить'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onPrimary,
                    backgroundColor: appColors.primary,
                    disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
                    disabledForegroundColor: theme.colorScheme.onSurfaceVariant.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
