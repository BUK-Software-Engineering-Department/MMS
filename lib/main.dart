import 'package:flutter/material.dart';
import 'package:mms/api/firebase_api.dart';
import 'package:mms/screens/home.dart';
import 'package:mms/screens/notification_page.dart';
import 'package:mms/screens/signin.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mms/screens/signup.dart';
import 'firebase_options.dart';

final navigationKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAPI().initNotifications();
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
      navigatorKey: navigationKey,
      routes: Map<String, WidgetBuilder>.from({
        '/': (context) => const SignIn(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/notification': (context) => const NotificationPage(),
      }),
    );
  }
}
