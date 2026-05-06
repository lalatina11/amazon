import 'package:amazon/src/feature/auth/services/auth_service.dart';
import 'package:amazon/src/feature/auth/services/auth_state.dart';
import 'package:amazon/src/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  SharedPreferences sharedPreferences;
  AuthCubit({required this.sharedPreferences}) : super(AuthInitial());

  final authServ = AuthService();

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await authServ.register(
        name: name,
        email: email,
        password: password,
      );
      if (!res.success) {
        return emit(AuthError(message: res.message));
      }
      final token = res.data['token'] as String;
      await sharedPreferences.setString("token", token);
      emit(
        AuthLoggedIn(token: token, user: UserModel.fromMap(res.data['user'])),
      );
    } catch (e) {
      print(e);
      emit(AuthSubmitError(message: "Unexpexted Error"));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final res = await authServ.login(email: email, password: password);
      if (!res.success && res.data != null) {
        return emit(AuthError(message: res.message));
      }
      final token = res.data['token'] as String;
      await sharedPreferences.setString("token", token);
      print(res.data['user']);
      emit(
        AuthLoggedIn(token: token, user: UserModel.fromMap(res.data['user'])),
      );
    } catch (e) {
      print(e);
      emit(AuthSubmitError(message: "Unexpexted Error"));
    }
  }

  Future<void> logout() async {
    try {
      final token = sharedPreferences.getString("token") ?? "";
      await authServ.logout(token: token);
      emit(AuthInitial());
    } catch (e) {
      print(e);
      emit(AuthSubmitError(message: "Unexpexted Error"));
    }
  }

  Future<void> loadUser() async {
    emit(AuthLoading());
    try {
      final token = sharedPreferences.getString("token") ?? "";
      if (token.isEmpty) {
        return emit(AuthInitial());
      }
      final res = await authServ.getCurrentUser(token: token);
      if (!res.success || res.data == null) {
        return emit(AuthInitial());
      }
      final user = UserModel.fromMap(res.data);
      emit(AuthLoggedIn(token: token, user: user));
    } catch (e) {
      emit(AuthInitial());
    }
  }
}
