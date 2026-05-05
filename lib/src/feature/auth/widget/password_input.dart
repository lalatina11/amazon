import 'package:amazon/src/feature/auth/services/auth_form_validator.dart';
import 'package:flutter/material.dart';
import "package:lucide_icons_flutter/lucide_icons.dart";

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  const PasswordInput({super.key, required this.controller});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isShowPassword = false;
  final _formValidator = AuthFormValidator();

  IconData eyeIcon() {
    if (isShowPassword) return LucideIcons.eyeOff;
    return LucideIcons.eye;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isShowPassword = !isShowPassword;
            });
          },
          child: Icon(eyeIcon()),
        ),
      ),
      controller: widget.controller,
      obscureText: !isShowPassword,
      validator: _formValidator.passwordInputValidator,
    );
  }
}
