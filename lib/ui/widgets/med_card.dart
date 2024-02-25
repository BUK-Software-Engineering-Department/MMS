import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mms/ui/size_config.dart';
import 'package:mms/ui/theme.dart';
import '../../models/medicine.dart';

class MedicineCard extends StatelessWidget {
  const MedicineCard(this.medicine, {Key? key}) : super(key: key);

  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(
              SizeConfig.orientation == Orientation.landscape ? 4 : 20)),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _getBGCLR(medicine.color)),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.title!,
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      medicine.dosage!,
                      style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey[200],
                          size: 18,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          '${medicine.startTime} - ${medicine.endTime}',
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 10,
                          )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      medicine.note!,
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 15,
                      )),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 0.5,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                medicine.isCompleted == 0 ? 'PENDING' : 'TAKEN',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getBGCLR(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }
}
