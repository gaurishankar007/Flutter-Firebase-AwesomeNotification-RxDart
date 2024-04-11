import 'dart:io';

import '../../../core/utils/image_picker.dart';
import '../models/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/typedef/function_type_definitions.dart';
import '../form/update_student_form.dart';
import '../models/address.dart';

class UpdateStudentView extends HookWidget {
  final Student student;
  final UpdateStudentCallback updateStudent;
  final GoBackCallback goBack;

  const UpdateStudentView({
    super.key,
    required this.student,
    required this.updateStudent,
    required this.goBack,
  });

  @override
  Widget build(BuildContext context) {
    final image = useState("");

    final nameController = useTextEditingController(text: student.name);
    final phoneNumberController = useTextEditingController(text: student.phoneNumber);
    final countryController = useTextEditingController(text: student.address.country);
    final cityController = useTextEditingController(text: student.address.city);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: goBack,
          icon: const Icon(Icons.close),
        ),
        title: const Text('Update student'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            if (image.value.isNotEmpty)
              Image.file(
                File(image.value),
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            else if (student.profilePicture.isNotEmpty)
              Image.network(
                student.profilePicture,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            else
              const Icon(
                Icons.person,
                size: 150,
                color: Colors.deepPurple,
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final imagePath = await imagePicker(ImageSource.gallery);
                if (imagePath == null) return;
                image.value = imagePath;
              },
              child: const Text("Select Profile"),
            ),
            const SizedBox(height: 20),
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

                final updateStudentForm = UpdateStudentForm(
                  imagePath: image.value,
                  student: student.copyWith(
                    name: name,
                    phoneNumber: phoneNumber,
                    address: Address(
                      country: country,
                      city: city,
                    ),
                  ),
                );

                updateStudent(updateStudentForm);
                goBack();
              },
              child: const Text('Update Student'),
            )
          ],
        ),
      ),
    );
  }
}
