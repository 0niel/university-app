import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rtu_mirea_app/common/widgets/app_date_picker.dart';
import 'package:rtu_mirea_app/common/widgets/app_time_picker.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/cubit/polls_cubit.dart';

part 'creator_preview_step.dart';
part 'creator_questions_step.dart';
part 'creator_settings_step.dart';

enum _CreatorStep { basics, questions, settings, preview }

String pollCategoryLabel(AppLocalizations l10n, PollCategory value) =>
    switch (value) {
      PollCategory.general => l10n.pollsCategoryGeneral,
      PollCategory.academic => l10n.pollsCategoryAcademic,
      PollCategory.events => l10n.pollsCategoryEvents,
      PollCategory.feedback => l10n.pollsCategoryFeedback,
      PollCategory.other => l10n.pollsCategoryOther,
    };

Future<bool?> showPollCreatorSheet(
  BuildContext context, {
  required PollsCubit cubit,
}) {
  return showAppSheet<bool>(
    context,
    title: context.l10n.pollsCreateTitle,
    scrollable: false,
    child: PollCreatorSheet(cubit: cubit),
  );
}

class _QuestionDraft {
  _QuestionDraft({this.kind = PollQuestionKind.single})
    : textController = TextEditingController(),
      isRequired = true,
      optionControllers = _initialOptions(kind);

  static List<TextEditingController> _initialOptions(PollQuestionKind kind) =>
      kind == PollQuestionKind.single ||
          kind == PollQuestionKind.multiple ||
          kind == PollQuestionKind.quiz
      ? [TextEditingController(), TextEditingController()]
      : [];

  final GlobalKey editorKey = GlobalKey();
  final TextEditingController textController;
  PollQuestionKind kind;
  bool isRequired;
  int correctIndex = 0;
  List<TextEditingController> optionControllers;

  bool get hasOptions =>
      kind == PollQuestionKind.single ||
      kind == PollQuestionKind.multiple ||
      kind == PollQuestionKind.quiz;

  bool get isValid {
    if (textController.text.trim().isEmpty) return false;
    if (!hasOptions) return true;
    final values = optionControllers
        .map((controller) => controller.text.trim())
        .where((value) => value.isNotEmpty)
        .toList();
    return values.length >= 2 &&
        values.toSet().length == values.length &&
        (kind != PollQuestionKind.quiz ||
            optionControllers[correctIndex].text.trim().isNotEmpty);
  }

  PollQuestionDraft toDraft() => PollQuestionDraft(
    text: textController.text.trim(),
    kind: kind,
    isRequired: isRequired,
    options: hasOptions
        ? [
            for (final controller in optionControllers)
              if (controller.text.trim().isNotEmpty) controller.text.trim(),
          ]
        : const [],
    correctIndex: kind == PollQuestionKind.quiz
        ? optionControllers
              .take(correctIndex)
              .where((controller) => controller.text.trim().isNotEmpty)
              .length
        : null,
  );

  void dispose() {
    textController.dispose();
    for (final controller in optionControllers) {
      controller.dispose();
    }
  }
}

class PollCreatorSheet extends StatefulWidget {
  const PollCreatorSheet({required this.cubit, super.key});

  final PollsCubit cubit;

  @override
  State<PollCreatorSheet> createState() => _PollCreatorSheetState();
}

class _PollCreatorSheetState extends State<PollCreatorSheet> {
  static const _maxQuestions = 10;

  final _scrollController = ScrollController();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _questions = <_QuestionDraft>[_QuestionDraft()];

