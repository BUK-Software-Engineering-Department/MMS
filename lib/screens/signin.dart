import 'package:flutter/material.dart';
import 'package:mms/reusable/reusablewidget.dart';
import 'package:mms/screens/Medscreens/home.dart';
import 'package:mms/screens/signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _passwordTextConroller = TextEditingController();
  final TextEditingController _emailTextConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                logoWidget('assets/images/logo.png'),
                const SizedBox(height: 30),
                reusableTextField('Enter UserName', Icons.person_outlined,
                    false, _emailTextConroller),
                const SizedBox(height: 20),
                reusableTextField('Enter Password', Icons.lock_outline, true,
                    _passwordTextConroller),
                const SizedBox(height: 20),
                signInSignUpButton(context, true, () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
