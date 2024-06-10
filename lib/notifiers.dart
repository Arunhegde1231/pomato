import 'package:flutter/material.dart';

class TimerNotifier extends ValueNotifier<int> {
  TimerNotifier(super.value);

  void updateTimer(int newValue) {
    value = newValue;
  }
}

class BreakNotifier extends ValueNotifier<int> {
  BreakNotifier(super.value);

  void updateBreak(int newValue) {
    value = newValue;
  }
}
