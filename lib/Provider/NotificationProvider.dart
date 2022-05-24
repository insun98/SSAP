import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shrine/Provider/scheduleProvider.dart';

class NotificationProvider with ChangeNotifier {
  NotificationProvider() {
    init();
  }

  StreamSubscription<DocumentSnapshot>? _notificationSubscription;
  NotificationInfo _notificationInfo = NotificationInfo(Friend: [], Group: []);

  NotificationInfo get notificationInfo => _notificationInfo;
  Meeting _pendingMeeting = Meeting(eventName: "",background: Colors.black,docId: "", type: '', to: DateTime.now(), from: DateTime.now(), isAllDay: false);
  Meeting get pendingMeeting => _pendingMeeting;
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


  Meeting setGroupPendingTime(String groupId) {
    FirebaseFirestore.instance.collection("group").doc(
        groupId).collection("pending").where('active',isEqualTo: true).snapshots().listen((snapshot) {
          if( snapshot.docs.isNotEmpty) {
            pendingMeeting.eventName=snapshot.docs[0].data()['schedule name'];
            pendingMeeting.to= snapshot.docs[0].data()['schedule end'].toDate();
            pendingMeeting.from=snapshot.docs[0].data()['schedule start'].toDate();

    }

          notifyListeners();
        }

    );
    return pendingMeeting;
    }
    void clean(){
      pendingMeeting.eventName="";
      pendingMeeting.to= DateTime.now();
      pendingMeeting.from=DateTime.now();

    }
  void denyMeeting(String groupId) async {
    var val = [];
    val.add(groupId);


    var querySnapshots = await FirebaseFirestore.instance.collection("group").doc(
        groupId).collection('pending').where('active',isEqualTo: true).get();

     int priority  = await querySnapshots.docs[0].data()['priority'];
     print(priority);
    // for (var doc in querySnapshots.docs) {
    //   await doc.reference.delete();
    // }
    await querySnapshots.docs[0].reference.update({'active': false});
    var collectionNewPending = await FirebaseFirestore.instance.collection("group").doc(
        groupId).collection('pending') .where('priority',isEqualTo:priority+1 ).get();
    if(collectionNewPending!=null) {
      await collectionNewPending.docs[0].reference.update({'active': true});
    }

    await FirebaseFirestore.instance.collection("notification").doc(
        FirebaseAuth.instance.currentUser?.uid).update({
      "group": FieldValue.arrayRemove(val)});
    notifyListeners();
  }
   void acceptMeeting(String groupId) async {
    var val = [];
    val.add(groupId);
    int member =0;
   var collection = await FirebaseFirestore.instance.collection('group').doc(groupId)
        .get();
        List<dynamic> members= collection.data()!["member"];
    print("member ${members.length}" );

    var querySnapshots = await FirebaseFirestore.instance.collection("group").doc(
        groupId).collection('pending') .where('active',isEqualTo: true).get();
     int accept = await querySnapshots.docs[0].data()['accept'] + 1;
    print("accept ${accept}" );
    if (accept == member){
      //add schedule to all users
      String id = FirebaseFirestore.instance.collection('group').doc().collection('confirmed').id;
        await FirebaseFirestore.instance
            .collection("group")
            .doc(groupId)
            .collection('confirmed').doc(id).set(<String, dynamic>{'schedule end': querySnapshots.docs[0].data()['schedule end'],'schedule start': querySnapshots.docs[0].data()['schedule start'],'schedule name':  querySnapshots.docs[0].data()['schedule name'], 'type':'Group'});

    }else {
      await querySnapshots.docs[0].reference.update({'accept':accept});
    }


    await FirebaseFirestore.instance.collection("notification").doc(
        FirebaseAuth.instance.currentUser?.uid).update({
      "group": FieldValue.arrayRemove(val)});
    notifyListeners();

  }


}



class NotificationInfo {
  NotificationInfo(
      {required this.Friend, required this.Group });
List<dynamic> Friend;
List<dynamic> Group;
 }