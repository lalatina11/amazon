import 'package:amazon/src/feature/auth/services/auth_form_validator.dart';
import 'package:amazon/src/feature/auth/widget/password_input.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _validator = AuthFormValidator();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
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
              Text("Name", style: TextStyle(fontSize: 16)),
              TextFormField(
                controller: nameController,
                validator: _validator.nameInputValidator,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: .start,
            spacing: 5,
            children: [
              Text("Email", style: TextStyle(fontSize: 16)),
              TextFormField(
                controller: emailController,
                validator: _validator.emailInputValidator,
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
            child: Text("Register"),
          ),
        ],
      ),
    );
  }
}
