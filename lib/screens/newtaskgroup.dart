import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomato/taskdata.dart';

class NewTaskGroup extends StatelessWidget {
  const NewTaskGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.list_rounded),
        title: const Text('Enter Details'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'Name',
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        enableFeedback: true,
        heroTag: 'newtaskGroup',
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
            final taskName = formKey.currentState?.value['Name'];
            final newTask = {'name': taskName};

            await DataBaseGroup().insertTask(newTask);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task saved!')),
            );

            Navigator.pop(context);
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
