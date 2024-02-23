import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mms/controllers/medicine_controller.dart';
import 'package:mms/models/medicine.dart';
import 'package:mms/ui/theme.dart';
import 'package:mms/ui/widgets/button.dart';
import 'package:mms/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final MedicineController _medicineController = Get.find<MedicineController>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime? _selectedDate;
  String? _startTime;
  //String? _endTime;
  int _selectedColor = 0;

  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];

  String? _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context) {
    print("starttime ${_startTime ?? 'null'}");
    //print("endtime ${_endTime ?? 'null'}");
    print("selectedDate ${_selectedDate ?? 'null'}");
    print("selectedRemind ${_selectedRemind ?? 'null'}");
    print("selectedRepeat ${_selectedRepeat ?? 'null'}");

    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, now.minute, now.second);
    final format = DateFormat.jm();
    print(format.format(dt));

    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Medication",
                style: headingTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              InputField(
                title: "Medication Name",
                hint: "Enter medication name here.",
                controller: _titleController,
              ),
              InputField(
                title: "Dosage",
                hint: "Enter dosage here.",
                controller: _dosageController,
              ),
              InputField(
                  title: "Instructions for Medication",
                  hint: "Enter instructions here.",
                  controller: _noteController),
              InputField(
                title: "Date",
                hint: _selectedDate != null ? DateFormat.yMd().format(_selectedDate!) : 'Select date',
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_month_sharp,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime ?? 'Select time',
                      widget: IconButton(
                        icon: const Icon(
                          Icons.alarm,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  /*Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime ?? 'Select time',
                      widget: IconButton(
                        icon: const Icon(
                          Icons.alarm,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  ),*/
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: Row(
                  children: [
                    DropdownButton<String>(
                        value: _selectedRemind.toString(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        style: subTitleTextStle,
                        underline: Container(height: 0),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRemind = int.parse(newValue!);
                          });
                        },
                        items: remindList
                            .map<DropdownMenuItem<String>>((int value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value.toString()),
                          );
                        }).toList()),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
              InputField(
                title: "Repeat",
                hint: _selectedRepeat ?? 'None',
                widget: Row(
                  children: [
                    DropdownButton<String>(
                      dropdownColor: Colors.blueGrey,
                      value: _selectedRepeat,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTitleTextStle,
                      underline: Container(
                        height: 6,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRepeat = newValue;
                        });
                      },
                      items: repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),

              const SizedBox(
                height: 18.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorChips(),
                  MyButton(
                    label: "Add Medication",
                    onTap: () {
                      _validateInputs();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateInputs() {
    if (_titleController.text.isNotEmpty &&
        _noteController.text.isNotEmpty &&
        _dosageController.text.isNotEmpty &&
        _selectedDate != null &&
        _startTime != null &&
        //_endTime != null &&
        _selectedRemind != null &&
        _selectedRepeat != null) {
      _addMedicineToDB();
      Get.back();
    } else if (_titleController.text.isEmpty ||
        _noteController.text.isEmpty ||
        _dosageController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      print("############ SOMETHING BAD HAPPENED #################");
    }
  }

  _addMedicineToDB() async {
    await _medicineController.addMedicine(
      medicine: Medicine(
        note: _noteController.text,
        title: _titleController.text,
        dosage: _dosageController.text,
        date: DateFormat.yMd().format(_selectedDate!),
        startTime: _startTime,
        //endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
  }

  _colorChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleTextStle,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(
            3,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0 ? primaryClr : index == 1 ? pinkClr : yellowClr,
                    child: index == _selectedColor
                        ? const Center(
                            child: Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 18,
                            ),
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: primaryClr,
        ),
      ),
      actions: const [
        CircleAvatar(
          radius: 16,
          backgroundImage: AssetImage("images/logo.png"),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

      _getTimeFromUser({required bool isStartTime}) async {
        var pickedTime = await _showTimePicker();
        if (pickedTime != null) {
          print(pickedTime.format(context));
          String formatedTime = pickedTime.format(context)!;
          print(formatedTime);
          if (isStartTime) {
            setState(() {
              _startTime = formatedTime;
            });
          } else {
            setState(() {
              //_endTime = formatedTime;
            });
          }
        } else {
          print("Time canceled");
        }
      }


      _showTimePicker() async {
      if (_startTime != null) {
        return showTimePicker(
          initialTime: TimeOfDay(
            hour: int.parse(_startTime!.split(":")[0]),
            minute: int.parse(_startTime!.split(":")[1].split(" ")[0]),
          ),
          initialEntryMode: TimePickerEntryMode.input,
          context: context,
        );
      } else {
        // Handle the case when _startTime is null
        // For example, you can return a default time
        return showTimePicker(
          initialTime: TimeOfDay.now(), // You can set any default time here
          initialEntryMode: TimePickerEntryMode.input,
          context: context,
        );
      }
    }


  _getDateFromUser() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
