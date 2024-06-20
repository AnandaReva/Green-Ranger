import 'package:green_ranger/mongoDB/conn.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:mongo_dart/mongo_dart.dart';

class QuestResultReportMongodb {
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

/* Sample Data:
{
  "_id": {
    "$oid": "666d9eaac4192284f5974377"
  },
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
      if (questId.startsWith('ObjectId("') && questId.endsWith('")')) {
        questId = questId.substring(10, questId.length - 2);
      }
      //insert new document
      if (quests.isNotEmpty) {
        var resultReportCollection = mongoConnection.db
            .collection(MongoConnection.RESULT_REPORT_COLLECTION);

        var document = {
          "userId": userId,
          "questId": questId,
          "rangerId": rangerId,
          "url": url,
          "date": DateTime.now(), // Contoh penggunaan tanggal saat ini
        };

        var result1 = await resultReportCollection.insert(document);

        /* Sample Data:
        {
          "_id": {
            "$oid": "666d9eaac4192284f5974377"
          },
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

        /* menjadi
        {
          "_id": {
            "$oid": "666d9eaac4192284f5974377"
          },
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
            "onProgress": [],
            "completed": [ "507fdgfdg77bcf86cd799439011"] // pindah kesini
          }
        } */
        //update user quest onProgress (hapus data questId) and completed (tambah dataQuestId)
        var userCollection =
            mongoConnection.db.collection(MongoConnection.USER_COLLECTION);

        // Clean the ObjectId string format if necessary

        print(' check 2 result: ${questId}');

        // Update user's quest status
        // var result2 = await userCollection.update(
        //     where.eq('_id', ObjectId.fromHexString(userId)),
        //     modify
        //         .pull('quest.onProgress', questId)
        //         .push('quest.completed', questId));

           // Update user's quest status
        var result2 = await userCollection.updateOne(
            where.eq('_id', ObjectId.fromHexString(rangerId)),
            modify
                .pull('quest.onProgress', questId)
                .push('quest.completed', questId));

        // Get updated data
        var query = where.eq('_id', ObjectId.fromHexString(rangerId));
        var user = await userCollection.findOne(query);

        if (user != null) {
          print('User found: $user');

          // Save user data to GlobalVar if found
          
          GlobalVar.instance.userLoginData = user;
        }

        print('result1 : $result1 , $result2');

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
