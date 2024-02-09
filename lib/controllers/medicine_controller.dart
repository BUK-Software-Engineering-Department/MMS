import 'package:get/get.dart';
import 'package:mms/db/db_helper.dart';
import 'package:mms/models/medicine.dart';

class MedicineController extends GetxController {
  //this will hold the data and update the ui

  @override
  void onReady() {
    getMedicines();
    super.onReady();
  }

  final RxList<Medicine> medicineList = List<Medicine>.empty().obs;

  // add data to table
  //second brackets means they are named optional parameters
  Future<void> addMedicine({required Medicine medicine}) async {
    await DBHelper.insert(medicine);
  }

  // get all the data from table
  void getMedicines() async {
    List<Map<String, dynamic>> medicines = await DBHelper.query();
    medicineList.assignAll(
        medicines.map((data) => new Medicine.fromJson(data)).toList());
  }

  // delete data from table
  void deleteMedicine(Medicine medicine) async {
    await DBHelper.delete(medicine);
    getMedicines();
  }

  // update data int table
  void markMedicineCompleted(int? id) async {
    await DBHelper.update(id);
    getMedicines();
  }
}
