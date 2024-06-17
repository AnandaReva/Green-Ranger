import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/main.dart';

import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key, required GlobalVar globalVar}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    GlobalVar globalVar = GlobalVar.instance;

    return MainPage();
  }
}
