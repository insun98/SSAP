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

  userInfo _singleUser =
  userInfo(name: "",
      uid: "",
      id: "",
      image: "",
      Friend: []);

  userInfo get singleUser => _singleUser;
  List<userInfo> _users = [];

  List<userInfo> get users => _users;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  // List<userInfo> _users = [];
  //
  // StreamSubscription<QuerySnapshot>? _userSubscription;

  Future<void> init() async {


    var snapshot = FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((value) =>
    {
      _singleUser.name = value.data()!['name'],
      _singleUser.id = value.data()!['id'],
      _singleUser.uid = value.data()!['uid'],
      _singleUser.image = value.data()!['image'],
      _singleUser.Friend = value.data()!['Friend']
    });
    print(_singleUser.name);
  }


  userInfo setFriend(String uid) {

    for (var friend in _singleUser.Friend) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(friend)
          .get().then((value) {  _users.add(userInfo(
        id: value.data()!['id'],
        uid: value.data()!['uid'],
        image: value.data()!['image'],
        name: value.data()!['name'],
        Friend: value.data()!['Friend'],

      ));
      });
      notifyListeners();
    }
    return singleUser;
  }
}


