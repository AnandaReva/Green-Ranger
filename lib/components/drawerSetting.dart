import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart'; // Pastikan path ini sesuai dengan struktur proyek Anda

class DrawerSetting extends StatelessWidget {
  const DrawerSetting({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: GlobalVar.mainColor,
            ),
            child: Text(
              'DrawerSetting Header',
              style: TextStyle(color: GlobalVar.baseColor),
            ),
          ),
          ListTile(
            title: const Text(
              'Item 1',
              style: TextStyle(color: GlobalVar.baseColor),
            ),
            onTap: () {
              // Handle your DrawerSetting item tap actions here
              Navigator.pop(context); // Close the DrawerSetting
            },
          ),
          ListTile(
            title: const Text(
              'Item 2',
              style: TextStyle(color: GlobalVar.baseColor),
            ),
            onTap: () {
              // Handle your DrawerSetting item tap actions here
              Navigator.pop(context); // Close the DrawerSetting
            },
          ),
          if (child != null) ...[
            // Add the provided child widget if available
            child!,
          ],
        ],
      ),
    );
  }
}
