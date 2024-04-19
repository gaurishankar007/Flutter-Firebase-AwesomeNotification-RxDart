import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/helpers/if_debugging.dart';
import '../../../core/typedef/function_type_definitions.dart';

class LoginView extends HookWidget {
  final LoginFunction login;
  final VoidCallback goToRegisterView;

  const LoginView({
    super.key,
    required this.login,
    required this.goToRegisterView,
  });

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: 'vandad.np@gmail.com'.ifDebugging);
    final passwordController = useTextEditingController(text: 'foobarbaz'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
              decoration: const InputDecoration(
                hintText: 'Enter your email here...',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              obscuringCharacter: '*',
              decoration: const InputDecoration(
                hintText: 'Enter your password here...',
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                login(email, password);
              },
              child: const Text('Log in'),
            ),
            TextButton(
              onPressed: goToRegisterView,
              child: const Text('Not registered yet? Register here!'),
            ),
          ],
        ),
      ),
    );
  }
}
