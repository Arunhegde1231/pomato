import 'package:flutter/material.dart';
import 'package:pomato/taskdata.dart';
import 'package:pomato/screens/newtaskscreen.dart';

class TaskListScreen extends StatefulWidget {
  final int groupId;

  const TaskListScreen({super.key, required this.groupId});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DataBaseGroup().getTasks(widget.groupId);
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            title: Text(task['name']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTaskScreen(groupId: widget.groupId),
            ),
          );
          if (result == true) {
            _loadTasks();
          }
        },
        backgroundColor: Colors.green[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}
