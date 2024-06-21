// // ignore_for_file: sort_child_properties_last, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
// import 'package:green_ranger/globalVar.dart';
// import 'package:provider/provider.dart';

// class QuestReportSlidePanel extends StatefulWidget {
//   final SlidingUpPanelController panelController;
//   final GlobalVar globalVar;

//   QuestReportSlidePanel(
//       {required this.panelController, required this.globalVar});

//   @override
//   QuestReportSlidePanelState createState() => QuestReportSlidePanelState();
// }

// class QuestReportSlidePanelState extends State<QuestReportSlidePanel>
//     with SingleTickerProviderStateMixin {
//   final ScrollController scrollController = ScrollController();
//   late AnimationController _animationController;
//   bool isDisposed = false;

//   final double minBound = 0;
//   final double upperBound = 1.0;
//   List<bool> _taskCheckedStates = [];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );
//     _initializeTaskCheckedStates();
//     print('scrollController and animationController initialized');
//   }

//   void _initializeTaskCheckedStates() {
//     if (widget.globalVar.questDataSelected != null &&
//         widget.globalVar.questDataSelected['tasks'] != null) {
//       setState(() {
//         _taskCheckedStates = List<bool>.filled(
//             widget.globalVar.questDataSelected['tasks'].length, false);
//       });
//     }
//   }

//   int _getCheckedTasksCount() {
//     return _taskCheckedStates.where((task) => task).length;
//   }

//   @override
//   void dispose() {
//     isDisposed = true;
//     scrollController.dispose();
//     _animationController.dispose();
//     super.dispose();
//     print('panel and animationController disposed');
//   }

