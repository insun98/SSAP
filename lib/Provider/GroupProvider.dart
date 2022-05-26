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
import '../Provider/scheduleProvider.dart';
import '../Provider/UserProvider.dart';

class GroupProvider extends ChangeNotifier {
  GroupProvider() {
    init();
  }
  String _defaultImage = "";
  String value = "ASC";
  int userIndex = 0;
  userInfo _singleUser = userInfo(name:"", uid:"", id: "", image:  "", Friend: []);
  userInfo get singleUser => _singleUser;
  List<userInfo> _users = [];
  List<userInfo> get users => _users;
  groupInfo _singleGroup = groupInfo(groupName: "", docId: "", member: []);
  groupInfo get singleGroup  => _singleGroup;
  List<groupInfo> _groups = [];
  List<groupInfo> get groups => _groups;
  List<userInfo> _members =[];
  List<userInfo> get members => _members;
  List<Meeting> _confirmedSchedules = [];
  List<Meeting> get confirmedSchedules => _confirmedSchedules;
  Meeting _pendingMeeting = Meeting(eventName: "", background:  const Color(0xFFB9C98C), docId: "", type: '', to: DateTime.now(), from: DateTime.now(), isAllDay: false);
  Meeting get pendingMeeting => _pendingMeeting;
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
          .where('member', arrayContains: FirebaseAuth.instance.currentUser?.uid)

          .snapshots()
          .listen((snapshot) {
        _groups = [];

        for (final document in snapshot.docs) {
          _groups.add(
            groupInfo(
              groupName: document.data()['groupName'] as String,
              docId: document.id,
              member: document.data()["member"],
            ),
          );

          notifyListeners();
        }
        notifyListeners();
      });


   
  });
  }

userInfo searchUser(String uid) {
  userInfo user= userInfo(name: "", id: "", image: "", uid: "", Friend: []);
  FirebaseFirestore.instance
      .collection('user')
      .doc(uid)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.exists) {
      user.name = snapshot.data()!['name'];
      user.id = snapshot.data()!['id'];
      user.uid = snapshot.data()!['uid'];
      user.image = snapshot.data()!['image'];

      user.Friend = snapshot.data()!['Friend'];
    }
    notifyListeners();
  });

  return user;
  }



  userInfo searchingUser(String userId) {
    userInfo user = userInfo(name: "", id: "", image: "", uid: "", Friend:[]);
     FirebaseFirestore.instance
        .collection('user')
        .where('id', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
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




  String addGroup(List<dynamic> members, String groupName) {

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

  groupInfo setGroup(String groupId) {

  FirebaseFirestore.instance
      .collection('group')
      .doc(groupId).snapshots()
      .listen((snapshot) {
    if (snapshot.data() != null) {
      singleGroup.groupName = snapshot.data()!['groupName'];
      singleGroup.member = snapshot.data()!['member'];
      singleGroup.docId = groupId;


    }});
    for(var member in singleGroup.member){
      FirebaseFirestore.instance
          .collection('user')
              .doc(member).snapshots()
              .listen((snapshot) {
                members.add(userInfo(
                  id: snapshot.data()!['id'],
                    uid:snapshot.data()!['uid'],
                  image: snapshot.data()!['image'],
                  name: snapshot.data()!['name'],
                  Friend:snapshot.data()!['Friend'],
                ));


      });
      }
  FirebaseFirestore.instance.collection("group").doc(
      groupId).collection("pending").where('active',isEqualTo: true).snapshots().listen((snapshot) {
    if( snapshot.docs.isNotEmpty) {
      pendingMeeting.eventName=snapshot.docs[0].data()['schedule name'];
      pendingMeeting.to= snapshot.docs[0].data()['schedule end'].toDate();
      pendingMeeting.from=snapshot.docs[0].data()['schedule start'].toDate();
      pendingMeeting.accept =snapshot.docs[0].data()['accept'];
    }

    notifyListeners();
  });
  FirebaseFirestore.instance
      .collection('group')
      .doc(groupId)
      .collection('confirmed')
      .snapshots()
      .listen((snapshot) {
    _confirmedSchedules = [];

    for (final document in snapshot.docs) {
      _confirmedSchedules.add(
        Meeting(
            eventName: document.data()['schedule name'],
            background:  const Color(0xFFB9C98C),
            docId: document.id,
            type: document.data()['type'],
            to: document.data()['schedule end'],
            from: document.data()['schedule start'],
            isAllDay: false

        ),
      );
    }
    notifyListeners();
  });

return singleGroup;
  }




  Future<void> deleteMember(String docId) async {
    var val = []; //blank list for add elements which you want to delete
    val.add(docId);
    FirebaseFirestore.instance
        .collection("group")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({"friend": FieldValue.arrayRemove(val)});
    notifyListeners();
    var collection = FirebaseFirestore.instance
        .collection('group')
        .doc(docId)
        .collection('pending');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    collection = FirebaseFirestore.instance
        .collection('group')
        .doc(docId)
        .collection('confirmed');
    snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }


    FirebaseFirestore.instance.collection('group').doc(docId).delete();
    notifyListeners();
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
  userInfo(
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

class groupInfo {
  groupInfo(
      {required this.groupName, required this.docId, required this.member});
  List<dynamic> member;
  String docId;
  String groupName;
}
