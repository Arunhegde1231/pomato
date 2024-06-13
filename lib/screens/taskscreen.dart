import 'package:flutter/material.dart';
import 'package:pomato/screens/tasklist.dart';
import 'package:pomato/taskdata.dart';
import 'package:pomato/screens/newtaskgroup.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Groups'),
      ),
      body: ListView.builder(
        itemCount: _taskGroups.length,
        itemBuilder: (context, index) {
          final taskGroup = _taskGroups[index];
          return ListTile(
            title: Text(taskGroup['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TaskListScreen(groupId: taskGroup['id']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewTaskGroup()),
          );
          if (result == true) {
            _loadTaskGroups();
          }
        },
        backgroundColor: Colors.green[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}
