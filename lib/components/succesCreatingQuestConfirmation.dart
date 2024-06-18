import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';

class SuccessCreatingQuestConfirmation extends StatelessWidget {
  const SuccessCreatingQuestConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVar.mainColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 500.0, // Set the desired width
                padding: const EdgeInsets.all(20.0), // Add padding
                child: Center(
                  child: Image.asset(
                    'assets/images/successIcon.png',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Quest has been created successfully",
                      style: TextStyle(
                        color: GlobalVar.baseColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        // Tombol untuk men-dispose halaman dan kembali ke halaman sebelumnya
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: GlobalVar.secondaryColorGreen, // Warna teks putih
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
