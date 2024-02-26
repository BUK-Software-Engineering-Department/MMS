import 'package:flutter/material.dart';
import 'package:mms/ui/pages/reusable/reusable_text_field.dart';
import 'package:mms/ui/pages/reusable/app_constants.dart';
import 'package:mms/ui/pages/reusable/signin_signup_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              ]),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  AppAssets.logo,
                  fit: BoxFit.fitWidth,
                  width: 200,
                  height: 200,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                reusableTextField(
                  'Please enter your email address',
                  Icons.person_outlined,
                  false,
                  _emailTextConroller,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  'Please enter your password',
                  Icons.lock_outline,
                  true,
                  _passwordTextConroller,
                ),
                const SizedBox(height: 20),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailTextConroller.text,
                    password: _passwordTextConroller.text,
                  ).then((value) {
                    print("Signed In");
                    // Check email verification status
                    checkEmailVerification();
                  });
                }),

                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }
    void checkEmailVerification() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        // Email is verified, proceed to the home screen
        Navigator.pushNamed(context, '/home');
      } else {
        // Email is not verified, prompt user to verify email
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please verify your email address.'),
            duration: Duration(seconds: 5),
            
          ),
        );
      }
    }
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
            Navigator.pushNamed(context, '/signup');
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