import 'package:flutter/material.dart';
import 'package:mms/screens/signin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:firebase_core/firebase_core.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SignIn(),
    );
  }
}
