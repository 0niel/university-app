import 'package:flutter/widgets.dart';
import 'package:stac_bridge/stac_bridge.dart';

abstract final class MiniAppContent {
  static Widget? render(Map<String, Object?> screen, BuildContext context) =>
      StacBridge.render(_safeForeground(screen), context);

  static Map<String, Object?> _safeForeground(Map<String, Object?> node) {
    final type = node['type'];
    if (type == 'safeArea') {
      final child = node['child'];
      return {
        ...node,
        'bottom': false,
        if (child is Map<String, Object?>) 'child': _safeForeground(child),
      };
    }
    if (type == 'listView' ||
        type == 'gridView' ||
        type == 'singleChildScrollView') {
      return {...node, 'type': 'appInsetScrollView', 'scrollViewType': type};
    }
    if (type == 'appForEach' &&
        (node['as'] == 'listView' || node['as'] == 'gridView')) {
      return {
        ...node,
        'as': 'appInsetScrollView',
        'scrollViewType': node['as'],
      };
    }
    if (type == 'scaffold') {
      final body = node['body'];
      if (body is Map<String, Object?>) {
        return {...node, 'body': _safeForeground(body)};
      }
      return node;
    }
    if (type == 'appStateScope' ||
        type == 'container' ||
        type == 'padding' ||
        type == 'refreshIndicator' ||
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
    if (type == 'appSwitch') {
      return {
        ...node,
        if (node['cases'] case final List<Object?> cases)
          'cases': [
            for (final branch in cases)
              if (branch is Map<String, Object?> &&
                  branch['child'] is Map<String, Object?>)
                {
                  ...branch,
                  'child': _safeForeground(
                    branch['child']! as Map<String, Object?>,
                  ),
                }
              else
                branch,
          ],
        if (node['default'] case final Map<String, Object?> fallback)
          'default': _safeForeground(fallback),
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
