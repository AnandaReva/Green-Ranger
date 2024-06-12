import 'package:flutter/material.dart';
import 'package:green_ranger/components/appBar.dart';
import 'package:provider/provider.dart';

import 'package:green_ranger/globalVar.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic>? userData; // Define userData parameter
  const HomePage({Key? key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        return Scaffold(
          extendBody: true,
          appBar: MyAppBar(),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.180),
                            spreadRadius: 2,
                            blurRadius: 1,
                            offset: Offset(0, 0),
                          ), // BoxShadow
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Setor sampah bawa keuntungan",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: GlobalVar
                                        .baseColor, // Change text color
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Tukar sampah di rumahmu dengan reward menarik dari kami",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: GlobalVar
                                        .baseColor, // Change text color
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Poin dan Voucher
            ],
          ),
          backgroundColor: GlobalVar.mainColor, // Set background color
        );
      },
    );
  }
}
