import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:flutter/material.dart';

import 'firebase_storage_result.dart';

class CloudStorageService {
  Future<CloudStorageResult> uploadImage({
    @required File imageToUpload, @required String title,
  }) async {
    var imageFileName = title + DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final firebase_storage.Reference firebaseStorageRef = firebase_storage.FirebaseStorage.instance.ref().child('walls').child(imageFileName);

    firebase_storage.UploadTask uploadTask =  firebaseStorageRef.putFile(imageToUpload);

    // firebase_storage.TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);

    uploadTask.snapshotEvents.listen((firebase_storage.TaskSnapshot snapshot) {
      print('Task state: ${snapshot.state}');

      print(
          'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
    }, onError: (e) {
      // The final snapshot is also available on the task via `.snapshot`,
      // this can include 2 additional states, `TaskState.error` & `TaskState.canceled`
      print(uploadTask.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();



  }
}