// import 'dart:io';
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//
// class Uploader {
//   final File imageFile;
//
//   const Uploader({this.imageFile});
//
//   Future<Widget> startUpload() async {
//     // String filePath = 'images/${DateTime.now()}.png';
//     var imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
//
//     final Reference firebaseStorageRef =
//         FirebaseStorage.instance.ref().child('walls').child(imageFileName);
//
//     UploadTask _uploadTask = firebaseStorageRef.putFile(imageFile);
//
//     var downloadUrl = await (await _uploadTask).ref.getDownloadURL();
//
//     _uploadTask.snapshotEvents.listen((snapshot) {
//       print('Task state: ${snapshot.state}');
//       print(
//           'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
//       progressInd(snapshot);
//     }, onError: (e) {
//       print(_uploadTask.snapshot);
//
//       if (e.code == 'permission-denied') {
//         print('User does not have permission to upload to this reference.');
//       }
//     });
//   }
//   Widget progressInd(TaskSnapshot event){
//     double progressPercent = event != null
//         ? event.bytesTransferred / event.totalBytes
//         : 0;
//
//     return LinearProgressIndicator(value: progressPercent);
//   }
// }
