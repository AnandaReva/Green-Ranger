import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _controllerTotalRangers = TextEditingController();
  final TextEditingController _controllerReward = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();

  final List<String> _levelOptions = [
    'Rookie',
    'Epic',
    'Legendary',
    'Mythrill'
  ];
  String? _selectedLevel;

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
    _controllerTotalRangers.text = globalVar.newQuestData['totalRangers'] ?? '';
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
    _controllerTotalRangers.addListener(() {
      globalVar.updateNewQuestData(
          'totalRangers', _controllerTotalRangers.text);
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
    return _controllerQuestName.text.isNotEmpty &&
        _controllerInstance.text.isNotEmpty &&
        _controllerAddress.text.isNotEmpty &&
        _controllerDuration.text.isNotEmpty &&
        _controllerTotalRangers.text.isNotEmpty &&
        _controllerReward.text.isNotEmpty &&
        _controllerDescription.text.isNotEmpty &&
        _selectedLevel != null &&
        _taskControllers.isNotEmpty &&
        _taskControllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        return Scaffold(
          extendBody: true,
          body: SingleChildScrollView(
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
                        _buildTextField(_controllerQuestName, 'Quest Name'),
                        _buildTextField(_controllerInstance, 'Instance'),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(_controllerDuration,
                                  'Duration (days)', TextInputType.number),
                            ),
                            SizedBox(
                                width:
                                    10), // Spacer between Duration and Total Rangers fields
                            Expanded(
                              child: _buildTextField(_controllerTotalRangers,
                                  'Total Rangers', TextInputType.number),
                            ),
                          ],
                        ),
                        _buildTextField(_controllerAddress, 'Address'),
                        _buildTextField(_controllerReward, 'Reward (IDR)'),
                        _buildTextField(_controllerDescription, 'Description'),
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
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _isFormValid() ? _handleSubmit : null,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
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
        );
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
        if (label == 'Address' || label == 'Description')
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: GlobalVar.baseColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              decoration: InputDecoration(hintText: 'Insert $label'),
              controller: controller,
              keyboardType: keyboardType,
              maxLines: 3,
              minLines: 3,
            ),
          ),
        if (label == 'Duration (days)' || label == 'Total Rangers')
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
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly // Hanya menerima input angka
              ],
            ),
          ),
        if (label != 'Address' &&
            label != 'Description' &&
            label != 'Duration (days)' &&
            label != 'Total Rangers')
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
          )
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

  void _handleSubmit() {
    if (_isFormValid()) {
      // Ambil nilai dari setiap field
      String questName = _controllerQuestName.text;
      String instance = _controllerInstance.text;
      String address = _controllerAddress.text;
      String duration = _controllerDuration.text;
      String totalRangers = _controllerTotalRangers.text;
      String reward = _controllerReward.text;
      String description = _controllerDescription.text;
      List<String> tasks =
          _taskControllers.map((controller) => controller.text).toList();
      String levelRequirements = _selectedLevel ??
          ''; // Pastikan tidak null, atau berikan nilai default jika null

      // Lakukan sesuatu dengan data yang telah dikumpulkan, misalnya mencetaknya
      print('Quest Name: $questName');
      print('Instance: $instance');
      print('Address: $address');
      print('Duration: $duration');
      print('Total Rangers: $totalRangers');
      print('Reward: $reward');
      print('Description: $description');
      print('Level Requirements: $levelRequirements');
      print('Tasks: $tasks');

      // Submit logic here
    } else {
      print('Form is not valid');
    }
  }
}
