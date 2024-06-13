// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:green_ranger/components/appBar.dart';
import 'package:green_ranger/components/infiniteScorllPagination.dart';
import 'package:provider/provider.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final TextEditingController _controllerSearcQuest = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        Map<String, dynamic> userData = globalVar.userLoginData;

        return Scaffold(
          extendBody: true,
          appBar: MyAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      Text(
                        'Level',
                        style: TextStyle(
                          fontSize: 15,
                          color: GlobalVar.baseColor,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 2,
                        endIndent: 60,
                      ),
                      Text(
                        userData['level'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(255, 175, 64, 1),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${userData['exp'] ?? ''} / 2500',
                            style: TextStyle(
                              fontSize: 14,
                              color: GlobalVar.baseColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '  EXP',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(144, 110, 218, 1),
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'GreenRangerWalletValue',
                        style: TextStyle(
                          fontSize: 15,
                          color: GlobalVar.baseColor,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 2,
                        endIndent: 60,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/coinIcon.png",
                            width: 30,
                          ),
                          Text(
                            'Rp. ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: '').format(int.parse(userData['wallet_value'] ?? '0'))}',
                            style: TextStyle(
                              fontSize: 14,
                              color: GlobalVar.baseColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: GlobalVar.baseColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        height: 50,
                        child: Row(
                          children: [
                            Icon(Icons.search),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: _controllerSearcQuest,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Search Quest',
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Quest',
                        style: TextStyle(
                          fontSize: 30,
                          color: GlobalVar.baseColor,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: QuestListPage(),
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
