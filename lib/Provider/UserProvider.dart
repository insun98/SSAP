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

  userInfo _singleUser = userInfo(name: "",
      uid: "",
      id: "",
      image: "",
      Friend: []);

  userInfo get singleUser => _singleUser;
  List<userInfo> _users = [];

  List<userInfo> get users => _users;
  StreamSubscription<QuerySnapshot>? _userSubscription;

  // List<userInfo> _users = [];
  //
  // StreamSubscription<QuerySnapshot>? _userSubscription;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      // FirebaseFirestore.instance
      //     .collection('user')
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .snapshots()
      //     .listen((snapshot) {
      //   if (snapshot.exists) {
      //     _singleUser.name = snapshot.data()!['name'];
      //     _singleUser.id = snapshot.data()!['id'];
      //     _singleUser.uid = snapshot.data()!['uid'];
      //     _singleUser.image = snapshot.data()!['image'];
      //     _singleUser.Friend = snapshot.data()!['Friend'];
      //   }
      //   print(_singleUser.name);
      //   notifyListeners();
      // });
      FirebaseFirestore.instance
          .collection('user')

          .snapshots()
          .listen((snapshot) {



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




        }
        notifyListeners();
      });

      // _userSubscription = FirebaseFirestore.instance
      //     .collection('user')
      //     .where('Friend',
      //     arrayContains: FirebaseAuth.instance.currentUser
      //         ?.uid) //여기에 친구 아이디가 포함되어야 하는거 아닌가..?
      //     .snapshots()
      //     .listen((snapshot) {
      //   _users = [];
      //
      //   for (final document in snapshot.docs) {
      //     print("user:${document.data()['name']}");
      //     _users.add(
      //       userInfo(
      //         name: document.data()['name'] as String,
      //         id: document.data()['id'],
      //         uid: document.data()['uid'],
      //         image: document.data()['image'],
      //
      //
      //         Friend: document.data()["Friend"],
      //       ),
      //     );
      //   }
      //   notifyListeners();
      // });

      notifyListeners();
    });
  }

  // _userSubscription = FirebaseFirestore.instance
  //     .collection('user')
  //     .snapshots()
  //     .listen((snapshot) {
  // _users = [];
  //
  // for (final document in snapshot.docs) {
  // _users.add(
  // userInfo(
  // name: document.data()['name'] as String,
  // id: document.data()['id'] as String,
  // uid: document.data()["uid"],
  // image: document.data()["image"],
  // ),
  // );
  // }
  // notifyListeners();
  // });

// userInfo? searchUser(String uid) {
//   for (var user in _users) {
//     if (user.uid == uid)
//       return user;
//   }
//   return null;
// }
//
// userInfo searchUserwithId(String userId) {
//   for (var user in _users) {
//     if (user.id == userId)
//       return user;
//   }
//   notifyListeners();
//   return singleUser;
// }

  // userInfo User() {
  //   userInfo user = userInfo(name: "", id: "", image: "", uid: "", Friend: []);
  //   FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots()
  //       .listen((snapshot) {
  //     if (snapshot.exists) {
  //       user.name = snapshot.data()!['name'];
  //       user.id = snapshot.data()!['id'];
  //       user.uid = snapshot.data()!['uid'];
  //       user.image = snapshot.data()!['image'];
  //       user.Friend = snapshot.data()!['Friend'];
  //     }
  //     notifyListeners();
  //   });
  //   notifyListeners();
  //   return user;
  // }

  void clear() {
    notifyListeners();
  }

  userInfo? searchUser(String uid) {
    for (var user in _users) {
      if (user.uid == uid) return user;
    }
    return null;
  }

  userInfo searchUserwithId(String userId) {
    for (var user in _users) {
      if (user.uid == userId) return user;
    }
    notifyListeners();
    return singleUser;
  }

// userInfo searchUserwithId(String userId) {
//   for (var user in _users) {
//     if (user.id == userId)
//       return user;
//   }
//   notifyListeners();
//   return singleUser;
// }

  userInfo setFriend(String uid) {
    for (var friend in _singleUser.Friend) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(friend).snapshots()
          .listen((snapshot) {
        _users.add(userInfo(
          id: snapshot.data()!['id'],
          uid: snapshot.data()!['uid'],
          image: snapshot.data()!['image'],
          name: snapshot.data()!['name'],
          Friend:snapshot.data()!['Friend'],
        ));
      });
    }
    return singleUser;
  }
}



// class groupInfo {
//   groupInfo(
//       {required this.groupName,
//         required this.docId,
//         required this.member
//       });
//
//   List<dynamic> member;
//   String docId;
//   String groupName;
// }
