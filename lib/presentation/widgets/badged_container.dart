import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class BadgedContainer extends StatelessWidget {
  final String label;
  final String text;
  final VoidCallback? onClick;

  const BadgedContainer(
      {Key? key, required this.label, required this.text, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: Card(
        color: DarkThemeColors.background02,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onClick,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: DarkTextTheme.bodyBold
                            .copyWith(color: DarkThemeColors.deactive)),
                    const SizedBox(height: 5),
                    Text(text, style: DarkTextTheme.title)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
