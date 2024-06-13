// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:provider/provider.dart';

class CreateQuest extends StatefulWidget {
  CreateQuest({Key? key}) : super(key: key);

  @override
  _CreateQuestState createState() => _CreateQuestState();
}

class _CreateQuestState extends State<CreateQuest> {
  final TextEditingController _controllerQuestName = TextEditingController();
  final TextEditingController _controllerInstance = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final List<TextEditingController> _taskControllers = [];

  void _addTaskField() {
    setState(() {
      _taskControllers.add(TextEditingController());
    });
  }

  void _removeTaskField(int index) {
    setState(() {
      _taskControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        return Scaffold(
          extendBody: true,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: GlobalVar.mainColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 55),
                        Text(
                          'Create Quest',
                          style: TextStyle(
                            fontSize: 30,
                            color: GlobalVar.baseColor,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Quest Name',
                          style: TextStyle(
                            fontSize: 14,
                            color: GlobalVar.baseColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: GlobalVar.baseColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 35,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _controllerQuestName,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Instance',
                          style: TextStyle(
                            fontSize: 14,
                            color: GlobalVar.baseColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: GlobalVar.baseColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 35,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _controllerInstance,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Tasks:',
                          style: TextStyle(
                            fontSize: 14,
                            color: GlobalVar.baseColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Column(
                          children: _taskControllers.asMap().entries.map((entry) {
                            int index = entry.key;
                            TextEditingController controller = entry.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: GlobalVar.baseColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 35,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        keyboardType: TextInputType.text,
                                        controller: controller,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _removeTaskField(index),
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _addTaskField,
                              icon: Icon(
                                Icons.add_box_outlined,
                                color: GlobalVar.baseColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 14,
                            color: GlobalVar.baseColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: GlobalVar.baseColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 70,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _controllerAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Insert Address',
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: GlobalVar.mainColor,
        );
      },
    );
  }
}
