import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class BadgedContainer extends StatelessWidget {
  const BadgedContainer({required this.label, required this.text, super.key});
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 90,
      child: Card(
        color: Theme.of(context).extension<AppColors>()!.background02,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyle.bodyBold.copyWith(
                        color: Theme.of(context).extension<AppColors>()!.deactive,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      text,
                      style: AppTextStyle.title,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
