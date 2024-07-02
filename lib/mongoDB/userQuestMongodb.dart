import 'package:green_ranger/components/infiniteScrollPagination/UserCompletedQuestList.dart';
import 'package:green_ranger/components/infiniteScrollPagination/UserMarkedQuestList%20.dart';
import 'package:green_ranger/components/infiniteScrollPagination/UserOnProgressQuestList.dart';
import 'package:green_ranger/mongoDB/conn.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:mongo_dart/mongo_dart.dart'; // Sesuaikan dengan lokasi sebenarnya dari file globalVar.dart

class UserQuestMongodb {
  /* 
  //Sample data
{
  "profile_image": "assets/images/logo.png",
  "username": "admin",
  "email": "admin@gmail.com",
  "password": "admin123",
  "exp": 2450,
  "wallet_value": 750000,
  "phone": "08123456789",
  "quest": {
    "marked": [
      "666da54aa8d882ad0fa0dc39",
      "666da54aa8d882ad0fa0dc3a"
    ],
    "onProgress": [
      ""
    ],
    "completed": []
  }
} */

  static Future<bool> fetchUserMarkedQuests() async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }

      //get data
      var onProgress = List<String>.from(
          GlobalVar.instance.userLoginData['quest']['onProgress'] ?? []);
      var completed = List<String>.from(
          GlobalVar.instance.userLoginData['quest']['completed'] ?? []);
      // print('Check 2 onPrgress QuestList: $onProgress');
      // print('Check 2 completed QuestList: $completed');

      // Get updated user data including marked quest ids
      var userCollection =
          mongoConnection.db.collection(MongoConnection.USER_COLLECTION);
      var query = where.eq('_id', GlobalVar.instance.userLoginData['_id']);
      var updatedUserData = await userCollection.findOne(query);

      GlobalVar.instance.userLoginData = updatedUserData;

      if (updatedUserData == null) {
        print('User data not found or updated.');
        return false;
      }

      var markedQuestIds = updatedUserData['quest']['marked'] as List<dynamic>;

      if (markedQuestIds == null || markedQuestIds.isEmpty) {
        print('No marked quests found for the user.');
        GlobalVar.instance.userMarkedQuest = []; // Clear existing data
        return true;
      }

      var questCollection =
          mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

      // Creating a query to fetch all quests with ids in markedQuestIds
      var questQuery = where.oneFrom(
          '_id', markedQuestIds.map((id) => ObjectId.parse(id)).toList());

      var markedQuests = await questCollection.find(questQuery).toList();

      if (markedQuests != null && markedQuests.isNotEmpty) {
        var userCollection =
            mongoConnection.db.collection(MongoConnection.USER_COLLECTION);

        List<MarkedQuestSummary> markedQuestSummaries = [];

        // Iterate through each quest to find the corresponding user phone number
        for (var quest in markedQuests) {
          var userId = quest['userId'] as String;
          var userQuery = where.eq('_id', ObjectId.parse(userId));
          var user = await userCollection.findOne(userQuery);

          String questOwnerPhone = '';
          if (user != null) {
            questOwnerPhone = user['phone'];
          }

          var questId = quest['_id']; // Use _id directly

          bool isOnProgress = onProgress.contains(questId.toHexString());
          // Check if current quest is completed
          bool isCompleted = completed.contains(questId.toHexString());
          // Only print if the quest is on progress
          if (isOnProgress) {
            print(' is on progress');
          }
          // Only print if the quest is completed
          if (isCompleted) {
            print(' is completed');
          }

          markedQuestSummaries.add(MarkedQuestSummary(
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
            date: quest['date'],
            categories: List<String>.from(quest['categories'] ?? []),
            status: quest['status'],
            rangers: List<String>.from(quest['rangers'] ?? []),
            questOwnerPhone: questOwnerPhone,
            isBookmarked: true,
            isOnProgress: isOnProgress,
            isCompleted: isCompleted,
            userId: quest['userId'],
          ));
        }

        // Update GlobalVar with the latest marked quests
        GlobalVar.instance.userMarkedQuest = markedQuestSummaries;

        // Print for verification (optional)
        print("Marked Quests found: $markedQuestSummaries");
      }
      return true;
    } catch (e) {
      print('Error during fetching marked quests: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }

  static Future<bool> fetchUserOnProgressQuests() async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }
      // Get updated user data including marked quest ids
      var userCollection =
          mongoConnection.db.collection(MongoConnection.USER_COLLECTION);
      var query = where.eq('_id', GlobalVar.instance.userLoginData['_id']);
      var updatedUserData = await userCollection.findOne(query);

      // print("check 1 onProgress $query");

      GlobalVar.instance.userLoginData = updatedUserData;

      if (updatedUserData == null) {
        print('User data not found or updated.');
        return false;
      }

      //  print("check 2 onProgress $query");

      var onProgressQuestIds =
          updatedUserData['quest']['onProgress'] as List<dynamic>;

      if (onProgressQuestIds == null || onProgressQuestIds.isEmpty) {
        print('No onProgress quests found for the user.');
        GlobalVar.instance.userOnProgressQuest = []; // Clear existing data
        return true;
      }

      //  print("check 3 onProgress $onProgressQuestIds");

      var questCollection =
          mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

      // Creating a query to fetch all quests with ids in onProgressQuestIds
      var questQuery = where.oneFrom(
          '_id', onProgressQuestIds.map((id) => ObjectId.parse(id)).toList());

      //    print("check 4 onProgress ${questQuery}");

      var onProgressQuests = await questCollection.find(questQuery).toList();

      if (onProgressQuests != null && onProgressQuests.isNotEmpty) {
        List<OnProgressQuestSummary> onProgressQuestSummaries = [];

        // Iterate through each quest to find the corresponding user phone number
        for (var quest in onProgressQuests) {
          var questId = quest['_id'];
          var userId = quest['userId'] as String;
          var userQuery = where.eq('_id', ObjectId.parse(userId));
          var user = await userCollection.findOne(userQuery);

          String questOwnerPhone = '';
          if (user != null) {
            questOwnerPhone = user['phone'];
          }

          onProgressQuestSummaries.add(OnProgressQuestSummary(
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
            date: quest['date'],
            categories: List<String>.from(quest['categories'] ?? []),
            status: quest['status'],
            rangers: List<String>.from(quest['rangers'] ?? []),
            questOwnerPhone: questOwnerPhone,
            isOnProgress: true,
            userId: quest['userId'],
          ));
        }

        // Update GlobalVar with the latest onProgress quests
        GlobalVar.instance.userOnProgressQuest = onProgressQuestSummaries;

        // Print for verification (optional)
        print("onProgress Quests found: $onProgressQuestSummaries");
      }
      return true;
    } catch (e) {
      print('Error during fetching onProgress quests: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }

  static Future<bool> fetchUserCompletedQuests() async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }

      // Get updated user data including onProgress ids
      var userCollection =
          mongoConnection.db.collection(MongoConnection.USER_COLLECTION);
      var query = where.eq('_id', GlobalVar.instance.userLoginData['_id']);
      var updatedUserData = await userCollection.findOne(query);

      print("check 1 completed $query");
      GlobalVar.instance.userLoginData = updatedUserData;

      if (updatedUserData == null) {
        print('User data not found or updated.');
        return false;
      }

      var completedQuestIds =
          updatedUserData['quest']['completed'] as List<dynamic>;

      if (completedQuestIds == null || completedQuestIds.isEmpty) {
        print('No completed quests found for the user.');
        GlobalVar.instance.userCompletedQuest = []; // Clear existing data
        return true;
      }

      var questCollection =
          mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

      // Creating a query to fetch all quests with ids in completedQuestIds
      var questQuery = where.oneFrom(
          '_id', completedQuestIds.map((id) => ObjectId.parse(id)).toList());

      var completedQuests = await questCollection.find(questQuery).toList();

      if (completedQuests != null && completedQuests.isNotEmpty) {
        var userCollection =
            mongoConnection.db.collection(MongoConnection.USER_COLLECTION);

        List<CompletedQuestSummary> completedQuestSummary = [];

        // Iterate through each quest to find the corresponding user phone number
        for (var quest in completedQuests) {
          var questId = quest['_id'];
          var userId = quest['userId'] as String;
          var userQuery = where.eq('_id', ObjectId.parse(userId));
          var user = await userCollection.findOne(userQuery);

          String questOwnerPhone = '';
          if (user != null) {
            questOwnerPhone = user['phone'];
          }
          completedQuestSummary.add(CompletedQuestSummary(
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
            date: quest['date'],
            categories: List<String>.from(quest['categories'] ?? []),
            status: quest['status'],
            rangers: List<String>.from(quest['rangers'] ?? []),
            questOwnerPhone: questOwnerPhone,
            isCompleted: true,
          ));
        }

        // Update GlobalVar with the latest marked quests
        GlobalVar.instance.userCompletedQuest = completedQuestSummary;

        // Print for verification (optional)
        print("Completed Quests found: $completedQuestSummary");
      }
      return true;
    } catch (e) {
      print('Error during fetching completed quests: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }

  //Sample data
/* {
  "_id": ObjectId("666e9cce6015fd82f31e5217"),
  "quest": {
    "marked": [
      "666da54aa8d882ad0fa0dc39"
    ]
  }
}
  */
  static Future<bool> unBookMarkQuest({
    required String questId,
    required String userId,
  }) async {
    final mongoConnection = MongoConnection();

    print(
        'check 1 unbookmark: ${userId}, ${questId}'); // output: 666e9cce6015fd82f31e5217, 666da54aa8d882ad0fa0dc39
    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }

      print('Connected to MongoDB!');

      // Convert userId and questId to ObjectId
      var userObjectId = ObjectId.fromHexString(userId);
      // var questObjectId = ObjectId.fromHexString(questId);

      // Update user
      var collectionUser =
          mongoConnection.db.collection(MongoConnection.USER_COLLECTION);

      var result1 = await collectionUser.updateOne(
          where.eq('_id', userObjectId), modify.pull('quest.marked', questId));

      // Update local user data, remove questId from marked quests
      GlobalVar.instance.userLoginData['quest']['marked'].remove(questId);
      print(
          "Updated local data: ${GlobalVar.instance.userLoginData['quest']['marked']}");

      print('Quest unbookmarked successfully: $result1');
      return true;
    } catch (e) {
      print('Error during quest unbookmarking: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }

  static Future<bool> addBookmarkQuest({
    required String questId,
    required String userId,
  }) async {
    final mongoConnection = MongoConnection();

    print(
        'check 1 bookmark: ${userId}, ${questId}'); // output: 666e9cce6015fd82f31e5217, 666da54aa8d882ad0fa0dc39
    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }

      print('Connected to MongoDB!');

      // Convert userId to ObjectId
      var userObjectId = ObjectId.fromHexString(userId);
      // var questObjectId = ObjectId.fromHexString(questId);

      // Update user
      var collectionUser =
          mongoConnection.db.collection(MongoConnection.USER_COLLECTION);

      var result1 = await collectionUser.updateOne(
          where.eq('_id', userObjectId),
          modify.addToSet('quest.marked', questId));

      // Update local user data, add questId to marked quests
      if (!GlobalVar.instance.userLoginData['quest']['marked']
          .contains(questId)) {
        GlobalVar.instance.userLoginData['quest']['marked'].add(questId);
      }
      print(
          "Updated local data: ${GlobalVar.instance.userLoginData['quest']['marked']}");

      print('Quest bookmarked successfully: $result1');
      return true;
    } catch (e) {
      print('Error during quest bookmarking: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }
}
