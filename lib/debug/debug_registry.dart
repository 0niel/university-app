import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class DebugRegistry extends ChangeNotifier {
  DebugRegistry._();

  static final instance = DebugRegistry._();

  final List<DebugAction> _actions = [];
  final List<DebugFeature> _features = [];

  List<DebugAction> get actions => .unmodifiable(_actions);
  List<DebugFeature> get features => .unmodifiable(_features);

  void registerAction(DebugAction action) {
    _actions.add(action);
    notifyListeners();
  }

  void toggleFeature(DebugFeature feature) {
    feature._enabled = !feature._enabled;
    notifyListeners();
  }
}

class DebugAction {
  const DebugAction({
    required this.label,
    required this.onTap,
    this.icon = AppLineIcon.bolt,
    this.subtitle,
    this.isDestructive = false,
  });

  final String label;
  final void Function(BuildContext context) onTap;
  final AppLineIcon icon;
  final String? subtitle;
  final bool isDestructive;
}

class DebugFeature {
  DebugFeature({
    required this.label,
    required this.builder,
    required this.icon,
  });

  final String label;
  final WidgetBuilder builder;
  final AppLineIcon icon;
  bool _enabled = false;
  bool get enabled => _enabled;
}
