import 'package:amazon/src/feature/auth/widget/password_input.dart';
import 'package:amazon/src/feature/auth/services/auth_form_validator.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formValidator = AuthFormValidator();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void handleSubmit() {
    if (formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 15,
        children: [
          Column(
            crossAxisAlignment: .start,
            spacing: 5,
            children: [
              Text("Email", style: TextStyle(fontSize: 16)),
              TextFormField(
                controller: emailController,
                validator: _formValidator.emailInputValidator,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: .start,
            spacing: 5,
            children: [
              Text("Password", style: TextStyle(fontSize: 16)),
              PasswordInput(controller: passwordController),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: handleSubmit,
            child: Text("Login"),
          ),
        ],
      ),
    );
  }
}
