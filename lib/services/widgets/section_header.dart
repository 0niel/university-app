import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';

/// A section header with a title
class SectionHeader extends StatelessWidget {
  /// Creates a section header.
  const SectionHeader({super.key, required this.title});

  /// The title of the section
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.h6.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).extension<AppColors>()!.active,
      ),
    );
  }
}

/// A section header with title and optional button
class SectionHeaderWithButton extends StatelessWidget {
  /// Creates a section header with an action button.
  const SectionHeaderWithButton({super.key, required this.title, required this.buttonText, required this.onPressed});

  /// The title of the section
  final String title;

  /// The text of the action button
  final String buttonText;

  /// Called when the button is pressed
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyle.h6.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).extension<AppColors>()!.active,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: AppTextStyle.body.copyWith(
              color: Theme.of(context).extension<AppColors>()!.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
