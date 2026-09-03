import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:rtu_mirea_app/polls/cubit/polls_cubit.dart';

Future<bool?> showPollRunnerSheet(
  BuildContext context, {
  required Poll poll,
  required PollsCubit cubit,
}) {
  return showAppSheet<bool>(
    context,
    title: poll.title,
    child: PollRunnerSheet(poll: poll, cubit: cubit),
  );
}

class PollRunnerSheet extends StatefulWidget {
  const PollRunnerSheet({required this.poll, required this.cubit, super.key});

  final Poll poll;
  final PollsCubit cubit;

  @override
  State<PollRunnerSheet> createState() => _PollRunnerSheetState();
}

class _PollRunnerSheetState extends State<PollRunnerSheet> {
  List<PollQuestion> _questions = [];

  final _singleAnswers = <String, String?>{};
  final _multipleAnswers = <String, Set<String>>{};
  final _textControllers = <String, TextEditingController>{};
  final _ratingAnswers = <String, int?>{};

  int _step = 0;
  bool _showError = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  @override
  void didUpdateWidget(covariant PollRunnerSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    final old = oldWidget.poll;
    final current = widget.poll;
    final unchanged =
        old.id == current.id &&
        old.iParticipated == current.iParticipated &&
        const DeepCollectionEquality().equals(
          old.questions.map(_draftSignature).toList(),
          current.questions.map(_draftSignature).toList(),
        );
    if (!unchanged && !_submitting) _restore();
  }

  List<Object?> _draftSignature(PollQuestion question) => [
    question.id,
    question.text,
    question.kind,
    question.position,
    question.isRequired,
    question.options.map((option) => (option.id, option.text)).toList(),
    question.myOptionIds,
    question.myTextAnswer,
    question.myRating,
  ];

