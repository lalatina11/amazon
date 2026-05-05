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
      await sharedPreferences.setString("token", res.data['token']);
      emit(AuthLoggedIn(user: UserModel.fromMap(res.data['user'])));
    } catch (e) {
      print(e);
      emit(AuthSubmitError(message: "Unexpexted Error"));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      final res = await authServ.login(email: email, password: password);
      if (!res.success) {
        return emit(AuthError(message: res.message));
      }
      await sharedPreferences.setString("token", res.data['token']);
      emit(AuthLoggedIn(user: UserModel.fromMap(res.data['user'])));
    } catch (e) {
      print(e);
      emit(AuthSubmitError(message: "Unexpexted Error"));
    }
  }

  Future<void> logout({required String email, required String password}) async {
    try {
      final res = await authServ.login(email: email, password: password);
      if (!res.success) {
        return emit(AuthError(message: res.message));
      }
      emit(AuthLoggedIn(user: UserModel.fromMap(res.data)));
    } catch (e) {
      print(e);
      emit(AuthSubmitError(message: "Unexpexted Error"));
    }
  }
}
