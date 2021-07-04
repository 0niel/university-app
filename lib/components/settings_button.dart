import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton(this.text, this.icon, this.fn);
  final String text;
  final IconData icon;
  final Function fn;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      child: InkWell(
        child: ListTile(
          leading: Icon(
            icon,
            color: Theme.of(context).textTheme.bodyText1?.color,
          ),
          title: Text(text),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        onTap: () {
          fn();
        },
      ),
    );
  }
}
