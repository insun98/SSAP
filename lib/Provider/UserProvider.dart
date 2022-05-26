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
      userInfo(name: "", uid: "", id: "", image: "", Friend: []);

  userInfo get singleUser => _singleUser;
  List<userInfo> _users = [];

  List<userInfo> get users => _users;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  // List<userInfo> _users = [];
  //
  // StreamSubscription<QuerySnapshot>? _userSubscription;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      _userSubscription = FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          _singleUser.name = snapshot.data()!['name'];
          _singleUser.id = snapshot.data()!['id'];
          _singleUser.uid = snapshot.data()!['uid'];
          _singleUser.image = snapshot.data()!['image'];
          _singleUser.Friend = snapshot.data()!['Friend'];
        }
        print(_singleUser.name);
        notifyListeners();
      });

      notifyListeners();
    });
  }

  userInfo setFriend(String uid) {

    for (var friend in _singleUser.Friend) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(friend)
          .snapshots()
          .listen((snapshot) {
        _users.add(userInfo(
          id: snapshot.data()!['id'],
          uid: snapshot.data()!['uid'],
          image: snapshot.data()!['image'],
          name: snapshot.data()!['name'],
          Friend: snapshot.data()!['Friend'],
        ));
      });
      notifyListeners();
    }
    return singleUser;
  }
}


