import 'package:flutter/widgets.dart';

class MiniAppStateStore extends ChangeNotifier {
  final Map<String, Object?> _values = <String, Object?>{};

  void seed(Map<String, Object?> initial) {
    _values.addAll(initial);
  }

  Object? get(String key) => _values[key];

  Map<String, Object?> snapshot() => .unmodifiable(_values);

  void set(String key, Object? value) {
    _values[key] = value;
    notifyListeners();
  }

  void add(String key, num delta) {
    final current = get(key);
    final base = current is num
        ? current
        : num.tryParse(current?.toString() ?? '');
    set(key, (base ?? 0) + delta);
  }

  @override
  void dispose() {
    _values.clear();
    super.dispose();
  }
}
