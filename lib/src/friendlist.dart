import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shrine/Provider/scheduleProvider.dart';
import 'package:shrine/src/friendCalendar.dart';
import 'package:shrine/src/scheduleView.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Provider/UserProvider.dart';
import 'EditProfile.dart';
import 'Notification.dart';
import 'addGroup.dart';
import 'login.dart';

class FriendLIst extends StatefulWidget {
  const FriendLIst({Key? key}) : super(key: key);

  @override
  State<FriendLIst> createState() => _FriendLIstState();
}

class _FriendLIstState extends State<FriendLIst> {
  // User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginWidget()));
  }
  bool status = false;
  bool month = false;
  final List<Meeting> meetings = ScheduleProvider().getSchedules;
  final _formKey = GlobalKey<FormState>();
  final CalendarController _controller = CalendarController();
  var currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      drawerScrimColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Friends',
          style: TextStyle(color: Colors.black),
        ),
        //centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0.0,
        leading: Builder(
          builder: (context) => IconButton(
            color: Colors.black,
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              },
              icon: const Icon(
                Icons.notifications,
                color: Color(0xFFB9C98C),
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  month = true;
                  if (kDebugMode) {
                    print(month);
                  }
                });
              },
              icon: const Icon(
                Icons.search,
                color: Color(0xFFB9C98C),
              )),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddGroupPage()));
              },
              icon: const Icon(
                Icons.person_add_alt_1,
                color: Color(0xFFB9C98C),
              )),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const Padding(
              child: Text(
                'SSAP calendar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              padding: EdgeInsets.only(top: 40, left: 10),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              title: Text(
                userProvider.singleUser.name +
                    " (" +
                    userProvider.singleUser.id +
                    ")",
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.people,
                color: Color(0xFFB9C98C),
              ),
              title: const Text(
                'Group List',
                style: TextStyle(color: Color(0xFFB9C98C)),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/groupList');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.people,
                color: Colors.black,
              ),
              title: const Text('My Friend List'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Color(0xFFB9C98C),
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );
              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: const Text(
                    'Pubic/Private View',
                    style: TextStyle(),
                  )),
              Container(
                padding: const EdgeInsets.only(right: 16),
                child: FlutterSwitch(
                  onToggle: (val) {
                    setState(() {
                      status = !status;
                    });
                  },
                  value: status,
                  width: 40.0,
                  height: 20.0,
                  valueFontSize: 10.0,
                  toggleSize: 15.0,
                  borderRadius: 30.0,
                  toggleColor: Colors.white,
                  activeColor: const Color(0xFFB9C98C),
                ),
              ),
            ]),
            ListTile(
              title: const Text('Sign out'),
              onTap: () {
                signOut();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, user, _) => Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.account_circle,
                    color: Colors.black,
                  ),
                  title: Text(
                    user.singleUser.name + " (" + user.singleUser.id + ")",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Friends ${user.singleUser.Friend.length}",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                    height: 400,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: user.singleUser.Friend.length,
                      itemBuilder: (BuildContext context, int index) {
                        singleuserInfo friendUser = user
                            .searchUserwithId(user.singleUser.Friend[index]);
                        String friendID = user.singleUser.Friend[index].trim();
                        return SizedBox(
                          height: 30,
                          child: TextButton(
                            onPressed: () {
                              context
                                  .read<ScheduleProvider>()
                                  .getFriendSchedules(friendID);

                              Navigator.pushNamed(context, '/friendCalendar');
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_circle,
                                  color: Colors.black,
                                ),
                                Text(
                                  "         ${friendUser.name}  (${friendUser.id})",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}