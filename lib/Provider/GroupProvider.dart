import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../firebase_options.dart';
import '../src/addGroup.dart';


class GroupProvider extends ChangeNotifier {
  bool order = true;
  String _defaultImage = "";
  String value = "ASC";
  int userIndex = 0;
  GroupProvider() {
    init(value);
  }
  StreamSubscription<DocumentSnapshot>? _profileSubscription;
  StreamSubscription<QuerySnapshot>? _groupSubscription;
  StreamSubscription<DocumentSnapshot>? _searchUserSubscription;
  Future<void> init(String newValue) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );


    final storageRef = FirebaseStorage.instance.ref();
    const filename = "defaultimage.png";
    final mountainsRef = storageRef.child(filename);
    value = newValue;
    if (value == "ASC") {
      order = false;
    } else {
      order = true;
    }

    final downloadUrl = await mountainsRef.getDownloadURL();
    _defaultImage = downloadUrl;

    FirebaseAuth.instance.userChanges().listen((user) {
      // _profileSubscription = FirebaseFirestore.instance
      //     .collection('user')
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .snapshots()
      //     .listen((snapshot) {
      //   if (snapshot.data() != null) {
      //     _profile.name = snapshot.data()!['name'];
      //     _profile.id = snapshot.data()!['email'];
      //     _profile.state_message = snapshot.data()!['state_message'];
      //     _profile.photo = snapshot.data()!['image'];
      //     _profile.uid = snapshot.data()!['name'];
      //     notifyListeners();
      //   }
      // });

      _groupSubscription = FirebaseFirestore.instance
          .collection('user')
          .snapshots()
          .listen((snapshot) {
        _users = [];
        for (final document in snapshot.docs) {
          _users.add(
            User(
              uid: document.id,
              name: document.data()['name'] as String,
              Userid: document.data()['id'] as String,
              index: ++userIndex,
            ),
          );
          print(document.data()['name'] as String);
        }
        notifyListeners();
      });
      if (order == true) {
        order = false;
      } else {
        order = true;
      }
    });
  }

  String get defaultimage => _defaultImage;

  List<User> _users = [];
  List<User> get user => _users;
  // Profile _profile = Profile(
  //     name: '',
  //     photo: '',
  //     email: '',
  //     state_message: 'I promise to take the test honestly before God',
  //     uid: ' ');
  // Profile get profile => _profile;

  Editing _editstate = Editing.no;
  Editing get editstate => _editstate;

  Like _like = Like.unlike;

  int _likenumber = 0;
  final int _userExist = 0;
  int get attendees => _likenumber;

  Like checkLike(String docId) {
    final userDoc = FirebaseFirestore.instance
        .collection('product')
        .doc(docId)
        .collection('Like')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.data() != null) {
        if (snapshot.data()!['like'] as bool) {
          _like = Like.like;
        } else {
          _like = Like.unlike;
        }
      } else {
        _like = Like.unlike;
      }
    });
    return _like;
  }

  int countLikes(String docId) {
    FirebaseFirestore.instance
        .collection('product')
        .doc(docId)
        .collection('Like')
        .where('like', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      _likenumber = snapshot.docs.length;
      notifyListeners();
    });
    return _likenumber;
  }

  User? searchUser (String userId){
    User user =User(Userid:"", name:"", index: 0,uid:"");
    FirebaseFirestore.instance
        .collection('user')
       .where('id', isGreaterThanOrEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty ) {
        user.name = snapshot.docs[0].data()['name'];
        user.Userid = snapshot.docs[0].data()['id'];


        notifyListeners();

      }else {
        return;
      }
    });
    return user;

  }
  Future<void> addGroup(List<User> members, String groupName) async {

      FirebaseFirestore.instance
          .collection('group')
          .doc(groupName)
          .set(<String, dynamic>{
        'groupName': groupName,
      });
      for(var member in members) {
        FirebaseFirestore.instance
            .collection('group')
            .doc(groupName)
            .collection('Members')
            .add(<String, dynamic>{
          'name': member.name,
          'uid':member.uid,
          'id':member.Userid,
        });

      }
}
  makeGroup makingState = makeGroup.selectMember;
  Future<DocumentReference> addItem(
      String URL, String name, int price, String description) {
    return FirebaseFirestore.instance
        .collection('product')
        .add(<String, dynamic>{
      'image': URL,
      'productName': name,
      'price': price,
      'description': description,
      'create': FieldValue.serverTimestamp(),
      'modify': FieldValue.serverTimestamp(),
      'creator': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<void> delete(String docId) async {
    FirebaseFirestore.instance.collection('product').doc(docId).delete();
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

  Future<void> like(String docId) async {
    CollectionReference product =
        FirebaseFirestore.instance.collection('product');

    product
        .doc(docId)
        .collection('Like')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(<String, dynamic>{'like': true});
  }

  // myPost checkPost(String creator) {
  //   if (creator == FirebaseAuth.instance.currentUser!.uid) {
  //     return myPost.yes;
  //   } else {
  //     return myPost.no;
  //   }
  // }

  void edit() {
    _editstate = Editing.yes;
    notifyListeners();
  }

  Future<void> save(String stateMessage) async {
    _editstate = Editing.no;
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(<String, dynamic>{'state_message': stateMessage});
    notifyListeners();
  }
}

class Group {
  Group(
      {required this.docId,
      required this.image,
      required this.productName,
      required this.price,
      required this.description,
      required this.create,
      required this.modify,
      required this.creator});
  String docId;
  String image;
  String productName;
  int price;
  String description;
  Timestamp create;
  Timestamp modify;
  String creator;
}

class User {
  User(
      {required this.name,
      required this.uid,
        required this.Userid,
        required this.index,

      });
  String name;
  String uid;
  String Userid;
  int index;

}

enum Like { like, unlike }

enum Editing { yes, no }
