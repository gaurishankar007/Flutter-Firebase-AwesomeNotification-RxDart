import '../../models/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/helpers/if_debugging.dart';
import '../../../../core/typedef/function_type_definitions.dart';
import '../../form/create_module_form.dart';

class CreateNewModule extends HookWidget {
  final String studentId;
  final CreateModuleCallBack createModule;
  final VoidCallback goBack;

  const CreateNewModule({
    super.key,
    required this.studentId,
    required this.createModule,
    required this.goBack,
  });

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(text: "Math".ifDebugging);
    final scoreController = useTextEditingController(text: "68.2".ifDebugging);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: nameController,
            keyboardAppearance: Brightness.dark,
            decoration: const InputDecoration(
              labelText: 'Name...',
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: scoreController,
            keyboardType: TextInputType.number,
            keyboardAppearance: Brightness.dark,
            decoration: const InputDecoration(
              labelText: 'Score Percentage...',
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final scorePercentage = scoreController.text;
              late double scorePercentageDouble;

              if (double.tryParse(scorePercentage) != null) {
                scorePercentageDouble = double.tryParse(scorePercentage) ?? 0.0;
              } else {
                return;
              }

              final createModuleForm = CreateModuleForm(
                studentId: studentId,
                module: Module(
                  name: name,
                  scorePercentage: scorePercentageDouble,
                ),
              );

              createModule(createModuleForm);
              goBack();
            },
            child: const Text('Create Module'),
          )
        ],
      ),
    );
  }
}
