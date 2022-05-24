import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'GroupProvider.dart';

class FriendProvider extends ChangeNotifier {
  Future<void> addFriend(String notification) async {
    var val = []; //blank list for add elements which you want to delete
    val.add(notification);
    FirebaseFirestore.instance.collection("user").doc(
        FirebaseAuth.instance.currentUser?.uid).update({

      "Friend": FieldValue.arrayUnion(val)});
     val = [];
    val.add( FirebaseAuth.instance.currentUser?.uid);

    FirebaseFirestore.instance.collection("user").doc(
        notification).update({

      "Friend": FieldValue.arrayUnion(val)});
    notifyListeners();
  }


}