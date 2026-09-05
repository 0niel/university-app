import 'package:flutter/widgets.dart';
import 'package:stac_bridge/stac_bridge.dart';

abstract final class MiniAppContent {
  static Widget? render(Map<String, Object?> screen, BuildContext context) =>
      StacBridge.render(_safeForeground(screen), context);

  static Map<String, Object?> _safeForeground(Map<String, Object?> node) {
    final type = node['type'];
    if (type == 'safeArea') return {...node, 'bottom': true};
    if (type == 'scaffold') {
      final body = node['body'];
      if (body is Map<String, Object?>) {
        return {...node, 'body': _safeForeground(body)};
      }
      return node;
    }
    if (type == 'appStateScope' ||
        type == 'container' ||
        type == 'coloredBox' ||
        type == 'decoratedBox') {
      final child = node['child'];
      if (child is Map<String, Object?>) {
        return {...node, 'child': _safeForeground(child)};
      }
    }
    if (type == 'appIf') {
      return {
        ...node,
        for (final key in ['child', 'else'])
          if (node[key] case final Map<String, Object?> branch)
            key: _safeForeground(branch),
      };
    }
    return {
      'type': 'safeArea',
      'top': false,
      'left': false,
      'right': false,
      'bottom': true,
      'child': node,
    };
  }
}
