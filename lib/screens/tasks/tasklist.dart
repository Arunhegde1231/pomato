import 'package:flutter/material.dart';
import 'database.dart';

class TaskListWidget extends StatefulWidget {
  const TaskListWidget({super.key});

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class TaskService {
  Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await DatabaseHelper().database;
    return await db.query('tasks');
  }
}

class _TaskListWidgetState extends State<TaskListWidget> {
  late Future<List<Map<String, dynamic>>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = TaskService().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _tasks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No tasks available.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              return ListTile(
                title: Text(task['name']),
                subtitle: Text(task['description']),
              );
            },
          );
        }
      },
    );
  }
}
