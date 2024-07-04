import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:pomato/effects.dart';
import 'package:pomato/notifiers.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _timerValue = 25;
  int _breakValue = 5;
  int _cycles = 1;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _timerValue = prefs.getInt('timerValue') ?? 25;
      _breakValue = prefs.getInt('breakValue') ?? 5;
      _cycles = prefs.getInt('cycleValue') ?? 1;
    });
  }

  void _showCycleSlider(BuildContext context, String title, String key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlassEffect(
          blur: 6,
          opacity: 0.3,
          color: Colors.grey,
          child: AlertDialog(
            title: Text(title),
            content: SleekCircularSlider(
              min: 1,
              max: 10,
              initialValue: _cycles.toDouble(),
              onChange: (double value) {
                setState(() {
                  _cycles = value.round();
                });
              },
              onChangeEnd: (double value) async {
                final cycleNotifier =
                    Provider.of<CycleNotifier>(context, listen: false);
                await cycleNotifier.setValue(value.round());
                setState(() {});
              },
              appearance: CircularSliderAppearance(
                customWidths: CustomSliderWidths(
                  trackWidth: 4,
                  progressBarWidth: 10,
                  shadowWidth: 20,
                ),
                infoProperties: InfoProperties(
                  modifier: (double value) {
                    final roundedValue = value.round().toString();
                    return '$roundedValue cycles';
                  },
                ),
                customColors: CustomSliderColors(
                  trackColor: Colors.grey,
                  progressBarColors: [Colors.blue, Colors.lightBlueAccent],
                  shadowColor: Colors.blueAccent,
                  shadowMaxOpacity: 0.2,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSliderDialog(BuildContext context, String title1, String key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlassEffect(
          blur: 6,
          opacity: 0.3,
          color: Colors.grey,
          child: AlertDialog(
            title: Text(title1),
            content: SleekCircularSlider(
              min: 5,
              max: 60,
              initialValue: key == 'timerValue'
                  ? _timerValue.toDouble()
                  : _breakValue.toDouble(),
              onChange: (double value) {
                setState(() {
                  if (key == 'timerValue') {
                    _timerValue = value.round();
                  } else {
                    _breakValue = value.round();
                  }
                });
              },
              onChangeEnd: (double value) async {
                if (key == 'timerValue') {
                  await Provider.of<TimerNotifier>(context, listen: false)
                      .setValue(value.round());
                } else {
                  await Provider.of<BreakNotifier>(context, listen: false)
                      .setValue(value.round());
                }
                setState(() {});
              },
              appearance: CircularSliderAppearance(
                customWidths: CustomSliderWidths(
                  trackWidth: 4,
                  progressBarWidth: 10,
                  shadowWidth: 20,
                ),
                infoProperties: InfoProperties(
                  modifier: (double value) {
                    final roundedValue = value.round().toString();
                    return '$roundedValue min';
                  },
                ),
                customColors: CustomSliderColors(
                  trackColor: Colors.grey,
                  progressBarColors: [Colors.blue, Colors.lightBlueAccent],
                  shadowColor: Colors.blueAccent,
                  shadowMaxOpacity: 0.2,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Timer'),
              tiles: [
                SettingsTile(
                  title: const Text('Minutes'),
                  description: const Text('Set Focus time in minutes'),
                  onPressed: (BuildContext context) {
                    _showSliderDialog(
                        context, 'Set Focus time Minutes', 'timerValue');
                  },
                ),
                SettingsTile(
                  title: const Text('Break'),
                  description: const Text('Set break time in minutes'),
                  onPressed: (BuildContext context) {
                    _showSliderDialog(
                        context, 'Set Break Minutes', 'breakValue');
                  },
                ),
                SettingsTile(
                    title: const Text('Cycles'),
                    description: const Text('Set number of Focus/Break Cycles'),
                    onPressed: (BuildContext context) {
                      _showCycleSlider(
                          context, 'Set Number of Cycles', 'cycleValue');
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}