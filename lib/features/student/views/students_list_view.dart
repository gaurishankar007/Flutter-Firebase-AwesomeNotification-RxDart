import 'package:flutter/material.dart';

import '../../../core/typedef/function_type_definitions.dart';
import '../models/student.dart';
import 'widgets/main_popup_menu_button.dart';
import 'widgets/student_list_tile.dart';

class StudentsListView extends StatelessWidget {
  final LogoutCallback logout;
  final DeleteAccountCallback deleteAccount;
  final UpdateStudentCallback updateStudent;
  final StudentCallback deleteStudent;
  final VoidCallback goCreateNewStudent;
  final VoidCallback goTestNotification;
  final StudentCallback goStudentInformation;
  final StudentCallback goUpdateStudent;
  final Stream<Iterable<Student>> students;

  const StudentsListView({
    super.key,
    required this.logout,
    required this.deleteAccount,
    required this.updateStudent,
    required this.deleteStudent,
    required this.goCreateNewStudent,
    required this.goTestNotification,
    required this.goStudentInformation,
    required this.goUpdateStudent,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
        actions: [
          IconButton(
            onPressed: goTestNotification,
            icon: const Icon(Icons.notifications),
          ),
          MainPopupMenuButton(
            logout: logout,
            deleteAccount: deleteAccount,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goCreateNewStudent,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<Iterable<Student>>(
        stream: students,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            // Returning circular progress indicator for both case
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.active:
            case ConnectionState.done:
              final students = snapshot.requireData;
              return ListView.separated(
                itemCount: students.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final student = students.elementAt(index);
                  return StudentListTile(
                    student: student,
                    goStudentInformation: () => goStudentInformation(student),
                    goToUpdateStudent: () => goUpdateStudent(student),
                    deleteStudent: () => deleteStudent(student),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
