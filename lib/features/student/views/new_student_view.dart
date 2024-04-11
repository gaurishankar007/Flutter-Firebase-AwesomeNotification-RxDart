import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/helpers/if_debugging.dart';
import '../../../core/typedef/function_type_definitions.dart';

class NewStudentView extends HookWidget {
  final CreateStudentCallback createStudent;
  final GoBackCallback goBack;

  const NewStudentView({
    super.key,
    required this.createStudent,
    required this.goBack,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: 'Vandad'.ifDebugging);
    final phoneNumberController = useTextEditingController(text: '+461234567890'.ifDebugging);
    final countryController = useTextEditingController(text: 'Sweden'.ifDebugging);
    final cityController = useTextEditingController(text: 'Stockholm'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new student'),
        leading: IconButton(
          onPressed: goBack,
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              keyboardAppearance: Brightness.dark,
              decoration: const InputDecoration(
                labelText: 'Name...',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              keyboardAppearance: Brightness.dark,
              decoration: const InputDecoration(
                labelText: 'Phone number...',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: countryController,
              keyboardAppearance: Brightness.dark,
              decoration: const InputDecoration(
                labelText: 'Country...',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: cityController,
              keyboardAppearance: Brightness.dark,
              decoration: const InputDecoration(
                labelText: 'City...',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                final phoneNumber = phoneNumberController.text;
                final country = countryController.text;
                final city = cityController.text;

                createStudent(
                  name: name,
                  phoneNumber: phoneNumber,
                  country: country,
                  city: city,
                );
                goBack();
              },
              child: const Text('Save Student'),
            )
          ],
        ),
      ),
    );
  }
}
