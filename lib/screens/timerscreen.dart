import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:pomato/notifiers.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TimerScreenState();
  }
}

class _TimerScreenState extends State<TimerScreen> {
  int remainingTime = 0;
  Timer? _timer;
  bool isPaused = true;
  bool isRunning = false;
  bool isBreakTime = false;
  int currentCycle = 1;
  int totalCycles = 1;

  @override
  void initState() {
    super.initState();
    _loadTimerData();
  }

  Future<void> _loadTimerData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    setState(() {
      remainingTime = (prefs.getInt('timerValue') ?? 25) * 60;
      totalCycles = prefs.getInt('cycleValue') ?? 1;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final TimerNotifier timerNotifier = Provider.of<TimerNotifier>(context);
    final BreakNotifier breakNotifier = Provider.of<BreakNotifier>(context);
    final CycleNotifier cycleNotifier = Provider.of<CycleNotifier>(context);
    timerNotifier.addListener(_updateRemainingTime);
    breakNotifier.addListener(_updateRemainingTime);
    cycleNotifier.addListener(_updateCycles);
  }

  void _updateRemainingTime() {
    setState(() {
      remainingTime = isBreakTime
          ? Provider.of<BreakNotifier>(context, listen: false).value * 60
          : Provider.of<TimerNotifier>(context, listen: false).value * 60;
    });
  }

  void _updateCycles() {
    setState(() {
      totalCycles = Provider.of<CycleNotifier>(context, listen: false).value;
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
      remainingTime = isBreakTime
          ? Provider.of<BreakNotifier>(context, listen: false).value * 60
          : Provider.of<TimerNotifier>(context, listen: false).value * 60;
      currentCycle = 1;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      isPaused = false;
      isBreakTime = false;
      remainingTime =
          Provider.of<TimerNotifier>(context, listen: false).value * 60;
      currentCycle = 1;
    });
  }

  void _switchMode() {
    setState(() {
      if (isBreakTime) {
        if (currentCycle >= totalCycles) {
          _stopTimer();
        } else {
          remainingTime =
              Provider.of<TimerNotifier>(context, listen: false).value * 60;
          isBreakTime = false;
          currentCycle++;
        }
      } else {
        remainingTime =
            Provider.of<BreakNotifier>(context, listen: false).value * 60;
        isBreakTime = true;
      }
    });
    if (isRunning) _startTimer();
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
            _timeFormat(remainingTime),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 45,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Cycle $currentCycle of $totalCycles',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
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
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: _resetTimer,
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _timeFormat(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