//   // dont change style

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<GlobalVar>(
//       builder: (context, globalVar, _) {
//         Map<String, dynamic> questData = globalVar.questDataSelected ?? {};

//         return SlidingUpPanelWidget(
//           panelController: widget.panelController,
//           child: Container(
//             width: double.infinity,
//             decoration: ShapeDecoration(
//               color: Color.fromRGBO(50, 51, 50, 1),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20.0),
//                   topRight: Radius.circular(20.0),
//                 ),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   child: Row(
//                     children: <Widget>[
//                       Icon(
//                         Icons.arrow_drop_down,
//                         size: 30,
//                         color: GlobalVar.baseColor,
//                       ),
//                       SizedBox(width: 8.0),
//                       Text(
//                         'Close',
//                         style: TextStyle(
//                           color: GlobalVar.baseColor,
//                         ),
//                       ),
//                     ],
//                     mainAxisAlignment: MainAxisAlignment.start,
//                   ),
//                   height: 50.0,
//                 ),
//                 Divider(
//                   height: 0.5,
//                   color: GlobalVar.baseColor,
//                 ),
//                 Flexible(
//                   child: questData.isEmpty
//                       ? Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: 20.0, horizontal: 10),
//                           child: Center(
//                             child: Column(
//                               children: [
//                                 SizedBox(height: 40),
//                                 Text(
//                                   'Oops! No Quest Selected Yet',
//                                   style: TextStyle(
//                                     color: GlobalVar.secondaryColorGreen,
//                                     fontSize: 24,
//                                     fontStyle: FontStyle.italic,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 30),
//                                 Image.asset(
//                                   'assets/images/tutorialIcon1.png',
//                                   width: 300,
//                                 ),
//                                 SizedBox(height: 20),
//                                 Text(
//                                   'Pick a Quest First to See Detail',
//                                   style: TextStyle(
//                                     color: GlobalVar.secondaryColorGreen,
//                                     fontSize: 18,
//                                     fontStyle: FontStyle.italic,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )
//                       : Container(
//                           padding: EdgeInsets.all(20),
//                           child: ListView(
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Image.asset(
//                                         'assets/images/diamondIcon.png',
//                                         width: 30,
//                                       ),
//                                       SizedBox(width: 10),
//                                       Text(
//                                         questData['instance'] ?? 'No data',
//                                         style: TextStyle(
//                                           color: GlobalVar.baseColor,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 5),
//                                   Row(
//                                     children: [
//                                       Image.asset(
//                                         'assets/images/noteIcon.png',
//                                         width: 22,
//                                       ),
//                                       SizedBox(width: 5),
//                                       Text(
//                                         questData['questName'] ?? 'No data',
//                                         style: TextStyle(
//                                           color: GlobalVar.baseColor,
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 10),
//                                   Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(horizontal: 30),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           margin: EdgeInsets.only(bottom: 8),
//                                           child: Divider(
//                                             color: GlobalVar.baseColor,
//                                             thickness: 2,
//                                             endIndent: 32,
//                                           ),
//                                         ),
//                                         Text(
//                                           questData['description'] ?? 'No data',
//                                           style: TextStyle(
//                                             color: GlobalVar.baseColor,
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(height: 10),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Image.asset(
//                                             'assets/images/taskIcon.png',
//                                             width: 22,
//                                           ),
//                                           SizedBox(width: 5),
//                                           Text(
//                                             "Task",
//                                             style: TextStyle(
//                                               color: GlobalVar.baseColor,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 14,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 30),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               margin:
//                                                   EdgeInsets.only(bottom: 8),
//                                               child: Divider(
//                                                 color: GlobalVar.baseColor,
//                                                 thickness: 2,
//                                                 endIndent: 32,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       if (questData != null &&
//                                           questData['tasks'] != null)
//                                         for (int i = 0;
//                                             i < questData['tasks'].length;
//                                             i++)
//                                           Column(
//                                             children: [
//                                               SizedBox(height: 5),
//                                               Row(
//                                                 children: [
//                                                   SizedBox(width: 5),
//                                                   Checkbox(
//                                                     value: _taskCheckedStates
//                                                                 .length >
//                                                             i
//                                                         ? _taskCheckedStates[i]
//                                                         : false,
//                                                     onChanged: (bool? value) {
//                                                       if (_taskCheckedStates
//                                                               .length <=
//                                                           i) {
//                                                         _taskCheckedStates =
//                                                             List<bool>.filled(
//                                                           widget
//                                                               .globalVar
//                                                               .questDataSelected[
//                                                                   'tasks']
//                                                               .length,
//                                                           false,
//                                                         );
//                                                       }
//                                                       setState(() {
//                                                         _taskCheckedStates[i] =
//                                                             value ?? false;
//                                                       });
//                                                     },
//                                                   ),
//                                                   SizedBox(width: 5),
//                                                   SizedBox(
//                                                     width: 250,
//                                                     child: Container(
//                                                       decoration: BoxDecoration(
//                                                         color: GlobalVar
//                                                             .secondaryColorPuple,
//                                                       ),
//                                                       padding:
//                                                           EdgeInsets.all(8.0),
//                                                       child: Text(
//                                                         questData['tasks'][i] ??
//                                                             'No data',
//                                                         style: TextStyle(
//                                                           color: GlobalVar
//                                                               .baseColor,
//                                                           fontWeight:
//                                                               FontWeight.w400,
//                                                           fontSize: 14,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 10),
//                                   SizedBox(height: 10),
//                                   Center(
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         int checkedCount =
//                                             _getCheckedTasksCount();
//                                         // jika belum semua task dicentang maka belum bisa sybmit
//                                         if (checkedCount <
//                                             questData['tasks'].length) {
//                                           if (mounted) {
//                                             showDialog(
//                                               context: context,
//                                               barrierColor: GlobalVar
//                                                   .secondaryColorGreen
//                                                   .withOpacity(
//                                                       0.1), // black background color
//                                               builder: (context) {
//                                                 return AlertDialog(
//                                                     content: Text(
//                                                       'Please complete all the task first before submiting.',
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                       style: TextStyle(
//                                                         color: GlobalVar
//                                                             .secondaryColorPink,
//                                                         fontWeight: FontWeight
//                                                             .bold, // Add this line
//                                                       ),
//                                                     ),
//                                                     backgroundColor:
//                                                         GlobalVar.mainColor);
//                                               },
//                                             );
//                                           }
//                                         }
//                                       },
//                                       style: ButtonStyle(
//                                         backgroundColor:
//                                             MaterialStateProperty.all(GlobalVar
//                                                 .secondaryColorGreen), // Set background color
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(
//                                             8.0), // Add padding to the button content
//                                         child: Text(
//                                           "Submit",
//                                           style: TextStyle(
//                                             color: GlobalVar.mainColor,
//                                             fontSize:
//                                                 30.0, // Use a floating-point literal for clarity
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                 ),
//               ],
//               mainAxisSize: MainAxisSize.min,
//             ),
//           ),
//           controlHeight: 0,
//         );
//       },
//     );
//   }
// }
