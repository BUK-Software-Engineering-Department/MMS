import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mms/controllers/medicine_controller.dart';
import 'package:mms/models/medicine.dart';
import 'package:mms/ui/theme.dart';
import 'package:mms/ui/widgets/button.dart';
import 'package:mms/ui/widgets/input_field.dart';
import 'package:intl/intl.dart';

class AddMedicinePage extends StatefulWidget {
  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final MedicineController _medicineController = Get.find<MedicineController>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  //String _startTime = DateFormat("hh:mm").format(DateTime.now());
  //_startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String? _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

  String? _endTime = "11:59 PM";
  int _selectedColor = 0;

  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];

  String? _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
  ];

  @override
  Widget build(BuildContext context) {
    //Below shows the time like Sep 15, 2021
    //print(new DateFormat.yMMMd().format(new DateTime.now()));
    print(" starttime " + _startTime!);
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, now.minute, now.second);
    final format = DateFormat.jm();
    print(format.format(dt));
    print("add Medicine date: " + DateFormat.yMd().format(_selectedDate));
    //_startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Medication",
                style: headingTextStyle,
              ),
              SizedBox(
                height: 8,
              ),
              InputField(
                title: "Medication Name",
                hint: "Enter medication name here.",
                controller: _titleController,
              ),
              InputField(
                  title: "Instructions for Medication",
                  hint: "Enter instructions here.",
                  controller: _noteController),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: (Icon(
                    Icons.calendar_month_sharp,
                    color: Colors.grey,
                  )),
                  onPressed: () {
                    //_showDatePicker(context);
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        icon: (Icon(
                          Icons.alarm,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        icon: (Icon(
                          Icons.alarm,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  )
                ],
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: Row(
                  children: [
                    DropdownButton<String>(
                        //value: _selectedRemind.toString(),
                        icon: Icon(
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
                    SizedBox(width: 6),
                  ],
                ),
              ),
              InputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: Row(
                  children: [
                    Container(
                      child: DropdownButton<String>(
                          dropdownColor: Colors.blueGrey,
                          //value: _selectedRemind.toString(),
                          icon: Icon(
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
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList()),
                    ),
                    SizedBox(width: 6),
                  ],
                ),
              ),
              SizedBox(
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
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateInputs() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addMedicineToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
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
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
  }

  _colorChips() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Color",
        style: titleTextStle,
      ),
      SizedBox(
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
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: index == _selectedColor
                      ? Center(
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
    ]);
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
        ),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage("images/girl.jpg"),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }

  // _compareTime() {
  //   print("compare time");
  //   print(_startTime);
  //   print(_endTime);

  //   var _start = double.parsestartTime);
  //   var _end = toDouble(_endTime);

  //   print(_start);
  //   print(_end);

  //   if (_start > _end) {
  //     Get.snackbar(
  //       "Invalid!",
  //       "Time duration must be positive.",
  //       snackPosition: SnackPosition.BOTTOM,
  //       overlayColor: context.theme.backgroundColor,
  //     );
  //   }
  // }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    print(_pickedTime.format(context));
    String? _formatedTime = _pickedTime.format(context);
    print(_formatedTime);
    if (_pickedTime == null)
      print("time canceld");
    else if (isStartTime)
      setState(() {
        _startTime = _formatedTime;
      });
    else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
      //_compareTime();
    }
  }

  _showTimePicker() async {
    return showTimePicker(
      initialTime: TimeOfDay(
          hour: int.parse(_startTime!.split(":")[0]),
          minute: int.parse(_startTime!.split(":")[1].split(" ")[0])),
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
    );
  }

  _getDateFromUser() async {
    final DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    }
  }
}
