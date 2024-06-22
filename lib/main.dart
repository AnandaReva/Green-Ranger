import 'package:green_ranger/components/slidingPanel/questDetailSlidePanel.dart';
import 'package:green_ranger/mongoDB/authMongodb.dart';
import 'package:green_ranger/pages/createQuestPage.dart';
import 'package:green_ranger/pages/homePage.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/onboarding/onboarding_screen.dart';
import 'package:green_ranger/pages/authPage.dart';
import 'package:green_ranger/pages/profile_pages.dart';
import 'package:green_ranger/pages/searchPage.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:green_ranger/pages/userQuestPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalVar globalVar = GlobalVar.instance;

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyDHhS1joU9B_M61p2j6cADe_XOtBDI4NzM',
              appId: '1:81206821612:android:5b681cf1e8b96625cedbc9',
              messagingSenderId: '81206821612',
              projectId: 'green-ranger-a112e',
              storageBucket: "green-ranger-a112e.appspot.com"))
      : await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
// dont delete
//  await prefs.clear();
  bool hasLoggedInOnce = prefs.getBool("hasLoggedInOnce") ?? false;

  await prefs.setBool("hasLoggedInOnce", true);
  print('Has Logged In Once: $hasLoggedInOnce');

  runApp(MyApp(initialRoute: await getInitialRoute(hasLoggedInOnce)));
}

Future<String> getInitialRoute(bool hasLoggedInOnce) async {
  if (hasLoggedInOnce) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String userEmail = user.email ?? "Terjadi Kesalahan saat mengambil data";
      print("User Account firebase: $userEmail  ");
      bool loginSuccess =
          await AuthMongodb.findUserDataWithouPasswordMongodb(userEmail);
      // Cek apakah data berhasil ditemukan
      if (!loginSuccess) {
        print('Failed to fetch user data');
        return 'AuthPage';
      }
      return 'homeScreen'; // Navigate to home screen if logged in
    } else {
      print('User not logged in');
      return 'AuthPage'; // Navigate to authentication page if no user found
    }
  } else {
    return 'onboardScreen'; // Navigate to onboarding screen if first time login
  }
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlobalVar.instance,
      child: Consumer<GlobalVar>(
        builder: (context, globalVar, _) {
          return MaterialApp(
            initialRoute: initialRoute,
            routes: {
              'homeScreen': (context) => MainPage(),
              'onboardScreen': (context) => OnBoardingScreen(
                    globalVar: globalVar,
                  ),
              'AuthPage': (context) => AuthPage(
                    globalVar: globalVar,
                  ),
              // Add other routes here as needed
            },
          );
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  static MainPageState of(BuildContext context) {
    return context.findAncestorStateOfType<MainPageState>()!;
  }

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  GlobalVar globalVar = GlobalVar.instance;
  late List<GlobalKey<NavigatorState>> navigatorKeys;
  late List<AnimationController> destinationFaders;
  late List<Widget> destinationViews;

  final SlidingUpPanelController panelController = SlidingUpPanelController();
  final StreamController<VoidCallback?> onTapController =
      StreamController<VoidCallback?>();

  bool isPanelOpen = false;
  late SlidingUpPanelStatus panelStatus;

  @override
  final List<Destination> allDestinations = [
    Destination(0, 'Dashboard', "assets/images/icon_dashboard.png",
        GlobalVar.baseColor),
    Destination(
        1, 'Guilds', "assets/images/icon_guild.png", GlobalVar.baseColor),
    Destination(2, 'Your Quest', "assets/images/icon_createquest.png",
        GlobalVar.baseColor),
    Destination(
        3, 'Create Quest', "assets/images/icon_quest.png", GlobalVar.baseColor),
    Destination(
        4, 'Profile', "assets/images/icon_person.png", GlobalVar.baseColor),
  ];
  @override
  void initState() {
    super.initState();
    globalVar = Provider.of<GlobalVar>(context as BuildContext, listen: false);

    // Listen to onTapController and call the callbacks
    onTapController.stream.listen((VoidCallback? onTap) {
      onTap?.call(); // Call the onTap function received from QuestListItem
    });

    navigatorKeys = List.generate(
      allDestinations.length,
      (index) => GlobalKey<NavigatorState>(),
    );

    destinationFaders = List.generate(
      allDestinations.length,
      (index) => buildFaderController(),
    );
    // Initialize panel status
   // Initialize panel status

    destinationFaders[globalVar.selectedIndex].value = 1.0;

    destinationViews = List.generate(
      allDestinations.length,
      (index) {
        switch (index) {
          case 0:
            return HomePage();
          case 1:
            return SearchPage();
          case 2:
            return UserQuestPage();
          case 3:
            return CreateQuest(
              globalVar: globalVar,
            );
          case 4:
            return ProfilePages();
          default:
            return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // nanti pindah kesini
          ...allDestinations.map((destination) {
            final index = destination.index;
            final view = destinationViews[index];
            if (index == globalVar.selectedIndex) {
              destinationFaders[index].forward();
              return Offstage(offstage: false, child: view);
            } else {
              destinationFaders[index].reverse();
              if (destinationFaders[index].isAnimating) {
                return IgnorePointer(child: view);
              }
              return Offstage(child: view);
            }
          }).toList(),
          QuestDetailSlidePanel(
              panelController: panelController, globalVar: globalVar),
          // buat coba
          //  QuestReportSlidePanel(
          //   panelController: panelController, globalVar: globalVar),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          backgroundColor: GlobalVar.mainColor,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: GlobalVar.baseColor),
          ),
        ),
        child: NavigationBar(
          selectedIndex: globalVar.selectedIndex,
          onDestinationSelected: (index) => setState(() {
            globalVar.selectedIndex = index;
          }),
          destinations: allDestinations.map((destination) {
            return NavigationDestination(
              icon: Image.asset(
                color: const Color.fromARGB(255, 133, 132, 132),
                destination.icon,
                width: 24,
                height: 24,
              ),
              selectedIcon: Image.asset(
                color: GlobalVar.baseColor,
                destination.icon,
                width: 24,
                height: 24,
              ),
              label: destination.title,
            );
          }).toList(),
        ),
      ),
    );
  }

  AnimationController buildFaderController() {
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {});
      }
    });
    return controller;
  }
}

class Destination {
  const Destination(this.index, this.title, this.icon, this.color);
  final int index;
  final String title;
  final String icon;
  final Color color;
}
