import 'package:flutter/foundation.dart';

class TimerNotifier extends ChangeNotifier {
  int _value = 25;

  int get value => _value;

  void setValue(int newValue) {
    _value = newValue;
    notifyListeners();
  }
}

class BreakNotifier extends ChangeNotifier {
  int _value = 5;

  int get value => _value;

  void setValue(int newValue) {
    _value = newValue;
    notifyListeners();
  }
}
