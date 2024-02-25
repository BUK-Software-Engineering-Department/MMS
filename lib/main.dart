import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mms/services/theme_services.dart';
import 'package:mms/ui/pages/home_page.dart';
import 'package:mms/ui/theme.dart';
import 'package:mms/ui/pages/medication_history.dart';
import 'package:mms/ui/pages/signup.dart';
import 'package:mms/ui/pages/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'db/db_helper.dart';

//future
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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      //home: const HomePage(),
      routes: Map<String, WidgetBuilder>.from({
        '/': (context) => const SignIn(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomePage(),
        '/history': (context) => const MedicationHistory(),
      })
    );
  }
}
