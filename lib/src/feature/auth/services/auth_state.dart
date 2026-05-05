import 'package:amazon/src/model/user_model.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSubmitting extends AuthState {}

final class AuthSubmitError extends AuthState {
  String message;
  AuthSubmitError({required this.message});
}

final class AuthError extends AuthState {
  String message;
  AuthError({required this.message});
}

final class AuthLoggedIn extends AuthState {
  UserModel user;
  AuthLoggedIn({required this.user});
}
