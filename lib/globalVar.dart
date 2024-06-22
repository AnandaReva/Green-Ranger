import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GlobalVar extends ChangeNotifier {
  static final GlobalVar _instance = GlobalVar._internal();
  static const mainColor = Color.fromARGB(255, 26, 27, 27);
  static const secondaryColorGreen = Color.fromARGB(255, 211, 255, 30);
  static const secondaryColorPuple = Color.fromRGBO(144, 110, 218, 1);
  static const secondaryColorPink = Color.fromRGBO(238, 51, 209, 1);
  static const secondaryColorBlue = Color.fromARGB(255, 37, 150, 190);
  static const baseColor = Color.fromRGBO(240, 240, 240, 1.0);

  bool _isPanelOpened = false;

  int FeedLimit = 0;
  int totalFeedCount= 0;

  Map<String, dynamic> _newQuestData = {
    'questName': '',
    'instance': '',
    'tasks': [],
    'address': '',
    'duration': '',
    'maxRangers': '',
    'reward': '',
    'levelRequirements': '',
    'description': '',
    'date': '',
    'categories': [],
  };

  Map<String, dynamic> _questDataSelected = {};

//levels: Mythrill, Legendary, Epic, Rookie (500, 1000, 1500, 2000)
  var _userLoginData;

  var _homePageQuestFeed;
  var _userMarkedQuest;
  var _userOnProgressQuest;
  var _userCompletedQuest;

  String _errorMessageGlobal = "";
  bool _isLoading = false;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  dynamic get userLoginData => _userLoginData;
  dynamic get homePageQuestFeed => _homePageQuestFeed;
  dynamic get userMarkedQuest => _userMarkedQuest;
  dynamic get userOnProgressQuest => _userOnProgressQuest;
  dynamic get userCompletedQuest => _userCompletedQuest;

  Map<String, dynamic> get questDataSelected => _questDataSelected;
  Map<String, dynamic> get newQuestData => _newQuestData;

  bool get isPanelOpened => _isPanelOpened;
  String get errorMessageGlobal => _errorMessageGlobal;
  bool get isLoading => _isLoading;

  // dont delete
  // set userLoginData(Map<String, dynamic> value) {
  //   _userLoginData = value;
  //   notifyListeners();
  // }

  set userLoginData(dynamic value) {
    _userLoginData = value;
  }

  set homePageQuestFeed(dynamic value) {
    _homePageQuestFeed = value;
  }

  set userMarkedQuest(dynamic value) {
    _userMarkedQuest = value;
  }

  set userOnProgressQuest(dynamic value) {
    _userOnProgressQuest = value;
  }

  set userCompletedQuest(dynamic value) {
    _userCompletedQuest = value;
  }

  set questDataSelected(Map<String, dynamic> value) {
    _questDataSelected = value;
    notifyListeners();
  }

  set isPanelOpened(bool value) {
    _isPanelOpened = value;
    notifyListeners();
  }

  set errorMessageGlobal(String value) {
    _errorMessageGlobal = value;
  }

  set isLoading(bool value) {
    _isLoading = value;
  }

  // Setter for newQuestData
  set newQuestData(Map<String, dynamic> value) {
    _newQuestData = value;
    notifyListeners();
  }

  // Update a specific field in newQuestData
  void updateNewQuestData(String key, dynamic value) {
    _newQuestData[key] = value;
    notifyListeners();
  }

  GlobalVar._internal();

  static GlobalVar get instance => _instance;
}
