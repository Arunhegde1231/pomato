import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SettingsList(sections: [
        SettingsSection(
          title: const Text('Timer'),
          tiles: [
            SettingsTile(
              title: const Text('Minutes'),
              description: const Text('Set timer in minutes'),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile(
              title: const Text('Break'),
              description: const Text('Set break time in minutes'),
              onPressed: (BuildContext context) {},
            ),
            SettingsTile(
              title: const Text('Number of Timers'),
              description: const Text('Set maximum number of timers'),
              onPressed: (BuildContext context) {},
            )
          ],
        )
      ])),
    );
  }
}
