import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crud/data/remote/repositories/firebase_auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../../core/constant.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  bool isLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordResetController = TextEditingController();
  bool _obscureText = true;

  signIn() async {
    try {
      await AuthFirebase().singInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? ""),
        ),
      );
    }
  }

  register() async {
    try {
      await AuthFirebase().createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? ""),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color secondary = Theme.of(context).colorScheme.secondary;
    Color surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Authentication"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: sWidth(context) * .04,
          vertical: 20,
        ),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: MultiValidator([
                RequiredValidator(errorText: "Email is required."),
                EmailValidator(errorText: "Invalid email."),
              ]),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.mail_rounded,
                  color: secondary,
                  size: iconSize - 5,
                ),
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_rounded,
                  color: secondary,
                  size: iconSize - 5,
                ),
                suffixIcon: InkWell(
                  onTap: () => setState(() {
                    _obscureText = !_obscureText;
                  }),
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                labelText: 'Password',
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  final formKey = GlobalKey<FormState>();
                  _passwordResetController.text = "";

                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (builder) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: formKey,
                            child: TextFormField(
                              controller: _passwordResetController,
                              keyboardType: TextInputType.emailAddress,
                              validator: MultiValidator([
                                RequiredValidator(errorText: "Email is required."),
                                EmailValidator(errorText: "Invalid email."),
                              ]),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail_rounded,
                                  color: secondary,
                                  size: iconSize - 5,
                                ),
                                labelText: 'Email',
                                hintText: 'Enter your email',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("An password reset link will be sent to this email."),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  await AuthFirebase()
                                      .resetPassword(email: _passwordResetController.text);

                                  Navigator.pop(context);
                                } on FirebaseAuthException catch (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(error.message ?? ""),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text("Send Reset Link"),
                          ),
                          SizedBox(
                            height: 10 + MediaQuery.of(context).viewInsets.bottom,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text("Forgot Password?"),
              ),
            ),
            ElevatedButton(
              onPressed: isLogin ? signIn : register,
              child: Text(isLogin ? "Login" : "Register"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                  isLogin ? "Don't have an account, register?" : "Already have an account, login?"),
            ),
          ],
        ),
      ),
    );
  }
}
