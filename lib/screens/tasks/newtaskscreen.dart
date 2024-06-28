import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomato/taskdata.dart';

class NewTaskScreen extends StatelessWidget {
  final int groupId;

  const NewTaskScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.task_alt_rounded),
        title: const Text('Enter Task Details'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'TaskName',
                  decoration: const InputDecoration(labelText: 'Task Name'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        enableFeedback: true,
        heroTag: 'newTask',
        label: const Row(
          children: [
            Icon(Icons.save_rounded),
            SizedBox(
              width: 15,
            ),
            Text(
              'Save',
              textAlign: TextAlign.left,
            ),
          ],
        ),
        onPressed: () async {
          if (formKey.currentState?.saveAndValidate() ?? false) {
            final taskName = formKey.currentState?.value['TaskName'];
            final newTask = {
              'name': taskName,
              'group_id': groupId,
            };

            await DataBaseGroup().insertTask(newTask);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task saved!')),
            );

            Navigator.pop(context, true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Validation failed')),
            );
          }
        },
      ),
    );
  }
}
