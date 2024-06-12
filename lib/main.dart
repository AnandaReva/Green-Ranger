import 'package:flutter/material.dart';
import 'package:green_ranger/components/homePage.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';

int initScreen = 0;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GlobalVar.instance,
      child: Consumer<GlobalVar>(
        builder: (context, globalVar, _) {
          return MaterialApp(
            initialRoute: 'onboard',
            routes: {
              'home': (context) => MainPage(),
              'onboard': (context) => OnBoardingScreen(globalVar: globalVar),
              // Add other routes here as needed
            },
          );
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late GlobalVar globalVar;
  late List<GlobalKey<NavigatorState>> navigatorKeys;
  late List<AnimationController> destinationFaders;
  late List<Widget> destinationViews;
  final List<Destination> allDestinations = [
    Destination(0, '', Icons.home, GlobalVar.baseColor),
    Destination(1, '', Icons.search, GlobalVar.baseColor),
    Destination(2, '', Icons.add_circle, GlobalVar.baseColor),
    Destination(3, '', Icons.task, GlobalVar.baseColor),
    Destination(4, '', Icons.person, GlobalVar.baseColor),
  ];

  @override
  void initState() {
    super.initState();
    globalVar = Provider.of<GlobalVar>(context, listen: false);

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
            return HomePage(userData: globalVar.userLoginData);

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
        children: allDestinations.map((destination) {
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
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: GlobalVar.mainColor, // Keep the background color here
        selectedIndex: globalVar.selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            globalVar.selectedIndex = index;
          });
        },
        destinations: allDestinations.map((destination) {
          return NavigationDestination(
            icon: Icon(destination.icon, color: GlobalVar.baseColor), // Change icon color here
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

class Destination {
  const Destination(this.index, this.title, this.icon, this.color);

  final int index;
  final String title;
  final IconData icon;
  final Color color;
}
