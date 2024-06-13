// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:intl/intl.dart';

class QuestListPage extends StatefulWidget {
  QuestListPage({Key? key}) : super(key: key);

  @override
  _QuestListPageState createState() => _QuestListPageState();
}

class _QuestListPageState extends State<QuestListPage> {
  late final PagingController<int, QuestSummary> _pagingController;

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
          itemBuilder: (context, item, index) => QuestListItem(quest: item),
        ),
      ),
    );
  }

/*   @override
  void dispose() {
    _pagingController.dispose(); // Dispose the controller
    super.dispose();
  } */
}

class QuestListItem extends StatelessWidget {
  final QuestSummary quest;

  const QuestListItem({Key? key, required this.quest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Row(
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${quest.instance}',
              style: TextStyle(
                fontSize: 12,
                color: GlobalVar.mainColor,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 30),
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
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: EdgeInsets.only(right: 8),
                  child: Text(
                    'Lvl ${quest.levelRequirements}',
                    style: TextStyle(
                      fontSize: 10,
                      color: GlobalVar.baseColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: GlobalVar.mainColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  margin: EdgeInsets.only(right: 8),
                  child: Text(
                    '${quest.duration} days',
                    style: TextStyle(
                      fontSize: 10,
                      color: GlobalVar.baseColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: GlobalVar.mainColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    '${quest.totalRangers} Peoples',
                    style: TextStyle(
                      fontSize: 10,
                      color: GlobalVar.baseColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            )
          ],
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
  });
}
