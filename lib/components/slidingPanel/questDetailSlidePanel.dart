// ignore_for_file: prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:green_ranger/components/loadingUI.dart';
import 'package:green_ranger/components/succesConfirmation.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/mongoDB/questMongodb.dart';

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
                                    // jika dalam progress,
                                    if (questData['isOnProgress'] == false)
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

                                                // Condition: Execute only if the quest status is 'open' and user has no 'onProgress' quest
                                                if (status == 'open' &&
                                                    !hasOnProgressQuest) {
                                                  print(
                                                      'Execute pressed on quest id: ${questData['objectId'] ?? 'No data'}');

                                                  var objectId =
                                                      questData['objectId'];
                                                  setState(() {
                                                    GlobalVar.instance
                                                        .isLoading = true;
                                                  });

                                                  // Pastikan objectId bukan null
                                                  if (objectId != null) {
                                                    bool isSuccess =
                                                        await executeQuest(
                                                            objectId);

                                                    // Tindakan yang diambil setelah memanggil executeQuest
                                                    if (isSuccess) {
                                                      setState(() {
                                                        GlobalVar.instance
                                                            .isLoading = false;
                                                      });

                                                      print(
                                                          'Quest executed successfully');
                                                      // Tambahkan logika yang sesuai jika quest berhasil dieksekusi

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SuccessConfirmation(
                                                                  successMessage:
                                                                      "Quests Already registered as yours, You can complete the task's"),
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
                                                              .withOpacity(
                                                                  0.1), // black background color
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
                                                                            .bold, // Add this line
                                                                  ),
                                                                ),
                                                                backgroundColor:
                                                                    GlobalVar
                                                                        .mainColor);
                                                          },
                                                        );
                                                      }
                                                    }
                                                  } else {
                                                    print('Invalid quest id');
                                                  } //disini
                                                } else if (status == 'closed') {
                                                  print('closed');
                                                  if (mounted) {
                                                    showDialog(
                                                      context: context,
                                                      barrierColor: GlobalVar
                                                          .secondaryColorGreen
                                                          .withOpacity(
                                                              0.1), // black background color
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            content: Text(
                                                              'Quest is Closed.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: GlobalVar
                                                                    .secondaryColorPink,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold, // Add this line
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                GlobalVar
                                                                    .mainColor);
                                                      },
                                                    );
                                                  }
                                                } else {
                                                  if (mounted) {
                                                    showDialog(
                                                      context: context,
                                                      barrierColor: GlobalVar
                                                          .secondaryColorGreen
                                                          .withOpacity(
                                                              0.1), // black background color
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            content: Text(
                                                              'You already have a quest in progress.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: GlobalVar
                                                                    .secondaryColorPink,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold, // Add this line
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                GlobalVar
                                                                    .mainColor);
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
                                    else
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
                                                  ],
                                                ),
                                              ),
                                              if (questData != null &&
                                                  questData['tasks'] != null)
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
                                                          SizedBox(width: 5),
                                                          Checkbox(
                                                            value: _taskCheckedStates
                                                                        .length >
                                                                    i
                                                                ? _taskCheckedStates[
                                                                    i]
                                                                : false,
                                                            onChanged:
                                                                (bool? value) {
                                                              if (_taskCheckedStates
                                                                      .length <=
                                                                  i) {
                                                                _taskCheckedStates =
                                                                    List<
                                                                        bool>.filled(
                                                                  widget
                                                                      .globalVar
                                                                      .questDataSelected[
                                                                          'tasks']
                                                                      .length,
                                                                  false,
                                                                );
                                                              }
                                                              setState(() {
                                                                _taskCheckedStates[
                                                                        i] =
                                                                    value ??
                                                                        false;
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(width: 5),
                                                          SizedBox(
                                                            width: 250,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: GlobalVar
                                                                    .secondaryColorPuple,
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
                                                                      .baseColor,
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
                                          SizedBox(height: 10),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                int checkedCount =
                                                    _getCheckedTasksCount();
                                                // jika belum semua task dicentang maka belum bisa sybmit
                                                if (checkedCount <
                                                    questData['tasks'].length) {
                                                  if (mounted) {
                                                    showDialog(
                                                      context: context,
                                                      barrierColor: GlobalVar
                                                          .secondaryColorGreen
                                                          .withOpacity(
                                                              0.1), // black background color
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            content: Text(
                                                              'Please complete all the task first before submiting.',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: GlobalVar
                                                                    .secondaryColorPink,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold, // Add this line
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                GlobalVar
                                                                    .mainColor);
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        GlobalVar
                                                            .secondaryColorGreen), // Set background color
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                    8.0), // Add padding to the button content
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                    color: GlobalVar.mainColor,
                                                    fontSize:
                                                        30.0, // Use a floating-point literal for clarity
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
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
}
