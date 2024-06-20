import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Assuming you are using Provider for state management
import 'package:green_ranger/globalVar.dart'; // Your global variables file
import 'package:green_ranger/pages/settingPage.dart'; // Your SettingPage widget

class ProfilePages extends StatelessWidget {
  const ProfilePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        // Initialize userData as Map<String, dynamic>
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(globalVar.userLoginData ?? {});

        // Define _userLevel and _nextLevelExp variables
        String _userLevel;
        String _nextLevelExp;

        // Determine user level based on 'exp' key in userData
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.settings,
                  color: GlobalVar.baseColor,
                ),
              ),
            ],
          ),
          body: ProfileBody(userData: userData, nextLevelExp: _nextLevelExp),
        );
      },
    );
  }
}

class ProfileBody extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String nextLevelExp;

  const ProfileBody(
      {super.key, required this.userData, required this.nextLevelExp});

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // DATE TIME VARIABLE
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          profilePicture(),
          const SizedBox(height: 20),
          tabBar(),
          const SizedBox(height: 20),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
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

  Column calendarContent() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, left: 20),
          child: DatePicker(
            DateTime.now(),
            height: 100,
            width: 80,
            initialSelectedDate: DateTime.now(),
            selectedTextColor: GlobalVar.mainColor,
            selectionColor: GlobalVar.secondaryColorBlue,
            dateTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: GlobalVar.baseColor,
            ),
            dayTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: GlobalVar.baseColor,
            ),
            monthTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: GlobalVar.baseColor,
            ),
            onDateChange: (date) {
              setState(() {
                date = _selectedDate;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: [
              Container(
                height: 180,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 180,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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
                              '$userExp / ${widget.nextLevelExp}',
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
      margin: EdgeInsets.symmetric(horizontal: 8),
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

class TaskTile extends StatelessWidget {
  final String taskName;

  TaskTile({required this.taskName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        taskName,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
