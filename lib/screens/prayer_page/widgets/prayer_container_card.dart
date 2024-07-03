import 'package:flutter/material.dart';


class PrayerContainerCard extends StatelessWidget {
  PrayerContainerCard({
    super.key,
    required this.prayerTimeText,
    this.prayerStartTime,
    this.prayerEndTime,
  });


  String prayerTimeText;
  String ? prayerStartTime;
  String ? prayerEndTime;

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      width: screenSize.width,
      decoration: BoxDecoration(
        // color: Colors.green,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(flex : 6,child: Text(prayerTimeText, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
          // SizedBox(width: 10),
          Expanded(flex: 2,child: Text(prayerStartTime ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
          // SizedBox(width: 10),
          //Expanded(flex: 2,child: Text(prayerEndTime ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
          // Expanded(flex: 1,child: Icon(Icons.notifications_none, color: Colors.white,)),
        ],
      ),
    );
  }
}