import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TimerScreen();
  }
}

class _TimerScreen extends State<TimerScreen> {
  double timer = 0;
  double breakTime = 0;

  @override
  void initState() {
    super.initState();
    _loadtimerdata();
  }

  Future<void> _loadtimerdata() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timer = prefs.getDouble('timerValue')?? 25;
      breakTime = prefs.getDouble('breakvalue')?? 10;
    });
  }

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
