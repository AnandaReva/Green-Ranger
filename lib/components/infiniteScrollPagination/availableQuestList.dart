// ignore_for_file: prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:green_ranger/components/questDetailSlidePanel.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class AvailableQuestList extends StatefulWidget {
  AvailableQuestList({Key? key}) : super(key: key);

  @override
  _AvailableQuestListState createState() => _AvailableQuestListState();
}

class _AvailableQuestListState extends State<AvailableQuestList> {
  late final PagingController<int, QuestSummary> _pagingController;

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
      final newItems = await GlobalVar.instance.getQuests(pageKey, 10);
      final isLastPage = newItems.isEmpty;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.cast<QuestSummary>());
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(
            newItems.cast<QuestSummary>(), nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PagedListView<int, QuestSummary>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<QuestSummary>(
          itemBuilder: (context, item, index) => QuestListItem(
            quest: item,
            color: questColors[index % questColors.length],
          ),
        ),
      ),
    );
  }
}

class QuestListItem extends StatelessWidget {
  final QuestSummary quest;
  final Color color;

  const QuestListItem({
    Key? key,
    required this.quest,
    required this.color,
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
          'totalRangers': quest.totalRangers,
          'reward': quest.reward,
          'levelRequirements': quest.levelRequirements,
          'description': quest.description,
          'date': quest.date,
        };

        // Menampilkan notifikasi "Quest Selected" dengan nama quest dan warna yang dipilih
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                'Quest ${quest.questName} Selected',
                style: TextStyle(
                    color:
                        GlobalVar.mainColor), // Menyesuaikan warna teks sesuai dengan warna card
              ),
              duration: Duration(seconds: 1), // Durasi notifikasi
              backgroundColor:
                  GlobalVar.baseColor // Mengubah warna latar belakang menjadi putih
              ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8),
        color: color,
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
                              color: color,
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
                              color: color,
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
                            '${quest.totalRangers} Peoples',
                            style: TextStyle(
                              fontSize: 10,
                              color: color,
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

class QuestSummary {
  final String questName;
  final String instance;
  final String duration;
  final String totalRangers;
  final String levelRequirements;
  final String reward;
  final String description;
  final List<String> taskList;
  final String address;
  final String objectId;
  final String date;

  QuestSummary({
    required this.questName,
    required this.instance,
    required this.duration,
    required this.totalRangers,
    required this.levelRequirements,
    required this.reward,
    required this.description,
    required this.taskList,
    required this.address,
    required this.objectId,
    required this.date,
  });
}