  _CreatorStep _step = _CreatorStep.basics;
  PollCategory? _category;
  bool _anonymous = false;
  PollResultsVisibility _resultsVisibility = PollResultsVisibility.always;
  bool _allowChange = false;
  DateTime? _closesAtDate;
  int _closesHour = 23;
  int _closesMinute = 59;
  bool _closesEnabled = false;
  bool _saving = false;
  bool _showStepError = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _title.dispose();
    _description.dispose();
    for (final question in _questions) {
      question.dispose();
    }
    super.dispose();
  }

  DateTime? get _closesAt {
    final date = _closesAtDate;
    if (!_closesEnabled || date == null) return null;
    return DateTime(
      date.year,
      date.month,
      date.day,
      _closesHour,
      _closesMinute,
    );
  }

  bool get _basicsValid => _title.text.trim().isNotEmpty;

  bool get _questionsValid =>
      _questions.isNotEmpty && _questions.every((question) => question.isValid);

  void _refresh() => setState(() {});

  void _clearStepError() {
    if (_showStepError) setState(() => _showStepError = false);
  }

  void _addQuestion() {
    if (_questions.length >= _maxQuestions) return;
    setState(() => _questions.add(_QuestionDraft()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _revealQuestion(_questions.length - 1);
    });
  }

  void _removeQuestion(int index) {
    if (_questions.length <= 1) return;
    setState(() {
      final removed = _questions.removeAt(index);
      WidgetsBinding.instance.addPostFrameCallback((_) => removed.dispose());
    });
  }

  void _moveQuestion(int index, int delta) {
    final target = index + delta;
    if (target < 0 || target >= _questions.length) return;
    setState(() {
      final item = _questions.removeAt(index);
      _questions.insert(target, item);
    });
  }

  void _setQuestionKind(int index, PollQuestionKind kind) {
    setState(() {
      final question = _questions[index]..kind = kind;
      if ((kind == PollQuestionKind.single ||
              kind == PollQuestionKind.multiple ||
              kind == PollQuestionKind.quiz) &&
          question.optionControllers.length < 2) {
        question.optionControllers = [
          ...question.optionControllers,
          ...List.generate(
            2 - question.optionControllers.length,
            (_) => TextEditingController(),
          ),
        ];
      }
    });
  }

  void _addOption(int index) {
    final question = _questions[index];
    if (question.optionControllers.length >= 10) return;
    setState(
      () => question.optionControllers = [
        ...question.optionControllers,
        TextEditingController(),
      ],
    );
  }

  void _removeOption(int index, int optionIndex) {
    final question = _questions[index];
    if (question.optionControllers.length <= 2) return;
    setState(() {
      final removed = question.optionControllers.removeAt(optionIndex);
      if (optionIndex < question.correctIndex) {
        question.correctIndex--;
      } else if (question.correctIndex >= question.optionControllers.length) {
        question.correctIndex = question.optionControllers.length - 1;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => removed.dispose());
    });
  }

  bool _canGoNext() => switch (_step) {
    _CreatorStep.basics => _basicsValid,
    _CreatorStep.questions => _questionsValid,
    _CreatorStep.settings =>
      _closesAt == null || _closesAt!.isAfter(DateTime.now()),
    _CreatorStep.preview => true,
  };

  void _showStep(_CreatorStep step, {int? questionIndex}) {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _step = step;
      _showStepError = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (questionIndex != null) {
        _revealQuestion(questionIndex);
      } else if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _revealQuestion(int index) {
    final target = _questions[index].editorKey.currentContext;
    if (target != null) {
      unawaited(Scrollable.ensureVisible(target));
    }
  }

  void _next() {
    if (!_canGoNext()) {
      setState(() => _showStepError = true);
      if (_step == _CreatorStep.questions) {
        final index = _questions.indexWhere((question) => !question.isValid);
        if (index >= 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _revealQuestion(index);
          });
        }
      }
      return;
    }
    if (_step == _CreatorStep.preview) {
      unawaited(_submit());
      return;
    }
    _showStep(_CreatorStep.values[_step.index + 1]);
  }

  void _back() {
    if (_step == _CreatorStep.basics || _saving) return;
    _showStep(_CreatorStep.values[_step.index - 1]);
  }

  Future<void> _pickClosesDate() async {
    final picked = await showAppDatePicker(
      context,
      initial: _closesAtDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _closesAtDate = picked;
      _closesEnabled = true;
    });
  }

  Future<void> _pickClosesTime() async {
    final picked = await showAppTimePicker(
      context,
      initial: (hour: _closesHour, minute: _closesMinute),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _closesHour = picked.hour;
      _closesMinute = picked.minute;
    });
  }

  Future<void> _submit() async {
    if (!_basicsValid || !_questionsValid || _saving) return;
    if (_closesAt != null && !_closesAt!.isAfter(DateTime.now())) {
      setState(() {
        _step = _CreatorStep.settings;
        _showStepError = true;
      });
      return;
    }
    setState(() => _saving = true);
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final poll = await widget.cubit.createPoll(
      title: _title.text.trim(),
      questions: [for (final question in _questions) question.toDraft()],
      description: _description.text.trim(),
      category: _category,
      isAnonymous: _anonymous,
      resultsVisibility: _resultsVisibility,
      expiresAt: _closesAt,
      allowChange: _allowChange,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (poll != null) {
      navigator.pop(true);
    } else {
      ToastManager.showError(context, message: l10n.pollsCreateError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final totalSteps = _CreatorStep.values.length;
    final stepTitle = switch (_step) {
      _CreatorStep.basics => l10n.pollsStepBasics,
      _CreatorStep.questions => l10n.pollsStepQuestions,
      _CreatorStep.settings => l10n.pollsSettings,
      _CreatorStep.preview => l10n.pollsStepPreview,
    };
    final header = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(stepTitle, style: AppText.bodyStrong)),
            Text(
              l10n.pollsStepCounter(_step.index + 1, totalSteps),
              style: AppText.caption.copyWith(color: colors.muted),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        AppProgressBar(value: (_step.index + 1) / totalSteps),
        const SizedBox(height: AppSpacing.md),
      ],
    );
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        switch (_step) {
          _CreatorStep.basics => _BasicsStep(
            titleController: _title,
            descriptionController: _description,
            category: _category,
            showError: _showStepError,
            onCategoryChanged: (value) => setState(() => _category = value),
            onChanged: _clearStepError,
          ),
          _CreatorStep.questions => _QuestionsStep(
            questions: _questions,
            showError: _showStepError,
            onAdd: _addQuestion,
            onRemove: _removeQuestion,
            onMove: _moveQuestion,
            onKindChanged: _setQuestionKind,
            onAddOption: _addOption,
            onRemoveOption: _removeOption,
            onRequiredChanged: (index, {required value}) =>
                setState(() => _questions[index].isRequired = value),
            onChanged: () {
              _refresh();
              _clearStepError();
            },
          ),
          _CreatorStep.settings => _SettingsStep(
            anonymous: _anonymous,
            onAnonymousChanged: (value) => setState(() => _anonymous = value),
            resultsVisibility: _resultsVisibility,
            onResultsVisibilityChanged: (value) =>
                setState(() => _resultsVisibility = value),
            allowChange: _allowChange,
            onAllowChangeChanged: (value) =>
                setState(() => _allowChange = value),
            closesEnabled: _closesEnabled,
            closesAt: _closesAt,
            onClosesCleared: () => setState(() => _closesEnabled = false),
            onPickDate: () => unawaited(_pickClosesDate()),
            onPickTime: () => unawaited(_pickClosesTime()),
            onPreset: (days) => setState(() {
              final at = DateTime.now().add(Duration(days: days));
              _closesAtDate = at;
              _closesHour = at.hour;
              _closesMinute = at.minute;
              _closesEnabled = true;
            }),
          ),
          _CreatorStep.preview => _PreviewStep(
            title: _title.text.trim(),
            description: _description.text.trim(),
            category: _category,
            questions: _questions,
            anonymous: _anonymous,
            closesAt: _closesAt,
            onEditBasics: _saving ? null : () => _showStep(_CreatorStep.basics),
            onEditQuestion: _saving
                ? null
                : (index) =>
                      _showStep(_CreatorStep.questions, questionIndex: index),
          ),
        },
        if (_step == _CreatorStep.settings && _showStepError) ...[
          const SizedBox(height: AppSpacing.sm),
          AppBanner(
            message: l10n.pollsClosesFuture,
            tone: AppBannerTone.danger,
          ),
        ],
      ],
    );
    final footer = Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Row(
        children: [
          if (_step != _CreatorStep.basics) ...[
            Expanded(
              child: AppButton.secondary(
                label: l10n.back,
                onPressed: _saving ? null : _back,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: AppButton.primary(
              label: _step == _CreatorStep.preview
                  ? l10n.pollsCreate
                  : l10n.pollsNext,
              loading: _saving,
              onPressed: _saving ? null : _next,
            ),
          ),
        ],
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedHeight) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [header, content, footer],
          );
        }
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverToBoxAdapter(child: header),
                  SliverToBoxAdapter(child: content),
                ],
              ),
            ),
            footer,
          ],
        );
      },
    );
  }
}

