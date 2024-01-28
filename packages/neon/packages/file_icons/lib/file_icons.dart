import 'package:file_icons/src/data.dart';
import 'package:flutter/widgets.dart';

// ignore: public_member_api_docs
class FileIcon extends StatelessWidget {
  // ignore: public_member_api_docs
  FileIcon(
    String fileName, {
    this.size,
    this.color,
    super.key,
  }) : fileName = fileName.toLowerCase();

  /// Name of the file
  final String fileName;

  /// Size of the icon
  final double? size;

  /// This color will override the color provided from Seti icons
  final Color? color;

  @override
  Widget build(BuildContext context) {
    String? key;

    if (iconSetMap.containsKey(fileName)) {
      key = fileName;
    } else {
      var chunks = fileName.split('.').sublist(1);
      while (chunks.isNotEmpty) {
        final k = '.${chunks.join()}';
        if (iconSetMap.containsKey(k)) {
          key = k;
          break;
        }
        chunks = chunks.sublist(1);
      }
    }

    final meta = iconSetMap[key ?? '.txt']!;
    return Icon(
      meta.iconData,
      color: color ?? Color(meta.color),
      size: size,
    );
  }
}
