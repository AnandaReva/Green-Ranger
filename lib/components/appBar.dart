import 'package:provider/provider.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        // Menggunakan data dummy
        Map<dynamic, dynamic> userData = globalVar.userLoginData;

        return AppBar(
          backgroundColor: GlobalVar.mainColor,
          toolbarHeight: 80,
          leadingWidth: 75,
          leading: Padding(
            padding: EdgeInsets.only(left: 20),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(userData['profile_image'] ?? 'assets\images\logo.png'),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userData['username'] ?? '',
                  style: const TextStyle(
                      color: Color.fromRGBO(171, 147, 224, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                  size: 28,
                  color: GlobalVar.baseColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  String getUserRole(String user_type) {
    switch (user_type) {
      case "1":
        return "Pengguna";
      case "2":
        return "Petugas pengangkut";
      case "3":
        return "Pengepul";
      default:
        return "Role tidak diketahui";
    }
  }
}