class _BasicsStep extends StatelessWidget {
  const _BasicsStep({
    required this.titleController,
    required this.descriptionController,
    required this.category,
    required this.showError,
    required this.onCategoryChanged,
    required this.onChanged,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final PollCategory? category;
  final bool showError;
  final ValueChanged<PollCategory?> onCategoryChanged;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInputField(
          controller: titleController,
          placeholder: l10n.pollsTitleHint,
          autofocus: true,
          maxLength: 200,
          textInputAction: TextInputAction.next,
          errorText: showError && titleController.text.trim().isEmpty
              ? l10n.pollsTitleRequired
              : null,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInputField.multiline(
          controller: descriptionController,
          placeholder: l10n.pollsDescriptionHint,
          maxLength: 2000,
          showCounter: false,
          minLines: 2,
          maxLines: 4,
          onChanged: (_) => onChanged(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.pollsCategoryLabel,
          style: AppText.captionStrong.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppChipRow<PollCategory?>(
          value: category,
          onChanged: onCategoryChanged,
          items: [
            AppChipRowItem(value: null, label: l10n.pollsCategoryAll),
            for (final value in PollCategory.values)
              AppChipRowItem(
                value: value,
                label: pollCategoryLabel(l10n, value),
              ),
          ],
        ),
      ],
    );
  }
}
