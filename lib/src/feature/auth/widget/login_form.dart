import 'package:amazon/src/feature/auth/services/auth_cubit.dart';
import 'package:amazon/src/feature/auth/services/auth_state.dart';
import 'package:amazon/src/feature/auth/widget/password_input.dart';
import 'package:amazon/src/feature/auth/services/auth_form_validator.dart';
import 'package:amazon/src/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void handleSubmit() async {
    if (formKey.currentState!.validate()) {
      final email = emailController.text;
      final password = passwordController.text;
      await context.read<AuthCubit>().login(email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedIn) {
          Navigator.of(context).push(HomeScreen.route());
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            spacing: 15,
            children: [
              state is AuthError
                  ? Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.pink),
                      ),
                    )
                  : Container(),
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
                  backgroundColor: state is AuthSubmitting
                      ? const Color.fromARGB(255, 158, 146, 108)
                      : null,
                ),
                onPressed: state is AuthSubmitting ? null : handleSubmit,
                child: Text("Login"),
              ),
            ],
          ),
        );
      },
    );
  }
}
