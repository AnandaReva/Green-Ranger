// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/main.dart';
import 'package:green_ranger/mongoDB/userQuestMongodb.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserMarkedQuestList extends StatefulWidget {
  const UserMarkedQuestList({Key? key}) : super(key: key);

  @override
  _UserMarkedQuestListState createState() => _UserMarkedQuestListState();
}

class _UserMarkedQuestListState extends State<UserMarkedQuestList> {
  final List<Color> questColors = [
    GlobalVar.secondaryColorGreen,
    GlobalVar.secondaryColorPuple,
    GlobalVar.secondaryColorPink,
  ];

  late PagingController<int, MarkedQuestSummary> _pagingController;
  Map<String, bool> bookmarkStatus = {}; // Map to store bookmark status

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchMarkedQuests(pageKey);
    });
  }

  Future<void> _fetchMarkedQuests(int pageKey) async {
    try {
      // Fetch marked quests from MongoDB or any other source
      bool isSuccess = await UserQuestMongodb.fetchUserMarkedQuests();

      if (!isSuccess) {
        _pagingController.error = "Failed to fetch quest data";
        return;
      }

      final allItems = GlobalVar.instance.userMarkedQuest ?? [];
      final reversedItems = List.from(allItems.reversed); // Reverse the array

      // Clear existing data if it's the first page
      if (pageKey == 0) {
        _pagingController.itemList?.clear();
      }

      // Append data to _pagingController
      _pagingController
          .appendLastPage(reversedItems.cast<MarkedQuestSummary>());
    } catch (error) {
      print("Error fetching marked quests: $error");
      _pagingController.error = error.toString();
    }
  }

  void _unBookmarkMarkedQuest(MarkedQuestSummary quest) async {
    print('check 2 : $quest');
    bool isSuccess = await UserQuestMongodb.unBookMarkQuest(quest.objectId);

    if (!isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to unbookmark quest'),
          duration: Duration(seconds: 1), // Optional, specify the duration
        ),
      );
      setState(() {
        _pagingController.error = "Failed to unbookmark quest";
      });
      return;
    }

    // Update bookmark status in the map
    setState(() {
      bookmarkStatus[quest.objectId] = false;
    });

    _refreshList();
  }

  Future<void> _refreshList() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshList,
      child: PagedListView<int, MarkedQuestSummary>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<MarkedQuestSummary>(
          itemBuilder: (context, item, index) {
            bool isBookmarked = bookmarkStatus[item.objectId] ?? false;
            return QuestListItem(
              quest: item,
              colorPattern: questColors[index % questColors.length],
              isBookmark: isBookmarked,
              unBookmarkCallback: _unBookmarkMarkedQuest,
            );
          },
          noItemsFoundIndicatorBuilder: (context) {
            return Center(
              child: Text(
                'No marked quests found',
                style: TextStyle(color: GlobalVar.baseColor),
              ),
            );
          },
        ),
      ),
    );
  }
}

class QuestListItem extends StatelessWidget {
  final MarkedQuestSummary quest;
  final Color colorPattern;
  final bool isBookmark;
  final Function(MarkedQuestSummary) unBookmarkCallback;

  QuestListItem({
    Key? key,
    required this.quest,
    required this.colorPattern,
    required this.isBookmark,
    required this.unBookmarkCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MainPageState mainPageState = MainPage.of(context);

        mainPageState.onTapController.add(() {
          mainPageState.panelController.expand();
        });

        // print(
        //     ( 'disini' +GlobalVar.instance.homePageQuestFeed['isOnProgress']).runtimeType);

        // Handle tap event to update questDataSelected
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
          'rangers': quest.rangers,
          'contact': quest.questOwnerPhone,
          'isBookmarked': true,
          'isOnProgress': quest.isOnProgress,
          'isCompleted': quest.isCompleted
        };
      },
      child: Card(
        margin: EdgeInsets.all(8),
        color: colorPattern,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      isBookmark
                          ? Icons.bookmark_add_outlined
                          : Icons.bookmark_add,
                      color: GlobalVar.mainColor,
                    ),
                    onPressed: () {
                      unBookmarkCallback(quest);

                      print('check 1 : $quest');
                    },
                  ),
                ],
              ),
              Text(
                quest.instance,
                style: TextStyle(
                  fontSize: 12,
                  color: GlobalVar.mainColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rp.${NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: '').format(int.parse(quest.reward))}',
                    style: TextStyle(
                      fontSize: 15,
                      color: GlobalVar.mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: GlobalVar.mainColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        margin: EdgeInsets.only(right: 8),
                        child: Text(
                          'Lvl ${quest.levelRequirements}',
                          style: TextStyle(
                            fontSize: 8,
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
            ],
          ),
        ),
      ),
    );
  }
}

class MarkedQuestSummary {
  final String questName;
  final String instance;
  final String duration;
  final String maxRangers;
  final String levelRequirements;
  final String reward;
  final String description;
  final List<String> taskList;
  final String address;
  final String objectId;
  final String date;
  final List<String> categories;
  final String status;
  final List<String> rangers;
  final String questOwnerPhone; // New property
  final bool isBookmarked;
  final bool isOnProgress;
  final bool isCompleted;

  MarkedQuestSummary({
    required this.questName,
    required this.instance,
    required this.duration,
    required this.maxRangers,
    required this.levelRequirements,
    required this.reward,
    required this.description,
    required this.taskList,
    required this.address,
    required this.objectId,
    required this.date,
    required this.categories,
    required this.status,
    required this.rangers,
    required this.questOwnerPhone,
    required this.isBookmarked,
    required this.isOnProgress,
    required this.isCompleted,
    // New property
  });
}
