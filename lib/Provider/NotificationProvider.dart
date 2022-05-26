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
  Meeting _pendingMeeting = Meeting(
      eventName: "",
      background: const Color(0xFFB9C98C),
      docId: "",
      type: '',
      to: DateTime.now(),
      from: DateTime.now(),
      isAllDay: false);

  Meeting get pendingMeeting => _pendingMeeting;

  Future<void> init() async {
    acceptMeeting("");
    denyMeeting("");
    FirebaseAuth.instance.userChanges().listen((user) {
      print("FirebaseAuth.instance.currentUser!.uid");
      _notificationSubscription = FirebaseFirestore.instance
          .collection('notification')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.data() != null) {
          _notificationInfo.Friend = snapshot.data()!['friend'];
          _notificationInfo.Group = snapshot.data()!['group'];
        }
        notifyListeners();
      });
    });
  }

    Future<void> remove(String notification) async {
      var val = []; //blank list for add elements which you want to delete
      val.add(notification);
      FirebaseFirestore.instance
          .collection("notification")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({"friend": FieldValue.arrayRemove(val)});
      notifyListeners();
    }

    Meeting setGroupPendingTime(String groupId) {
      FirebaseFirestore.instance
          .collection("group")
          .doc(groupId)
          .collection("pending")
          .where('active', isEqualTo: true)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          pendingMeeting.eventName = snapshot.docs[0].data()['schedule name'];
          pendingMeeting.to = snapshot.docs[0].data()['schedule end'].toDate();
          pendingMeeting.from =
              snapshot.docs[0].data()['schedule start'].toDate();
        }

        notifyListeners();
      });
      return pendingMeeting;
    }

    void clean() {
      pendingMeeting.eventName = "";
      pendingMeeting.to = DateTime.now();
      pendingMeeting.from = DateTime.now();
    }

    void denyMeeting(String groupId) async {
      var val = [];
      val.add(groupId);
      int priority = 0;
      var collectionNewPending;
      var collection =  FirebaseFirestore.instance
          .collection("group")
          .doc(groupId)
          .collection('pending')
          .where('active', isEqualTo: true)
          .get().then((value) {
        print("good");
        priority = value.docs[0].data()['priority'];
        print("priority ${priority}");
        value.docs[0].reference.update({'active': false});
        collectionNewPending = FirebaseFirestore.instance
            .collection("group")
            .doc(groupId)
            .collection('pending')
            .where('priority', isEqualTo: priority + 1)
            .get().then((value) {
          if (value != null) {
            value.docs[0].reference.update({'active': true});
          }
          notifyListeners();
        });
      });
    }

    void acceptMeeting(String groupId) async {
      var val = [];
      val.add(groupId);
      int member = 0;
      int accept = 0;
      var querySnapshots;
      List<dynamic> members = [];
      var collection =  FirebaseFirestore.instance
          .collection('group')
          .doc(groupId)
          .get()
          .then((value) {


        print("good");
          members = value.data()!["member"];
          print("member ${members.length}");
          member = members.length;

          querySnapshots = FirebaseFirestore.instance
              .collection("group")
              .doc(groupId)
              .collection('pending')
              .where('active', isEqualTo: true)
              .get().then((value) {
            accept = value.docs[0].data()['accept'] + 1;
            print("accept ${accept}");

            if (accept == member) {
              print("good");
              FirebaseFirestore.instance
                  .collection("group")
                  .doc(groupId)
                  .collection('confirmed')
                  .doc()
                  .set(<String, dynamic>{
                'schedule end': querySnapshots.docs[0].data()['schedule end'],
                'schedule start': querySnapshots.docs[0]
                    .data()['schedule start'],
                'schedule name': querySnapshots.docs[0].data()['schedule name'],
                'type': 'Group'
              });
            } else
              value.docs[0].reference.update({'accept': accept});
            FirebaseFirestore.instance
                .collection("notification")
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .update({"group": FieldValue.arrayRemove(val)});
            notifyListeners();
          });
        });



    }
  }


class NotificationInfo {
  NotificationInfo({required this.Friend, required this.Group});
  List<dynamic> Friend;
  List<dynamic> Group;
}
