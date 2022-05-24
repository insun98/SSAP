import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../firebase_options.dart';
import '../src/addGroup.dart';

class GroupProvider extends ChangeNotifier {
  String _defaultImage = "";
  String value = "ASC";
  int userIndex = 0;
  List<userInfo> _users = [];
  List<userInfo> get user => _users;
  groupInfo _singleGroup = groupInfo(groupName: "", docId: "", members: []);
  groupInfo get singleGroup  => _singleGroup;
  List<groupInfo> _groups = [];
  List<groupInfo> get groups => _groups;
  GroupProvider() {
    init();
  }
  StreamSubscription<QuerySnapshot>? _userSubscription;
  StreamSubscription<QuerySnapshot>? _groupSubscription;
  StreamSubscription<QuerySnapshot>? _groupMemeberSubscription;
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final storageRef = FirebaseStorage.instance.ref();
    const filename = "defaultProfile.png";
    final mountainsRef = storageRef.child(filename);
    final downloadUrl = await mountainsRef.getDownloadURL();
    _defaultImage = downloadUrl;

    FirebaseAuth.instance.userChanges().listen((user) {
      _groupSubscription =
          FirebaseFirestore.instance
          .collection('group')
          .where('members', arrayContains: FirebaseAuth.instance.currentUser?.uid)
          .snapshots()
          .listen((snapshot) {
        _groups = [];

        for (final document in snapshot.docs) {
          _groups.add(
            groupInfo(
              groupName: document.data()['groupName'] as String,
              docId: document.id,
              members: document.data()["members"],
            ),
          );
        }
        notifyListeners();
      });
      _userSubscription =FirebaseFirestore.instance
          .collection('user')
          .snapshots()
          .listen((snapshot) {
        _users = [];

        for (final document in snapshot.docs) {
          _users.add(
            userInfo(
              name: document.data()['groupName'] as String,
              id: document.data()['groupName'] as String,
              uid: document.data()["uid"],
              image: document.data()["image"],
            ),
          );
        }
        notifyListeners();
      });

    });
  }

  userInfo searchUser(String userId) {
    userInfo user = userInfo(name:"", id:"", image: "", uid:"");
    FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {

      if(snapshot.docs.isNotEmpty) {
        user.name = snapshot.docs[0].data()['name'];
        user.id = snapshot.docs[0].data()['id'];
        user.uid = snapshot.docs[0].data()['uid'];
        user.image = snapshot.docs[0].data()['image'];
      }
      notifyListeners();
    });
    notifyListeners();
    return user;
  }

  String addGroup(List<String> members, String groupName)  {
    String id = FirebaseFirestore.instance.collection('group').doc().id;
    FirebaseFirestore.instance
        .collection('group')
        .doc(id)
        .set(<String, dynamic>{
      'groupName': groupName,
      'member': members,
    });


    notifyListeners();
    return id;
  }

  bool setGroup(String docId) {
  FirebaseFirestore.instance
      .collection('group')
      .doc(docId).snapshots()
      .listen((snapshot) {
    if (snapshot.data() != null) {
      singleGroup.groupName = snapshot.data()!['groupName'];
      singleGroup. members = snapshot.data()!['members'];
      singleGroup.docId = docId;

    }
  });
  return true;
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
  void clear(){
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
    required this.id,
    required this.image,
  });
  String name;
  String uid;
  String id;
  String image;
}
