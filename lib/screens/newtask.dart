import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class NewTask extends StatelessWidget {
  const NewTask({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      appBar: AppBar(leading: const Icon(Icons.list_rounded),title: const Text('Enter Details'),),
      body:  Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: FormBuilder(
            key: _formKey,
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
        heroTag: 'newtask',
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
        onPressed: () {},
      ),
    );
  }
}
