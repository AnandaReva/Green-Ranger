// ignore_for_file: prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_const_constructors

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:green_ranger/components/loadingUI.dart';
import 'package:green_ranger/components/succesConfirmation.dart';
import 'package:green_ranger/firebase/uploadResultReport.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/main.dart';
import 'package:green_ranger/mongoDB/questMongodb.dart';
import 'package:green_ranger/mongoDB/resultReportMongodb.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class QuestDetailSlidePanel extends StatefulWidget {
  final SlidingUpPanelController panelController;
  dynamic globalVar;

  QuestDetailSlidePanel(
      {required this.panelController, required this.globalVar});

  @override
  QuestDetailSlidePanelState createState() => QuestDetailSlidePanelState();
}

class QuestDetailSlidePanelState extends State<QuestDetailSlidePanel>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late AnimationController _animationController;
  bool isDisposed = false;
  List<bool> _taskCheckedStates = [];

  final double minBound = 0;
  final double upperBound = 1.0;
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _initializeTaskCheckedStates();
    print('scrollController and animationController initialized');
  }

  void _initializeTaskCheckedStates() {
    if (widget.globalVar.questDataSelected != null &&
        widget.globalVar.questDataSelected['tasks'] != null) {
      setState(() {
        _taskCheckedStates = List<bool>.filled(
            widget.globalVar.questDataSelected['tasks'].length, false);
      });
    }
  }

  int _getCheckedTasksCount() {
    return _taskCheckedStates.where((task) => task).length;
  }

  @override
  void dispose() {
    isDisposed = true;
    scrollController.dispose();
    _animationController.dispose();
    super.dispose();
    print('panel and animationController disposed');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        Map<String, dynamic> questData = globalVar.questDataSelected ?? {};

        return SlidingUpPanelWidget(
          panelController: widget.panelController, // Add this line
          child: Container(
            width: double.infinity,

            // margin: EdgeInsets.only(top: 10.0),
            // margin: EdgeInsets.only(top: questData != null ? 50.0 : 20.0),
            decoration: ShapeDecoration(
              color: Color.fromRGBO(50, 51, 50, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
            child: globalVar.isLoading
                ? LoadingUi()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                              color: GlobalVar.baseColor,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              'Close',
                              // textAlign: TextAlign.end,
                              style: TextStyle(
                                color: GlobalVar.baseColor,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        height: 50.0,
                      ),
                      Divider(
                        height: 0.5,
                        color: GlobalVar.baseColor,
                      ),
                      Flexible(
                        child: questData.isEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10),
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 40),
                                      Text(
                                        'Oops! No Quest Selected Yet',
                                        style: TextStyle(
                                          color: GlobalVar.secondaryColorGreen,
                                          fontSize: 24,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Image.asset(
                                        'assets/images/tutorialIcon1.png',
                                        width: 300,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Pick a Quest First to See Detail',
                                        style: TextStyle(
                                          color: GlobalVar.secondaryColorGreen,
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(20),
                                child: ListView(
                                  children: [
                                    // jika dalam progress atau completed tampilkna section ini,
                                    if (questData['isOnProgress'] == false  && questData['isCompleted'] == false  ) // execute
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/diamondIcon.png',
                                                width: 30,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                questData['instance'] ??
                                                    'No data',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/noteIcon.png',
                                                width: 22,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                questData['questName'] ??
                                                    'No data',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 8),
                                                  child: Divider(
                                                    color: Colors.grey,
                                                    thickness: 2,
                                                    endIndent: 32,
                                                  ),
                                                ),
                                                Text(
                                                  questData['description'] ??
                                                      'No data',
                                                  style: TextStyle(
                                                    color: GlobalVar.baseColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/taskIcon.png',
                                                    width: 22,
                                                  ),
                                                  SizedBox(width: 5),
                                                  SizedBox(
                                                    width: 250,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            GlobalVar.baseColor,
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        (questData != null &&
                                                                questData[
                                                                        'tasks'] !=
                                                                    null &&
                                                                questData[
                                                                        'tasks']
                                                                    .isNotEmpty)
                                                            ? questData['tasks']
                                                                    [0] ??
                                                                'No data'
                                                            : 'No data',
                                                        style: TextStyle(
                                                          color: GlobalVar
                                                              .mainColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (questData != null &&
                                                  questData['tasks'] != null)
                                                for (int i = 1;
                                                    i <
                                                        questData['tasks']
                                                            .length;
                                                    i++)
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/taskIcon.png',
                                                            width: 22,
                                                          ),
                                                          SizedBox(width: 5),
                                                          SizedBox(
                                                            width: 250,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: GlobalVar
                                                                    .baseColor,
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                questData['tasks']
                                                                        [i] ??
                                                                    'No data',
                                                                style:
                                                                    TextStyle(
                                                                  color: GlobalVar
                                                                      .mainColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            // Ini adalah Row utama
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/prizeIcon.png',
                                                        width: 22,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        'Rewards',
                                                        style: TextStyle(
                                                          color: GlobalVar
                                                              .baseColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width:
                                                            150, // Set the desired width here
                                                        height: 35,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: GlobalVar
                                                              .mainColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start, // Align children to the start
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/coinIcon.png",
                                                              width:
                                                                  30, // Reduced image width
                                                            ),
                                                            SizedBox(width: 5),
                                                            Consumer<GlobalVar>(
                                                              builder: (context,
                                                                  globalVar,
                                                                  _) {
                                                                Map<String,
                                                                        dynamic>
                                                                    questData =
                                                                    globalVar
                                                                            .questDataSelected ??
                                                                        {};

                                                                // Ensure questData['reward'] can be parsed to integer
                                                                int rewardAmount =
                                                                    int.tryParse(questData['reward'] ??
                                                                            '0') ??
                                                                        0;

                                                                return Text(
                                                                  'Rp. ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: '').format(rewardAmount)}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12, // Reduced font size
                                                                    color: GlobalVar
                                                                        .secondaryColorGreen,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  softWrap:
                                                                      true, // Ensures text wraps within the row
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/calendarIcon.png',
                                                        width: 22,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'Date & Duration',
                                                        style: TextStyle(
                                                          color: GlobalVar
                                                              .baseColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          GlobalVar.baseColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Text(
                                                      questData['date'] != null
                                                          ? DateFormat(
                                                                  'E, dd MMM yyyy \'at\' HH:mm')
                                                              .format(DateTime
                                                                  .parse(questData[
                                                                      'date']))
                                                          : 'No data',
                                                      style: TextStyle(
                                                        color:
                                                            GlobalVar.mainColor,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    '${questData['duration'] ?? ''} days',
                                                    style: TextStyle(
                                                      color:
                                                          GlobalVar.baseColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  width:
                                                      5), // Tambahkan spasi horizontal di sini
                                              Image.asset(
                                                'assets/images/discussionIcon.png',
                                                height: 75,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/locationIcon.png',
                                                width: 22,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'Location',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            questData['address'] ?? 'No data',
                                            style: TextStyle(
                                              color: GlobalVar.baseColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/personIcon.png',
                                                width: 22,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'RSVP',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            questData['contact'] ?? 'No data',
                                            style: TextStyle(
                                              color: GlobalVar.baseColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                var status =
                                                    questData['status'] ??
                                                        'No data';
                                                bool hasOnProgressQuest =
                                                    globalVar
                                                            .userLoginData[
                                                                'quest']
                                                                ['onProgress']
                                                            .length >
                                                        0;

                                                var userLoginId = GlobalVar
                                                    .instance
                                                    .userLoginData['_id']
                                                    .toHexString();
                                                var questOwnerId =
                                                    questData['userId'];

                                                print(
                                                    'Execute pressed on quest id: ${questData['objectId'] ?? 'No data'}, userLoginId: $userLoginId, questOwnerId: $questOwnerId');

                                                // Check if user is the owner
                                                if (userLoginId ==
                                                    questOwnerId) {
                                                  // Disable the button with text "You Are The Owner"
                                                  if (mounted) {
                                                    showDialog(
                                                      context: context,
                                                      barrierColor: GlobalVar
                                                          .secondaryColorGreen
                                                          .withOpacity(0.1),
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            'You Are The Owner of this Quest.',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: GlobalVar
                                                                  .secondaryColorPink,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              GlobalVar
                                                                  .mainColor,
                                                        );
                                                      },
                                                    );
                                                  }
                                                  return;
                                                }

                                                // Condition: Execute only if the quest status is 'open' and user has no 'onProgress' quest
                                                if (status == 'open' &&
                                                    !hasOnProgressQuest) {
                                                  var objectId =
                                                      questData['objectId'];
                                                  setState(() {
                                                    GlobalVar.instance
                                                        .isLoading = true;
                                                  });

                                                  // Make sure objectId is not null
                                                  if (objectId != null) {
                                                    bool isSuccess =
                                                        await executeQuest(
                                                            objectId);

                                                    // Actions after executing executeQuest
                                                    if (isSuccess) {
                                                      setState(() {
                                                        GlobalVar.instance
                                                            .isLoading = false;
                                                      });

                                                      print(
                                                          'Quest executed successfully');
                                                      // Add appropriate logic if quest is successfully executed

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SuccessConfirmation(
                                                            successMessage:
                                                                "Quests Already registered as yours, You can complete the task's",
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      setState(() {
                                                        GlobalVar.instance
                                                            .isLoading = false;
                                                      });

                                                      print(
                                                          'Failed to execute quest');

                                                      if (mounted) {
                                                        showDialog(
                                                          context: context,
                                                          barrierColor: GlobalVar
                                                              .secondaryColorGreen
                                                              .withOpacity(0.1),
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              content: Text(
                                                                'Failed When Executing Quest, Try Again.',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: GlobalVar
                                                                      .secondaryColorPink,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  GlobalVar
                                                                      .mainColor,
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }
                                                  } else {
                                                    print('Invalid quest id');
                                                  }
                                                } else if (status == 'closed') {
                                                  print('closed');
                                                  if (mounted) {
                                                    showDialog(
                                                      context: context,
                                                      barrierColor: GlobalVar
                                                          .secondaryColorGreen
                                                          .withOpacity(0.1),
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            'Quest is Closed.',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: GlobalVar
                                                                  .secondaryColorPink,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              GlobalVar
                                                                  .mainColor,
                                                        );
                                                      },
                                                    );
                                                  }
                                                } else {
                                                  if (mounted) {
                                                    showDialog(
                                                      context: context,
                                                      barrierColor: GlobalVar
                                                          .secondaryColorGreen
                                                          .withOpacity(0.1),
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            'You already have a quest in progress.',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: GlobalVar
                                                                  .secondaryColorPink,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              GlobalVar
                                                                  .mainColor,
                                                        );
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) {
                                                  if (questData['status'] ==
                                                      'open') {
                                                    return GlobalVar
                                                        .secondaryColorGreen;
                                                  } else if (questData[
                                                          'status'] ==
                                                      'closed') {
                                                    return Colors
                                                        .grey; // Adjust color for closed state
                                                  }
                                                  return GlobalVar
                                                      .secondaryColorGreen; // Default color
                                                }),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  questData['status'] ==
                                                          'closed'
                                                      ? 'Closed'
                                                      : 'Execute it!',
                                                  style: TextStyle(
                                                    color: questData[
                                                                'status'] ==
                                                            'closed'
                                                        ? GlobalVar.baseColor
                                                        : GlobalVar.mainColor,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else if (questData['isCompleted'] == true) // completed
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/diamondIcon.png',
                                                width: 30,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                questData['instance'] ??
                                                    'No data',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/noteIcon.png',
                                                width: 22,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                questData['questName'] ??
                                                    'No data',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 8),
                                                  child: Divider(
                                                    color: Colors.grey,
                                                    thickness: 2,
                                                    endIndent: 32,
                                                  ),
                                                ),
                                                Text(
                                                  questData['description'] ??
                                                      'No data',
                                                  style: TextStyle(
                                                    color: GlobalVar.baseColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/taskIcon.png',
                                                    width: 22,
                                                  ),
                                                  SizedBox(width: 5),
                                                  SizedBox(
                                                    width: 250,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            GlobalVar.baseColor,
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        (questData != null &&
                                                                questData[
                                                                        'tasks'] !=
                                                                    null &&
                                                                questData[
                                                                        'tasks']
                                                                    .isNotEmpty)
                                                            ? questData['tasks']
                                                                    [0] ??
                                                                'No data'
                                                            : 'No data',
                                                        style: TextStyle(
                                                          color: GlobalVar
                                                              .mainColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (questData != null &&
                                                  questData['tasks'] != null)
                                                for (int i = 1;
                                                    i <
                                                        questData['tasks']
                                                            .length;
                                                    i++)
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 5),
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/images/taskIcon.png',
                                                            width: 22,
                                                          ),
                                                          SizedBox(width: 5),
                                                          SizedBox(
                                                            width: 250,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: GlobalVar
                                                                    .baseColor,
                                                              ),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                questData['tasks']
                                                                        [i] ??
                                                                    'No data',
                                                                style:
                                                                    TextStyle(
                                                                  color: GlobalVar
                                                                      .mainColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            // Ini adalah Row utama
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/prizeIcon.png',
                                                        width: 22,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        'Rewards',
                                                        style: TextStyle(
                                                          color: GlobalVar
                                                              .baseColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width:
                                                            150, // Set the desired width here
                                                        height: 35,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: GlobalVar
                                                              .mainColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start, // Align children to the start
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/coinIcon.png",
                                                              width:
                                                                  30, // Reduced image width
                                                            ),
                                                            SizedBox(width: 5),
                                                            Consumer<GlobalVar>(
                                                              builder: (context,
                                                                  globalVar,
                                                                  _) {
                                                                Map<String,
                                                                        dynamic>
                                                                    questData =
                                                                    globalVar
                                                                            .questDataSelected ??
                                                                        {};

                                                                // Ensure questData['reward'] can be parsed to integer
                                                                int rewardAmount =
                                                                    int.tryParse(questData['reward'] ??
                                                                            '0') ??
                                                                        0;

                                                                return Text(
                                                                  'Rp. ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: '').format(rewardAmount)}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        12, // Reduced font size
                                                                    color: GlobalVar
                                                                        .secondaryColorGreen,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  softWrap:
                                                                      true, // Ensures text wraps within the row
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/calendarIcon.png',
                                                        width: 22,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        'Date & Duration',
                                                        style: TextStyle(
                                                          color: GlobalVar
                                                              .baseColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          GlobalVar.baseColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Text(
                                                      questData['date'] != null
                                                          ? DateFormat(
                                                                  'E, dd MMM yyyy \'at\' HH:mm')
                                                              .format(DateTime
                                                                  .parse(questData[
                                                                      'date']))
                                                          : 'No data',
                                                      style: TextStyle(
                                                        color:
                                                            GlobalVar.mainColor,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    '${questData['duration'] ?? ''} days',
                                                    style: TextStyle(
                                                      color:
                                                          GlobalVar.baseColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  width:
                                                      5), // Tambahkan spasi horizontal di sini
                                              Image.asset(
                                                'assets/images/discussionIcon.png',
                                                height: 75,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/locationIcon.png',
                                                width: 22,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'Location',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            questData['address'] ?? 'No data',
                                            style: TextStyle(
                                              color: GlobalVar.baseColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/personIcon.png',
                                                width: 22,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'RSVP',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            questData['contact'] ?? 'No data',
                                            style: TextStyle(
                                              color: GlobalVar.baseColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed:
                                                  null, // Disable the button
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            Colors.grey),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Quest Completed',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    else if (questData['isOnProgress'] == true) // submit
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/diamondIcon.png',
                                                width: 30,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                questData['instance'] ??
                                                    'No data',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/noteIcon.png',
                                                width: 22,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                questData['questName'] ??
                                                    'No data',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 8),
                                                  child: Divider(
                                                    color: GlobalVar.baseColor,
                                                    thickness: 2,
                                                    endIndent: 32,
                                                  ),
                                                ),
                                                Text(
                                                  questData['description'] ??
                                                      'No data',
                                                  style: TextStyle(
                                                    color: GlobalVar.baseColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/taskIcon.png',
                                                    width: 22,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    "Task",
                                                    style: TextStyle(
                                                      color:
                                                          GlobalVar.baseColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 30),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 8),
                                                      child: Divider(
                                                        color:
                                                            GlobalVar.baseColor,
                                                        thickness: 2,
                                                        endIndent: 32,
                                                      ),
                                                    ),
                                                    if (questData != null &&
                                                        questData['tasks'] !=
                                                            null)
                                                      for (int i = 0;
                                                          i <
                                                              questData['tasks']
                                                                  .length;
                                                          i++)
                                                        Column(
                                                          children: [
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 210,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: GlobalVar
                                                                          .secondaryColorPuple,
                                                                    ),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                      questData['tasks']
                                                                              [
                                                                              i] ??
                                                                          'No data',
                                                                      style:
                                                                          TextStyle(
                                                                        color: GlobalVar
                                                                            .baseColor,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Checkbox(
                                                                  value: _taskCheckedStates
                                                                              .length >
                                                                          i
                                                                      ? _taskCheckedStates[
                                                                          i]
                                                                      : false,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    if (_taskCheckedStates
                                                                            .length <=
                                                                        i) {
                                                                      _taskCheckedStates =
                                                                          List<
                                                                              bool>.filled(
                                                                        widget
                                                                            .globalVar
                                                                            .questDataSelected['tasks']
                                                                            .length,
                                                                        false,
                                                                      );
                                                                    }
                                                                    setState(
                                                                        () {
                                                                      _taskCheckedStates[
                                                                              i] =
                                                                          value ??
                                                                              false;
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),

                                          _uploadSection(context),
                                          SizedBox(height: 10),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                int checkedCount =
                                                    _getCheckedTasksCount();
                                                // Jika belum semua task dicentang atau file kosong, tampilkan pesan
                                                if (checkedCount <
                                                        questData['tasks']
                                                            .length ||
                                                    _selectedFile == null) {
                                                  if (mounted) {
                                                    showDialog(
                                                      context: context,
                                                      barrierColor: GlobalVar
                                                          .secondaryColorGreen
                                                          .withOpacity(0.1),
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            'Please complete all the tasks and select a file before submitting.',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: GlobalVar
                                                                  .secondaryColorPink,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              GlobalVar
                                                                  .mainColor,
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(); // Close the dialog
                                                              },
                                                              child: Text(
                                                                'OK',
                                                                style:
                                                                    TextStyle(
                                                                  color: GlobalVar
                                                                      .secondaryColorPink,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  }
                                                } else {
                                                  var userId =
                                                      questData['userId'] ??
                                                          'No data';
                                                  var questId =
                                                      questData['objectId'] ??
                                                          'No data';
                                                  // questId =
                                                  //     questId.toHexString();
                                                  var rangerId = GlobalVar
                                                      .instance
                                                      .userLoginData['_id']
                                                      .toHexString();
                                                  onSubmitQuest(userId, questId,
                                                      rangerId);

                                                  // MainPageState mainPageState =
                                                  //     MainPage.of(context);

                                                  // mainPageState.onTapController
                                                  //     .add(() {
                                                  //   mainPageState
                                                  //       .panelController
                                                  //       .collapse();
                                                  // });
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        GlobalVar
                                                            .secondaryColorGreen),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                    color: GlobalVar.mainColor,
                                                    fontSize: 30.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),

                                          //submit
                                        ],
                                      ),
                                  ],
                                )),
                      ),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
          ),
          controlHeight: 0,
        );
      },
    );
  }

  Widget _uploadSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 0),
              Text(
                "Upload Results",
                style: TextStyle(
                  color: GlobalVar.baseColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Divider(
            color: GlobalVar.baseColor,
            thickness: 2,
            endIndent: 32,
          ),
          Container(
            width: 230,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: GlobalVar.baseColor,
                width: 2,
              ),
            ),
            child: ElevatedButton(
              onPressed: () async {
                File? pickedFile = await getFilesFromDevice(context);
                if (pickedFile != null) {
                  setState(() {
                    _selectedFile = pickedFile;
                  });
                  print('User picked file: ${_selectedFile!.path}');
                } else {
                  print('No file picked');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: GlobalVar.baseColor, width: 2),
                ),
              ),
              child: _selectedFile != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _selectedFile!.path.split('/').last,
                        style: TextStyle(
                          color: GlobalVar.secondaryColorGreen,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/uploadIcon.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> executeQuest(String objectId) async {
    try {
      // Ambil userId dari GlobalVar instance
      var userId = GlobalVar.instance.userLoginData['_id'].toHexString();

      print('user id: ${userId ?? 'No data'}');
      // Pastikan userId tidak null
      if (userId == null) {
        print('No userId provided');
        return false;
      }

      // Panggil fungsi executeQuestMongodb dan tunggu hasilnya
      bool isSuccess = await QuestMongodb.executeQuestMongodb(
        questId: objectId,
        userId: userId,
      );

      // Periksa hasil eksekusi
      if (!isSuccess) {
        print('Quest execution failed');
        return false;
      }

      print('Quest executed successfully');
      return true;
    } catch (e) {
      print('Error during quest execution: $e');
      return false;
    }
  }

  void onSubmitQuest(String userId, String questId, String rangerId) {
    if (mounted) {
      showDialog(
        context: context,
        barrierColor: GlobalVar.secondaryColorGreen.withOpacity(0.1),
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Are you sure you want to submit the quest report?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: GlobalVar.secondaryColorGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: GlobalVar.mainColor,
            actions: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          // Add your action for 'No' here
                          // For example, you can do nothing or show a message
                          print('User clicked No');
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: GlobalVar.secondaryColorPink,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () async {

                          Navigator.of(context).pop();

                          File? imageFile = _selectedFile;

                          if (imageFile != null) {
                            print(
                                'data upload userId: $userId,  questId: $questId , rangerId: $rangerId');

                            try {
                              setState(() {
                                GlobalVar.instance.isLoading = true;
                              });

                              String? url =
                                  await UploadResultReport.getDownloadUrl(
                                      questId, rangerId, imageFile);

                              if (url != null) {
                                print('Success Upload to firestorag URL: $url');

                                // Panggil metode uploadDataResultReport
                                bool success = await QuestResultReportMongodb
                                    .uploadDataResultReport(
                                        userId, questId, rangerId, url);

                                if (success) {
                                  print(
                                      'Data result report uploaded successfully');

                                  // Tampilkan snackbar jika menggunakan Flutter
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Data result report uploaded successfully')),
                                    );
                                  }
                                  // Collapse the panel

                                  setState(() {
                                    _selectedFile = null;
                                    _taskCheckedStates = List<bool>.filled(
                                        widget.globalVar
                                            .questDataSelected['tasks'].length,
                                        false);
                                    widget.panelController.collapse();
                                  });

                                  // panelController.Close();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SuccessConfirmation(
                                          successMessage:
                                              "Quest Report Has Been Sent!"),
                                    ),
                                  );
                                } else {
                                  print('Failed to upload data result report');
                                  // Tampilkan snackbar jika menggunakan Flutter
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to upload data result report')),
                                    );
                                  }
                                }

                                setState(() {
                                  GlobalVar.instance.isLoading = false;
                                });
                              } else {
                                print('Failed to get URL');
                                setState(() {
                                  GlobalVar.instance.isLoading = false;
                                });

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Error while uploading result report, please try again.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: GlobalVar.baseColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              // Tangkap error jika terjadi kesalahan dalam mendapatkan url
                              print('Error during getting download URL: $e');
                              setState(() {
                                GlobalVar.instance.isLoading = false;
                              });
                            }
                          } else {
                            // Handle jika file belum dipilih (imageFile == null)
                            print('No file selected');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: GlobalVar.mainColor,
                          backgroundColor: GlobalVar.secondaryColorGreen,
                        ),
                        child: Text('Yes'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<File?> getFilesFromDevice(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'webp',
          'png',
          'pdf',
          'doc',
          'docx',
          'mp4',
          'mov',
          'avi',
          'zip',
          'rar',
          'txt',
          'ppt',
        ],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      File file = File(result.files.single.path!);
      int fileSize = await file.length();

      if (fileSize > 20 * 1024 * 1024) {
        // File is too large, handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File size ecxeed 20 MB.'),
            duration: Duration(seconds: 3),
          ),
        );
        return null;
      }

      return file;
    } catch (e) {
      print('Error Image Picker: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          duration: Duration(seconds: 3),
        ),
      );
      return null;
    }
  }
}
