import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:mms/controllers/medicine_controller.dart';
import 'package:mms/models/medicine.dart';
import 'package:mms/ui/widgets/menu.dart';
import '../size_config.dart';
import '../widgets/medcard.dart';

class MedicationHistory extends StatelessWidget {
  const MedicationHistory({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final medicineController = Get.find<MedicineController>();
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: context.theme.colorScheme.background,
      drawer:  MyMenu(),
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
      flex: 1,
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
            child: MedicineCards(medicine),
          ),
        ),
      ),
    );
  }
}


  