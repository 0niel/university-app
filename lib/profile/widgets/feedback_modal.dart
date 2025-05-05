import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:sentry/sentry.dart';

class FeedbackBottomModalSheet extends StatefulWidget {
  const FeedbackBottomModalSheet({super.key, this.onConfirm, this.defaultText, this.defaultEmail});

  final String? defaultEmail;
  final String? defaultText;
  final VoidCallback? onConfirm;

  static void show(BuildContext context, {String? defaultEmail, String? defaultText, VoidCallback? onConfirm}) {
    BottomModalSheet.show(
      context,
      child: FeedbackBottomModalSheet(defaultEmail: defaultEmail, defaultText: defaultText, onConfirm: onConfirm),
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
  bool _isSubmitting = false;

  final _reEmail = RegExp(r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

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
      _isSubmitting = true;
    });

    final SentryId sentryId = await Sentry.captureMessage(text, level: SentryLevel.info);

    final userFeedback = SentryUserFeedback(eventId: sentryId, email: email, comments: text);

    Sentry.captureUserFeedback(userFeedback).then((value) {
      setState(() {
        _isSubmitting = false;
      });

      final message = 'Отзыв отправлен. Код ошибки: $sentryId';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).extension<AppColors>()!.primary.withOpacity(0.9),
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text(message, style: AppTextStyle.captionL.copyWith(color: Colors.white))),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );

      widget.onConfirm?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormFieldLabel(label: 'Email'),
        TextInput(
          hintText: 'Введите email',
          controller: _emailController,
          errorText: _emailErrorText,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(Icons.email_outlined, color: colors.deactive),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 20),
        _FormFieldLabel(label: 'Что случилось?'),
        TextInput(
          hintText: 'Когда я нажимаю "Х" происходит "У"',
          controller: _textController,
          errorText: _textErrorText,
          maxLines: 5,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Icon(Icons.comment_outlined, color: colors.deactive),
          ),
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child:
              _isSubmitting
                  ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: colors.primary),
                    ),
                  )
                  : PrimaryButton(
                    text: 'Отправить',
                    onPressed: _sendFeedback,
                    icon: Icon(Icons.send_rounded, size: 20, color: colors.white),
                  ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _FormFieldLabel extends StatelessWidget {
  final String label;

  const _FormFieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: AppTextStyle.body.copyWith(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).extension<AppColors>()!.deactive,
        ),
      ),
    );
  }
}
