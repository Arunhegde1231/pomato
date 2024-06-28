import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

DateTime _focusDate =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    super.initState();
  }

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
                  )),
                  //add sorting and filtering and tag features
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromARGB(255, 188, 85, 232),
        child: const Icon(Icons.add),
      ),
    );
  }
}
