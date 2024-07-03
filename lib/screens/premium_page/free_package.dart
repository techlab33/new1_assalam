import 'package:assalam/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class FreePackage extends StatefulWidget {
  const FreePackage({super.key});

  @override
  State<FreePackage> createState() => _FreePackageState();
}

class _FreePackageState extends State<FreePackage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Premium Package"),backgroundColor: TColors.primaryColor,),
      body: Center(
        child: Column(
          children: [
            Text('Developing Mood..... ', style: TextStyle(fontSize: 20),),
            Container(height: 100,width: 100,child: Text("Live Stream"),color: Colors.red),
            Container(height: 100,width: 100,child: Text("Educational Part"),color: Colors.deepPurple),
          ],
        ),
      ),
    );
  }
}
