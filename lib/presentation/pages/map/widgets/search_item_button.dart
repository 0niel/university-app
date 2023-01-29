import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/typography.dart';

class SearchItemButton extends StatelessWidget {
  const SearchItemButton({Key? key, required this.room, required this.onClick})
      : super(key: key);

  final Map<String, dynamic> room;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints.tightFor(width: double.infinity, height: 36),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        ),
        child: Row(
          children: [
            Text(
              room['t'],
              style: AppTextStyle.buttonS,
              textAlign: TextAlign.left,
            ),
          ],
        ),
        onPressed: () => onClick(),
      ),
    );
  }
}
