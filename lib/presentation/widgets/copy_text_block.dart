import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

import 'container_label.dart';

class CopyTextBlockWithLabel extends StatelessWidget {
  const CopyTextBlockWithLabel({
    Key? key,
    required this.label,
    required this.text,
  }) : super(key: key);

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ContainerLabel(label: label),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: DarkTextTheme.titleM,
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  padding: EdgeInsets.all(4),
                  content: Text('Текст скопирован!')));
            },
            child: const SizedBox(
              width: 30,
              height: 30,
              child: Icon(
                FontAwesomeIcons.copy,
                size: 15.0,
              ),
            ),
          )
        ],
      ),
      const SizedBox(height: 12),
      const Divider(),
    ]);
  }
}
