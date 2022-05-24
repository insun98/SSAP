import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import '../Provider/GroupProvider.dart';
import '../Provider/NotificationProvider.dart';


class NotificationPage extends StatefulWidget {


  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool status = false;

  @override

  Widget build(BuildContext context) {
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.notifications_active,
                color: Color(0xffB9C98C),
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.post_add_sharp,
                color: Color(0xffB9C98C),
              ),
              onPressed: () {Navigator.pushNamed(context, '/addgroupSchedule');},
            ),
            IconButton(
              icon: const Icon(
                Icons.person_add,
                color: Color(0xffB9C98C),
              ),
              onPressed: () {},
            ),
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
                title: const Text('Yoo Isae'),
                onTap: () {},
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
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Color(0xFFB9C98C),
                ),
                title: const Text('Settings'),
                onTap: () {},
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
                onTap: () {},
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
                                itemCount:  0,//notify.notificationInfo.Friend.length,
                                itemBuilder: (BuildContext context, int index)  {
                               //   userInfo? user =   groupProvider.searchUser(notify.notificationInfo.Friend[index]);
                                 // print("user: ${notify.notificationInfo.Friend[index]}");
                                  return SizedBox(
                                    height: 50,
                                    child:   Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          child: const Text('accept'),
                                          style: ElevatedButton.styleFrom(primary: Color(0xffB9C98C)),
                                          onPressed: () async {},
                                        ),
                                        SizedBox(width:30),
                                        ElevatedButton(
                                          child: const Text('deny'),
                                          style: ElevatedButton.styleFrom(primary: Color(0xffB9C98C)),
                                          onPressed: () async {},
                                        ),
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
                                     userInfo? user =   groupProvider.searchUser(notify.notificationInfo.Friend[index]);
                                  // print("user: ${notify.notificationInfo.Friend[index]}");
                                  return SizedBox(
                                    height: 50,
                                    child:   Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                       SizedBox( width:100,child:Text("${user?.name}"),),
                                        ElevatedButton(
                                          child: const Text('accept'),
                                          style: ElevatedButton.styleFrom(primary: Color(0xffB9C98C)),
                                          onPressed: () async {notify.addFriend(notify.notificationInfo.Friend[index]);notify.remove(notify.notificationInfo.Friend[index]);},
                                        ),
                                        SizedBox(width:30),
                                        ElevatedButton(
                                          child: const Text('deny'),
                                          style: ElevatedButton.styleFrom(primary: Color(0xffB9C98C)),
                                          onPressed: () async {notify.remove(notify.notificationInfo.Friend[index]);},


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

