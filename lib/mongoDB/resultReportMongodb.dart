import 'package:green_ranger/mongoDB/conn.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:mongo_dart/mongo_dart.dart';

class QuestMongodb {
  /* // Sample Data Quest resut report
  "_id": {
    "$oid": "667449be36bb32cd4e53202d"
  },
  "userId": "",
  "questId": "",
  "rangerId": "",
  "url": "",
  "date": ""
}  */

  static Future<bool> uploadDataResultReport(
      String userId, String questId, String rangerId, String url) async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }
      // dont remove all print check
      print('Check 1');

      var questCollection =
          mongoConnection.db.collection(MongoConnection.QUEST_COLLECTION);

      // Query to limit results to 20 quests
      var questQuery = where.limit(20);

      var quests = await questCollection.find(questQuery).toList();

      //insert new document
      if (quests.isNotEmpty) {
        var resultReportCollection = mongoConnection.db
            .collection(MongoConnection.RESULT_REPORT_COLLECTION);

        //update user quest onProgress and completed
        var userCollection =
            mongoConnection.db.collection(MongoConnection.USER_COLLECTION);



        // updated data
        // GlobalVar.instance.userLoginData = ;
      }

      // Return true even if no quests were found
      return true;
    } catch (e) {
      print('Error during uploading result report quests: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }
}
