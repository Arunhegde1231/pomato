import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:pomato/effects.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomato/notifiers.dart';


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  bool _settingsChanged = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() async {
      await prefs.reload();
      _timerValue = prefs.getInt('timerValue') ?? 25;
      _breakValue = prefs.getInt('breakValue') ?? 5;
    });
  }

  void _showSliderDialog(BuildContext context, String title, String key) {
    showDialog(
      context: context,
      builder: (context) {
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
                  await prefs.reload();
                  Provider.of<TimerNotifier>(context, listen: false)
                      .updateTimer(value.round());
                } else {
                  prefs.setInt('breakValue', value.round());
                  await prefs.reload();
                  Provider.of<BreakNotifier>(context, listen: false)
                      .updateBreak(value.round());
                }
                setState(() {
                  _settingsChanged = true;
                });
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
                  setState(() {
                    _settingsChanged = true;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    Navigator.of(context).pop(_settingsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
              ],
            ),
            SettingsSection(
              title: const Text('Tasks'),
              tiles: [
                SettingsTile(
                  title: const Text('xoxoxox'),
                  description: const Text('xoxoxoxox'),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: const Text('xoxoxox'),
                  description: const Text('xoxoxoxox'),
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
