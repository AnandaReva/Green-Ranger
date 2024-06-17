// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:green_ranger/components/infiniteScrollPagination/UserMarkedQuestList%20.dart';

import 'package:green_ranger/components/appBar.dart';
import 'package:provider/provider.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

class UserQuestPage extends StatefulWidget {
  UserQuestPage({Key? key}) : super(key: key);

  @override
  _UserQuestPageState createState() => _UserQuestPageState();
}

class _UserQuestPageState extends State<UserQuestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _controllerSearcQuest = TextEditingController();
  final SlidingUpPanelController panelController = SlidingUpPanelController();
  final double minBound = 0;
  final double upperBound = 1.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        Map<String, dynamic> userData = globalVar.userLoginData;

        return DefaultTabController(
          length: 3,
          child: Stack(
            children: <Widget>[
              Scaffold(
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
                          boxShadow: const [
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
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: GlobalVar.baseColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              height: 40,
                              child: Row(
                                children: [
                                  Icon(Icons.search),
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      controller: _controllerSearcQuest,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search Quest',
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
                              'Your Quest',
                              style: TextStyle(
                                fontSize: 30,
                                color: GlobalVar.baseColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 25,
                              color: GlobalVar.mainColor,
                              child: TabBar(
                                controller: _tabController,
                                labelColor: Colors.black,
                                unselectedLabelColor: GlobalVar.baseColor,
                                indicator: BoxDecoration(
                                  color: GlobalVar.secondaryColorGreen,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                tabs: [
                                  Tab(
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Marked',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      width: 130,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'On progress',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Finished',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Marked
                            UserMarkedQuestList(),
                            // Center(child: Text('On Marked Quests')),
                            // On Progress
                            Center(child: Text('On Progress Quests')),
                            // Finished
                            Center(child: Text('Finished Quests')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                backgroundColor: GlobalVar.mainColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
