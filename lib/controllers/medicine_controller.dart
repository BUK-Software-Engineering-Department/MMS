import 'package:get/get.dart';
import 'package:mms/db/db_helper.dart';
import 'package:mms/models/medicine.dart';

class MedicineController extends GetxController {
  final RxList<Medicine> medicineList = <Medicine>[].obs;

  Future<int> addMedicine({Medicine? medicine}) {
    return DBHelper.insert(medicine);
  }

  void getMedicines() async {
    List<Map<String, dynamic>> medicines = await DBHelper.query();
    medicineList.assignAll(
        medicines.map((data) => Medicine.fromJson(data)).toList());
  }

  void deleteMedicines(Medicine medicine) async {
    await DBHelper.delete(medicine);
    getMedicines();
  }

  void deleteAllMedicines() async {
    await DBHelper.deleteAll();
    getMedicines();
  }

  void markTaskAsCompleted(int id) async {
    await DBHelper.update(id);
    getMedicines();
  }
}
