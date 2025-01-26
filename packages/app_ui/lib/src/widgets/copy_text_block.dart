import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';

class CopyTextBlockWithLabel extends StatelessWidget {
  const CopyTextBlockWithLabel({
    required this.label,
    required this.text,
    super.key,
  });

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
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedCopy01,
              size: 15,
              color: Theme.of(context).extension<AppColors>()!.active,
            ),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  padding: EdgeInsets.all(4),
                  content: Text('Текст скопирован!'),
                ),
              );
            },
          ),
        ),
        const Divider(),
      ],
    );
  }
}
