// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';

class IntroPage1 extends StatelessWidget {

  
  const IntroPage1({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVar.mainColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                  child: Image.asset(
                "assets/images/logo.png",
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "This App Contribute with SDGs 15",
                    style: TextStyle(
                      color: GlobalVar.baseColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
