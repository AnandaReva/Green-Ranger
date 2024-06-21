// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:green_ranger/components/loadingUI.dart';
import 'package:green_ranger/components/succesConfirmation.dart';
import 'package:green_ranger/mongoDB/questMongodb.dart';
import 'package:provider/provider.dart';
import 'package:green_ranger/globalVar.dart';

class CreateQuest extends StatefulWidget {
  CreateQuest({Key? key, required GlobalVar globalVar}) : super(key: key);

  @override
  _CreateQuestState createState() => _CreateQuestState();
}

class _CreateQuestState extends State<CreateQuest> {
  final TextEditingController _controllerQuestName = TextEditingController();
  final TextEditingController _controllerInstance = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final List<TextEditingController> _taskControllers = [];
  final TextEditingController _controllerDuration = TextEditingController();
  final TextEditingController _controllerMaxRangers = TextEditingController();
  final TextEditingController _controllerReward = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  String _errorMessage = "";

  final List<String> _levelOptions = [
    'Rookie',
    'Epic',
    'Legendary',
    'Mythrill'
  ];

  bool trashCollection = false;
  bool natureConservation = false;
  bool pollutionControl = false;
  bool other = false;

  String? _selectedLevel;
  bool _categoryError = false;

  @override
  void initState() {
    super.initState();
    final globalVar = Provider.of<GlobalVar>(context, listen: false);

    // Initialize controllers with existing values from GlobalVar
    _initializeControllers(globalVar);

    // Add listeners to update GlobalVar when fields change
    _addListeners(globalVar);
  }

  void _initializeControllers(GlobalVar globalVar) {
    _controllerQuestName.text = globalVar.newQuestData['questName'] ?? '';
    _controllerInstance.text = globalVar.newQuestData['instance'] ?? '';
    _controllerAddress.text = globalVar.newQuestData['address'] ?? '';
    _controllerDuration.text = globalVar.newQuestData['duration'] ?? '';
    _controllerMaxRangers.text = globalVar.newQuestData['maxRangers'] ?? '';
    _controllerReward.text = globalVar.newQuestData['reward'] ?? '';
    _controllerDescription.text = globalVar.newQuestData['description'] ?? '';

    _selectedLevel =
        _levelOptions.contains(globalVar.newQuestData['levelRequirements'])
            ? globalVar.newQuestData['levelRequirements']
            : _levelOptions.first;

    if (globalVar.newQuestData['tasks'] != null) {
      for (String task in globalVar.newQuestData['tasks']) {
        final taskController = TextEditingController(text: task);
        _taskControllers.add(taskController);
      }
    }
  }

  void _addListeners(GlobalVar globalVar) {
    _controllerQuestName.addListener(() {
      globalVar.updateNewQuestData('questName', _controllerQuestName.text);
    });
    _controllerInstance.addListener(() {
      globalVar.updateNewQuestData('instance', _controllerInstance.text);
    });
    _controllerAddress.addListener(() {
      globalVar.updateNewQuestData('address', _controllerAddress.text);
    });
    _controllerDuration.addListener(() {
      globalVar.updateNewQuestData('duration', _controllerDuration.text);
    });
    _controllerMaxRangers.addListener(() {
      globalVar.updateNewQuestData('maxRangers', _controllerMaxRangers.text);
    });
    _controllerReward.addListener(() {
      globalVar.updateNewQuestData('reward', _controllerReward.text);
    });
    _controllerDescription.addListener(() {
      globalVar.updateNewQuestData('description', _controllerDescription.text);
    });

    for (int i = 0; i < _taskControllers.length; i++) {
      _taskControllers[i].addListener(() {
        final tasks =
            _taskControllers.map((controller) => controller.text).toList();
        globalVar.updateNewQuestData('tasks', tasks);
      });
    }
  }

  void _addTaskField() {
    setState(() {
      final newController = TextEditingController();
      _taskControllers.add(newController);
      newController.addListener(() {
        final tasks =
            _taskControllers.map((controller) => controller.text).toList();
        Provider.of<GlobalVar>(context, listen: false)
            .updateNewQuestData('tasks', tasks);
      });
    });
  }

  void _removeTaskField(int index) {
    setState(() {
      print(
          'Removing TaskField index: $index'); // Mencetak indeks TaskField yang dihapus
      _taskControllers[index].removeListener(() {});
      _taskControllers.removeAt(index);
      final tasks =
          _taskControllers.map((controller) => controller.text).toList();
      Provider.of<GlobalVar>(context, listen: false)
          .updateNewQuestData('tasks', tasks);
    });
  }

