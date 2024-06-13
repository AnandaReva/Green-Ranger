import 'package:flutter/material.dart';
import 'package:green_ranger/components/infiniteScorllPagination.dart';

class GlobalVar extends ChangeNotifier {
  static final GlobalVar _instance = GlobalVar._internal();
  static const mainColor = Color.fromARGB(255, 26, 27, 27);
  static const secondaryColor = Color.fromARGB(255, 211, 255, 30);
  static const baseColor = Color.fromRGBO(240, 240, 240, 1.0);

  Map<String, dynamic> _userLoginData = {
    'profile_image': 'assets/images/logo.png',
    'username': 'admin',
    'level': 'Mythrill',
    'exp': '2000',
    'wallet_value': '750000',
  };

  Map<String, dynamic> _newQuestData = {
    'questName': '',
    'instance': '',
    'tasks': [],
    'address': '',
    'duration': '',
    'totalRangers': '',
    'reward': '',
    'levelRequirements': '',
    'description': '',
  };

//levels: Mythrill, Legendary, Epic, Rookie (500, 1000, 1500, 2000)

  final List<QuestSummary> _currentQuestData = [
    QuestSummary(
      questName: 'Find Sample Cosmetics Trash',
      instance: 'PT Paragon',
      duration: '2',
      totalRangers: '10',
      levelRequirements: 'Rookie',
      reward: '800000',
      description: 'Find Sample Cosmetics Trash',
      taskList: ['Organizing Rangers', 'Gathering Trash'],
      address: 'Jalan Swadarma Raya Kampung Baru IV No. 1. Jakarta - 12250',
    ),
    QuestSummary(
      questName: 'Recycle Oil and Biodiesel',
      instance: 'CV Prima Oil Slepet',
      duration: '5',
      totalRangers: '20',
      levelRequirements: 'Legendary',
      reward: '1200000',
      description: 'Find Oil and Biodiesel Trash and Recycle',
      taskList: ['Collecting Oil Barrels', 'Sorting Biodiesel Waste'],
      address: 'Jl Kemana Saja Sukanasi Jakarta',
    ),
    QuestSummary(
      questName: 'Clean Up Beach Pollution',
      instance: 'Green Earth Organization',
      duration: '3',
      totalRangers: '15',
      levelRequirements: 'Mythrill',
      reward: '1000000',
      description: 'Clean up plastic and waste from beaches',
      taskList: ['Organizing volunteers', 'Collecting plastic waste'],
      address: 'Ocean Drive, Beach City',
    ),
    QuestSummary(
      questName: 'Plant Trees in Urban Areas',
      instance: 'EcoGreen Foundation',
      duration: '7',
      totalRangers: '30',
      levelRequirements: 'Legendary',
      reward: '1500000',
      description: 'Plant trees in urban areas to increase green cover',
      taskList: ['Preparation of saplings', 'Planting in designated areas'],
      address: 'City Parks and Recreation Center',
    ),
    QuestSummary(
      questName: 'Restore River Ecosystem',
      instance: 'Water Conservation Alliance',
      duration: '4',
      totalRangers: '25',
      levelRequirements: 'Epic',
      reward: '1800000',
      description: 'Restore natural habitat and improve water quality',
      taskList: ['Monitoring water quality', 'Restocking fish population'],
      address: 'Riverside Drive, Riverside City',
    ),
  ];

  // Simulated asynchronous fetch of quest data
  Future<List<QuestSummary>> getQuests(int pageKey, int pageSize) async {
    await Future.delayed(
        Duration(milliseconds: 500)); // Simulating network delay

    final startIndex = pageKey * pageSize;
    if (startIndex >= _currentQuestData.length) {
      return []; // No more items
    }

    return _currentQuestData.sublist(
        startIndex,
        startIndex + pageSize < _currentQuestData.length
            ? startIndex + pageSize
            : _currentQuestData.length);
  }

  bool _isLogin = false;
  bool _isLoading = false;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  Map<String, dynamic> get userLoginData => _userLoginData;

  bool get isLogin => _isLogin;
  bool get isLoading => _isLoading;

  set userLoginData(Map<String, dynamic> value) {
    _userLoginData = value;
    notifyListeners();
  }

  set isLogin(bool value) {
    _isLogin = value;
  }

  set isLoading(bool value) {
    _isLoading = value;
  }

  // Getter for newQuestData
  Map<String, dynamic> get newQuestData => _newQuestData;

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
