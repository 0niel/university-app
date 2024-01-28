import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/widgets/forms/text_input.dart';
import 'package:sentry/sentry.dart';

import '../theme.dart';
import '../typography.dart';
import 'bottom_modal_sheet.dart';
import 'buttons/primary_button.dart';

class FeedbackBottomModalSheet extends StatefulWidget {
  const FeedbackBottomModalSheet({
    Key? key,
    this.onConfirm,
    this.defaultText,
    this.defaultEmail,
  }) : super(key: key);

  final String? defaultEmail;
  final String? defaultText;
  final VoidCallback? onConfirm;

  static void show(
    BuildContext context, {
    String? defaultEmail,
    String? defaultText,
    VoidCallback? onConfirm,
  }) {
    BottomModalSheet.show(
      context,
      child: FeedbackBottomModalSheet(
        defaultEmail: defaultEmail,
        defaultText: defaultText,
        onConfirm: onConfirm,
      ),
      title: 'Оставить отзыв',
      description:
          'Кажется, у вас что-то пошло не так. Пожалуйста, напишите нам, и мы постараемся исправить это. Мы свяжемся по указанному email адресу для уточнения деталей.',
    );
  }

  @override
  State<FeedbackBottomModalSheet> createState() => _FeedbackBottomModalSheetState();
}

class _FeedbackBottomModalSheetState extends State<FeedbackBottomModalSheet> {
  @override
  void initState() {
    super.initState();
    _emailController.text = widget.defaultEmail ?? '';
    _textController.text = widget.defaultText ?? '';
  }

  final _emailController = TextEditingController();
  final _textController = TextEditingController();

  String? _emailErrorText;
  String? _textErrorText;

  final _reEmail = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  void _sendFeedback() async {
    final email = _emailController.text;
    final text = _textController.text;

    if (!_reEmail.hasMatch(email)) {
      setState(() {
        _emailErrorText = 'Некорректный email';
      });
      return;
    }

    if (text.isEmpty) {
      setState(() {
        _textErrorText = 'Введите текст';
      });
      return;
    }

    setState(() {
      _emailErrorText = null;
      _textErrorText = null;
    });

    final SentryId sentryId = await Sentry.captureMessage(text, level: SentryLevel.info);

    final userFeedback = SentryUserFeedback(
      eventId: sentryId,
      email: email,
      comments: text,
    );

    Sentry.captureUserFeedback(userFeedback).then((value) {
      final message = 'Отзыв отправлен. Код ошибки: $sentryId';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.colors.primary.withOpacity(0.8),
          content: Text(message, style: AppTextStyle.captionL),
          duration: const Duration(seconds: 3),
        ),
      );
    });
    widget.onConfirm?.call();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: AppTextStyle.chip.copyWith(
            color: AppTheme.colors.deactive,
          ),
        ),
        const SizedBox(height: 8),
        TextInput(
          hintText: 'Введите email',
          controller: _emailController,
          errorText: _emailErrorText,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),
        Text(
          'Что случилось?',
          style: AppTextStyle.chip.copyWith(
            color: AppTheme.colors.deactive,
          ),
        ),
        const SizedBox(height: 8),
        TextInput(
          hintText: 'Когда я нажимаю "Х" происходит "У"',
          controller: _textController,
          errorText: _textErrorText,
          maxLines: 5,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          text: 'Отправить',
          onClick: _sendFeedback,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
