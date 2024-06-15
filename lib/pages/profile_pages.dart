import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';

class ProfilePages extends StatelessWidget {
  const ProfilePages({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const ProfileBody(),
    );
  }
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

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
    return const Column(
      children: [
        // Coin
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.paid,
                color: GlobalVar.secondaryColor,
                size: 50,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ranger Coin",
                  style: TextStyle(
                    color: GlobalVar.baseColor,
                  ),
                ),
                Text(
                  "10.040",
                  style: TextStyle(
                    fontSize: 20,
                    color: GlobalVar.baseColor,
                  ),
                )
              ],
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
                        color: GlobalVar.secondaryColor,
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
          color: GlobalVar.secondaryColor,
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
