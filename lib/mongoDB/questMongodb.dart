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

  static Future<bool> fetchQuestDataHomePage() async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }
      // dont remove all print check
      //  print('Check 1');

      var questCollection =
          mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

      GlobalVar.instance.totalFeedCount = await questCollection.count(where);

      var questQuery = await questCollection
          .find(where.sortBy('date', descending: true).limit(20))
          .toList();

      var quests = questQuery;

//var quests = await questCollection.find(questQuery).toList();

      if (quests.isNotEmpty) {
        var userCollection =
            mongoConnection.db.collection(MongoConnection.USER_COLLECTION);

        List<QuestFeedSummary> questFeedSummaryList = [];

        // Fetch user's bookmarked quests
        var markedQuests = List<String>.from(
            GlobalVar.instance.userLoginData['quest']['marked'] ?? []);

        // Fetch user's onProgress quests
        var onProgress = List<String>.from(
            GlobalVar.instance.userLoginData['quest']['onProgress'] ?? []);

        // Fetch user's completed quests
        var completed = List<String>.from(
            GlobalVar.instance.userLoginData['quest']['completed'] ?? []);
        // sample Output: [666da54aa8d882ad0fa0dc39,, 666da54aa8d882ad0fa0dc3b]
        // print('Check 2 marked QuestList : $markedQuests');
        // print('Check 2 onPrgress QuestList: $onProgress');
        // print('Check 2 completed QuestList: $completed');

// Iterate through each quest
        var num = 0;
        for (var quest in quests) {
          num = num + 1;
          print('iteration: $num');

          var questId = quest['_id']; // Use _id directly

          var userId = quest['userId'] as String;
          var userQuery = where.eq('_id', ObjectId.parse(userId));
          var user = await userCollection.findOne(userQuery);

          String questOwnerPhone = '';
          if (user != null) {
            questOwnerPhone = user['phone'];
          }

          // Convert 'date' string to DateTime object
          DateTime date = DateTime.parse(quest['date']);

          print('Check 3 (explicit string): ${questId.toHexString()}');
          // Check if current quest is bookmarked
          bool isBookmarked = markedQuests.contains(questId.toHexString());

          // Check if current quest is on progress
          bool isOnProgress = onProgress.contains(questId.toHexString());

          // Check if current quest is completed
          bool isCompleted = completed.contains(questId.toHexString());

          // Only print if the quest is bookmarked
          if (isBookmarked) {
            print(' is bookmarked');
          }

          // Only print if the quest is on progress
          if (isOnProgress) {
            print(' is on progress');
          }

          // Only print if the quest is completed
          if (isCompleted) {
            print(' is completed');
          }

          print(
              'Check 4: isBookmarked: $isBookmarked, isOnProgress : $isOnProgress, $isCompleted');

          questFeedSummaryList.add(QuestFeedSummary(
            objectId: questId.toHexString(),
            questName: quest['questName'],
            instance: quest['instance'],
            duration: quest['duration'],
            maxRangers: quest['maxRangers'],
            levelRequirements: quest['levelRequirements'],
            reward: quest['reward'],
            description: quest['description'],
            taskList: List<String>.from(quest['taskList'] ?? []),
            address: quest['address'],
            date: date.toIso8601String(),
            rangers: List<String>.from(quest['rangers'] ?? []),
            userId: quest['userId'],
            categories: List<String>.from(quest['categories'] ?? []),
            status: quest['status'],
            questOwnerPhone: questOwnerPhone,
            isBookmarked: isBookmarked,
            isOnProgress: isOnProgress,
            isCompleted: isCompleted,
          ));
        }

        // Save quest summaries to GlobalVar
        GlobalVar.instance.homePageQuestFeed = questFeedSummaryList;
      }

      // Return true even if no quests were found
      return true;
    } catch (e) {
      print('Error during fetching quests: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }

  static Future<bool> fetchMoreQuestData(DateTime? lastItemDate) async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }

      var questCollection =
          mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

      // Define the query to fetch more data based on the last item's date
      var query = lastItemDate != null
          ? where
              .sortBy('date', descending: true)
              .gt('date', lastItemDate.toIso8601String())
              .limit(20)
          : where.sortBy('date', descending: true).limit(20);

      var questQuery = await questCollection.find(query).toList();
      var quests = questQuery;

      if (quests.isNotEmpty) {
        var userCollection =
            mongoConnection.db.collection(MongoConnection.USER_COLLECTION);

        List<QuestFeedSummary> questFeedSummaryList = [];

        var markedQuests = List<String>.from(
            GlobalVar.instance.userLoginData['quest']['marked'] ?? []);
        var onProgress = List<String>.from(
            GlobalVar.instance.userLoginData['quest']['onProgress'] ?? []);
        var completed = List<String>.from(
            GlobalVar.instance.userLoginData['quest']['completed'] ?? []);

        for (var quest in quests) {
          var questId = quest['_id'];
          var userId = quest['userId'] as String;
          var userQuery = where.eq('_id', ObjectId.parse(userId));
          var user = await userCollection.findOne(userQuery);

          String questOwnerPhone = '';
          if (user != null) {
            questOwnerPhone = user['phone'];
          }

          DateTime date = DateTime.parse(quest['date']);

          bool isBookmarked = markedQuests.contains(questId.toHexString());
          bool isOnProgress = onProgress.contains(questId.toHexString());
          bool isCompleted = completed.contains(questId.toHexString());

          questFeedSummaryList.add(QuestFeedSummary(
            objectId: questId.toHexString(),
            questName: quest['questName'],
            instance: quest['instance'],
            duration: quest['duration'],
            maxRangers: quest['maxRangers'],
            levelRequirements: quest['levelRequirements'],
            reward: quest['reward'],
            description: quest['description'],
            taskList: List<String>.from(quest['taskList'] ?? []),
            address: quest['address'],
            date: date.toIso8601String(),
            rangers: List<String>.from(quest['rangers'] ?? []),
            userId: quest['userId'],
            categories: List<String>.from(quest['categories'] ?? []),
            status: quest['status'],
            questOwnerPhone: questOwnerPhone,
            isBookmarked: isBookmarked,
            isOnProgress: isOnProgress,
            isCompleted: isCompleted,
          ));
        }

        GlobalVar.instance.homePageQuestFeed = questFeedSummaryList;
      }

      return true;
    } catch (e) {
      print('Error during fetching quests: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }

  static Future<bool> createQuestMongodb({
    required String questName,
    required String instance,
    required String address,
    required String duration,
    required String maxRangers,
    required String reward,
    required String description,
    required String levelRequirements,
    required List<String> tasks,
    required List<String> selectedCategories,
    required String questOwnerPhone,
  }) async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }

      print('Connected to MongoDB!');

      var documentToInsert = {
        'questName': questName,
        'instance': instance,
        'address': address,
        'duration': duration,
        'maxRangers':
            maxRangers, // Pastikan maxRangers sesuai dengan variabel yang Anda gunakan
        'reward': reward,
        'description': description,
        'levelRequirements': levelRequirements,
        'taskList':
            List<dynamic>.from(tasks), // Pastikan tasks adalah List<dynamic>
        'categories': List<dynamic>.from(
            selectedCategories), // Pastikan selectedCategories adalah List<dynamic>
        'questOwnerPhone': questOwnerPhone,
        'status': 'open', // Default status
        'rangers': [], // Jika tidak ada ranger, biarkan kosong seperti ini
        'userId': GlobalVar.instance.userLoginData['_id'] is ObjectId
            ? GlobalVar.instance.userLoginData['_id'].toHexString()
            : GlobalVar.instance.userLoginData['_id'],

        'date': DateTime.now().toIso8601String(),
      };

      var collection =
          mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

      // Insert the new quest document
      await collection.insert(documentToInsert);

      print('Quest created successfully');
      return true;
    } catch (e) {
      print('Error during quest creation: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }

  static Future<bool> executeQuestMongodb({
    required String questId,
    required String userId,
  }) async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }

      print('Connected to MongoDB!');
      // update user
      var collectionUser =
          mongoConnection.db.collection(MongoConnection.USER_COLLECTION);
      // update quest
      var collectionQuest =
          mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

      var result1 = await collectionUser.update(
          where.eq('_id', ObjectId.fromHexString(userId)),
          modify.push('quest.onProgress', questId));
      // update data lokal user, tambahkan data quest
      GlobalVar.instance.userLoginData['quest']['onProgress'].add(questId);
      print(
          "updated lokal data: ${GlobalVar.instance.userLoginData['quest']['onProgress']}");
      var result2 = await collectionQuest.update(
        where.eq('_id', ObjectId.fromHexString(questId)),
        modify.push('rangers', userId),
      );

      print('Quest executed successfully: $result1, $result2 ');
      return true;
    } catch (e) {
      print('Error during quest executing: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }
}
