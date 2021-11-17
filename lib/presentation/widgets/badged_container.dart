import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class BadgedContainer extends StatelessWidget {
  final String label;
  final String value;
  final Color badgeColor;
  final VoidCallback? callback;

  const BadgedContainer(
      {Key? key,
      required this.label,
      required this.value,
      required this.badgeColor,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: double.infinity,
        height: 90,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: DarkThemeColors.background02,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: DarkThemeColors.colorful03, shape: BoxShape.circle),
                child: const Icon(Icons.do_not_disturb,
                    color: Colors.white, size: 30)),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: DarkTextTheme.bodyBold),
                const SizedBox(height: 5),
                (value == "Off")
                    ? Text(value,
                        style: DarkTextTheme.bodyBold
                            .copyWith(color: DarkThemeColors.deactive))
                    : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: badgeColor,
                        ),
                        child: Text(
                          value,
                          style: DarkTextTheme.bodyBold,
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
