import 'package:flutter/material.dart';

import '../../models/student.dart';

class StudentListTile extends StatelessWidget {
  final Student student;
  final VoidCallback goStudentInformation;
  final VoidCallback goToUpdateStudent;
  final VoidCallback deleteStudent;

  const StudentListTile({
    super.key,
    required this.student,
    required this.goStudentInformation,
    required this.goToUpdateStudent,
    required this.deleteStudent,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: goStudentInformation,
      leading: student.profilePicture.isEmpty
          ? const Icon(Icons.person, size: 40, color: Colors.deepPurple)
          : ClipOval(
              child: Image.network(
                student.profilePicture,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
      title: Text(
        student.name,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(student.phoneNumber),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: goToUpdateStudent,
            icon: const Icon(Icons.edit_rounded, color: Colors.deepPurple),
          ),
          IconButton(
            onPressed: deleteStudent,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
