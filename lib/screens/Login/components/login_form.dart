// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/screens/Home/home.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants/colours.dart';
import '../../../constants/paddings.dart';
import '../../Signup/signup_screen.dart';
import '../../../main.dart';
import '../../../constants/destinations.dart';
import '../../../screens/Expenditure/expenditure.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Perform a query to check if the provided email and password match a user in Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    // Check if any matching user documents are found
    if (snapshot.docs.isNotEmpty) {
      // Authentication successful, navigate to the home screen
      //return const MainPage(title: 'Flutter Demo Home Page');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainPage(title: 'Flutter Demo Home Page'),
        ),
      );
    } else {
      // Authentication failed, display an error message
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Email or password is not right!"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: const Color(Colours.PRIMARY),
            //onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: const Color(Colours.PRIMARY),
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: () => _login(context),
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
