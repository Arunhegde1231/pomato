import 'package:flutter/foundation.dart';

class TimerNotifier with ChangeNotifier {
  int _value = 25;
  int get value => _value;
  void setValue(int newValue) {
    _value = newValue;
    notifyListeners();
  }
}

class BreakNotifier with ChangeNotifier {
  int _value = 5;
  int get value => _value;
  void setValue(int newValue) {
    _value = newValue;
    notifyListeners();
  }
}

class CycleNotifier with ChangeNotifier {
  int _value = 1;
  int get value => _value;
  void setValue(int newValue) {
    _value = newValue;
    notifyListeners();
  }
}
