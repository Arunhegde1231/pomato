import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Timer",
        style: TextStyle(
          color: Color.fromRGBO(109, 50, 227, 1),
          fontSize: 45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
