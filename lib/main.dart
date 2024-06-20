// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:green_ranger/components/slidingPanel/questDetailSlidePanel.dart';
import 'package:green_ranger/pages/createQuestPage.dart';
import 'package:green_ranger/pages/homePage.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/onboarding/onboarding_screen.dart';
import 'package:green_ranger/pages/login_register_page.dart';
import 'package:green_ranger/pages/profile_pages.dart';
import 'package:green_ranger/pages/searchPage.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:green_ranger/pages/userQuestPage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

//  await prefs.clear();
  bool hasLoggedInOnce = prefs.getBool("hasLoggedInOnce") ?? false;

  await prefs.setBool("hasLoggedInOnce", true);
  print('Has Logged In Once: $hasLoggedInOnce');

  runApp(MyApp(initialRoute: getInitialRoute(hasLoggedInOnce)));
}

String getInitialRoute(bool hasLoggedInOnce) {
  if (hasLoggedInOnce) {
    return 'AuthPage';
  } else {
    return 'onboardScreen';
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
              'AuthPage': (context) => SignInPage(
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

  @override
  final List<Destination> allDestinations = [
    Destination(0, '', Icons.home, GlobalVar.baseColor),
    Destination(1, '', Icons.search, GlobalVar.baseColor),
    Destination(3, '', Icons.task, GlobalVar.baseColor),
    Destination(2, '', Icons.add_circle, GlobalVar.baseColor), // create quest
    Destination(4, '', Icons.person, GlobalVar.baseColor), // profile
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
      bottomNavigationBar: NavigationBar(
        backgroundColor: GlobalVar.mainColor,
        selectedIndex: globalVar.selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            globalVar.selectedIndex = index;
          });
        },
        destinations: allDestinations.map((destination) {
          return NavigationDestination(
            icon: Icon(destination.icon, color: GlobalVar.baseColor),
            label: destination.title,
          );
        }).toList(),
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

class SuccesCreatingQuestConfirmationScreen {}

class Destination {
  const Destination(this.index, this.title, this.icon, this.color);

  final int index;
  final String title;
  final IconData icon;
  final Color color;
}
