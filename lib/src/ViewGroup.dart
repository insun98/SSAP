import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import '../Provider/GroupProvider.dart';
import '../Provider/UserProvider.dart';
import 'EditProfile.dart';
import 'addGroup.dart';
import 'login.dart';

class ViewGroup extends StatefulWidget {


  const ViewGroup({Key? key}) : super(key: key);

  @override
  _ViewGroupState createState() => _ViewGroupState();
}

class _ViewGroupState extends State<ViewGroup> {
  bool status = false;
  String name = "";
  @override

  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
      drawerScrimColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          groupProvider.singleGroup.groupName,
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
            onPressed: () {Navigator.pushNamed(context, '/Notification');},
          ),
          IconButton(
            icon: const Icon(
              Icons.post_add_sharp,
              color: Color(0xffB9C98C),
            ),
            onPressed: () {Navigator.pushNamed(context, '/addgroupSchedule');},
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
                  MaterialPageRoute(builder: (context) => const LoginWidget()),
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
                        Text('Member',
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
                            height: 100,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount:  groupProvider.singleGroup.member.length,

                              itemBuilder: (BuildContext context, int index)  {
                                

                                return Consumer<GroupProvider>(

                                  builder: (context, group, _)=>SizedBox(
                                  height: 30,
                                  child: Text(
                                    "${groupProvider.members[index].name} (${groupProvider.members[index].id})",
                                    style: const TextStyle(color: Colors.black,fontSize: 17),
                                  ),

                                  ),
                                );
                              },
                            )),
                        Text('Incoming Meeting',
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
                            height: 100,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount:  groupProvider.confirmedSchedules.length,
                              itemBuilder: (BuildContext context, int index)  {
                                return Consumer<GroupProvider>(

                                  builder: (context, group, _)=>SizedBox(
                                    height: 30,
                                    child: Text(
                                      "${groupProvider.confirmedSchedules[index].eventName} (${groupProvider.confirmedSchedules[index].from})",
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              },
                            )),
                        const SizedBox(
                          height: 100,
                        ),
                        Text('Unconfirmed Meeting',
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[600])),
                        const Divider(
                          height: 8,
                          thickness: 1,
                          indent: 0,
                          endIndent: 8,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 30,
                          child: Row(children:[Expanded(child: Text(
                            "${groupProvider.pendingMeeting.eventName} (${groupProvider.pendingMeeting.from})",
                            style: const TextStyle(color: Colors.black,fontSize: 15
                            ),
                          ),),
                            Text(
                              "vote ",
                              style: const TextStyle(color: Color(0xFFB9C98C),fontSize: 17
                              ),),
                              Text(
                                "${groupProvider.pendingMeeting.accept}",
                                style: const TextStyle(color:Colors.black,fontSize: 17
                                ),),
                            SizedBox(width:10),
                          ],
                            ),

                        ),
                      ],
                        ),

                    ),
          ],
        ),
        ),

        ),
      ),

      resizeToAvoidBottomInset: false,

    );
  }
}

