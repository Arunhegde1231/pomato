import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:pomato/screens/tasks/database.dart';

class TaskListWidget extends StatefulWidget {
  final DateTime selectedDate;
  const TaskListWidget({super.key, required this.selectedDate});

  @override
  TaskListWidgetState createState() => TaskListWidgetState();
}

class TaskListWidgetState extends State<TaskListWidget> {
  late Future<List<Map<String, dynamic>>> _tasks;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _tasks = fetchTasks(widget.selectedDate);
  }

  @override
  void didUpdateWidget(TaskListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      _tasks = fetchTasks(widget.selectedDate);
    }
  }

  Future<List<Map<String, dynamic>>> fetchTasks(DateTime focusDate) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(focusDate);
    return _databaseHelper.getTasksByDate(formattedDate);
  }

  Future<void> _completeTask(int taskId) async {
    String completionDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    await _databaseHelper.moveTaskToCompleted(taskId, completionDate);
    setState(() {
      _tasks = fetchTasks(widget.selectedDate);
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
          return const Center(child: Text('Tasks Empty.'));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final task = snapshot.data![index];
              return Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(task['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                      subtitle: Text(
                        task['description'],
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MSHCheckbox(
                      size: 20,
                      value: true,
                      style: MSHCheckboxStyle.stroke,
                      onChanged: (selected) {
                        if (selected) {
                          _completeTask(task['id']);
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
