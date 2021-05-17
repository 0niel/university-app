import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  final Size size;
  final Color backgroupColor;
  final Color textColor;
  final Function onPress;
  final String text;

  const ButtonPrimary({
    Key key,
    @required this.size,
    @required this.backgroupColor,
    @required this.textColor,
    @required this.onPress,
    @required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      children: <Widget>[
        TextButton(
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            minimumSize: MaterialStateProperty.all<Size>(size),
            backgroundColor: MaterialStateProperty.all<Color>(backgroupColor),
          ),
          onPressed: () {
            onPress();
          },
        )
      ],
    );
  }
}
