import '../../../core/helpers/if_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/typedef/function_type_definitions.dart';

class NewContactView extends HookWidget {
  final CreateContactCallback createContact;
  final GoBackCallback goBack;

  const NewContactView({
    super.key,
    required this.createContact,
    required this.goBack,
  });

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController(text: 'Vandad'.ifDebugging);
    final lastNameController = useTextEditingController(text: 'Nahavandipoor'.ifDebugging);
    final phoneNumberController = useTextEditingController(text: '+461234567890'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new contact'),
        leading: IconButton(
          onPressed: goBack,
          icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                keyboardType: TextInputType.name,
                keyboardAppearance: Brightness.dark,
                decoration: const InputDecoration(
                  hintText: 'First name...',
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: lastNameController,
                keyboardType: TextInputType.name,
                keyboardAppearance: Brightness.dark,
                decoration: const InputDecoration(
                  hintText: 'Last name...',
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
                  hintText: 'Phone number...',
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  final firstName = firstNameController.text;
                  final lastName = lastNameController.text;
                  final phoneNumber = phoneNumberController.text;

                  createContact(firstName, lastName, phoneNumber);
                  goBack();
                },
                child: const Text('Save Contact'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
