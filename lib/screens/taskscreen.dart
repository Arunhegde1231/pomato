import 'package:flutter/material.dart';
import 'package:pomato/screens/newtask.dart';


class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Tasks",
          style: TextStyle(
            color: Colors.green[900],
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewTask(),
              ));
        },
        heroTag: 'newtask',
        enableFeedback: true,
        child: const Icon(Icons.add),
      ),
    );
  }
}
