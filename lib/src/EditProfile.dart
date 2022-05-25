import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';

import '../Widget/profile_widget.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference _users = FirebaseFirestore.instance.collection('user');

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();

  // late File file = File('image/sos_button.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
              fontFamily: 'Yrsa',
              fontSize: 25,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: _users.doc(currentUser!.uid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData && !snapshot.data!.exists) {
              _usernameController.text = "";
              _passwordController.text = "";
              _nameController.text = "";
              _idController.text = "";
            } else if (snapshot.connectionState == ConnectionState.done) {
              print("here2");
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              _usernameController.text = data["email"];
              _passwordController.text = data["password"];
              _nameController.text = data["name"];
              _idController.text = data["id"];
            }

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 5),
                      ProfileWidget(
                        // imagePath: user.imagePath,

                        imagePath:
                            "https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206",
                        isEdit: true,
                        onClicked: () async {
                          final image = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);

                          if (image == null) return;

                          final directory =
                              await getApplicationDocumentsDirectory();
                          final name = basename(image!.path);
                          final imageFile = File('${directory.path}/$name');
                          final newImage =
                              await File(image.path).copy(imageFile.path);

                          FirebaseFirestore.instance
                              .collection('user')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .update(<String, dynamic>{
                            'image': newImage.path,
                            'uid': FirebaseAuth.instance.currentUser!.uid,
                          }
                                  // setState(() => user = user.copy(imagePath: newImage.path)
                                  );
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _idController,
                        decoration: new InputDecoration(hintText: 'ID'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter ID";
                          }
                        },
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _passwordController,
                        decoration: new InputDecoration(hintText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Password";
                          }
                        },
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _nameController,
                        decoration: new InputDecoration(hintText: 'Name'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Name";
                          }
                        },
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        controller: _usernameController,
                        decoration: new InputDecoration(hintText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            (value!.isEmpty) ? ' Please enter email' : null,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: const Text('confirm'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFB9C98C),
                          // set the background color

                          minimumSize: Size(100, 35),
                        ),
                        onPressed: () {
                          profile_register(
                              _usernameController.text,
                              _idController.text,
                              _passwordController.text,
                              _nameController.text,
                              (e) => _showErrorDialog(context, 'error ', e));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  // chooseImage() async {
  //   XFile? xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   print("file " + xfile!.path);
  //   file = File(xfile.path);
  //   setState(() {});
  // }
  //
  // updateProfile(BuildContext context) async {
  //
  //   if (file != null) {
  //     String url = await uploadImage();
  //     FirebaseFirestore.instance
  //         .collection('user')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .set(<String, dynamic>{
  //       'image':url,
  //       'uid': FirebaseAuth.instance.currentUser!.uid,
  //     });
  //
  //   }
  //
  //   await FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .set(<String, dynamic>{
  //     'image':url,
  //     'uid': FirebaseAuth.instance.currentUser!.uid,
  //   });
  //
  //   Navigator.pop(context);
  //
  //
  // }
  //
  // Future<String> uploadImage() async {
  //   TaskSnapshot taskSnapshot = await FirebaseStorage.instance
  //       .ref()
  //       .child("profile_picture")
  //       .child(
  //           FirebaseAuth.instance.currentUser!.uid + "_" + basename(file.path))
  //       .putFile(file);
  //
  //   return taskSnapshot.ref.getDownloadURL();
  // }

  Future<void> profile_register(
      String email,
      String displayName,
      String password,
      String name,
      void Function(FirebaseAuthException e) errorCallback) async {
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(<String, dynamic>{
      'email': email,
      'name': name,
      'id': displayName,
      'password': password,
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
  }
}
