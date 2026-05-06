import 'package:amazon/src/constants/global_variables.dart';
import 'package:amazon/src/feature/auth/screen/auth_screen.dart';
import 'package:amazon/src/feature/auth/services/auth_cubit.dart';
import 'package:amazon/src/feature/auth/services/auth_state.dart';
import 'package:amazon/src/feature/cart/widget/cart_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => CartScreen());

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keranjang"),
        backgroundColor: GlobalVariables.secondaryColor,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            return CartList(token: state.token);
          }
          return Center(
            child: Column(
              children: [
                Text("Anda harus login untuk melihat keranjang"),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(AuthScreen.route());
                  },
                  child: Text("Login"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
