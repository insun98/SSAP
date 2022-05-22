import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../firebase_options.dart';
import '../src/addGroup.dart';

class GroupProvider extends ChangeNotifier {
  String _defaultImage = "";
  String value = "ASC";
  int userIndex = 0;
  List<userInfo> _users = [];
  List<userInfo> get user => _users;

  List<groupInfo> _groups = [];
  List<groupInfo> get groups => _groups;
  GroupProvider() {
    init(value);
  }
  StreamSubscription<DocumentSnapshot>? _profileSubscription;
  StreamSubscription<QuerySnapshot>? _groupSubscription;
  StreamSubscription<QuerySnapshot>? _groupMemeberSubscription;
  Future<void> init(String newValue) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final storageRef = FirebaseStorage.instance.ref();
    const filename = "defaultProfile.png";
    final mountainsRef = storageRef.child(filename);
    final downloadUrl = await mountainsRef.getDownloadURL();
    _defaultImage = downloadUrl;

    FirebaseAuth.instance.userChanges().listen((user) {
      _groupSubscription = FirebaseFirestore.instance
          .collection('group')
          .snapshots()
          .listen((snapshot) {
        _groups = [];

        for (final document in snapshot.docs) {
          _groups.add(
            groupInfo(
              groupName: document.data()['groupName'] as String,
              docId: document.id,
            ),
          );
        }
        notifyListeners();
      });
      for (final group in _groups) {
        _groupMemeberSubscription = FirebaseFirestore.instance
            .collection('group')
            .doc(group.groupName)
            .collection('Members')
            .snapshots()
            .listen((snapshot) {
          for (final document in snapshot.docs) {
            group.members.add(userInfo(
              uid: document.id,
              name: document.data()['name'],
              Userid: document.data()['id'],
              photo: _defaultImage,
            ));
            print(group.members.length);
          }
          notifyListeners();
        });
      }
    });
  }

  List<userInfo> searchUser(String userId) {
    FirebaseFirestore.instance
        .collection('user')
        .where('id', isGreaterThanOrEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      _users = [];
      for (final document in snapshot.docs) {
        _users.add(
          userInfo(
            name: document.data()['name'] as String,
            Userid: document.data()['id'] as String,
            uid: document.id,
            photo: "",
          ),
        );
      }
      notifyListeners();
    });
    notifyListeners();
    return _users;
  }

  Future<void> addGroup(List<userInfo> members, String groupName) async {
    FirebaseFirestore.instance
        .collection('group')
        .doc(groupName)
        .set(<String, dynamic>{
      'groupName': groupName,
    });
    for (var member in members) {
      FirebaseFirestore.instance
          .collection('group')
          .doc(groupName)
          .collection('Members')
          .add(<String, dynamic>{
        'name': member.name,
        'uid': member.uid,
        'id': member.Userid,
      });
    }
    notifyListeners();
  }

  Future<DocumentReference> addItem(
      String URL, String name, int price, String description) {
    return FirebaseFirestore.instance
        .collection('product')
        .add(<String, dynamic>{
      'image': URL,
      'productName': name,
      'price': price,
      'description': description,
      'create': FieldValue.serverTimestamp(),
      'modify': FieldValue.serverTimestamp(),
      'creator': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> delete(String groupName) async {
    var collection = FirebaseFirestore.instance
        .collection('group')
        .doc(groupName)
        .collection('Members');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    FirebaseFirestore.instance.collection('group').doc(groupName).delete();
  }

  Future<void> editItem(String docId, String URL, String name, int price,
      String description) async {
    FirebaseFirestore.instance
        .collection('product')
        .doc(docId)
        .update(<String, dynamic>{
      'image': URL,
      'productName': name,
      'price': price,
      'description': description,
      'modify': FieldValue.serverTimestamp(),
    });
    notifyListeners();
  }

  Future<String> UploadFile(File image) async {
    final storageRef = FirebaseStorage.instance.ref();
    final filename = "${DateTime.now().millisecondsSinceEpoch}.png";
    final mountainsRef = storageRef.child(filename);
    final mountainImagesRef = storageRef.child("images/$filename");
    File file = File(image.path);
    await mountainsRef.putFile(file);
    final downloadUrl = await mountainsRef.getDownloadURL();
    return downloadUrl;
  }
}

class userInfo {
  userInfo({
    required this.name,
    required this.uid,
    required this.Userid,
    required this.photo,
  });
  String name;
  String uid;
  String Userid;
  String photo;
}
