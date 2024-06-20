import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/pages/login_register_page.dart';

import 'package:green_ranger/onboarding/intro_page_1.dart';
import 'package:green_ranger/onboarding/intro_page_2.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key, required GlobalVar globalVar})
      : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
GlobalVar globalVar = GlobalVar.instance;

  int currentPage = 0;
  List<Widget> listPage = [];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.round();
      });
    });

    // Initialize listPage here
    listPage = [IntroPage1(), IntroPage2()];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == listPage.length - 1);
              });
            },
            children: listPage,
          ),

          // Indicator
          Container(
            margin: const EdgeInsets.only(bottom: 90),
            alignment: Alignment(0, 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: onLastPage
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (onLastPage) {
                          // Set userLoginData to null or em

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SignInPage(globalVar: globalVar),
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
