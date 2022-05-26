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
  bool status = false;
  bool month = false;
  final List<Meeting> meetings = ScheduleProvider().getSchedules;
  final _formKey = GlobalKey<FormState>();
  final CalendarController _controller = CalendarController();
  var currentUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('user');

  // Future<String> getUserDoc(String UserId) async {
  //   DocumentReference documentReference = users.doc(UserId);
  //   String data;
  //   await documentReference.get().then((snapshot) {
  //     data = snapshot!.data()?.['name'].toString();
  //   });
  //   return specie;
  // }
  // Future<String> getUserDocName(String UserId) async {
  //   var data;
  //
  //   await users!
  //       .doc(UserId)
  //       .get()
  //       .then((doc) => {data = doc.data()})
  //       .catchError((error) =>
  //           {print("Error on get data from User"), print(error.toString())});
  //
  //   String userName = data["name"];
  //   return userName;
  // }
  //
  // Future<String> getUserDocID(String UserId) async {
  //   var data;
  //
  //   await users!
  //       .doc(UserId)
  //       .get()
  //       .then((doc) => {data = doc.data()})
  //       .catchError((error) =>
  //           {print("Error on get data from User"), print(error.toString())});
  //
  //   String userID = data["id"];
  //   return userID;
  // }

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginWidget()),
                );
              },
            ),
          ],
        ),
      ),
      body:
      // Consumer<GroupProvider>(
      //   builder: (context, group, _) => SafeArea(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Container(
      //           margin: const EdgeInsets.all(10),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               const SizedBox(
      //                 height: 30,
      //               ),
      //               const Divider(
      //                 color: Colors.grey,
      //               ),
      //               SizedBox(
      //
      //                   height:500,
      //                   child: ListView.separated(
      //                     padding: const EdgeInsets.all(8),
      //                     itemCount: group.groups.length,
      //                     itemBuilder: (BuildContext context, int index) {
      //                       return Dismissible(
      //                         key: UniqueKey(),
      //                         child: SizedBox(
      //                           height: 50,
      //                           child: Row(children:[TextButton(
      //                             onPressed: ()  async {
      //                               groupInfo groupinfo = await group.setGroup(group.groups[index].docId);
      //                               print("group: ${groupinfo.groupName}, ${group.groups[index].docId}");
      //                               Navigator.pushNamed(context, '/viewGroup');
      //
      //                             },
      //                             child: Text(
      //                               "${group.groups[index].groupName}    (${group.groups[index].member.length})",
      //                               style: TextStyle(color: Colors.black),
      //                             ),
      //                           ),
      //
      //
      //
      //                           ],
      //
      //                           ),
      //                         ),
      //                       );
      //                     },
      //                     separatorBuilder:
      //                         (BuildContext context, int index) {
      //                       return const Divider(color: Colors.grey,);
      //                     },
      //                   )),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      //   resizeToAvoidBottomInset: true,
      SingleChildScrollView(child:SafeArea(
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
                    // Navigator.pushNamed(context, '/');
                    // print(userProvider.singleUser.name);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                ),

                // TextFormField(
                //   controller: _controller,
                //   decoration: const InputDecoration(
                //     filled: true,
                //     fillColor: Color(0xffE5E5E5),
                //     hintText: 'Search by Id',
                //   ),
                //   onChanged: (value) {
                //     setState(() {
                //       if (_controller.text == null) {
                //         user = groupProvider.searchUser(_controller.text)!;
                //       }
                //       String name = value;
                //       user = groupProvider.searchUser(_controller.text)!;
                //     });
                //   },
                // ),
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
                    height: 700,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: user.users.length,
                      itemBuilder: (BuildContext context, int index) {
                        // if(user.singleUser.Friend[index]){
                        //
                        // }
                        // userInfo friendUser =
                        // user.searchUserwithId(user.singleUser.Friend[index]);
                        // user.users[index];
                        return SizedBox(
                          height: 30,
                          child: TextButton(
                            onPressed: () {
                              context
                                  .read<ScheduleProvider>()
                                  .getFriendSchedules(
                                  user.users[index].uid);
                              //  's2MVJDiwX7heYDR5xiD07mi6AKC2'
                              Navigator.pushNamed(context, '/friendCalendar');

                              //  friendProvider.addFriend();
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.account_circle,
                                  color: Colors.black,
                                ),
                                // future.then((val) {
                                //   // int가 나오면 해당 값을 출력
                                //   print('val: $val');
                                // }).catchError((error) {
                                //   // error가 해당 에러를 출력
                                //   print('error: $error');
                                // });
                                Text(
                                  "${user.users[index].name} (${user.users[index].id})",
                                  // getUserDocName(user.singleUser.Friend[index].toString()).then((value) => null
                                  //"${getUserDocName(user.singleUser.Friend[index].toString())}"+"${getUserDocID(user.singleUser.Friend[index].toString())}"
                                  //"${users.doc(user.singleUser.Friend[index].toString()).get()} (${users.doc(user.singleUser.Friend[index].toString()).get()})"
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
                // RadioGrou
                //           users: groupProvider.user,
                //         ),
              ],
            ),
          ),
        ),
      ),),

      resizeToAvoidBottomInset: false,
      // Container(
      //   child: Column(
      //     children: [
      //       ListTile(
      //           title: Text('노은호(eunho111'),
      //           onTap: () {
      //             context.read<ScheduleProvider>().getFriendSchedules('s2MVJDiwX7heYDR5xiD07mi6AKC2');
      //             Navigator.pushNamed(
      //               context,
      //               '/friendCalendar'
      //             );
      //           })
      //     ],
      //   ),
      // ),
    );
  }
}
