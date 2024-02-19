
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:mms/controllers/medicine_controller.dart';
import 'package:mms/models/medicine.dart';
import 'package:mms/ui/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../size_config.dart';
import '../widgets/med_card.dart';

class MedicationHistory extends StatelessWidget {
  const MedicationHistory({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final medicineController = Get.find<MedicineController>();
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: context.theme.colorScheme.background,
      drawer: Drawer(
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
                        /*onTap: () {
                          ThemeService().switchTheme();
                          notifyHelper.displayNotification(
                            title: "Theme Changed",
                            body: Get.isDarkMode
                                ? "Light theme activated."
                                : "Dark theme activated",
                          );
                        },*/
                        child: Icon(
                            Get.isDarkMode
                                ? Icons.wb_sunny
                                : Icons.shield_moon,
                            color: Get.isDarkMode
                                ? Colors.white
                                : darkGreyClr),
                      ),
                      const CircleAvatar(
                        radius: 16,
                        backgroundImage: AssetImage("images/logo.png"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'MediGuardian',
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
      ),
      body: _buildMedicineList(medicineController),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text("History"),
    );
  }

  Widget _buildMedicineList(MedicineController medicineController) {
    return Expanded(
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: medicineController.medicineList.length,
          itemBuilder: (context, index) {
            Medicine medicine = medicineController.medicineList[index];
            return medicine.isCompleted == 1
                ? _buildMedicineRow(context, medicine, index)
                : const SizedBox.shrink(); // Use SizedBox.shrink() for better performance
          },
        ),
      ),
    );
  }

  Widget _buildMedicineRow(BuildContext context, Medicine medicine, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 1375),
      child: SlideAnimation(
        horizontalOffset: 300.0,
        child: FadeInAnimation(
          child: GestureDetector(
            child: MedicineCard(medicine),
          ),
        ),
      ),
    );
  }
}



  