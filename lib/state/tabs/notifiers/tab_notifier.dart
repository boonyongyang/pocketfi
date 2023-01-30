import 'package:flutter/material.dart';

class TabProvider extends ChangeNotifier {
  int _currentTab = 0;

  int get currentTab => _currentTab;

  set currentTab(int value) {
    _currentTab = value;
    notifyListeners();
  }
}
