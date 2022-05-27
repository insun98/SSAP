import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shrine/Provider/FriendProvider.dart';

import '../Provider/GroupProvider.dart';
import '../Provider/NotificationProvider.dart';
import '../Provider/UserProvider.dart';
import '../Provider/scheduleProvider.dart';
import 'EditProfile.dart';
import 'login.dart';


class NotificationPage extends StatefulWidget {


  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool status = false;

  @override

  Widget build(BuildContext context) {
    FriendProvider friendProvider = Provider.of<FriendProvider>(context);
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Consumer<NotificationProvider>(
      builder: (context, notify, _) =>Scaffold(
        drawerScrimColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          title: Text(
            'Notification',
            style: const TextStyle(color: Colors.black),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              color: Colors.black,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),

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
                      "(" +
                      userProvider.singleUser.id +
                      ")",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/home');

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
                onTap: () {Navigator.pushNamed(context, '/groupList');},
              ),
              ListTile(
                leading: const Icon(
                  Icons.people,
                  color: Colors.black,
                ),
                title: const Text('My Friend List'),
                onTap: () {
                  Navigator.pushNamed(context, '/friendlist');


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
                    MaterialPageRoute(
                        builder: (context) => const LoginWidget()),
                  );

                },
              ),
            ],
          ),
        ),
        body:


        SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          //List of Group Members
                          Text('Group Schedule Confirmation',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey[600])),
                          const Divider(
                            height: 8,
                            thickness: 1,
                            indent: 0,
                            endIndent: 8,
                            color: Colors.grey,
                          ),
                          SizedBox(
                              height: 250,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount:  notify.notificationInfo.Group.length,
                                itemBuilder: (BuildContext context, int index)  {
                                  Meeting meeting =   notify.setGroupPendingTime(notify.notificationInfo.Group[index]);
                                  // print("user: ${notify.notificationInfo.Friend[index]}");
                                  return SizedBox(
                                    height: 50,
                                    child:   Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(child: SizedBox( child: meeting.eventName != ""?Column(crossAxisAlignment: CrossAxisAlignment.start,children:[Text("${meeting.eventName}",style: TextStyle(color:Colors.black),),Text("${meeting.from.toString()}",style: TextStyle(color:Colors.black),),],) : Text(""),),
                                        ),
                                        meeting.eventName != "" ?ElevatedButton(
                                          child: const Text('accept'),
                                          style: ElevatedButton.styleFrom(primary: Color(0xffB9C98C)),
                                          onPressed: () async { notify.acceptMeeting(notify.notificationInfo.Group[index]);  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text('Accepted group meeting'),
                                          ));},
                                        ):Text(""),
                                        SizedBox(width:30),
                                        meeting.eventName != ""? ElevatedButton(
                                          child: const Text('deny'),
                                          style: ElevatedButton.styleFrom(primary: Color(0xffB9C98C)),
                                          onPressed: ()  async {ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text('Denied the group meeting '),
                                          ));print("good"); notify.denyMeeting(notify.notificationInfo.Group[index]);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text('New group meeting recommended'),
                                          ));
                                          },


                                        ):Text(""),
                                        SizedBox(height:10),
                                      ],

                                    ),
                                  );
                                },
                              )),
                          Text('Friend Request',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey[600])),
                          const Divider(
                            height: 8,
                            thickness: 1,
                            indent: 0,
                            endIndent: 8,
                            color: Colors.grey,
                          ),
                          SizedBox(
                              height: 250,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8),
                                itemCount:  notify.notificationInfo.Friend.length,
                                itemBuilder: (BuildContext context, int index)  {
                                userInfo  user =   groupProvider.searchUser(notify.notificationInfo.Friend[index]);
                                  // print("user: ${notify.notificationInfo.Friend[index]}");
                                  return SizedBox(
                                    height: 50,
                                    child:   Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox( width:100,child:Text("${groupProvider.singleUser.name}"),),
                                        ElevatedButton(
                                          child: const Text('accept'),
                                          style: ElevatedButton.styleFrom(primary: Color(0xffB9C98C)),
                                          onPressed: () async {friendProvider.addFriend(notify.notificationInfo.Friend[index]);notify.remove(notify.notificationInfo.Friend[index]);ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text('Accepted friend request'),
                                          ));},
                                        ),
                                        SizedBox(width:30),
                                        ElevatedButton(
                                          child: const Text('deny'),
                                          style: ElevatedButton.styleFrom(primary: Color(0xffB9C98C)),
                                          onPressed: () async {notify.remove(notify.notificationInfo.Friend[index]); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text('Denied friend request'),
                                          ));},


                                        ),
                                        SizedBox(height:10),
                                      ],

                                    ),
                                  );
                                },
                              )),

                        ],
                      ))
                ],
              ),
            ),
          ),
        ),

        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