  bool _isFormValid() {
    final int maxReward = 100000000; // 100 juta
    final int minReward = 10000; // 10 ribu
    final int walletValue =
        GlobalVar.instance.userLoginData['wallet_value'] ?? 0;

    bool isRewardValid = false;

    if (_controllerReward.text.isNotEmpty) {
      int reward = int.tryParse(_controllerReward.text) ?? 0;
      isRewardValid =
          reward >= minReward && reward <= maxReward && reward < walletValue;
    }

    return _controllerQuestName.text.isNotEmpty &&
        _controllerInstance.text.isNotEmpty &&
        _controllerAddress.text.isNotEmpty &&
        _controllerDuration.text.isNotEmpty &&
        _controllerMaxRangers.text.isNotEmpty &&
        _controllerReward.text.isNotEmpty &&
        _controllerDescription.text.isNotEmpty &&
        _selectedLevel != null &&
        _taskControllers.isNotEmpty &&
        _taskControllers.every((controller) => controller.text.isNotEmpty) &&
        (trashCollection || natureConservation || pollutionControl || other) &&
        isRewardValid;
  }

  void _handleSubmit() async {
    // Check form validity and update UI accordingly
    setState(() {
      GlobalVar.instance.isLoading = true;
      _categoryError =
          !(trashCollection || natureConservation || pollutionControl || other);
      _errorMessage = ''; // Clear any previous error message
    });

    if (_isFormValid()) {
      // Gather values from each field
      String questName = _controllerQuestName.text;
      String instance = _controllerInstance.text;
      String address = _controllerAddress.text;
      String duration = _controllerDuration.text;
      String maxRangers = _controllerMaxRangers.text;
      String reward = _controllerReward.text;
      String description = _controllerDescription.text;
      List<String> tasks =
          _taskControllers.map((controller) => controller.text).toList();
      String levelRequirements = _selectedLevel ?? '';

      // Create list to store selected categories
      List<String> selectedCategories = [];
      if (trashCollection) selectedCategories.add('Trash Collection');
      if (natureConservation) selectedCategories.add('Nature Conservation');
      if (pollutionControl) selectedCategories.add('Pollution Control');
      if (other) selectedCategories.add('Other');

      // Validate reward amount
      int maxReward = 100000000; // 100 million
      int walletValue = GlobalVar.instance.userLoginData['wallet_value'] ?? 0;

      if (_controllerReward.text.isNotEmpty) {
        int rewardValue = int.tryParse(_controllerReward.text) ?? 0;
        if (rewardValue > maxReward || rewardValue > walletValue) {
          setState(() {
            GlobalVar.instance.isLoading = false;
            _errorMessage =
                'Reward should not exceed 100 million or wallet value';
          });
          return;
        }
      }

      // Proceed with quest creation in MongoDB
      bool createQuestSuccess = await QuestMongodb.createQuestMongodb(
        questName: questName,
        instance: instance,
        address: address,
        duration: duration,
        maxRangers: maxRangers,
        reward: reward,
        description: description,
        levelRequirements: levelRequirements,
        tasks: tasks,
        selectedCategories: selectedCategories,
        questOwnerPhone: GlobalVar.instance.userLoginData['phone'],
      );

      if (!createQuestSuccess) {
        // If quest creation fails, update error message
        setState(() {
          GlobalVar.instance.isLoading = false;
          _errorMessage = 'Error creating quest. Please try again';
        });
        return;
      }

      // If quest creation succeeds, navigate to success confirmation page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessConfirmation(
              successMessage: "Quest has been created successfully"),
        ),
      );

      // Reset form fields and state variables
      _controllerQuestName.clear();
      _controllerInstance.clear();
      _controllerAddress.clear();
      _controllerDuration.clear();
      _controllerMaxRangers.clear();
      _controllerReward.clear();
      _controllerDescription.clear();
      _taskControllers.clear();
      setState(() {
        trashCollection = false;
        natureConservation = false;
        pollutionControl = false;
        other = false;
        GlobalVar.instance.isLoading = false;
        _errorMessage = '';
      });
    } else {
      // If form is not valid, update error message
      setState(() {
        GlobalVar.instance.isLoading = false;
        _errorMessage =
            'Please fill out all fields and select at least one category';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        return Scaffold(
            backgroundColor: GlobalVar.mainColor,
            body: globalVar.isLoading
                ? LoadingUi() // Show loading UI when isLoading is true
                : SafeArea(
                    child: SingleChildScrollView(
                        child: Container(
                      color: GlobalVar.mainColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: GlobalVar.mainColor,
                              ),
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 55),
                                  Center(
                                    child: Text(
                                      'Create Quest',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: GlobalVar.baseColor,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  _buildTextField(
                                      _controllerQuestName, 'Quest Name'),
                                  _buildTextField(
                                      _controllerInstance, 'Instance'),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                            _controllerDuration,
                                            'Duration (days)',
                                            TextInputType.number),
                                      ),
                                      SizedBox(
                                          width:
                                              10), // Spacer between Duration and Total Rangers fields
                                      Expanded(
                                        child: _buildTextField(
                                            _controllerMaxRangers,
                                            'Total Rangers',
                                            TextInputType.number),
                                      ),
                                    ],
                                  ),
                                  _buildTextField(
                                      _controllerAddress, 'Address'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Your Wallet: " +
                                            GlobalVar.instance
                                                .userLoginData['wallet_value']
                                                .toString() ?? '0',
                                        style: TextStyle(
                                          color: GlobalVar.baseColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              10), // Spacer untuk memberikan jarak antara elemen

                                      Text(
                                        '(IDR, max Rp.100.000.000 , min Rp.10.000 and not exceed your wallet value)',
                                        style: TextStyle(
                                          color: GlobalVar.baseColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),

                                      SizedBox(
                                          height:
                                              10), // Spacer untuk memberikan jarak antara elemen

                                      _buildTextField(
                                          _controllerReward, "Reward"),
                                    ],
                                  ),
                                  _buildTextField(
                                      _controllerDescription, 'Description'),
                                  _buildDropdownField(),
                                  Text(
                                    'Task List (min. 1)',
                                    style: TextStyle(
                                        color: GlobalVar.baseColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  _buildTaskFields(),
                                  IconButton(
                                    color: GlobalVar.baseColor,
                                    icon: Icon(Icons.add_box_outlined),
                                    onPressed: _addTaskField,
                                  ),
                                  Text(
                                    'Categories (min. 1)',
                                    style: TextStyle(
                                        color: GlobalVar.baseColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  ListView(
                                    shrinkWrap: true,
                                    children: <Widget>[
                                      CheckboxListTile(
                                        title: Text(
                                          'Trash Collection',
                                          style: TextStyle(
                                              color: GlobalVar.baseColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value: trashCollection,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            trashCollection = value ?? false;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        title: Text(
                                          'Nature Conservation',
                                          style: TextStyle(
                                              color: GlobalVar.baseColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value: natureConservation,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            natureConservation = value ?? false;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        title: Text(
                                          'Pollution Control',
                                          style: TextStyle(
                                              color: GlobalVar.baseColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value: pollutionControl,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            pollutionControl = value ?? false;
                                          });
                                        },
                                      ),
                                      CheckboxListTile(
                                        title: Text(
                                          'Other',
                                          style: TextStyle(
                                              color: GlobalVar.baseColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        value: other,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            other = value ?? false;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  if (_categoryError)
                                    Text(
                                      'Please select at least one category',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: _isFormValid()
                                            ? _handleSubmit
                                            : null,
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty
                                              .resolveWith<Color?>(
                                                  (Set<MaterialState> states) {
                                            if (states.contains(
                                                MaterialState.disabled)) {
                                              // Set the button color when it is disabled
                                              return Colors
                                                  .grey; // You can change this to any color you prefer
                                            }
                                            // Set the button color when it is enabled
                                            return GlobalVar
                                                .secondaryColorGreen; // Default enabled color
                                          }),
                                        ),
                                        child: Text(
                                          'Create Quest',
                                          style: TextStyle(
                                            color: GlobalVar.mainColor,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ));
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType? keyboardType]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: GlobalVar.baseColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        if (label == 'Reward')
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: GlobalVar.baseColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              decoration: InputDecoration(hintText: 'Insert $label'),
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(
                    7), // Batasan panjang input 7 digit
              ],
            ),
          ),
        if (_errorMessage.isNotEmpty && label == 'Reward')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ),
        if (label != 'Reward')
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: GlobalVar.baseColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              decoration: InputDecoration(hintText: 'Insert $label'),
              controller: controller,
              keyboardType: keyboardType,
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Level Requirements',
            style: TextStyle(fontSize: 18, color: GlobalVar.baseColor),
          ),
        ),
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: GlobalVar.baseColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedLevel,
            onChanged: (String? newValue) {
              setState(() {
                _selectedLevel = newValue;
                Provider.of<GlobalVar>(context, listen: false)
                    .updateNewQuestData('levelRequirements', newValue);
              });
            },
            items: _levelOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _buildTaskFields() {
    return Column(
      children: _taskControllers.asMap().entries.map((entry) {
        int index = entry.key;
        TextEditingController controller = entry.value;
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: GlobalVar.baseColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextFormField(
                      controller: controller,
                      decoration:
                          InputDecoration(hintText: 'Task ${index + 1}'),
                    ),
                  ),
                ),
                SizedBox(
                    width: 10), // SizedBox untuk memberikan jarak horizontal
                IconButton(
                  icon: Icon(Icons.remove_circle_outline_outlined),
                  onPressed: () => _removeTaskField(index),
                  color: GlobalVar.baseColor,
                ),
              ],
            ),
            SizedBox(
                height:
                    10), // SizedBox untuk memberikan jarak vertikal antar Row
          ],
        );
      }).toList(),
    );
  }
}
