import 'package:flutter/material.dart';
import 'package:pomato/taskdata.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Map<String, dynamic>> _taskGroups = [];

  @override
  void initState() {
    super.initState();
    _loadTaskGroups();
  }

  Future<void> _loadTaskGroups() async {
    final taskGroups = await DataBaseGroup().getTaskGroups();
    setState(() {
      _taskGroups = taskGroups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Tasks')),
          );
  }
}
