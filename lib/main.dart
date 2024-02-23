import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mms/db/db_helper.dart';
import 'package:mms/services/theme_services.dart';
import 'package:mms/ui/pages/home_page.dart';
import 'package:mms/ui/pages/medication_history.dart';
import 'package:mms/ui/pages/signup.dart';
import 'package:mms/ui/pages/signin.dart';
import 'package:mms/ui/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      //home: const HomePage(),
      //navigatorKey: navigationKey,
      routes: Map<String, WidgetBuilder>.from({
        '/': (context) => const SignIn(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomePage(),
        '/history': (context) => const MedicationHistory(),
      })
    );
  }
}
