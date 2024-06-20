import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';

class SettingPages extends StatelessWidget {
  const SettingPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVar.mainColor,
      appBar: AppBar(
        backgroundColor: GlobalVar.mainColor,
        toolbarHeight: 120,
        centerTitle: true,
        title: const Text(
          "Setting",
          style: TextStyle(color: GlobalVar.baseColor),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, 
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 20,
            bottom: 20,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                iconColor: Colors.red,
                textStyle: TextStyle(color: GlobalVar.baseColor),
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.logout),
              label:
                  Text('Logout', style: TextStyle(color: GlobalVar.baseColor)),
            ),
          )
        ],
      ),
    );
  }
}
