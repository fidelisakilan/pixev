import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddPictureScreen extends StatefulWidget {
  @override
  _AddPictureScreenState createState() => _AddPictureScreenState();
}

class _AddPictureScreenState extends State<AddPictureScreen> {
  File _imageFile;

  UploadTask _uploadTask;
  double progressPercent = 0.0;
  DocumentReference imagedocRef;

  Future<void> startUpload() async {
    // String filePath = 'images/${DateTime.now()}.png';
    var imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('walls').child(imageFileName);

    _uploadTask = firebaseStorageRef.putFile(_imageFile);
    _uploadTask.snapshotEvents.listen((event) {
      setState(() {
        progressPercent =
            event != null ? event.bytesTransferred / event.totalBytes : 0;

        print('Task state: ${event.state}');
        print(
            'Progress: ${(event.bytesTransferred / event.totalBytes) * 100} %');
      });
    }, onError: (e) {
      print(_uploadTask.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }
    });
    var downloadUrl = await (await _uploadTask).ref.getDownloadURL();
    await saveImages(downloadUrl,imagedocRef);
  }
@override
  void initState() {
    super.initState();
    imagedocRef = FirebaseFirestore.instance.collection('images').doc();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Align(
              alignment: Alignment.center,
              child:
                  _imageFile != null ? Image.file(_imageFile) : Placeholder(),
            ),
          ),
          // StreamBuilder<TaskSnapshot>(
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       var event = snapshot?.data;
          //       double progressPercent = (event != null)
          //           ? event.bytesTransferred / event.totalBytes
          //           : 0;
          //       return Column(
          //         children: [
          //           LinearProgressIndicator(value: progressPercent),
          //           Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
          //         ],
          //       );
          //     } else {
          //       return Container();
          //     }
          //   },
          //   stream: _uploadTask.snapshotEvents,
          // ),
          LinearProgressIndicator(value: progressPercent),
          Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Icon(Icons.crop),
                    onPressed: _imageFile != null ? _cropImage : null,
                  ),
                  ElevatedButton(
                    child: Icon(Icons.refresh),
                    onPressed: _clear,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            IconButton(
              icon: Icon(Icons.upload_file),
              onPressed: () {
                if (_imageFile != null) {
                  startUpload();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final _picker = ImagePicker();
    PickedFile image = await _picker.getImage(source: source);
    setState(() {
      _imageFile = File(image.path);
      print(_imageFile.path);
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );
    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  void _clear() {
    setState(() {
      progressPercent = 0;
      _imageFile = null;
    });
  }

  Future<void> saveImages(String imageUrl, DocumentReference ref) async{
    ref.set({"images": FieldValue.arrayUnion([imageUrl])});
  }
}
