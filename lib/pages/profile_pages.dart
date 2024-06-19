// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:green_ranger/globalVar.dart';

class ProfilePages extends StatelessWidget {
  const ProfilePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        Map<String, dynamic> userData = globalVar.userLoginData;

        // Define _userLevel variable
        // Define _userLevel variable
        String _userLevel;
        String _nextLevelExp;

        // Determine user level
        int userExp = userData['exp'] ?? 0;
        int levelStep = 1500;
        int userLevelValue = (userExp / levelStep).floor();

        if (userLevelValue < 1) {
          _userLevel = 'rookie';
          _nextLevelExp = (levelStep * 1).toString();
        } else if (userLevelValue < 2) {
          _userLevel = 'epic';
          _nextLevelExp = (levelStep * 2).toString();
        } else if (userLevelValue < 3) {
          _userLevel = 'legendary';
          _nextLevelExp = (levelStep * 3).toString();
        } else if (userLevelValue < 4) {
          _userLevel = 'mythic';
          _nextLevelExp = (levelStep * 4).toString();
        } else {
          _userLevel = 'mythic';
          _nextLevelExp = 'max'; // max level reached
        }

        return Scaffold(
          backgroundColor: GlobalVar.mainColor,
          appBar: AppBar(
            backgroundColor: GlobalVar.mainColor,
            toolbarHeight: 120,
            centerTitle: true,
            title: const Text(
              "My Profile",
              style: TextStyle(color: GlobalVar.baseColor),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_alert,
                  color: GlobalVar.baseColor,
                ),
              ),
            ],
          ),
          body: ProfileBody(userData: userData),
        );
      },
    );
  }
}

class ProfileBody extends StatefulWidget {
  final Map<String, dynamic> userData;

  const ProfileBody({super.key, required this.userData});

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          profilePicture(),
          const SizedBox(height: 20),
          tabBar(),
          const SizedBox(height: 20),
          tabBarView()
        ],
      ),
    );
  }

  Container tabBarView() {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab Bar Content
                statisticContent(),
                calendarContent(),
                reviewContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text calendarContent() => const Text("Calendar Content Under Construction");

  Column reviewContent() {
    int userExp =
        widget.userData['exp'] ?? 0; // Access user experience from userData
    return Column(
      children: [
        // Coin
        Row(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/coinIcon.png",
                        width: 100,
                      ),
                      const SizedBox(width: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ranger Coin',
                              style: TextStyle(
                                fontSize: 12,
                                color: GlobalVar.baseColor,
                                fontWeight: FontWeight.normal,
                                
                              ),
                            ),
                            Text(
                              'Rp. ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: '').format(widget.userData['wallet_value'] ?? 0)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: GlobalVar.baseColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/cherryIcon.png",
                        width: 100,
                      ),
                      const SizedBox(width: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Exp',
                              style: TextStyle(
                                fontSize: 14,
                                color: GlobalVar.baseColor,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              // '$userExp / ${widget.nextLevelExp}',
                              '$userExp ',
                              style: TextStyle(
                                fontSize: 14,
                                color: GlobalVar.baseColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        //TODO:Exp
        Row(),
      ],
    );
  }

  Column statisticContent() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: GlobalVar.baseColor,
              width: 1, // Set the width of the border
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: GlobalVar.secondaryColorGreen,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.description),
                      ),
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CV_Afrizal.pdf",
                        style: TextStyle(color: GlobalVar.baseColor),
                      ),
                      Text(
                        "Views 39",
                        style: TextStyle(color: GlobalVar.baseColor),
                      ),
                    ],
                  ),
                ],
              ),
              downloadAndShareButton(),
            ],
          ),
        ),
        // TODO:Analytic Content Disini
      ],
    );
  }

  Container tabBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(
          color: GlobalVar.baseColor,
          width: 1, // Set the width of the border
        ),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: GlobalVar.secondaryColorGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        labelStyle: const TextStyle(color: GlobalVar.mainColor),
        unselectedLabelColor: GlobalVar.baseColor,
        dividerColor: Colors.transparent,
        controller: _tabController,
        tabs: const <Widget>[
          Tab(text: "Statistic"),
          Tab(text: "Calendar"),
          Tab(text: "Review"),
        ],
      ),
    );
  }

  Row downloadAndShareButton() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: GlobalVar
                .baseColor, // Background color for the first IconButton
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download),
            color: GlobalVar.mainColor, // Icon color for the first IconButton
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: GlobalVar.baseColor,
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
            color: GlobalVar.mainColor,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }

  Center profilePicture() {
    return const Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBaM3CxDawkcDk651EFI7xnHMSeMc2ddgZ3szAHmLYREZfO_ONZqhumm1vOQ&s",
            ),
          ),
        ],
      ),
    );
  }
}
