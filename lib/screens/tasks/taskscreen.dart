import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';
import 'package:pomato/screens/tasks/newtaskscreen.dart';
import 'package:pomato/screens/tasks/tasklist.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final GlobalKey<TaskListWidgetState> _taskListKey =
      GlobalKey<TaskListWidgetState>();

  DateTime _focusDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void _refreshTaskList() {
    _taskListKey.currentState?.fetchTasks(_focusDate);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(_focusDate);
    return Scaffold(
      body: Column(
        children: [
          EasyInfiniteDateTimeLine(
            showTimelineHeader: false,
            selectionMode: const SelectionMode.autoCenter(),
            firstDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
            focusDate: _focusDate,
            lastDate: DateTime(DateTime.now().year, DateTime.now().month + 2,
                DateTime.now().day),
            onDateChange: (selectedDate) {
              setState(() {
                _focusDate = selectedDate;
                _refreshTaskList();
              });
            },
            dayProps: const EasyDayProps(
              dayStructure: DayStructure.dayStrDayNum,
              activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 0, 121, 145),
                      Color.fromARGB(255, 120, 255, 214),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                alignment: Alignment.topLeft,
                child: const Text(
                  'Tasks',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
                alignment: Alignment.topRight,
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TaskListWidget(
              key: _taskListKey,
              selectedDate: _focusDate,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewTaskForm(selectedDate: _focusDate)),
          );
          _refreshTaskList();
        },
        backgroundColor: const Color.fromARGB(255, 188, 85, 232),
        child: const Icon(Icons.add_task_rounded),
      ),
    );
  }
}
