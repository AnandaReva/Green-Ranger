// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVar.mainColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Save Our",
                      textAlign: TextAlign.center, // Add textAlign here
                      style: TextStyle(
                        color: GlobalVar.baseColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 35,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      "Environment",
                      textAlign: TextAlign.center, // Add textAlign here
                      style: TextStyle(
                        color: GlobalVar.secondaryColor,
                        fontWeight: FontWeight.normal,
                        fontSize: 35,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      height: 55,
                    ),
                    Image.asset(
                      "assets/images/image.png",
                      width: 250, // adjust the width to your desired size
                      /* height:,  */ // adjust the height to your desired size
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Contribute for live on land",
                      textAlign: TextAlign.center, // Already centered
                      style: TextStyle(
                        color: GlobalVar.baseColor,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      "and below water",
                      textAlign: TextAlign.center, // Already centered
                      style: TextStyle(
                        color: GlobalVar.baseColor,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
