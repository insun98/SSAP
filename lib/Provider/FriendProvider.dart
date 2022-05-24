import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'GroupProvider.dart';

class FriendProvider extends ChangeNotifier {
  Future<void> addFriend(userInfo friend) async {
    CollectionReference product =
    FirebaseFirestore.instance.collection('user');

    product
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Friend')
        .doc(friend.id)
        .set(<String, dynamic>{'name': friend.name,'id':friend.id});
  }

}