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

import 'package:provider/provider.dart';





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
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: const <Widget>[
                Text('Yori',
                    style: TextStyle(
                        fontFamily: 'Yrsa',
                        color: Color(0xFF961D36),
                        fontSize: 64)),
                Text('Jori',
                    style: TextStyle(
                        fontFamily: 'Yrsa',
                        color: Color(0xFF961D36),
                        fontSize: 64)),
              ],
            ),
            const SizedBox(height: 30.0),
            // TODO: Remove filled: true values (103)
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFFBF7F7),
                labelText: '이름',
                border: OutlineInputBorder(),
              ),

            ),
          const SizedBox(height: 12.0),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFFBF7F7),
                labelText: '아이디',
                border: OutlineInputBorder(),
              ),

            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFFBF7F7),
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color(0xFFFBF7F7),
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              child: const Text('가입하기'),
              style: ElevatedButton.styleFrom(primary: Color(0xFF961D36)),
              onPressed: () {
               registerAccount(_usernameController.text, _idController.text, _passwordController.text,_nameController.text,(e) => _showErrorDialog(context, 'Invalid email', e));
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
      'image':"https://firebasestorage.googleapis.com/v0/b/yorijori-52f2a.appspot.com/o/defaultProfile.png?alt=media&token=127cd072-80b8-4b77-ab22-a50a0dfa5206",
      'email': email,
      'name': name,
      'id': displayName,
      'password': password,
      'uid': FirebaseAuth.instance.currentUser!.uid,
    });

  }

}
