import 'package:flutter/material.dart';
import 'package:mms/reusable/reusable_text_field.dart';
import 'package:mms/reusable/signin_signup_btn.dart';
import 'package:mms/screens/home.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextConroller = TextEditingController();
  final TextEditingController _emailTextConroller = TextEditingController();
  final TextEditingController _usernameTextConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 28, 147, 245),
              Color.fromARGB(255, 145, 32, 165)
            ])),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                reusableTextField(
                  'Please enter your full name',
                  Icons.person_outline,
                  false,
                  _usernameTextConroller,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  'Please enter your email address',
                  Icons.email_sharp,
                  false,
                  _emailTextConroller,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  'Please choose a password',
                  Icons.lock_outlined,
                  true,
                  _passwordTextConroller,
                ),
                const SizedBox(height: 20),
                signInSignUpButton(context, false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
