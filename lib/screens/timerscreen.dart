import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TimerScreenState();
  }
}

class _TimerScreenState extends State<TimerScreen> {
  int timer = 25;
  int breakTime = 10; 
  bool isBreakTime = false;
  int remainingTime = 0;
  Timer? _timer;
  bool isPaused = false;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    _loadTimerData();
  }

  Future<void> _loadTimerData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timer = prefs.getInt('timerValue') ?? 25;
      breakTime = prefs.getInt('breakValue') ?? 10;
      remainingTime = timer * 60;
    });
  }

  void _startTimer() {
    setState(() {
      isRunning = true;
      isPaused = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (!isPaused) {
          if (remainingTime > 0) {
            remainingTime--;
          } else {
            _timer?.cancel();
            _switchMode();
          }
        }
      });
    });
  }

  void _pauseResumeTimer() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      isPaused = false;
      remainingTime = isBreakTime ? breakTime * 60 : timer * 60;
    });
  }

  void _switchMode() {
    setState(() {
      if (isBreakTime) {
        remainingTime = timer * 60;
        isBreakTime = false;
      } else {
        remainingTime = breakTime * 60;
        isBreakTime = true;
      }
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              isBreakTime ? "Take a Break" : "It's Focus Time",
              style: const TextStyle(
                color: Color.fromRGBO(109, 50, 227, 1),
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _formatTime(remainingTime),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isRunning ? _pauseResumeTimer : _startTimer,
                child:
                    Text(isRunning ? (isPaused ? 'Resume' : 'Pause') : 'Start'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _stopTimer,
                child: const Text('Stop'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
