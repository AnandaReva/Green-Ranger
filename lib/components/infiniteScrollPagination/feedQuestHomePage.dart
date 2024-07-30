// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/main.dart';
import 'package:green_ranger/mongoDB/questMongodb.dart';
import 'package:green_ranger/mongoDB/userQuestMongodb.dart';

import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class AvailableQuestList extends StatefulWidget {
  AvailableQuestList({Key? key}) : super(key: key);

  @override
  _AvailableQuestListState createState() => _AvailableQuestListState();
}

class _AvailableQuestListState extends State<AvailableQuestList> {
  late final PagingController<int, QuestFeedSummary> _pagingController;

  int numberOfItems = 0;
  DateTime? lastItemDate;

  final List<Color> questColors = [
    GlobalVar.secondaryColorGreen,
    GlobalVar.secondaryColorPuple,
    GlobalVar.secondaryColorPink,
  ];

  @override
  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 0);

    _pagingController.addPageRequestListener((pageKey) {
      // Hanya panggil _fetchData jika pageKey adalah 0
      if (pageKey == 0) {
        _fetchData(pageKey);
      } else {
        // Jika Anda memiliki logika lain untuk halaman lain, tambahkan di sini

        print('check ini');
      }
    });
  }

  Future<void> _fetchMoreData(int pageKey) async {
    // print("pageKey fetch more: $pageKey");

    try {
      String latestDate = '';
      String latestQuestName = '';

      latestDate = GlobalVar.instance.homePageQuestFeed?.isNotEmpty == true
          ? GlobalVar.instance.homePageQuestFeed!.last.date
          : '';
      latestQuestName = GlobalVar.instance.homePageQuestFeed?.isNotEmpty == true
          ? GlobalVar.instance.homePageQuestFeed!.last.questName
          : '';
      print(
          "latestDate : $latestDate , latestQuestName: $latestQuestName, ${GlobalVar.instance.homePageQuestFeed.length}, pageKey fetch more: $pageKey ");

      bool isSuccess = await QuestMongodb.fetchMoreQuestData(latestDate);

      if (!isSuccess) {
        _pagingController.error = "Failed to fetch quest data";
        return;
      }

      final allItems = GlobalVar.instance.homePageQuestFeed ?? [];

      if (allItems.isNotEmpty) {
        latestDate = allItems.last.date;
        latestQuestName = allItems.last.questName;
      }

      _pagingController.itemList = [];

      _pagingController.appendPage(
          allItems.cast<QuestFeedSummary>(), pageKey + 1);

      print(
          "Number of items after appending: ${_pagingController.itemList?.length}");
      print(
          'homePageQuestFeed length 2: ${GlobalVar.instance?.homePageQuestFeed?.length}');
    } catch (error) {
      _pagingController.error = error.toString();
    }
  }

  Future<void> _fetchData(int pageKey) async {
    print("_fetchData called with pageKey: $pageKey");

    try {
      // Fetch quest data from MongoDB
      bool isSuccess = await QuestMongodb.fetchQuestDataHomePage();

      if (!isSuccess) {
        // Handle fetch failure
        _pagingController.error = "Failed to fetch quest data";
        return;
      }

      // Retrieve the fetched items from the global variable
      final allItems = GlobalVar.instance.homePageQuestFeed ?? [];

      print('Total number of quests: ${GlobalVar.instance.totalFeedCount}');

      if (allItems.isNotEmpty) {
        // Accessing the date of the last item
        final lastItemDate = allItems.last.date;
        print('Date of the last item: $lastItemDate');
      }

      // Append data to _pagingController if itemList is empty or null
      if (_pagingController.itemList == null ||
          _pagingController.itemList!.isEmpty) {
        _pagingController.appendLastPage(allItems.cast<QuestFeedSummary>());
      }

      // Get the number of items currently in _pagingController
      int numberOfItems = allItems.length;
      print("Number of items Fetch Data: $numberOfItems");
    } catch (error) {
      // Set error to string representation of the error
      _pagingController.error = error.toString();
    }
  }

  void _unBookmarkMarkedQuest(QuestFeedSummary quest) async {
    String questId = quest.objectId;
    String userId = GlobalVar.instance.userLoginData['_id'].toHexString();

    questId = questId.replaceAll('ObjectId("', '').replaceAll('")', '');

    print("qustId: $questId, userId : $userId");

    bool isSuccess = await UserQuestMongodb.unBookMarkQuest(
        questId: questId, userId: userId);

    if (!isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to unbookmark quest, Try Again',
              textAlign: TextAlign.center),
          duration: Duration(seconds: 1),
        ),
      );

      return;
    }

    _refreshData();
  }

  void _addBookmarkMarkedQuest(QuestFeedSummary quest) async {
    String questId = quest.objectId;
    String userId = GlobalVar.instance.userLoginData['_id'].toHexString();

    questId = questId.replaceAll('ObjectId("', '').replaceAll('")', '');

    print("questId: $questId, userId : $userId");

    bool isSuccess = await UserQuestMongodb.addBookmarkQuest(
      questId: questId,
      userId: userId,
    );

    if (!isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to bookmark quest. Please try again.',
              textAlign: TextAlign.center),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    _refreshData();
  }

  Future<void> _refreshData() async {
    _pagingController.refresh();
    print("_refreshData called");
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: PagedListView<int, QuestFeedSummary>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<QuestFeedSummary>(
                  itemBuilder: (context, item, index) {
                    // Check if current item is the last one
                    return Column(
                      children: [
                        QuestListItem(
                          quest: item,
                          colorPattern: questColors[index % questColors.length],
                          unBookmarkCallback: _unBookmarkMarkedQuest,
                          addBookmarkCallback: _addBookmarkMarkedQuest,
                        ),
                     

                        // Conditional widget based on index
                        if (index == _pagingController.itemList!.length - 1 &&
                            index < GlobalVar.instance.totalFeedCount - 1)
                          TextButton(
                            onPressed: () {
                              _fetchMoreData(
                                  _pagingController.nextPageKey ?? 0);
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                color: GlobalVar.mainColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '${GlobalVar.instance.homePageQuestFeed?.length}/${GlobalVar.instance.totalFeedCount}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: GlobalVar.baseColor,
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Load More',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: GlobalVar.secondaryColorGreen,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.refresh,
                                        size: 20,
                                        color: GlobalVar.secondaryColorGreen,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (index ==
                                _pagingController.itemList!.length - 1 &&
                            index == GlobalVar.instance.totalFeedCount - 1)
                          // Show available quests text at the end
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Text(
                              '${GlobalVar.instance.homePageQuestFeed?.length}/${GlobalVar.instance.totalFeedCount}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: GlobalVar.baseColor,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                  noItemsFoundIndicatorBuilder: (context) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No quests found, please try again',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: GlobalVar.baseColor,
                            ),
                          ),
                          IconButton(
                            onPressed: _refreshData,
                            icon: Icon(
                              Icons.refresh,
                              size: 24,
                              color: GlobalVar.baseColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestListItem extends StatelessWidget {
  final QuestFeedSummary quest;
  final Color colorPattern;
  final Function(QuestFeedSummary) unBookmarkCallback;
  final Function(QuestFeedSummary) addBookmarkCallback;

  const QuestListItem({
    Key? key,
    required this.quest,
    required this.colorPattern,
    required this.unBookmarkCallback,
    required this.addBookmarkCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<GlobalVar>(context, listen: false).questDataSelected = {
          'objectId': quest.objectId,
          'questName': quest.questName,
          'instance': quest.instance,
          'tasks': quest.taskList,
          'address': quest.address,
          'duration': quest.duration,
          'maxRangers': quest.maxRangers,
          'reward': quest.reward,
          'levelRequirements': quest.levelRequirements,
          'description': quest.description,
          'date': quest.date,
          'status': quest.status,
          'contact': quest.questOwnerPhone,
          'rangers': quest.rangers,
          'userId': quest.userId,
          'isBookmarked': quest.isBookmarked,
          'isOnProgress': quest.isOnProgress,
          'isCompleted': quest.isCompleted
        };

        // print(
        //     '${quest.questName} : isCOmplete,${quest.isCompleted}  ,  isOnprogress ${quest.isOnProgress}');

        MainPageState? mainPageState = MainPage.of(context);
        mainPageState.onTapController.add(() {
          mainPageState.panelController.expand();
        });
      },
      child: Card(
        margin: EdgeInsets.all(8),
        color: colorPattern,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            quest.questName,
                            style: TextStyle(
                              fontSize: 13,
                              color: GlobalVar.mainColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            quest.isBookmarked
                                ? Icons.bookmark_add // saat true
                                : Icons.bookmark_outline, // saat false
                            color: GlobalVar.mainColor,
                          ),
                          onPressed: () {
                            // Add your bookmark functionality here
                            if (quest.isBookmarked) {
                              // Remove bookmark logic
                              unBookmarkCallback(quest);
                              // UserQuestPageState userQuestPageState =
                              //     UserQuestPageState();
                              // userQuestPageState(); // refresh list
                            } else {
                              // Add bookmark logic
                              addBookmarkCallback(quest);
                            }
                          },
                        ),
                        if (quest.isOnProgress) ...[
                          IconButton(
                            onPressed: () {
                              // Tidak melakukan apapun
                            },
                            icon: SizedBox(
                              height: 24, // Sesuaikan ukuran tinggi gambar
                              child: Image.asset(
                                "assets/images/timeIcon.png", // Pastikan path benar
                              ),
                            ),
                            color: GlobalVar.mainColor,
                          ),
                        ] else if (quest.isCompleted) ...[
                          IconButton(
                            onPressed: () {
                              // Tidak melakukan apapun
                            },
                            icon: SizedBox(
                              height: 24, // Sesuaikan ukuran tinggi gambar
                              child: Image.asset(
                                "assets/images/checkMarkIcon.png", // Pastikan path benar
                              ),
                            ),
                            color: GlobalVar.mainColor,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      '${quest.instance}',
                      style: TextStyle(
                        fontSize: 12,
                        color: GlobalVar.mainColor,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Rp.${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: '').format(int.parse(quest.reward))}',
                      style: TextStyle(
                        fontSize: 15,
                        color: GlobalVar.mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: GlobalVar.mainColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: EdgeInsets.only(right: 8),
                          child: Text(
                            'Lvl ${quest.levelRequirements}',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorPattern,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: GlobalVar.mainColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          margin: EdgeInsets.only(right: 8),
                          child: Text(
                            '${quest.duration} days',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorPattern,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: GlobalVar.mainColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            '${quest.maxRangers} Peoples',
                            style: TextStyle(
                              fontSize: 10,
                              color: colorPattern,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Image.asset(
                "assets/images/cartIcon.png",
                width: 80,
                height: 90,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestFeedSummary {
  final objectId;
  final String questName;
  final String instance;
  final String duration;
  final String maxRangers;
  final String levelRequirements;
  final String reward;
  final String description;
  final List<String> taskList;
  final String address;
  final String date;
  final List<String> rangers;
  final String userId;
  final List<String> categories;
  final String status;
  final String questOwnerPhone;
  final bool isBookmarked;
  final bool isOnProgress;
  final bool isCompleted;

  QuestFeedSummary(
      {required this.objectId,
      required this.questName,
      required this.instance,
      required this.duration,
      required this.maxRangers,
      required this.levelRequirements,
      required this.reward,
      required this.description,
      required this.taskList,
      required this.address,
      required this.date,
      required this.rangers,
      required this.userId,
      required this.categories,
      required this.status,
      required this.questOwnerPhone,
      required this.isBookmarked,
      required this.isOnProgress,
      required this.isCompleted});
}
