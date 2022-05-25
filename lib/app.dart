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

import 'package:flutter/material.dart';
import 'package:shrine/src/Friend.dart';
import 'package:shrine/src/Notification.dart';
import 'package:shrine/src/ViewGroup.dart';

import 'package:shrine/src/addGroup.dart';
import 'package:shrine/src/friendCalendar.dart';
import 'package:shrine/src/friendlist.dart';
import 'package:shrine/src/gruopList.dart';




import 'package:shrine/src/scheduleView.dart';
import 'package:shrine/src/signup.dart';


import 'src/login.dart';



// TODO: Convert ShrineApp to stateful widget (104)
class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      initialRoute: '/login',
      routes: {
        // '/login': (BuildContext context) => LoginPage(),
        // TODO: Change to a Backdrop with a HomePage frontLayer (104)
        '/addGroup': (BuildContext context) => const AddGroupPage(),

        '/home': (BuildContext context) => const MyHomePage(),
        '/login': (BuildContext context) => const LoginWidget(),
        '/signup': (BuildContext context) => const SignupPage(),
        '/groupList': (BuildContext context) => const GroupList(),
        '/addgroupSchedule': (BuildContext context) => const AddGroupSchedule(),
        '/addFriend': (BuildContext context) => const AddFriend(),
        '/friendlist' : (BuildContext context) => const FriendLIst(),
        '/friendCalendar' : (BuildContext context) => const FriendCalendar(),
        '/viewGroup' : (BuildContext context) => const ViewGroup(),
        '/Notification' : (BuildContext context) => const NotificationPage(),



        // TODO: Make currentCategory field take _currentCategory (104)
        // TODO: Pass _currentCategory for frontLayer (104)
        // TODO: Change backLayer field value to CategoryMenuPage (104)
      },
      // TODO: Add a theme (103)
    );
  }
}

// TODO: Build a Shrine Theme (103)
// TODO: Build a Shrine Text Theme (103)
