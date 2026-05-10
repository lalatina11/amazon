import 'package:amazon/src/constants/global_variables.dart';
import 'package:amazon/src/feature/auth/services/auth_cubit.dart';
import 'package:amazon/src/feature/home/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await dotenv.load();
  await initializeDateFormatting('id_ID', null); // ← add this
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final authCubit = AuthCubit(sharedPreferences: sharedPreferences);
  await authCubit.loadUser();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider.value(value: authCubit)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalVariables.secondaryColor,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
          errorStyle: TextStyle(fontSize: 14),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: GlobalVariables.secondaryColor,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
