import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mms/ui/pages/add_medicine_page.dart';
import 'package:mms/ui/widgets/button.dart';
import 'package:mms/ui/widgets/med_card.dart';
import '../../controllers/medicine_controller.dart';
import '../../models/medicine.dart';
import '../../services/notification_services.dart';
import '../size_config.dart';
import '../theme.dart';
import 'package:mms/ui/widgets/menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _medicineController.getMedicines();
  }

  DateTime _selectedDate = DateTime.now();
  final MedicineController _medicineController = Get.put(MedicineController());

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      // ignore: deprecated_member_use
      backgroundColor: context.theme.backgroundColor,
      appBar: _customAppBar(),
      drawer: const MyMenu(),
      body: Column(
        children: [
          _addMedicineBar(),
          _addDateBar(),
          const SizedBox(
            height: 6,
          ),
          _showMedicines(),
        ],
      ),
    );
  }

  AppBar _customAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
    );
  }

  _addMedicineBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: subHeadingStyle,
              ),
            ],
          ),
          MyButton(
              label: '+ Add Medication',
              onTap: () async {
                await Get.to(() => const AddMedicinePage());
                _medicineController.getMedicines();
              }),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
      child: DatePicker(
        DateTime.now(),
        width: 80,
        height: 100,
        initialSelectedDate: _selectedDate,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        )),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        )),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        )),
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    _medicineController.getMedicines();
  }

  _showMedicines() {
    return Expanded(
      child: Obx(() {
        if (_medicineController.medicineList.isEmpty) {
          return _noTaskMsg();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              scrollDirection: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                var medicine = _medicineController.medicineList[index];

                if (medicine.repeat == 'Daily' ||
                    medicine.date == DateFormat.yMd().format(_selectedDate) ||
                    (medicine.repeat == 'Weekly' &&
                        _selectedDate
                                    .difference(
                                        DateFormat.yMd().parse(medicine.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (medicine.repeat == 'Monthly' &&
                        DateFormat.yMd().parse(medicine.date!).day ==
                            _selectedDate.day)) {
                 try {
                  if (medicine.startTime != null) {
                    var dateFormat = DateFormat('h:mm a'); // Specify the format of task.startTime
                    var date = dateFormat.parse(medicine.startTime!);
                    var myTime = DateFormat('HH:mm').format(date);

                    notifyHelper.scheduledNotification(
                      int.parse(myTime.split(':')[0]),
                      int.parse(myTime.split(':')[1]),
                      medicine,
                    );
                  } else {
                    // Handle case where startTime is null
                    debugPrint('Task startTime is null');
                  }
                } catch (e) {
                  debugPrint('Error parsing time: $e');
                }

 
                } else {
                  Container();
                }
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 1375),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => _showBottomSheet(context, medicine),
                        child: MedicineCard(medicine),
                      ),
                    ),
                  ),
                );
              },
              itemCount: _medicineController.medicineList.length,
            ),
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 2000),
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: SizeConfig.orientation == Orientation.landscape
                    ? Axis.horizontal
                    : Axis.vertical,
                children: [
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 6,
                        )
                      : const SizedBox(
                          height: 220,
                        ),
                  SvgPicture.asset(
                    'images/medicine.svg',
                    // ignore: deprecated_member_use
                    color: primaryClr.withOpacity(0.5),
                    height: 90,
                    semanticsLabel: 'Medicine',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Text(
                      'You do not have any medication yet!\nAdd new medication to improve your health.',
                      style: subTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizeConfig.orientation == Orientation.landscape
                      ? const SizedBox(
                          height: 120,
                        )
                      : const SizedBox(
                          height: 180,
                        ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  _showBottomSheet(BuildContext context, Medicine medicine) {
    Get.bottomSheet(SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 4),
        width: SizeConfig.screenWidth,
        height: (SizeConfig.orientation == Orientation.landscape)
            ? (medicine.isCompleted == 1
                ? SizeConfig.screenHeight * 0.6
                : SizeConfig.screenHeight * 0.8)
            : (medicine.isCompleted == 1
                ? SizeConfig.screenHeight * 0.24
                : SizeConfig.screenHeight * 0.30),
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            medicine.isCompleted == 1
                ? Container()
                : _buildBottomSheet(
                    label: 'Taken',
                    onTap: () {
                      NotifyHelper().cancelNotification(medicine);
                      _medicineController.markTaskAsCompleted(medicine.id!);
                      Get.back();
                    },
                    clr: primaryClr),
            _buildBottomSheet(
                label: 'Delete',
                onTap: () {
                  NotifyHelper().cancelNotification(medicine);
                  _medicineController.deleteMedicines(medicine);
                  Get.back();
                },
                clr: Colors.red[300]!),
                const Spacer(),
            _buildBottomSheet(
                label: 'Close',
                onTap: () {
                  Get.back();
                },
                clr: primaryClr),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    ));
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : clr,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : clr),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
