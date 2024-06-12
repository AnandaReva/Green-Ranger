import 'package:flutter/material.dart';

class GlobalVar extends ChangeNotifier {
  static final GlobalVar _instance = GlobalVar._internal();
  static const mainColor = Color.fromARGB(255, 26, 27, 27);
  static const secondaryColor = Color.fromARGB(255, 211, 255, 30);
  static const baseColor = Color.fromRGBO(240, 240, 240, 1.0);

  dynamic _userLoginData;
  dynamic _currentOrderData;
  dynamic _currentPickUpData;
  dynamic _currentSweeperData;

  dynamic _orderDataList;

  bool _isLogin = false;
  bool _isLoading = false;
  bool _isInOrder = false;
  int _selectedIndex = 0;
  String _selected_role_onboarding = "";
  String _userLocation = "";

  int _initScreen = 0;

  List<int> _selectedTrashIndexes = []; // Initialize with an empty list

  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  List<int> get selectedTrashIndexes => _selectedTrashIndexes;
  set selectedTrashIndexes(List<int> value) {
    _selectedTrashIndexes = value;
    notifyListeners();
  }

/*   int get initScreen => _initScreen;
  set initScreen(int value) {
    _initScreen = value;
    notifyListeners();
  } */

  String get selected_role_onboarding => _selected_role_onboarding;
  String get userLocation => _userLocation;

  dynamic get userLoginData => _userLoginData;
  dynamic get currentOrderData => _currentOrderData;
  dynamic get orderDataList => _orderDataList;
  dynamic get currentPickUpData => _currentPickUpData;
  dynamic get currentSweeperData => _currentSweeperData;

  bool get isLogin => _isLogin;
  bool get isLoading => _isLoading;
  bool get isInOrder => _isInOrder;

  set userLoginData(dynamic value) {
    _userLoginData = value;
    notifyListeners();
  }

  set currentOrderData(dynamic value) {
    _currentOrderData = value;
    notifyListeners();
  }

  set currentPickUpData(dynamic value) {
    _currentPickUpData = value;
    notifyListeners();
  }

  set orderDataList(dynamic value) {
    _orderDataList = value;
    notifyListeners();
  }

  set currentSweeperData(dynamic value) {
    _currentSweeperData = value;
    notifyListeners();
  }

  set isLogin(bool value) {
    _isLogin = value;
  }

  set isLoading(bool value) {
    _isLoading = value;
  }

  set isInOrder(bool value) {
    _isInOrder = value;
    notifyListeners();
  }

  set selected_role_onboarding(String value) {
    _selected_role_onboarding = value;
    notifyListeners();
  }

  set userLocation(String value) {
    _userLocation = value;
    notifyListeners();
  }

  GlobalVar._internal();

  static GlobalVar get instance => _instance;
}
