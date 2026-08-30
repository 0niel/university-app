import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/widgets/event_category_style.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'events/category_choice.dart';
part 'events/category_picker.dart';
part 'events/emoji_picker.dart';
part 'events/event_preview.dart';
part 'events/field_label.dart';
part 'events/sheet_picker_field.dart';

class CreateEventSheet extends StatefulWidget {
  const CreateEventSheet({super.key});

  @override
  State<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<CreateEventSheet> {
  static const _coverEmojis = ['🚀', '🤖', '🎤', '🏀', '👾', '🌿'];

  final _titleController = TextEditingController();
  final _placeController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final Listenable _previewListenable = Listenable.merge([
    _titleController,
    _placeController,
  ]);

  DateTime _startsAt = DateTime.now().add(const Duration(days: 1));
  EventCategory _category = .other;
  String? _coverEmoji;

  String get _emoji => _coverEmoji ?? eventCategoryEmoji(_category);

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showAppDatePicker(
      context,
      initial: _startsAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    setState(() {
      _startsAt = DateTime(
        date.year,
        date.month,
        date.day,
        _startsAt.hour,
        _startsAt.minute,
      );
    });
  }

  Future<void> _pickTime() async {
    final time = await showAppTimePicker(
      context,
      initial: (hour: _startsAt.hour, minute: _startsAt.minute),
    );
    if (time == null || !mounted) return;
    setState(() {
      _startsAt = DateTime(
        _startsAt.year,
        _startsAt.month,
        _startsAt.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    Navigator.of(context).pop(
      EventDraft(
        title: title,
        startsAt: _startsAt,
        place: _placeController.text.trim(),
        emoji: _emoji,
        category: _category,
        description: _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        AnimatedBuilder(
          animation: _previewListenable,
          builder: (_, _) => _EventPreview(
            title: _titleController.text.trim(),
            place: _placeController.text.trim(),
            startsAt: _startsAt,
            category: _category,
            emoji: _emoji,
          ),
        ),
        const SizedBox(height: 14),
        _FieldLabel(l10n.eventsCreateCoverLabel),
        const SizedBox(height: 8),
        _EmojiPicker(
          emojis: _coverEmojis,
          selected: _coverEmoji,
          onSelected: (emoji) => setState(() => _coverEmoji = emoji),
        ),
        const SizedBox(height: 14),
        NinjaInput(
          controller: _titleController,
          autofocus: true,
          label: l10n.eventsCreateNameLabel,
          placeholder: l10n.eventsCreateNameHint,
        ),
        const SizedBox(height: 12),
        _FieldLabel(l10n.eventsCreateCategoryLabel),
        const SizedBox(height: 8),
        _CategoryPicker(
          selected: _category,
          onSelected: (category) => setState(() => _category = category),
        ),
        const SizedBox(height: 14),
        _FieldLabel(l10n.eventsCreateWhenLabel),
        const SizedBox(height: 8),
        Row(
          spacing: 10,
          children: [
            Expanded(
              flex: 3,
              child: _SheetPickerField(
                icon: .calendar,
                value: DateFormat('d MMMM', locale).format(_startsAt),
                onTap: () => unawaited(_pickDate()),
              ),
            ),
            Expanded(
              flex: 2,
              child: _SheetPickerField(
                icon: .clock,
                value: DateFormat.Hm().format(_startsAt),
                onTap: () => unawaited(_pickTime()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        NinjaInput(
          controller: _placeController,
          label: l10n.eventsCreateWhereLabel,
          placeholder: l10n.eventsCreatePlaceHint,
        ),
        const SizedBox(height: 12),
        NinjaInput.multiline(
          controller: _descriptionController,
          minLines: 2,
          maxLines: 4,
          placeholder: l10n.eventsCreateDescriptionHint,
        ),
        const SizedBox(height: 18),
        AnimatedBuilder(
          animation: _titleController,
          builder: (_, _) => NinjaButton.primary(
            label: l10n.eventsCreate,
            expanded: true,
            size: NinjaButtonSize.large,
            onPressed: _titleController.text.trim().isEmpty ? null : _submit,
          ),
        ),
      ],
    );
  }
}
