//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mms/reusable/reusablewidget.dart';
import 'package:mms/screens/Medscreens/home.dart';

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
    // Set the status bar and navigation bar color to transparent
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //statusBarColor: Colors.transparent,
    //systemNavigationBarColor: Colors.transparent,
    //systemNavigationBarIconBrightness: Brightness.dark,
    //));
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Sign Up',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                reusableTextField('Enter UserName', Icons.person_outline, false,
                    _usernameTextConroller),
                const SizedBox(height: 20),
                reusableTextField('Enter Email Id', Icons.person_outline, false,
                    _emailTextConroller),
                const SizedBox(height: 20),
                reusableTextField('Enter Password', Icons.lock_outlined, true,
                    _passwordTextConroller),
                const SizedBox(height: 20),
                signInSignUpButton(context, true, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
