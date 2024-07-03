import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pomato/screens/tasks/database.dart';

class TaskListWidget extends StatefulWidget {
  final DateTime selectedDate;
  const TaskListWidget({super.key, required this.selectedDate});

  @override
  TaskListWidgetState createState() => TaskListWidgetState();
}

class TaskListWidgetState extends State<TaskListWidget> {
  late Future<List<Map<String, dynamic>>> _tasks;

  @override
  void initState() {
    super.initState();
    fetchTasks(widget.selectedDate);
  }

  void fetchTasks(DateTime focusDate) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(focusDate);
    setState(() {
      _tasks = DatabaseHelper().getTasksByDate(formattedDate);
    });
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
            shrinkWrap: true,
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