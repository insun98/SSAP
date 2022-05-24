import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  NotificationProvider() {
    init();
  }

  StreamSubscription<DocumentSnapshot>? _notificationSubscription;
  NotificationInfo _notificationInfo = NotificationInfo(Friend: [], Group: []);

  NotificationInfo get notificationInfo => _notificationInfo;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      print("FirebaseAuth.instance.currentUser!.uid");
      _notificationSubscription = FirebaseFirestore.instance
          .collection('notification')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots().
      listen((snapshot) {
        if (snapshot.data() != null) {
          _notificationInfo.Friend = snapshot.data()!['friend'];
          _notificationInfo.Group = snapshot.data()!['group'];

        }
        notifyListeners();
      }
      );

    });
  }

  Future<void> remove(String notification) async {
    var val = []; //blank list for add elements which you want to delete
    val.add(notification);
    FirebaseFirestore.instance.collection("notification").doc(
        FirebaseAuth.instance.currentUser?.uid).update({

      "friend": FieldValue.arrayRemove(val)});
    notifyListeners();
  }


  Future<void> addFriend(String notification) async {
    var val = []; //blank list for add elements which you want to delete
    val.add(notification);
    FirebaseFirestore.instance.collection("user").doc(
        FirebaseAuth.instance.currentUser?.uid).update({

      "Friend": FieldValue.arrayUnion(val)});
    notifyListeners();
  }
}



class NotificationInfo {
  NotificationInfo(
      {required this.Friend, required this.Group });
List<dynamic> Friend;
List<dynamic> Group;
 }