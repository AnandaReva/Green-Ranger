import 'package:green_ranger/mongoDB/conn.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:mongo_dart/mongo_dart.dart'; // Sesuaikan dengan lokasi sebenarnya dari file globalVar.dart


class AuthMongodb {
  static Future<bool> findUserDataMongodb(String email, String password) async {
    final mongoConnection = MongoConnection();

    try {
      await mongoConnection.openConnection();
      print('Connected to MongoDB!');

      var collection = mongoConnection.db.collection(MongoConnection.USER_COLLECTION);
      var query = where
          .eq('email', email)
          .eq('password', password);
      var user = await collection.findOne(query);

      if (user != null) {
        print('User found: $user');

        // Save user data to GlobalVar if found
        GlobalVar.instance.userLoginData = user;
        GlobalVar.instance.isLogin = true;

        // Print each field of the user data from MongoDB
        print('User data from DB:');
        print('ID: ${user['_id']}'); // Access _id directly or convert it to String if needed
        print('Profile Image: ${user['profile_image']}');
        print('Username: ${user['username']}');
        print('Email: ${user['email']}');
        print('Password: ${user['password']}');
        print('EXP: ${user['exp']}');
        print('Wallet Value: ${user['wallet_value']}');
        print('Phone: ${user['phone']}');

        return true; // Successful login
      } else {
        print('No user found with the provided email and password.');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    } finally {
      await mongoConnection.closeConnection();
    }
  }
}

