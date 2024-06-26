// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:green_ranger/globalVar.dart';
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
  bool _isLoading = false; // Variabel untuk mengecek status loading

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
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      await QuestMongodb.fetchQuestDataHomePage();

      // Simulasi penundaan untuk menunjukkan proses loading
      await Future.delayed(Duration(seconds: 2));

      // Fetch feed quests from GlobalVar
      final allItems = GlobalVar.instance.homePageQuestFeed ?? [];
      final newItems = allItems.skip(pageKey * 10).take(10).toList();
      final isLastPage = newItems.length < 10 ||
          pageKey * 10 + newItems.length >= allItems.length;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  // Future<void> _loadMoreFeed(int pageKey) async {
  //   try {
  //     // Simulasi penundaan untuk menunjukkan proses loading
  //     await Future.delayed(Duration(seconds: 2));

  //     // Panggil fungsi untuk mengambil data dari MongoDB
  //     final newItems = await QuestMongodb.fetchMoreQuestData(pageKey);

  //     // Tambahkan data baru ke dalam GlobalVar atau ke dalam _pagingController
  //     // Misalnya, jika menggunakan GlobalVar, tambahkan ke dalam list yang sesuai
  //     GlobalVar.instance.homePageQuestFeed.addAll(newItems);

  //     // Tentukan apakah halaman ini adalah halaman terakhir
  //     final isLastPage = newItems.length <
  //         10; // Sesuaikan dengan kondisi halaman terakhir Anda

  //     if (isLastPage) {
  //       _pagingController.appendLastPage(newItems);
  //     } else {
  //       final nextPageKey = pageKey + 1;
  //       _pagingController.appendPage(newItems, nextPageKey);
  //     }
  //   } catch (error) {
  //     _pagingController.error = error;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: _isLoading ? null : () => _pagingController.refresh(),
              icon: Icon(Icons.refresh, color: GlobalVar.baseColor),
            ),
          ),
          Expanded(
            child: PagedListView<int, QuestFeedSummary>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<QuestFeedSummary>(
                itemBuilder: (context, item, index) => QuestListItem(
                  quest: item,
                  colorPattern: questColors[index % questColors.length],
                ),
                noItemsFoundIndicatorBuilder: (context) {
                  if (_isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No Quests Shown, Please Try Again',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: GlobalVar.mainColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: GlobalVar.baseColor, // Warna latar belakang
                borderRadius: BorderRadius.circular(
                    20.0), // Melengkungkan sudut container
              ),
              child: TextButton(
                onPressed:
                    _isLoading ? null : () => _pagingController.refresh(),
                child: Text(
                  'Load More',
                  style: TextStyle(color: GlobalVar.mainColor),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
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
        // Mengakses dan mengupdate questDataSelected
        Provider.of<GlobalVar>(context, listen: false).questDataSelected = {
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
          'rangers': quest.rangers
        };

        // Menampilkan notifikasi "Quest Selected" dengan nama quest dan warna yang dipilih
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Quest ${quest.questName} Selected',
              style: TextStyle(
                  color: GlobalVar
                      .mainColor), // Menyesuaikan warna teks sesuai dengan warna card
            ),
            duration: Duration(seconds: 1), // Durasi notifikasi
            backgroundColor: GlobalVar
                .baseColor, // Mengubah warna latar belakang menjadi putih
          ),
        );
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
                          icon: Icon(Icons.favorite_border),
                          onPressed: () {
                            // Add your like functionality here
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.bookmark_border),
                          onPressed: () {
                            // Add your bookmark functionality here
                          },
                        ),
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
  final List<String> rangers;
  final List<String> categories;
  final String status;
  final String questOwnerPhone;


  QuestFeedSummary({
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
    required this.rangers,
    required this.categories,
    required this.status,
    required this.questOwnerPhone,
   
  });

  factory QuestFeedSummary.fromJson(Map<String, dynamic> json) {
    return QuestFeedSummary(
      questName: json['questName'],
      instance: json['instance'],
      duration: json['duration'],
      maxRangers: json['maxRangers'],
      levelRequirements: json['levelRequirements'],
      reward: json['reward'],
      description: json['description'],
      taskList: List<String>.from(json['taskList'] ?? []),
      address: json['address'],
      objectId: json['_id'].toString(),
      date: json['date'],
      rangers: List<String>.from(json['rangers'] ?? []),
      categories: List<String>.from(json['categories'] ?? []),
      status: json['status'],
      questOwnerPhone: json['questOwnerPhone'],
    );
  }
}

