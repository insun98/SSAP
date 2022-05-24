import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import '../Provider/GroupProvider.dart';
import 'ViewGroup.dart';

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerScrimColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          "Group",
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
              onPressed: () {
                Navigator.pushNamed(context, '/addGroup');
              },
              icon: const Icon(
                Icons.person_add_alt_1,
                color: Color(0xFFB9C98C),
              )),
          PopupMenuButton<String>(
            icon: Icon(Icons.notifications,  color: Color(0xFFB9C98C),),
            onSelected: (String result) {
              switch (result) {
                case 'filter1':
                  print('filter 1 clicked');
                  break;
                case 'filter2':
                  print('filter 2 clicked');
                  break;
                case 'clearFilters':
                  print('Clear filters');
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'filter1',
                child: Text('Filter 1'),
              ),
              const PopupMenuItem<String>(
                value: 'filter2',
                child: Text('Filter 2'),
              ),
              const PopupMenuItem<String>(
                value: 'clearFilters',
                child: Text('Clear filters'),
              ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'option1':
                  print('option 1 clicked');
                  break;
                case 'option2':
                  print('option 2 clicked');
                  break;
                case 'delete':
                  print('I want to delete');
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'option1',
                child: Text('Option 1'),
              ),
              const PopupMenuItem<String>(
                value: 'option2',
                child: Text('Option 2'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          )
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
              onTap: () {},
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
      body: Consumer<GroupProvider>(
        builder: (context, group, _) => SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(

                        height:500,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: group.groups.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: UniqueKey(),
                              child: SizedBox(
                              height: 50,
                              child: Row(children:[TextButton(
                                onPressed: ()  async {
                                  groupInfo groupinfo = await group.setGroup(group.groups[index].docId);
                                  print("group: ${groupinfo.groupName}, ${group.groups[index].docId}");
                                  Navigator.pushNamed(context, '/viewGroup');

                                },
                                child: Text(
                                  "${group.groups[index].groupName}    (${group.groups[index].member.length})",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),



                              ],

                              ),
                            ),
                            );
                          },
                          separatorBuilder:
                              (BuildContext context, int index) {
                            return const Divider(color: Colors.grey,);
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}