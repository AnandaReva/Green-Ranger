// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:green_ranger/components/appBar.dart';
import 'package:green_ranger/components/infiniteScorllPagination.dart';
import 'package:provider/provider.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final TextEditingController _controllerSearcQuest = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        Map<String, dynamic> userData = globalVar.userLoginData;

        return Scaffold(
          extendBody: true,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: GlobalVar.mainColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [],
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: GlobalVar.baseColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: GlobalVar.baseColor),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: _controllerSearcQuest,
                                style: TextStyle(
                                  color: GlobalVar
                                      .baseColor, // Warna teks input disesuaikan dengan baseColor
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Search Any',
                                  fillColor: GlobalVar.mainColor,
                                  filled: true,
                                  labelStyle: TextStyle(
                                    color: GlobalVar.baseColor,
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Popular Search',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: GlobalVar.secondaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                'Categories',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: GlobalVar.secondaryColor,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: GlobalVar.mainColor,
        );
      },
    );
  }
}
