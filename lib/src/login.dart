// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../Provider/AuthProvider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formkey,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Hero(
                              tag: '1',
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: _idController,
                              decoration: new InputDecoration(hintText: 'ID'),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return "Please enter ID";
                              //   }
                              // },
                              // onChanged: (value) {
                              //   userId = value;
                              // },
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: _nameController,
                              decoration: new InputDecoration(hintText: 'Name'),
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return "Please enter Name";
                              //   }
                              // },
                              // onChanged: (value) {
                              //   userName = value;
                              // },
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: _usernameController,
                              decoration:
                                  new InputDecoration(hintText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              // onChanged: (value) {
                              //   email = value.toString().trim();
                              // },
                              // validator: (value) => (value!.isEmpty)
                              //     ? ' Please enter email'
                              //     : null,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: _passwordController,
                              decoration:
                                  new InputDecoration(hintText: 'Password'),
                              obscureText: true,
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return "Please enter Password";
                              //   }
                              // },
                              // onChanged: (value) {
                              //   password = value;
                              // },
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              child: const Text('Confirm'),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFB9C98C),
                                // set the background color

                                minimumSize: Size(300, 35),
                              ),
                              onPressed: () {
                                registerAccount(
                                    _usernameController.text,
                                    _idController.text,
                                    _passwordController.text,
                                    _nameController.text,
                                    (e) => _showErrorDialog(
                                        context, 'Invalid email', e));
                                _idController.clear();
                                _nameController.clear();
                                _usernameController.clear();
                                _passwordController.clear();
                                Navigator.pushNamed(context, '/login');
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
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

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      String name,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(<String, dynamic>{
      'image':
          "https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206",
      'email': email,
      'name': name,
      'id': displayName,
      'password': password,
      'followers': "20",
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
