import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:green_ranger/globalVar.dart';

class UploadResultReport {
  GlobalVar globalVar = GlobalVar.instance;

  // static Future<String?> getDownloadUrl(
  //     String questId, String rangerId, File file) async {
  //   try {

  //     String path = "quests/$questId/report/rangers/$rangerId/";
  //     final fileName = file.path.split("/").last;
  //     final timeStamp = DateTime.now().millisecondsSinceEpoch;

  //     final storageRef =
  //         FirebaseStorage.instance.ref("$path$timeStamp-$fileName");

  //     // Upload file to Firebase Storage
  //     await storageRef.putFile(file);

  //     // Get download URL after successful upload
  //     String url = await storageRef.getDownloadURL();
  //     return url;
  //   } catch (e) {
  //     print('Error during Upload Firebase Storage: $e');
  //     return null;
  //   }
  // }
  static Future<String?> getDownloadUrl(
      String questId, String rangerId, File file) async {
    String path = "quests/$questId/rangers_report/$rangerId/";
    final fileName = file.path.split("/").last;
    final timeStamp = DateTime.now().millisecondsSinceEpoch;

    final storageRef =
        FirebaseStorage.instance.ref("$path$timeStamp-$fileName");

    // Upload file to Firebase Storage
    await storageRef.putFile(file);

    // Get download URL after successful upload
    return await storageRef.getDownloadURL();
  }
}
