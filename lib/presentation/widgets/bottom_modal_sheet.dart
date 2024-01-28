import 'package:flutter/material.dart';

import '../theme.dart';
import '../typography.dart';

class BottomModalSheet extends StatelessWidget {
  const BottomModalSheet({
    Key? key,
    required this.title,
    this.onConfirm,
    this.description,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onConfirm;
  final String title;
  final String? description;
  final Widget child;

  static void show(
    BuildContext context, {
    required Widget child,
    required String title,
    String? description,
    Color? backgroundColor,
  }) {
    showModalBottomSheet(
      showDragHandle: true,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: backgroundColor ?? AppTheme.colorsOf(context).background02,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: BottomModalSheet(
          title: title,
          description: description,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ListView(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              title,
              style: AppTextStyle.h5.copyWith(
                color: AppTheme.colorsOf(context).active,
              ),
            ),
            const SizedBox(height: 8),
            if (description != null)
              Text(
                description!,
                style: AppTextStyle.captionL.copyWith(
                  color: AppTheme.colorsOf(context).deactive,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 32),
          ]),
          child,
        ],
      ),
    );
  }
}
