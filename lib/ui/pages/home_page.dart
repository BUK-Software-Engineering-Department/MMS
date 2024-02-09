import 'dart:async';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms/controllers/medicine_controller.dart';
import 'package:mms/models/medicine.dart';
import 'package:mms/services/notification_services.dart';
import 'package:mms/ui/pages/add_medicine_page.dart';
import 'package:mms/ui/size_config.dart';
import 'package:mms/ui/theme.dart';
import 'package:mms/ui/widgets/button.dart';
import 'package:intl/intl.dart';
import 'package:mms/ui/widgets/task_tile.dart';

import '../../services/theme_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());
  final _medicineController = Get.put(MedicineController());
  late var notifyHelper;
  bool animate = false;
  double left = 630;
  double top = 900;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _timer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        animate = true;
        left = 30;
        top = top / 3;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addMedicineBar(),
          _dateBar(),
          SizedBox(
            height: 12,
          ),
          _showMedicines(),
        ],
      ),
    );
  }

  _dateBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 20),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: DatePicker(
          DateTime.now(),
          height: 100.0,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryClr,
          //selectedTextColor: primaryClr,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 10.0,
              color: Colors.grey,
            ),
          ),

          onDateChange: (date) {
            // New date selected

            setState(
              () {
                _selectedDate = date;
              },
            );
          },
        ),
      ),
    );
  }

  _addMedicineBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Today",
                style: headingTextStyle,
              ),
            ],
          ),
          MyButton(
            label: "+ Add Medication",
            onTap: () async {
              await Get.to(AddMedicinePage());
              _medicineController.getMedicines();
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            ThemeService().switchTheme();
            notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Light theme activated."
                  : "Dark theme activated",
            );

            //notifyHelper.scheduledNotification();
            //notifyHelper.periodicalyNotification();
          },
          child: Icon(Get.isDarkMode ? Icons.wb_sunny : Icons.shield_moon,
              color: Get.isDarkMode ? Colors.white : darkGreyClr),
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

  _showMedicines() {
    return Expanded(
      child: Obx(() {
        if (_medicineController.medicineList.isEmpty) {
          return _noMedicineMsg();
        } else
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _medicineController.medicineList.length,
              itemBuilder: (context, index) {
                Medicine medicine = _medicineController.medicineList[index];
                if (medicine.repeat == 'Daily') {
                  // medicine.startTime = '2022-01-01 ' + medicine.startTime!;
                  var hour = medicine.startTime.toString().split(":")[0];
                  var minutes = medicine.startTime.toString().split(":")[1];
                  debugPrint("My time is " + hour);
                  debugPrint("My minute is " + minutes);
                  print('Starttime is ${medicine.startTime.toString()}');

                  DateTime date = DateFormat.jm().parse(medicine.startTime!);
                  var myTime = DateFormat("HH:mm").format(date);
                  /*
                  print("my date "+date.toString());
                  print("my time " +myTime);
                  var t=DateFormat("M/d/yyyy hh:mm a").parse(medicine.date+" "+medicine.startTime);
                  print(t);
                  print(int.parse(myTime.toString().split(":")[0]));*/
                  notifyHelper.scheduledNotification(
                      int.parse(myTime.toString().split(":")[0]),
                      int.parse(myTime.toString().split(":")[1]),
                      medicine);

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1375),
                    child: SlideAnimation(
                      horizontalOffset: 300.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showBottomSheet(context, medicine);
                                },
                                child: MedicineTile(medicine)),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (medicine.date == DateFormat.yMd().format(_selectedDate)) {
                  //notifyHelper.scheduledNotification();
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1375),
                    child: SlideAnimation(
                      horizontalOffset: 300.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showBottomSheet(context, medicine);
                                },
                                child: MedicineTile(medicine)),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
      }),
    );
  }

  showBottomSheet(BuildContext context, Medicine medicine) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: medicine.isCompleted == 1
            ? SizeConfig.screenHeight * 0.20
            : SizeConfig.screenHeight * 0.35,
        width: SizeConfig.screenWidth,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          Spacer(),
          medicine.isCompleted == 1
              ? Container()
              : _buildBottomSheetButton(
                  label: "Taken",
                  onTap: () {
                    _medicineController.markMedicineCompleted(medicine.id);
                    Get.back();
                  },
                  clr: primaryClr),
          _buildBottomSheetButton(
              label: "Dismiss",
              onTap: () {
                _medicineController.deleteMedicine(medicine);
                Get.back();
              },
              clr: Colors.red[300]),
          // SizedBox(
          //   height: 10,
          // ),
          _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true),
          SizedBox(
            height: 30,
          ),
        ]),
      ),
    );
  }

  _buildBottomSheetButton(
      {required String label,
      Function? onTap,
      Color? clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: SizeConfig.screenWidth! * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
          label,
          style: isClose
              ? titleTextStle
              : titleTextStle.copyWith(color: Colors.white),
        )),
      ),
    );
  }

  _noMedicineMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: 2000),
          left: left,
          top: top,
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "images/medicine.svg",
                color: primaryClr.withOpacity(0.5),
                height: 90,
                semanticsLabel: 'Medicine',
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "You do not have any medication yet!\nAdd new medicine to manage your health.",
                  textAlign: TextAlign.center,
                  style: subTitleTextStle,
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          )),
        )
      ],
    );
  }
}
