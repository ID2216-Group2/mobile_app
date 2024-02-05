import 'package:flutter/material.dart';
import 'Welcome/welcome_screen.dart';
import '../constants/colours.dart';
import '../constants/paddings.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HANGOUT',
      theme: ThemeData(
          primaryColor: const Color(Colours.PRIMARY),
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: const Color(Colours.PRIMARY),
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(Colours.SECONDARY),
            iconColor: Color(Colours.PRIMARY),
            prefixIconColor: Color(Colours.PRIMARY),
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: const WelcomeScreen(),
    );
  }
}
