import 'package:flutter/material.dart';
import 'package:green_ranger/components/infiniteScorllPagination.dart';

class GlobalVar extends ChangeNotifier {
  static final GlobalVar _instance = GlobalVar._internal();
  static const mainColor = Color.fromARGB(255, 26, 27, 27);
  static const secondaryColorGreen = Color.fromARGB(255, 211, 255, 30);
  static const secondaryColorPuple = Color.fromRGBO(144, 110, 218, 1);
  static const secondaryColorPink = Color.fromRGBO(238, 51, 209, 1);
  static const baseColor = Color.fromRGBO(240, 240, 240, 1.0);

  bool _isPanelOpened = false;

  Map<String, dynamic> _userLoginData = {
    'objectId': '507f1f77bcf86cd799439011',
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
    'date': '',
  };

  Map<String, dynamic> _questDataSelected = {};

//levels: Mythrill, Legendary, Epic, Rookie (500, 1000, 1500, 2000)

  final List<QuestSummary> _currentQuestData = [
    QuestSummary(
      objectId: '507f1f77bcf86cd799439011',
      questName: 'Find Sample Cosmetics Trash',
      instance: 'PT Paragon',
      duration: '2',
      totalRangers: '10',
      levelRequirements: 'Rookie',
      reward: '800000',
      description:
          'Find and organize samples of cosmetics trash. This quest involves gathering trash from various sources and organizing rangers to effectively manage the cleanup operation.',
      taskList: [
        'Organizing Rangers',
        'Gathering Trash',
        'Collect data results from rangers and calculation each ranger prizes',
        'Prizes distribution'
      ],
      address: 'Jalan Swadarma Raya Kampung Baru IV No. 1. Jakarta - 12250',
      date: '2024-06-14T12:00:00Z',
    ),
    QuestSummary(
      objectId: '507f1f77bcffrcd799439424',
      questName: 'Recycle Oil and Biodiesel',
      instance: 'CV Prima Oil Slepet',
      duration: '5',
      totalRangers: '20',
      levelRequirements: 'Legendary',
      reward: '1200000',
      description:
          'Find oil and biodiesel trash in the city and recycle them. This quest requires collecting oil barrels and sorting biodiesel waste for recycling purposes.',
      taskList: ['Collecting Oil Barrels', 'Sorting Biodiesel Waste'],
      address: 'Jl Kemana Saja Sukanasi Jakarta',
      date: '2024-06-15T14:00:00Z',
    ),
    QuestSummary(
      objectId: '507fdgfdg77bcf86cd799439011',
      questName: 'Clean Up Beach Pollution',
      instance: 'Green Earth Organization',
      duration: '3',
      totalRangers: '15',
      levelRequirements: 'Mythrill',
      reward: '1000000',
      description:
          'Join the Green Earth Organization in cleaning up plastic and waste from beaches. This quest involves organizing volunteers and collecting plastic waste to protect marine life.',
      taskList: ['Organizing volunteers', 'Collecting plastic waste'],
      address: 'Ocean Drive, Beach City',
      date: '2024-06-16T10:30:00Z',
    ),
    QuestSummary(
      objectId: '507f1f77bcf86cd799433rwe11',
      questName: 'Plant Trees in Urban Areas',
      instance: 'EcoGreen Foundation',
      duration: '7',
      totalRangers: '30',
      levelRequirements: 'Legendary',
      reward: '1500000',
      description:
          'Join the EcoGreen Foundation in planting trees in urban areas to increase green cover. This quest involves preparing saplings and planting them in designated areas to improve the environment.',
      taskList: ['Preparation of saplings', 'Planting in designated areas'],
      address: 'City Parks and Recreation Center',
      date: '2024-06-17T08:00:00Z',
    ),
    QuestSummary(
      objectId: '50fsfs1f77bcf86cd799439011',
      questName: 'Restore River Ecosystem',
      instance: 'Water Conservation Alliance',
      duration: '4',
      totalRangers: '25',
      levelRequirements: 'Epic',
      reward: '1800000',
      description:
          'Join the Water Conservation Alliance to restore the natural habitat and improve water quality in rivers. This quest involves monitoring water quality and restocking fish population for ecological balance.',
      taskList: ['Monitoring water quality', 'Restocking fish population'],
      address: 'Riverside Drive, Riverside City',
      date: '2024-06-18T15:45:00Z',
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

  Map<String, dynamic> get questDataSelected => _questDataSelected;

  bool get isPanelOpened => _isPanelOpened;
  bool get isLogin => _isLogin;
  bool get isLoading => _isLoading;

  set userLoginData(Map<String, dynamic> value) {
    _userLoginData = value;
    notifyListeners();
  }

  set questDataSelected(Map<String, dynamic> value) {
    _questDataSelected = value;
    notifyListeners();
  }

  set isPanelOpened(bool value) {
    _isPanelOpened = value;
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
