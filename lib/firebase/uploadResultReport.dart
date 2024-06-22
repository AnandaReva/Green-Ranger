import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:green_ranger/globalVar.dart';

class UploadResultReport {
  GlobalVar globalVar = GlobalVar.instance;

  static Future<String?> getDownloadUrl(
      String questId, String rangerId, File file) async {
    try {

      
      String path = "quests/$questId/rangers/$rangerId/";
      final fileName = file.path.split("/").last;
      final timeStamp = DateTime.now().millisecondsSinceEpoch;

      final storageRef =
          FirebaseStorage.instance.ref("$path$timeStamp-$fileName");

      // Upload file to Firebase Storage
      await storageRef.putFile(file);

      // Get download URL after successful upload
      String url = await storageRef.getDownloadURL();
      return url;
    } catch (e) {
      print('Error getting download URL: $e');
      return null;
    }
  }
}
