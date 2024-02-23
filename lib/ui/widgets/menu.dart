import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mms/services/notification_services.dart';
import 'package:mms/services/theme_services.dart';
import 'package:mms/ui/theme.dart';


class MyMenu extends StatefulWidget {

  MyMenu({super.key});

  @override
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  late var notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions(); 
    }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
    
          DrawerHeader(
    decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
          Color.fromARGB(255, 28, 147, 245),
          Color.fromARGB(255, 145, 32, 165)
        ])),
    child: Column( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                ThemeService().switchTheme();
                notifyHelper.displayNotification(
                  title: "Theme Changed",
                  body: Get.isDarkMode
                      ? "Light theme activated."
                      : "Dark theme activated",
                );
              },
              child: Icon(
                  Get.isDarkMode
                      ? Icons.wb_sunny
                      : Icons.shield_moon,
                  color: Get.isDarkMode
                      ? Colors.white
                      : darkGreyClr),
            ),
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage("images/logo.png"),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Welcome!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
        ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            title: const Text('Medication History'),
            onTap: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value){
                print("Signed Out");
                Navigator.pushNamed(context, '/');
              });
            },
          ),
        ],
      ),
    );
  }
}
  

