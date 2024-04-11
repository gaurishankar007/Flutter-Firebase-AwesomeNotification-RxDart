import 'widgets/module_list.dart';
import 'package:flutter/material.dart';

import '../../../core/typedef/function_type_definitions.dart';
import '../../../widgets/bottom_sheets/create_module_bottom_sheet.dart';
import '../models/student.dart';

class StudentInformation extends StatelessWidget {
  final Student student;
  final ModuleStreamCallback moduleStream;
  final CreateModuleCallBack createModule;
  final DeleteModuleCallBack deleteModule;
  final GoBackCallback goBack;

  const StudentInformation({
    super.key,
    required this.student,
    required this.moduleStream,
    required this.createModule,
    required this.deleteModule,
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
        child: Padding(
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Modules",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () {
                      showCreateModuleBottomSheet(
                        context: context,
                        studentId: student.id,
                        createModule: createModule,
                      );
                    },
                    icon: const Icon(Icons.add_circle_rounded, color: Colors.deepPurple),
                  ),
                ],
              ),
              Expanded(
                child: ModuleList(
                  student: student,
                  moduleStream: moduleStream,
                  deleteModule: deleteModule,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
