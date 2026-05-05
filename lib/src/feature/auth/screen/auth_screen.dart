import 'package:amazon/src/constants/global_variables.dart';
import 'package:amazon/src/feature/auth/services/auth_type.dart';
import 'package:amazon/src/feature/auth/widget/login_form.dart';
import 'package:amazon/src/feature/auth/widget/register_form.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => AuthScreen());

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthType authType = AuthType.register;

  void switchAuthType() {
    setState(() {
      authType = authType == AuthType.login
          ? AuthType.register
          : AuthType.login;
    });
  }

  bool isLoginScreen() {
    return authType == AuthType.login;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: GlobalVariables.secondaryColor,
        title: Center(child: Text(isLoginScreen() ? "Masuk" : "Daftar")),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: isLoginScreen() ? LoginForm() : RegisterForm(),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: switchAuthType,
              child: Text(
                isLoginScreen()
                    ? "Belum punya akun? Daftar disini"
                    : "Sudah punya akun? Masuk disini",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
