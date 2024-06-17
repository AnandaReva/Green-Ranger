import 'package:green_ranger/components/infiniteScrollPagination/UserMarkedQuestList%20.dart';
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
      "507fdgfdg77bcf86cd799439011"
    ],
    "completed": []
  }
} */
  // static Future<void> fetchUserMarkedQuest() async {
  //   final mongoConnection = MongoConnection();

  //   try {
  //     bool isConnected = await mongoConnection.openConnection();

  //     if (!isConnected) {
  //       print('Failed to connect to MongoDB.');
  //       return;
  //     }

  //     var markedQuestIds =
  //         GlobalVar.instance.userLoginData['quest']['marked'] as List<dynamic>;

  //     if (markedQuestIds == null || markedQuestIds.isEmpty) {
  //       print('No marked quest');
  //       return;
  //     }

  //     var questCollection =
  //         mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

  //     var questQuery = where.oneFrom(
  //         '_id', markedQuestIds.map((id) => ObjectId.parse(id)).toList());

  //     var markedQuests = await questCollection.find(questQuery).toList();

  //     if (markedQuests != null && markedQuests.isNotEmpty) {
  //       List<MarkedQuestSummary> markedQuestSummaries = [];

  //       var userCollection =
  //           mongoConnection.db.collection(MongoConnection.USER_COLLECTION);

  //       for (var quest in markedQuests) {
  //         var userId = quest['userId'] as String;
  //         var userQuery = where.eq('_id', ObjectId.parse(userId));
  //         var user = await userCollection.findOne(userQuery);

  //         String questOwnerPhone = '';
  //         if (user != null) {
  //           questOwnerPhone = user['phone'];
  //         }

  //         markedQuestSummaries.add(MarkedQuestSummary(
  //           questName: quest['questName'],
  //           instance: quest['instance'],
  //           duration: quest['duration'],
  //           maxRangers: quest['maxRangers'],
  //           levelRequirements: quest['levelRequirements'],
  //           reward: quest['reward'],
  //           description: quest['description'],
  //           taskList: List<String>.from(quest['taskList'] ?? []),
  //           address: quest['address'],
  //           objectId: quest['_id'].toString(),
  //           date: quest['date'],
  //           categories: List<String>.from(quest['categories'] ?? []),
  //           status: quest['status'],
  //           questOwnerPhone: questOwnerPhone,
  //         ));
  //       }

  //       // Update GlobalVar with the fetched data
  //       GlobalVar.instance.userMarkedQuest = markedQuestSummaries;
  //       print("Marked Quest Found ${GlobalVar.instance.userMarkedQuest}");
  //     }
  //   } catch (e) {
  //     print('Error during fetching marked quests: $e');
  //   } finally {
  //     await mongoConnection.closeConnection();
  //   }
  // }

  static Future<void> fetchUserMarkedQuest() async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return;
      }

      // Get updated user data including marked quest ids
      var userCollection =
          mongoConnection.db.collection(MongoConnection.USER_COLLECTION);
      var query = where.eq('_id', GlobalVar.instance.userLoginData['_id']);
      var updatedUserData = await userCollection.findOne(query);

      GlobalVar.instance.userLoginData = updatedUserData;

      if (updatedUserData == null) {
        print('User data not found or updated.');
        return;
      }

      var markedQuestIds = updatedUserData['quest']['marked'] as List<dynamic>;

      if (markedQuestIds == null || markedQuestIds.isEmpty) {
        print('No marked quests found for the user.');
        GlobalVar.instance.userMarkedQuest = []; // Clear existing data
        return;
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

          markedQuestSummaries.add(MarkedQuestSummary(
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
            date: quest['date'],
            categories: List<String>.from(quest['categories'] ?? []),
            status: quest['status'],
            questOwnerPhone: questOwnerPhone,
          ));
        }

        // Update GlobalVar with the latest marked quests
        GlobalVar.instance.userMarkedQuest = markedQuestSummaries;

        // Print for verification (optional)
        print("Marked Quests found: $markedQuestSummaries");
      }
    } catch (e) {
      print('Error during fetching marked quests: $e');
    } finally {
      await mongoConnection.closeConnection();
    }
  }

  static Future<void> fetchUserOnProgressQuest() async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return;
      }

      var onProgressQuestIds = GlobalVar.instance.userLoginData['quest']
          ['onProgress'] as List<dynamic>; // get user OnProgress quest data

      if (onProgressQuestIds == null || onProgressQuestIds.isEmpty) {
        print('No OnProgress quest');
        return;
      }

      var collection =
          mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

      // Creating a query to fetch all quests with ids in onProgressQuestIds
      var query = where.oneFrom(
          '_id', onProgressQuestIds.map((id) => ObjectId.parse(id)).toList());

      var onProgressQuests = await collection.find(query).toList();

      if (onProgressQuests != null && onProgressQuests.isNotEmpty) {
        print('OnProgress Quests found: $onProgressQuests');

        // Save OnProgress quests to GlobalVar
        GlobalVar.instance.userOnProgressQuest = onProgressQuests;

        // Print OnProgress quests
        onProgressQuests.forEach((quest) {
          print('Quest ID: ${quest['_id']}');
          print('Quest Name: ${quest['questName']}');
          print('Instance: ${quest['instance']}');
          print('Duration: ${quest['duration']}');
          print('Total Rangers: ${quest['totalRangers']}');
          print('Level Requirements: ${quest['levelRequirements']}');
          print('Reward: ${quest['reward']}');
          print('Description: ${quest['description']}');
          print('Address: ${quest['address']}');
          print('Date: ${quest['date']}');
          print('Status: ${quest['status']}');
        });
      } else {
        print('No onProgress quests found.');
      }
    } catch (e) {
      print('Error during fetching onProgress quests: $e');
    } finally {
      await mongoConnection.closeConnection();
    }
  }
}
