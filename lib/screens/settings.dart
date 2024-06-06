import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:pomato/effects.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  int _timerValue = 25; // default
  int _breakValue = 5; // default

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _timerValue = prefs.getInt('timerValue') ?? 25;
      _breakValue = prefs.getInt('breakValue') ?? 5;
    });
  }

  void _showSliderDialog(BuildContext context, String title, String key) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GlassEffect(
          blur: 3,
          opacity: 0.3,
          color: Colors.grey[600]!,
          child: AlertDialog(
            title: Text(title),
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
                final prefs = await SharedPreferences.getInstance();
                if (key == 'timerValue') {
                  prefs.setInt('timerValue', value.round());
                } else {
                  prefs.setInt('breakValue', value.round());
                }
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
                  description: Text('Set timer in minutes ($_timerValue min)'),
                  onPressed: (BuildContext context) {
                    _showSliderDialog(
                        context, 'Set Timer Minutes', 'timerValue');
                  },
                ),
                SettingsTile(
                  title: const Text('Break'),
                  description:
                      Text('Set break time in minutes ($_breakValue min)'),
                  onPressed: (BuildContext context) {
                    _showSliderDialog(
                        context, 'Set Break Minutes', 'breakValue');
                  },
                ),
                SettingsTile(
                  title: const Text('Number of Timers'),
                  description: const Text('Set maximum number of timers'),
                  onPressed: (BuildContext context) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
