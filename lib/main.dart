import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) return Home();
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> urls =[];
  Future<void> getImage() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    firebase_storage.Reference ref =
        storage.ref().child('walls').child('gradients');
    firebase_storage.ListResult result = await ref.listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
      print(ref.getDownloadURL().toString());
      urls.add(ref.getDownloadURL().toString());
    });
    result.prefixes.forEach((firebase_storage.Reference ref) {
      print('Found directory: $ref');
    });
  }

  Future<String> downloadUrlEx() async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('walls')
        .child('gradients')
        .child('image2.jpg')
        .getDownloadURL().toString();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Hello started app");
    print(downloadUrlEx());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WallHeaven',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xffF28B82),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.blue,
          // child: StreamBuilder(stream: ,)
        ),
      ),
    );
  }
}
