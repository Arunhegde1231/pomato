import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pomato/screens/tasks/database.dart';
import 'package:pomato/screens/tasks/tasklist.dart'; 

DateTime _focusDate =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
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
          const SizedBox(
            height: 10,
          ),
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
            ],
          ),
          const Expanded(
            child: TaskListWidget(), 
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewTaskForm()),
          ).then((_) {
            setState(() {});
          });
        },
        backgroundColor: const Color.fromARGB(255, 188, 85, 232),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NewTaskForm extends StatefulWidget {
  const NewTaskForm({super.key});

  @override
  _NewTaskFormState createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> task = {
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                    };
                    int result = await DatabaseHelper().insertTask(task);
                    if (result > 0) {
                      Fluttertoast.showToast(
                        msg: " ✔ Added task successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor:
                            const Color.fromARGB(255, 145, 247, 197),
                        textColor: Colors.black,
                        fontSize: 20,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: " ✖ Failed to add task",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 20,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
