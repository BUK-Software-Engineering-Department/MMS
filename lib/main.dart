import 'package:flutter/material.dart';
import 'package:mms/screens/home.dart';
import 'package:mms/screens/signin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediGuardian',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const SignIn(),
        '/home': (context) => const HomeScreen(),
        // '/medicine_list': (context) => MedicineListScreen(),
        // '/reminders': (context) => RemindersScreen(),
        // '/history': (context) => HistoryScreen(),
        // '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
