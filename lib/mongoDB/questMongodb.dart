import 'package:green_ranger/components/infiniteScrollPagination/feedQuestHomePage.dart';
import 'package:green_ranger/mongoDB/conn.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:mongo_dart/mongo_dart.dart';

class QuestMongodb {
  /* // Sample Data Quest
{
  "_id": {
    "$oid": "666da54aa8d882ad0fa0dc39"
  },
  "questName": "Find Sample Cosmetics Trash",
  "instance": "PT Paragon",
  "duration": "2",
  "levelRequirements": "Rookie",
  "reward": "800000",
  "description": "Find and organize samples of cosmetics trash. This quest involves gathering trash from various sources and organizing rangers to effectively manage the cleanup operation.",
  "taskList": [
    "Organizing Rangers",
    "Gathering Trash",
    "Collect data results from rangers and calculation each ranger prizes",
    "Prizes distribution"
  ],
  "address": "Jalan Swadarma Raya Kampung Baru IV No. 1. Jakarta - 12250",
  "date": "2024-06-14T12:00:00Z",
  "categories": [
    "Trash Collection"
  ],
  "status": "open",
  "rangers": [
    "666d9eaac4192284f5974377",
    "666d9eaac4192284f5974378",
    "666d9eaac4192284f5974379"
  ],
  "userId": "666e9cce6015fd82f31e5217",
  "maxRangers": "10"
} */

  static Future<void> fetchQuestDataHomePage() async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return;
      }

      var questCollection =
          mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

      // Membuat query untuk mendapatkan quests dengan status 'open' atau 'inProgress' dan membatasi hasilnya hingga 10
      var questQuery =
          where.oneFrom('status', ['open', 'inProgress']).limit(10);

      var quests = await questCollection.find(questQuery).toList();

      if (quests.isNotEmpty) {
        print('Quests found: $quests');

        var userCollection =
            mongoConnection.db.collection(MongoConnection.USER_COLLECTION);

        List<QuestFeedSummary> questFeedSummaryList = [];

        // Iterate through each quest to find the corresponding user phone number
        for (var quest in quests) {
          var userId = quest['userId'] as String;
          var userQuery = where.eq('_id', ObjectId.parse(userId));
          var user = await userCollection.findOne(userQuery);

          String questOwnerPhone = '';
          if (user != null) {
            questOwnerPhone = user['phone'];
          }
 // Convert 'date' string to DateTime object
        DateTime date = DateTime.parse(quest['date']);

        questFeedSummaryList.add(QuestFeedSummary(
          questName: quest['questName'],
          instance: quest['instance'],
          duration: quest['duration'],
          maxRangers: quest['maxRangers'],
          levelRequirements: quest['levelRequirements'],
          reward: quest['reward'],
          description: quest['description'],
          taskList: List<String>.from(quest['taskList'] ?? []),
          address: quest['address'],
          objectId: quest['_id'].toString(),
          date: date.toIso8601String(), // Convert DateTime to ISO 8601 string
          rangers: List<String>.from(quest['rangers'] ?? []),
          categories: List<String>.from(quest['categories'] ?? []),
          status: quest['status'],
          questOwnerPhone: questOwnerPhone,
       
        ));
      }

        // Save quest summaries to GlobalVar
        GlobalVar.instance.homePageQuestFeed = questFeedSummaryList;
      }
    } catch (e) {
      print('Error during fetching quests: $e');
    } finally {
      await mongoConnection.closeConnection();
    }
  }

  // static Future<List<QuestFeedSummary>> fetchMoreQuestData(int pageKey) async {
  //   final mongoConnection = MongoConnection();

  //   try {
  //     bool isConnected = await mongoConnection.openConnection();

  //     if (!isConnected) {
  //       print('Failed to connect to MongoDB.');
  //       return [];
  //     }

  //     var questCollection =
  //         mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

  //     final int limit = 10;
  //     final int skip = pageKey * limit;

  //     final List<Map<String, dynamic>> data =
  //         await questCollection.find().skip(skip).limit(limit).toList();

  //     List<QuestFeedSummary> quests =
  //         data.map((json) => QuestFeedSummary.fromJson(json)).toList();

  //     return quests;
  //   } catch (e) {
  //     print('Error during fetching quests: $e');
  //     return [];
  //   } finally {
  //     await mongoConnection.closeConnection();
  //   }
  // }
}
