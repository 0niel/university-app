import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class NinjaForumAvatar extends StatelessWidget {
  const NinjaForumAvatar({
    required this.name,
    required this.url,
    required this.size,
    super.key,
  });

  final String name;
  final String url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AppAvatar(name: name, imageUrl: url, size: size);
  }
}
