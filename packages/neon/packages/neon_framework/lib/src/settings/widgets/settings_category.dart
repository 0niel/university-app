import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neon_framework/src/utils/adaptive.dart';

@internal
class SettingsCategory extends StatelessWidget {
  const SettingsCategory({
    required this.tiles,
    this.title,
    this.footer,
    this.hasLeading = false,
    super.key,
  });

  final Widget? title;
  final List<Widget> tiles;
  final Widget? footer;
  final bool hasLeading;

  @override
  Widget build(BuildContext context) {
    if (isCupertino(context)) {
      return CupertinoListSection.insetGrouped(
        hasLeading: hasLeading,
        header: title,
        footer: footer,
        children: tiles,
      );
    } else {
      return MaterialSettingsCategory(
        header: title,
        children: tiles,
      );
    }
  }
}

@internal
class MaterialSettingsCategory extends StatelessWidget {
  const MaterialSettingsCategory({
    required this.children,
    this.header,
    super.key,
  });

  final Widget? header;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.only(top: 25, bottom: 5),
            child: DefaultTextStyle(
              style: textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
              child: header!,
            ),
          ),
        ...children,
      ],
    );
  }
}
