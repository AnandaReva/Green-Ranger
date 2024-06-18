import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';

class MongoConnection {
  static const String MONGO_CONN_URL =
      "mongodb+srv://whitegateincorporations:qwerqwer@greenranger.xpglyf3.mongodb.net/green_ranger_db?retryWrites=true&w=majority&appName=GreenRanger";

  static const String USER_COLLECTION = "users";
  static const String QUEST_COLLECTION = "quests";

  late Db _db;

  bool get isConnected => _db.isConnected;

  Future<bool> openConnection() async {
    try {
      _db = await Db.create(MONGO_CONN_URL);
      await _db.open();
      print('Connected to MongoDB!');

      // Inspect the database
      inspect(_db);

      // Get server status
      var status = await _db.serverStatus();
      // print('status: $status');

      return true;
    } catch (e) {
      print('Error connecting to MongoDB: $e');
      return false;
    }
  }

  Db get db {
    if (!isConnected) {
      throw StateError("MongoDB connection has not been opened yet.");
    }
    return _db;
  }

  Future<void> closeConnection() async {
    if (isConnected) {
      await _db.close();
      print('Connection closed.');
    }
  }
}


// dont delete
      // // Example: Find all documents in the 'users' collection
      // var usersCollection = _db.collection(USER_COLLECTION);
      // var allUsers = await usersCollection.find().toList();
      // print('All users: $allUsers');

      // Example: Find all documents in the 'quests' collection
      // var questsCollection = _db.collection(QUEST_COLLECTION);
      // var allQuests = await questsCollection.find().toList();
      // print('All quests: $allQuests');