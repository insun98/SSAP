import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shrine/Provider/FriendProvider.dart';

import '../Provider/GroupProvider.dart';
import '../Provider/NotificationProvider.dart';
import '../Provider/scheduleProvider.dart';


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
              Padding(
                child: TextButton(
                  child: const Text('SSAP calendar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black,),textAlign: TextAlign.left, ),
                  onPressed: () => Navigator.pushNamed(context, '/home'),
                ),
                padding: const EdgeInsets.only(top: 40, left: 10),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.account_circle,
                  color: Colors.black,
                ),
                title: Text(context.read<ScheduleProvider>().curUserName.toString()),
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
                                itemCount:  notify.notificationInfo.Group.length,
                                itemBuilder: (BuildContext context, int index)  {
                                  Meeting meeting =   notify.setGroupPendingTime(notify.notificationInfo.Group[index]);
                                  // print("user: ${notify.notificationInfo.Friend[index]}");
                                  return SizedBox(
                                    height: 50,
                                    child:   Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(child: SizedBox( child:Column(crossAxisAlignment: CrossAxisAlignment.start,children:[Text("${meeting.eventName}",style: TextStyle(color:Colors.black),),Text("${meeting.from.toString()}",style: TextStyle(color:Colors.black),),],),),
                                        ),
                                  ElevatedButton(
                                          child: const Text('accept'),
                                          style: ElevatedButton.styleFrom(primary: Color(0xffB9C98C)),
                                          onPressed: ()  { notify.acceptMeeting(notify.notificationInfo.Group[index]);},
                                        ),
                                        SizedBox(width:30),
                                        ElevatedButton(
                                          child: const Text('deny'),
                                          style: ElevatedButton.styleFrom(primary: Color(0xffB9C98C)),
                                          onPressed: ()  {notify.denyMeeting(notify.notificationInfo.Group[index]);},


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
                                     groupProvider.searchUser(notify.notificationInfo.Friend[index]);
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
                                          onPressed: () async {friendProvider.addFriend(notify.notificationInfo.Friend[index]);notify.remove(notify.notificationInfo.Friend[index]);},
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

