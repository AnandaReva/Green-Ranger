import 'package:green_ranger/mongoDB/conn.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:mongo_dart/mongo_dart.dart'; // Sesuaikan dengan lokasi sebenarnya dari file globalVar.dart

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
class AuthMongodb {
  static Future<bool> findUserDataMongodb(String email, String password) async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }

      var collection =
          mongoConnection.db.collection(MongoConnection.USER_COLLECTION);
      var query = where.eq('email', email).eq('password', password);
      var user = await collection.findOne(query);

      if (user != null) {
        print('User found: $user');

        // Save user data to GlobalVar if found
        GlobalVar.instance.userLoginData = user;

        // Print each field of the user data from MongoDB
        print('User data from DB:');
        print('ID: ${user['_id']}');
        print('Profile Image: ${user['profile_image']}');
        print('Username: ${user['username']}');
        print('Email: ${user['email']}');
        print('Password: ${user['password']}');
        print('EXP: ${user['exp']}');
        print('Wallet Value: ${user['wallet_value']}');
        print('Phone: ${user['phone']}');
        // Print the quest data
        var quest = user['quest'];
        if (quest != null) {
          print('Quest data:');
          print('Marked: ${quest['marked']}');
          print('On Progress: ${quest['onProgress']}');
          print('Completed: ${quest['completed']}');
        } else {
          print('No quest data found.');
        }

        return true; // Successful login
      } else {
        print('No user found with the provided email and password.');
        return false;
      }
    } catch (e) {
      print('Error during sign in: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }

  static Future<bool> createUserDataMongodb(
      String email, String password, String username, String phone) async {
    final mongoConnection = MongoConnection();

    try {
      bool isConnected = await mongoConnection.openConnection();

      if (!isConnected) {
        print('Failed to connect to MongoDB.');
        return false;
      }

      print('Connected to MongoDB!');

      var documentToInsert = {
        'email': email,
        'username': username,
        'password': password,
        'phone': phone,
        'profile_image': '',
        'exp': 0, 
        'wallet_value': 0, 
        'quest': {
          'marked': [],
          'onProgress': [],
          'completed': []
        } 
      };

      var collection =
          mongoConnection.db.collection(MongoConnection.USER_COLLECTION);

      // Insert the new user document
      await collection.insert(documentToInsert);

      // Fetch the newly created user document
      var user = await collection.findOne(where.eq('email', email));

      if (user != null) {
        print('New user created: $user');

        // Save user data to GlobalVar
        GlobalVar.instance.userLoginData = user;

        // Print each field of the user data from MongoDB
        print('New User data:');
        print(
            'ID: ${user['_id']}'); // Access _id directly or convert it to String if needed
        print('Profile Image: ${user['profile_image']}');
        print('Username: ${user['username']}');
        print('Email: ${user['email']}');
        print('Password: ${user['password']}');
        print('EXP: ${user['exp']}');
        print('Wallet Value: ${user['wallet_value']}');
        print('Phone: ${user['phone']}');

        return true; // Successful creation
      } else {
        print('User creation failed.');
        return false;
      }
    } catch (e) {
      print('Error during user creation: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }
}
