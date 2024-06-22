// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/main.dart';
import 'package:green_ranger/mongoDB/questMongodb.dart';
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
  void initState() {
    super.initState();
    _pagingController = PagingController(firstPageKey: 0);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchData(pageKey);
    });
  }

  Future<void> _fetchData(int pageKey) async {
    print("pageKey: $pageKey");
    try {
      bool isSuccess = await QuestMongodb.fetchQuestDataHomePage();

      if (!isSuccess) {
        _pagingController.error = "Failed to fetch quest data";
        return;
      }
      final allItems = GlobalVar.instance.homePageQuestFeed ?? [];

      print('Total number of quests: {${GlobalVar.instance.totalFeedCount}');

      if (allItems.isNotEmpty) {
        final lastItemDate =
            allItems.last.date; // Accessing the date of the last item
        print('Date of the last item: $lastItemDate');
      }

      // Clear existing data if it's the first page
      if (pageKey == 0) {
        _pagingController.itemList?.clear();
      }

      // Append data to _pagingController
      _pagingController.appendLastPage(allItems.cast<QuestFeedSummary>());
      // Get the number of items currently in _pagingController
      int numberOfItems = allItems.length ?? 0;
      print("Number of items after appending: $numberOfItems"); // always 20
    } catch (error) {
      _pagingController.error =
          error.toString(); // Set error to string representation of error
    }
  }

  Future<void> _fetchMoreData(int pageKey) async {
    print("pageKey: $pageKey");
    try {
      bool isSuccess = await QuestMongodb.fetchMoreQuestData(lastItemDate);

      if (!isSuccess) {
        _pagingController.error = "Failed to fetch quest data";
        return;
      }
      final allItems = GlobalVar.instance.homePageQuestFeed ?? [];

      print('Total number of quests: ${GlobalVar.instance.totalFeedCount}');

      if (allItems.isNotEmpty) {
        lastItemDate = DateTime.parse(allItems
            .last.date); // Accessing and parsing the date of the last item
        print('Date of the last item: $lastItemDate');
      }

      if (pageKey == 0) {
        _pagingController.itemList?.clear();
      }

      _pagingController.appendLastPage(allItems.cast<QuestFeedSummary>());
      int numberOfItems = allItems.length ?? 0;
      print("Number of items after appending: $numberOfItems");
    } catch (error) {
      _pagingController.error = error.toString();
    }
  }

  Future<void> _refreshData() async {
    _pagingController.refresh();
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
                        ),
                        if (index == _pagingController.itemList!.length - 1 &&
                            index <
                                GlobalVar.instance.totalFeedCount -
                                    1) // Show load more button for the last item and when there are more items to load

                          TextButton(
                            onPressed: () {
                              _fetchMoreData(
                                  _pagingController.nextPageKey ?? 0);
                            },
                            child: Container(
                              width: 100,

                              decoration: BoxDecoration(
                                color: GlobalVar.mainColor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust border radius as needed
                              ),
                              padding:
                                  EdgeInsets.all(8), // Adjust padding as needed
                              child: Row(
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
                                  SizedBox(
                                      width: 4), // Adjust spacing as needed
                                  Icon(
                                    Icons.refresh,
                                    size: 20,
                                    color: GlobalVar.secondaryColorGreen,
                                  ),
                                ],
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
                            'No Quests Shown, Please Try Again',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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

  const QuestListItem({
    Key? key,
    required this.quest,
    required this.colorPattern,
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

        print(
            '${quest.questName} : isCOmplete,${quest.isCompleted}  ,  isOnprogress ${quest.isOnProgress}');

        MainPageState? mainPageState = MainPage.of(context);
        mainPageState?.onTapController.add(() {
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
                            } else {
                              // Add bookmark logic
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
