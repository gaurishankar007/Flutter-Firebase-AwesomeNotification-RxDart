import 'package:flutter/material.dart';

import '../../../core/typedef/function_type_definitions.dart';
import '../models/student.dart';

class StudentInformation extends StatelessWidget {
  final Student student;
  final GoBackCallback goBack;

  const StudentInformation({
    super.key,
    required this.student,
    required this.goBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: goBack,
          icon: const Icon(Icons.close),
        ),
        title: const Text('Student Information'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              if (student.profilePicture.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    student.profilePicture,
                    width: 250,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                )
              else
                const Icon(
                  Icons.person,
                  size: 150,
                  color: Colors.deepPurple,
                ),
              const SizedBox(height: 10, width: double.maxFinite),
              Row(
                children: [
                  const Icon(size: 18, Icons.person),
                  const SizedBox(width: 5),
                  Text(
                    student.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(size: 18, Icons.phone),
                  const SizedBox(width: 5),
                  Text(
                    student.phoneNumber,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(size: 18, Icons.location_on),
                  const SizedBox(width: 5),
                  Text(
                    student.address.country,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
