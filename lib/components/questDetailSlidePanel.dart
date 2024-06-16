// ignore_for_file: prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class QuestDetailSlidePanel extends StatefulWidget {
  final SlidingUpPanelController panelController;

  QuestDetailSlidePanel(
      {required this.panelController, required GlobalVar globalVar});



  /* 
    void expandPanel() {

    this.widget.panelController.expand();
  }

  void collapsePanel() {
    this.widget.panelController.collapse();
  }  */

  @override
  QuestDetailSlidePanelState createState() => QuestDetailSlidePanelState();
}

class QuestDetailSlidePanelState extends State<QuestDetailSlidePanel>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late AnimationController _animationController;
  bool isDisposed = false;

  final double minBound = 0;
  final double upperBound = 1.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    print('scrollController and animationController initialized');
  }

  @override
  void dispose() {
    isDisposed = true;
    scrollController.dispose();
    _animationController.dispose();
    super.dispose();
    print('panel and animationController disposed');
  }

  void _scrollListener() {
    if (!isDisposed) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        widget.panelController.expand();
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        widget.panelController.anchor();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalVar>(
      builder: (context, globalVar, _) {
        Map<String, dynamic> questData = globalVar.questDataSelected ?? {};

        return SlidingUpPanelWidget(
          child: Container(
            width: double.infinity,

            margin: EdgeInsets.only(top: 10.0),
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
            child: Column(
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
                        'See Quest Detail',
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/diamondIcon.png',
                                        width: 30,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        questData['instance'] ?? 'No data',
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
                                        questData['questName'] ?? 'No data',
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 8),
                                          child: Divider(
                                            color: Colors.grey,
                                            thickness: 2,
                                            endIndent: 32,
                                          ),
                                        ),
                                        Text(
                                          questData['description'] ?? 'No data',
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
                                                color: GlobalVar.baseColor,
                                              ),
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                (questData != null &&
                                                        questData['tasks'] !=
                                                            null &&
                                                        questData['tasks']
                                                            .isNotEmpty)
                                                    ? questData['tasks'][0] ??
                                                        'No data'
                                                    : 'No data',
                                                style: TextStyle(
                                                  color: GlobalVar.mainColor,
                                                  fontWeight: FontWeight.w400,
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
                                            i < questData['tasks'].length;
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
                                                      decoration: BoxDecoration(
                                                        color:
                                                            GlobalVar.baseColor,
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Text(
                                                        questData['tasks'][i] ??
                                                            'No data',
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
                                                  color: GlobalVar.baseColor,
                                                  fontWeight: FontWeight.w500,
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
                                                decoration: BoxDecoration(
                                                  color: GlobalVar.mainColor,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                                          globalVar, _) {
                                                        Map<String, dynamic>
                                                            questData =
                                                            globalVar
                                                                    .questDataSelected ??
                                                                {};

                                                        // Ensure questData['reward'] can be parsed to integer
                                                        int rewardAmount =
                                                            int.tryParse(questData[
                                                                        'reward'] ??
                                                                    '0') ??
                                                                0;

                                                        return Text(
                                                          'Rp. ${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: '').format(rewardAmount)}',
                                                          style: TextStyle(
                                                            fontSize:
                                                                12, // Reduced font size
                                                            color: GlobalVar
                                                                .secondaryColorGreen,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                'assets/images/calendarIcon.png',
                                                width: 22,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                'Date & Duration',
                                                style: TextStyle(
                                                  color: GlobalVar.baseColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: GlobalVar.baseColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              questData['date'] != null
                                                  ? DateFormat(
                                                          'E, dd MMM yyyy \'at\' HH:mm')
                                                      .format(DateTime.parse(
                                                          questData['date']))
                                                  : 'No data',
                                              style: TextStyle(
                                                color: GlobalVar.mainColor,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '${questData['duration'] ?? ''} days',
                                            style: TextStyle(
                                              color: GlobalVar.baseColor,
                                              fontWeight: FontWeight.w500,
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
                                    questData['address'] ?? 'No data',
                                    style: TextStyle(
                                      color: GlobalVar.baseColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print('Executed');
                                        // Tambahkan logika fungsi onPressed di sini
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                GlobalVar.secondaryColorGreen),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Execute it!',
                                          style: TextStyle(
                                            color: GlobalVar.mainColor,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          ),
          controlHeight: 50.0,
          anchor: 0.4,
          minimumBound: minBound,
          upperBound: upperBound,
          panelController: widget.panelController,
          onTap: () {
            if (!isDisposed) {
              if (widget.panelController.status ==
                  SlidingUpPanelStatus.expanded) {
                widget.panelController.collapse();
              } else {
                widget.panelController.expand();
              }
            }
          },
          enableOnTap: true,
        );
      },
    );
  }
}
