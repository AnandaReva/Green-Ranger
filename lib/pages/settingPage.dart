import 'package:flutter/material.dart';
import 'package:green_ranger/components/loadingUI.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/pages/authPage.dart';

class SettingPage extends StatelessWidget {
  final GlobalVar globalVar = GlobalVar.instance;

  SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVar.mainColor,
      body: globalVar.isLoading
          ? LoadingUi()
          : SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        showLogoutConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: GlobalVar.baseColor),
                        ),
                        backgroundColor:
                            Colors.transparent, // Latar belakang transparan
                        textStyle:
                            TextStyle(color: GlobalVar.baseColor), // Warna teks
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout,
                              color:
                                  Colors.red), // Ikon logout dengan warna merah
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(color: GlobalVar.baseColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      appBar: AppBar(
        backgroundColor: GlobalVar.mainColor,
        toolbarHeight: 120,
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(color: GlobalVar.baseColor),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
    );
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: GlobalVar.secondaryColorPink.withOpacity(0.1),
      builder: (context) => AlertDialog(
        content: Text(
          'Log Out from this account?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: GlobalVar.baseColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: GlobalVar.mainColor,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: GlobalVar.baseColor),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    globalVar.isLoading = true;
                    AuthPageState auth = AuthPageState();
                    await auth.signOutUser();

                    // Reset data pada globalVar
                    globalVar.userLoginData =
                        {}; // Menggunakan userData setelah logout
                    globalVar.questDataSelected = {};
                    globalVar.userMarkedQuest = [];
                    globalVar.userOnProgressQuest = [];
                    globalVar.userCompletedQuest = [];
                    globalVar.isLoading = false;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthPage(globalVar: globalVar),
                      ),
                    );
                  } catch (e) {
                    globalVar.isLoading = false;
                    print('Error during logout: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Fail during sign out. please try again.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: GlobalVar.baseColor),
                  ),
                  backgroundColor: Colors.transparent,
                  textStyle: TextStyle(color: GlobalVar.baseColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(color: GlobalVar.baseColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
