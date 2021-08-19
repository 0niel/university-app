import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton(this.text, this.icon, this.onClick);
  final String text;
  final IconData icon;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: DarkThemeColors.background02,
      shadowColor: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Icon(
                icon,
                color: Theme.of(context).textTheme.bodyText1?.color,
              ),
            ),
            Text(
              text,
              style: DarkTextTheme.buttonL,
            ),
          ],
        ),
        onTap: () {
          onClick();
        },
      ),
    );
  }
}
