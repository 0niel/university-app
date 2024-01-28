import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Column(
      children: [
        ListTile(
          title: Text(
            label.toUpperCase(),
          ),
          subtitle: Text(
            text,
          ),
          trailing: IconButton(
            icon: const Icon(
              FontAwesomeIcons.copy,
              size: 15.0,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(padding: EdgeInsets.all(4), content: Text('Текст скопирован!')));
            },
          ),
        ),
        const Divider(),
      ],
    );
  }
}
