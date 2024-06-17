import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: GlobalVar.baseColor.withOpacity(0.1), // Transparan hitam
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.threeRotatingDots(
                color: GlobalVar.secondaryColorGreen,
                size: 75,
              ),
              SizedBox(height: 20), // Tambahkan jarak antara animasi dan teks
              const Text(
                "loading...",
                style: TextStyle(
                  color: GlobalVar.secondaryColorGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
