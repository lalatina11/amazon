import "package:email_validator/email_validator.dart";

class AuthFormValidator {
  String? emailInputValidator(String? email) {
    if (email == null || email.isEmpty) {
      return "Email harus diisi";
    }
    final isValidEmail = EmailValidator.validate(email);
    if (!isValidEmail) {
      return "Mohon Masukkan email yang valid";
    }
    return null;
  }

  String? passwordInputValidator(String? password) {
    if (password == null || password.isEmpty) {
      return "Password harus diisi";
    }
    if (password.length < 8) {
      return "Password min 8 karakter";
    }
    if (password.length > 32) {
      return "Password max 32 karakter";
    }
    return null;
  }

  String? nameInputValidator(String? name) {
    if (name == null || name.isEmpty) {
      return "Nama harus diisi";
    }
    if (name.length < 3) {
      return "Nama min 3 karakter";
    }
    if (name.length > 128) {
      return "Nama max 128 karakter";
    }
    return null;
  }
}
