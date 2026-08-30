import 'package:flutter/foundation.dart';

class TabReselectNotifier extends ChangeNotifier {
  TabReselectNotifier._();

  static final TabReselectNotifier instance = TabReselectNotifier._();

  int _tabIndex = -1;
  int _revision = 0;

  int get tabIndex => _tabIndex;

  int get revision => _revision;

  void reselect(int index) {
    _tabIndex = index;
    _revision++;
    notifyListeners();
  }
}
