import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/widgets/emoji_tile.dart';
import 'package:rtu_mirea_app/community/widgets/event_category_style.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

part 'events/category_picker.dart';
part 'events/emoji_picker.dart';
part 'events/event_preview.dart';
part 'events/sheet_picker_field.dart';

class CreateEventSheet extends StatefulWidget {
  const CreateEventSheet({
    required this.onSubmit,
    super.key,
    this.existing,
    this.initialStartsAt,
  });

  final Future<bool> Function(EventDraft draft) onSubmit;
  final CampusEvent? existing;
  final DateTime? initialStartsAt;

  @override
  State<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<CreateEventSheet> {
  static const _coverEmojis = ['🚀', '🤖', '🎤', '🏀', '👾', '🌿', '📚', '🎉'];

  late final _titleController = TextEditingController(
    text: widget.existing?.title ?? '',
  );
  late final _placeController = TextEditingController(
    text: widget.existing?.place ?? '',
  );
  late final _descriptionController = TextEditingController(
    text: widget.existing?.description ?? '',
  );
  late final Listenable _previewListenable = Listenable.merge([
    _titleController,
    _placeController,
  ]);

  late DateTime _startsAt =
      widget.existing?.startsAt ?? widget.initialStartsAt ?? _defaultStart();
  late DateTime? _endsAt = widget.existing?.endsAt;
  late EventCategory _category = widget.existing == null
      ? EventCategory.other
      : EventCategory.fromWireName(widget.existing!.category);
  late String? _coverEmoji = widget.existing?.emoji;

  var _submitted = false;
  var _saving = false;
  var _failed = false;

  String get _emoji => _coverEmoji ?? eventCategoryEmoji(_category);
  bool get _isEditing => widget.existing != null;

  static DateTime _defaultStart() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 18);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _placeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _titleError(AppLocalizations l10n) {
    if (!_submitted) return null;
    return _titleController.text.trim().isEmpty
        ? l10n.eventsCreateTitleError
        : null;
  }

  String? _endError(AppLocalizations l10n) {
    final end = _endsAt;
    if (end == null) return null;
    return end.isAfter(_startsAt) ? null : l10n.eventsCreateEndBeforeStartError;
  }

  Future<void> _pickDate() async {
    final date = await showAppDatePicker(
      context,
      initial: _startsAt,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
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

  Future<void> _pickEndTime() async {
    final initial = _endsAt ?? _startsAt.add(const Duration(hours: 1));
    final time = await showAppTimePicker(
      context,
      initial: (hour: initial.hour, minute: initial.minute),
    );
    if (time == null || !mounted) return;
    setState(() {
      _endsAt = DateTime(
        _startsAt.year,
        _startsAt.month,
        _startsAt.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _clearEndTime() => setState(() => _endsAt = null);

  Future<void> _submit() async {
    final l10n = context.l10n;
    setState(() => _submitted = true);
    if (_titleError(l10n) != null || _endError(l10n) != null) return;

    setState(() {
      _saving = true;
      _failed = false;
    });
    final draft = EventDraft(
      title: _titleController.text.trim(),
      startsAt: _startsAt,
      endsAt: _endsAt,
      place: _placeController.text.trim(),
      emoji: _emoji,
      category: _category,
      description: _descriptionController.text.trim(),
    );
    final success = await widget.onSubmit(draft);
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _saving = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).languageCode;
    final titleError = _titleError(l10n);
    final endError = _endError(l10n);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _previewListenable,
          builder: (_, _) => _EventPreview(
            title: _titleController.text.trim(),
            place: _placeController.text.trim(),
            startsAt: _startsAt,
            endsAt: _endsAt,
            category: _category,
            emoji: _emoji,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppOverline(l10n.eventsCreateCoverLabel, topPadding: 0),
        _EmojiPicker(
          emojis: _coverEmojis,
          selected: _coverEmoji,
          onSelected: (emoji) => setState(() => _coverEmoji = emoji),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppInputField(
          controller: _titleController,
          autofocus: !_isEditing,
          label: l10n.eventsCreateNameLabel,
          placeholder: l10n.eventsCreateNameHint,
          errorText: titleError,
          maxLength: 200,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.md),
        AppOverline(l10n.eventsCreateCategoryLabel, topPadding: 0),
        _CategoryPicker(
          selected: _category,
          onSelected: (category) => setState(() => _category = category),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        AppOverline(l10n.eventsCreateWhenLabel, topPadding: 0),
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
        const SizedBox(height: AppSpacing.md),
        AppOverline(l10n.eventsCreateEndLabel, topPadding: 0),
        _SheetPickerField(
          icon: .clock,
          value: _endsAt == null
              ? l10n.eventsCreateEndPlaceholder
              : DateFormat.Hm().format(_endsAt!),
          onTap: () => unawaited(_pickEndTime()),
          trailing: _endsAt == null
              ? null
              : AppIconButton(
                  icon: const AppLineIconWidget(AppLineIcon.close),
                  size: AppIconButtonSize.compact,
                  tone: AppIconButtonTone.plain,
                  tooltip: l10n.pickerClear,
                  onPressed: _clearEndTime,
                ),
        ),
        if (endError != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            endError,
            style: AppText.subtext.copyWith(color: context.colors.danger),
          ),
        ],
        const SizedBox(height: AppSpacing.sectionGap),
        AppInputField(
          controller: _placeController,
          label: l10n.eventsCreateWhereLabel,
          placeholder: l10n.eventsCreatePlaceHint,
        ),
        const SizedBox(height: AppSpacing.md),
        AppInputField.multiline(
          controller: _descriptionController,
          minLines: 2,
          maxLines: 4,
          maxLength: 4000,
          placeholder: l10n.eventsCreateDescriptionHint,
        ),
        if (_failed) ...[
          const SizedBox(height: AppSpacing.fieldGap),
          AppBanner(
            tone: AppBannerTone.danger,
            message: _isEditing
                ? l10n.eventsUpdateError
                : l10n.eventsCreateError,
          ),
        ],
        const SizedBox(height: AppSpacing.fieldGap),
        AppButton.primary(
          label: _isEditing ? l10n.eventsSave : l10n.eventsCreate,
          expanded: true,
          size: AppButtonSize.large,
          loading: _saving,
          onPressed: _saving ? null : () => unawaited(_submit()),
        ),
      ],
    );
  }
}
