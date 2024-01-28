import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class BadgedContainer extends StatelessWidget {
  final String label;
  final String text;

  const BadgedContainer({Key? key, required this.label, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 90,
      child: Card(
        color: AppTheme.colorsOf(context).background02,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                        color: AppTheme.colorsOf(context).deactive,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
