import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

import '../theme.dart';
import '../typography.dart';
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
    showModalBottomSheet(
      showDragHandle: true,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: AppTheme.colors.background02,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: FeedbackBottomModalSheet(
            defaultEmail: defaultEmail,
            defaultText: defaultText,
            onConfirm: () {
              onConfirm?.call();
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  State<FeedbackBottomModalSheet> createState() =>
      _FeedbackBottomModalSheetState();
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

    final SentryId sentryId =
        await Sentry.captureMessage(text, level: SentryLevel.info);

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ListView(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              'Оставить отзыв',
              style: AppTextStyle.h5,
            ),
            const SizedBox(height: 8),
            Text(
              'Кажется, у вас что-то пошло не так. Пожалуйста, напишите нам, и мы постараемся исправить это. Мы свяжемся по указанному email адресу для уточнения деталей.',
              style: AppTextStyle.captionL.copyWith(
                color: AppTheme.colors.deactive,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
          ]),
          Text(
            'Email',
            style: AppTextStyle.chip.copyWith(
              color: AppTheme.colors.deactive,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              errorText: _emailErrorText,
              errorStyle: AppTextStyle.captionL.copyWith(
                color: AppTheme.colors.colorful07,
              ),
              hintText: 'Введите email',
              hintStyle: AppTextStyle.titleS.copyWith(
                color: AppTheme.colors.deactive,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.colors.primary,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.colors.colorful07,
                ),
              ),
              disabledBorder: border,
              enabledBorder: border,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.colors.colorful07,
                ),
              ),
              fillColor: AppTheme.colors.background01,
              filled: true,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            style: AppTextStyle.titleS,
            controller: _emailController,
          ),
          const SizedBox(height: 24),
          Text(
            'Что случилось?',
            style: AppTextStyle.chip.copyWith(
              color: AppTheme.colors.deactive,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            controller: _textController,
            decoration: InputDecoration(
              hintText: 'Когда я нажимаю "Х" происходит "У"',
              hintStyle: AppTextStyle.bodyL.copyWith(
                color: AppTheme.colors.deactive,
              ),
              errorText: _textErrorText,
              errorStyle: AppTextStyle.captionS.copyWith(
                color: AppTheme.colors.colorful07,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.colors.primary,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.colors.colorful07,
                ),
              ),
              disabledBorder: border,
              enabledBorder: border,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.colors.colorful07,
                ),
              ),
              fillColor: AppTheme.colors.background01,
              filled: true,
            ),
            textInputAction: TextInputAction.done,
            style: AppTextStyle.bodyL,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Отправить',
            onClick: _sendFeedback,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