  void _restore() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    _textControllers.clear();
    _singleAnswers.clear();
    _multipleAnswers.clear();
    _ratingAnswers.clear();
    _questions = [...widget.poll.questions]
      ..sort((a, b) => a.position.compareTo(b.position));
    _step = 0;
    _showError = false;
    for (final question in _questions) {
      switch (question.kind) {
        case PollQuestionKind.single:
        case PollQuestionKind.quiz:
          _singleAnswers[question.id] = question.myOptionIds.isEmpty
              ? null
              : question.myOptionIds.first;
        case PollQuestionKind.multiple:
          _multipleAnswers[question.id] = {...question.myOptionIds};
        case PollQuestionKind.text:
          _textControllers[question.id] = TextEditingController(
            text: question.myTextAnswer ?? '',
          );
        case PollQuestionKind.rating:
          _ratingAnswers[question.id] = question.myRating;
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  bool _isAnswered(PollQuestion question) => switch (question.kind) {
    PollQuestionKind.single ||
    PollQuestionKind.quiz => _singleAnswers[question.id] != null,
    PollQuestionKind.multiple =>
      _multipleAnswers[question.id]?.isNotEmpty ?? false,
    PollQuestionKind.text =>
      _textControllers[question.id]?.text.trim().isNotEmpty ?? false,
    PollQuestionKind.rating => _ratingAnswers[question.id] != null,
  };

  void _clearError() {
    if (_showError) setState(() => _showError = false);
  }

  void _back() {
    if (_step == 0 || _submitting) return;
    setState(() {
      _step--;
      _showError = false;
    });
  }

  Future<void> _next() async {
    if (_submitting || _questions.isEmpty) return;
    if (widget.poll.isEnded ||
        (widget.poll.iParticipated && !widget.poll.allowChange)) {
      ToastManager.showError(context, message: context.l10n.pollsStatusClosed);
      return;
    }
    final current = _questions[_step];
    if (current.isRequired && !_isAnswered(current)) {
      setState(() => _showError = true);
      return;
    }
    if (_step < _questions.length - 1) {
      setState(() {
        _step++;
        _showError = false;
      });
      return;
    }
    await _submit();
  }

  Future<void> _submit() async {
    final answers = <PollAnswer>[];
    for (final question in _questions) {
      switch (question.kind) {
        case PollQuestionKind.single:
        case PollQuestionKind.quiz:
          final id = _singleAnswers[question.id];
          if (id != null) {
            answers.add(PollAnswer(questionId: question.id, optionIds: [id]));
          }
        case PollQuestionKind.multiple:
          final ids = _multipleAnswers[question.id] ?? const <String>{};
          if (ids.isNotEmpty) {
            answers.add(
              PollAnswer(questionId: question.id, optionIds: ids.toList()),
            );
          }
        case PollQuestionKind.text:
          final text = _textControllers[question.id]?.text.trim() ?? '';
          if (text.isNotEmpty) {
            answers.add(PollAnswer(questionId: question.id, text: text));
          }
        case PollQuestionKind.rating:
          final rating = _ratingAnswers[question.id];
          if (rating != null) {
            answers.add(PollAnswer(questionId: question.id, rating: rating));
          }
      }
    }
    if (!validPollAnswers(widget.poll, answers)) {
      setState(() {
        final missing = _questions.indexWhere(
          (question) => question.isRequired && !_isAnswered(question),
        );
        if (missing >= 0) _step = missing;
        _showError = true;
      });
      return;
    }
    setState(() => _submitting = true);
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final updated = await widget.cubit.submitAnswers(
      poll: widget.poll,
      answers: answers,
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (updated != null) {
      ToastManager.showSuccess(context, message: l10n.pollsRunnerSuccess);
      navigator.pop(true);
    } else {
      ToastManager.showError(context, message: l10n.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final total = _questions.length;
    if (total == 0) {
      return NinjaEmptyState(
        title: l10n.pollsEmptyQuestions,
        icon: const AppLineIconWidget(AppLineIcon.chart),
      );
    }
    final current = _questions[_step];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppProgressBar(value: (_step + 1) / total),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          l10n.pollsStepCounter(_step + 1, total),
          style: AppText.caption.copyWith(color: colors.muted),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          current.text,
          style: AppText.headline.copyWith(color: colors.ink),
        ),
        if (current.isRequired) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.pollsQuestionRequired,
            style: AppText.caption.copyWith(color: colors.muted),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        AbsorbPointer(
          absorbing: _submitting,
          child: _QuestionInput(
            question: current,
            singleValue: _singleAnswers[current.id],
            multipleValue: _multipleAnswers[current.id] ?? const <String>{},
            textController: _textControllers[current.id],
            ratingValue: _ratingAnswers[current.id],
            onSingleChanged: (value) {
              _singleAnswers[current.id] = value;
              setState(() {});
              _clearError();
            },
            onMultipleChanged: (value) {
              _multipleAnswers[current.id] = value;
              setState(() {});
              _clearError();
            },
            onTextChanged: _clearError,
            onRatingChanged: (value) {
              _ratingAnswers[current.id] = value;
              setState(() {});
              _clearError();
            },
          ),
        ),
        if (_showError) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.pollsRequiredError,
            style: AppText.caption.copyWith(color: colors.danger),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            if (_step > 0) ...[
              Expanded(
                child: AppButton.secondary(
                  label: l10n.back,
                  onPressed: _submitting ? null : _back,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: AppButton.primary(
                label: _step == total - 1 ? l10n.pollsSubmit : l10n.pollsNext,
                loading: _submitting,
                onPressed: _submitting ? null : () => unawaited(_next()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuestionInput extends StatelessWidget {
  const _QuestionInput({
    required this.question,
    required this.singleValue,
    required this.multipleValue,
    required this.textController,
    required this.ratingValue,
    required this.onSingleChanged,
    required this.onMultipleChanged,
    required this.onTextChanged,
    required this.onRatingChanged,
  });

  final PollQuestion question;
  final String? singleValue;
  final Set<String> multipleValue;
  final TextEditingController? textController;
  final int? ratingValue;
  final ValueChanged<String?> onSingleChanged;
  final ValueChanged<Set<String>> onMultipleChanged;
  final VoidCallback onTextChanged;
  final ValueChanged<int?> onRatingChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    switch (question.kind) {
      case PollQuestionKind.single:
      case PollQuestionKind.quiz:
        return Column(
          children: [
            for (final option in question.options)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xxs,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppRadio<String>(
                    value: option.id,
                    groupValue: singleValue,
                    label: option.text,
                    onChanged: onSingleChanged,
                  ),
                ),
              ),
          ],
        );
      case PollQuestionKind.multiple:
        return Column(
          children: [
            for (final option in question.options)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xxs,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AppCheckbox(
                    value: multipleValue.contains(option.id),
                    label: option.text,
                    onChanged: (checked) {
                      final next = {...multipleValue};
                      if (checked) {
                        next.add(option.id);
                      } else {
                        next.remove(option.id);
                      }
                      onMultipleChanged(next);
                    },
                  ),
                ),
              ),
          ],
        );
      case PollQuestionKind.text:
        return AppInputField.multiline(
          controller: textController,
          placeholder: l10n.pollsTextAnswerHint,
          maxLength: 2000,
          onChanged: (_) => onTextChanged(),
        );
      case PollQuestionKind.rating:
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (var value = 1; value <= 5; value++)
              Semantics(
                label: l10n.pollsRatingOption(value),
                excludeSemantics: true,
                child: AppChip.filter(
                  label: '$value',
                  selected: ratingValue == value,
                  onTap: () => onRatingChanged(value),
                ),
              ),
          ],
        );
    }
  }
}
