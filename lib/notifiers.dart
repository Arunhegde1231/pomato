import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerNotifier extends ChangeNotifier {
  int _value = 25;

  int get value => _value;

  Future<void> setValue(int newValue) async {
    _value = newValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timerValue', newValue);
    notifyListeners();
  }

  Future<void> loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    _value = prefs.getInt('timerValue') ?? 25;
    notifyListeners();
  }
}

class BreakNotifier extends ChangeNotifier {
  int _value = 5;

  int get value => _value;

  Future<void> setValue(int newValue) async {
    _value = newValue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('breakValue', newValue);
    notifyListeners();
  }

  Future<void> loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    _value = prefs.getInt('breakValue') ?? 5;
    notifyListeners();
  }
}

class CycleNotifier extends ChangeNotifier {
  int _value = 1;

  int get value => _value;

  Future<void> setValue(int newValue) async {
    if (_value != newValue) {
      _value = newValue;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('cycleValue', newValue);
      notifyListeners();
    }
  }

  Future<void> loadValue() async {
    final prefs = await SharedPreferences.getInstance();
    _value = prefs.getInt('cycleValue') ?? 1;
    notifyListeners();
  }
}
