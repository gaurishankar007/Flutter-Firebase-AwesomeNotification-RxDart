import 'package:flutter/material.dart';

import '../../../../core/typedef/function_type_definitions.dart';
import '../../form/delete_module_form.dart';
import '../../models/module.dart';
import '../../models/student.dart';

class ModuleList extends StatelessWidget {
  final Student student;
  final ModuleStreamCallback moduleStream;
  final DeleteModuleCallBack deleteModule;

  const ModuleList({
    super.key,
    required this.student,
    required this.moduleStream,
    required this.deleteModule,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<Module>>(
      stream: moduleStream(student.id),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          // Returning circular progress indicator for both case
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());

          case ConnectionState.active:
          case ConnectionState.done:
            final modules = snapshot.requireData;
            return ListView.separated(
              itemCount: modules.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final module = modules.elementAt(index);
                return ListTile(
                  leading: Text("${index + 1}.", style: const TextStyle(fontSize: 18)),
                  title: Text(module.name),
                  subtitle: Text("Score: ${module.scorePercentage}%"),
                  trailing: IconButton(
                    onPressed: () {
                      final deleteModuleForm = DeleteModuleForm(
                        studentId: student.id,
                        moduleId: module.id,
                      );
                      deleteModule(deleteModuleForm);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                );
              },
            );
        }
      },
    );
  }
}
