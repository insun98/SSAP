import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../firebase_options.dart';
import 'GroupProvider.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    init();
  }

  singleuserInfo _singleUser =
  singleuserInfo(name: "", uid: "", id: "", image: "", Friend: []);

  singleuserInfo get singleUser => _singleUser;
  List<singleuserInfo> _users = [];

  List<singleuserInfo> get users => _users;
  StreamSubscription<QuerySnapshot>? _userSubscription;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      FirebaseFirestore.instance
          .collection('user')
          .snapshots()
          .listen((snapshot) {
        _users = [];

        for (final document in snapshot.docs) {
          if (document.data()['uid'] ==
              FirebaseAuth.instance.currentUser!.uid) {
            _singleUser.name = document.data()['name'] as String;
            _singleUser.id = document.data()['id'] as String;
            _singleUser.uid = document.data()["uid"];
            _singleUser.image = document.data()["image"];
            _singleUser.Friend = document.data()["Friend"];
          }
          // document.data()['uid']==FirebaseAuth.instance.currentUser!.uid
          _users.add(
            singleuserInfo(
              name: document.data()['name'] as String,
              id: document.data()['id'] as String,
              uid: document.data()["uid"],
              image: document.data()["image"],
              Friend: document.data()["Friend"],
            ),
          );

          notifyListeners();
        }
        notifyListeners();
      });

      notifyListeners();
    });
  }

  void clear() {
    notifyListeners();
  }

  singleuserInfo searchUserwithId(String userId) {
    for (var user in _users) {
      String freindId = userId.trim();
      String user_ID = user.uid.trim();

      if (user_ID.compareTo(freindId) == 0) {
        // print("Real friend ID : ${userId}");
        // print("Real user.uid : ${user.uid}");
        return user;
      }
    }
    notifyListeners();
    return singleUser;
  }
}

class singleuserInfo {
  singleuserInfo(
      {required this.name,
        required this.uid,
        required this.id,
        required this.image,
        required this.Friend});

  String name;
  String uid;
  String id;
  String image;
  List<dynamic> Friend;
}