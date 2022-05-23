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

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shrine/src/ViewGroup.dart';

import '../Provider/GroupProvider.dart';
import '../Provider/groupTime.dart';
import '../Provider/scheduleProvider.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  _AddGroupPageState createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final _controller = TextEditingController();
  List<userInfo> groupMembers = [];

  String name = "";
  List<userInfo> foundUsers = [];
  userInfo user = userInfo(Userid: "", name: "", uid: "", photo: "");
  @override
  Widget build(BuildContext context) {
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        title: Text(
          'Select Friends',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,

        leading: IconButton(
          icon: const Icon(
            Icons.cancel,
            color: Colors.grey,
          ),
          onPressed: () {Navigator.pop(context);},
        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: const Text('OK'),
              style: ElevatedButton.styleFrom(primary: const Color(0xFFB9C98C)),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RadioGroup(groupMembers: groupMembers)));
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<GroupProvider>(
          builder: (context, group, _) => Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xffE5E5E5),
                    hintText: 'Search by Id',
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (_controller.text == null) {
                        foundUsers = groupProvider.searchUser(_controller.text);
                      }
                      String name = value;
                      foundUsers = groupProvider.searchUser(_controller.text);
                    });
                  },
                ),

                SizedBox(
                    height: 500,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: foundUsers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 30,
                          child: TextButton(
                            onPressed: () {
                              if (!groupMembers.contains(foundUsers[index])) {
                                groupMembers.add(foundUsers[index]);
                              }
                              _controller.clear();
                              foundUsers =
                                  groupProvider.searchUser(_controller.text);
                            },
                            child: Text(
                              "${foundUsers[index].name}(${foundUsers[index].Userid})",
                              style: TextStyle(color: Colors.black),
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
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class RadioGroup extends StatefulWidget {
  final List<userInfo> groupMembers;
  const RadioGroup({required this.groupMembers});

  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}


class RadioGroupWidget extends State<RadioGroup> {

 
  final _controller = TextEditingController();
  Schedule schedule = Schedule(title: "", dateTime: "");
  groupInfo group = groupInfo(groupName: "");
  @override
  Widget build(BuildContext context) {
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,

        elevation: 0.0,
        title: Text(
          'Group Setting',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.cancel,
            color: Colors.grey,
          ),

          onPressed: () {Navigator.pushNamed(context,'/home');},

        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: const Text('OK'),
              style: ElevatedButton.styleFrom(primary: const Color(0xFFB9C98C)),
              onPressed: () async {
                group.members = widget.groupMembers;
                print(group.members[0].name);
                group.groupName = _controller.text;
                groupProvider.addGroup(widget.groupMembers, _controller.text);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewGroup(group: group)));
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'GroupName',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                    height: 500,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: widget.groupMembers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 30,
                          child: Text(
                              "${widget.groupMembers[index].name}(${widget.groupMembers[index].Userid})"),
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

class GroupList extends StatefulWidget {
  const GroupList({Key? key}) : super(key: key);

  @override
  _GroupListState createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  bool status = false;
  List<groupInfo> groups = [];
  @override
  Widget build(BuildContext context) {
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
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
          IconButton(
            icon: const Icon(
              Icons.notifications_active,
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
                            return Dismissible(key: UniqueKey(), child: SizedBox(
                              height: 50,
                              child: Row(children:[TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewGroup(group: group.groups[index])));
                                },
                                child: Text(
                                  "${group.groups[index].groupName}    (${group.groups[index].members.length})",
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

class AddGroupSchedule extends StatefulWidget {
  const AddGroupSchedule({
    Key? key,
  }) : super(key: key);

  @override
  State<AddGroupSchedule> createState() => _AddGroupScheduleState();
}

class _AddGroupScheduleState extends State<AddGroupSchedule> {
  final List<String> _type = ['type1', 'type2', 'type3'];
  String _curType = 'type1';
  DateTime startTime = DateTime.parse(DateTime.now().toString());
  DateTime endTime =
      DateTime.parse(DateTime.now().add(const Duration(hours: 2)).toString());
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  List<userInfo> members = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            )),
        actions: [
          TextButton(onPressed: (){GroupTime().addGroupSchedule('groupId', Duration(minutes: int.parse(_hourController.text)), false, startTime, endTime, members);}, child: const Text('save')
          ),],
      ),
      body: Container(
        //width: MediaQuery.of(context).size.width - 10,
        //height: MediaQuery.of(context).size.height - 80,
        //padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _controller1,
              decoration: const InputDecoration(
                  labelText: 'Enter meeting title',
                  hintText: ' meeting title',
                  contentPadding: EdgeInsets.only(left: 20)),
            ),
            SizedBox(
                height: 100,
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text('Duration: '),
                      Expanded(
                          child: TextFormField(
                        controller: _hourController,
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 100)),
                      )),
                      Text('mins'),
                    ],
                  ),
                )),
            DateTimePicker(
                //textAlign: TextAlign.center,
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                //controller: _controller1,
                initialValue: startTime.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: const Icon(Icons.event),
                dateLabelText: 'Start Date',
                timeLabelText: "Start Time",
                //use24HourFormat: false,
                //locale: Locale('pt', 'BR'),
                // selectableDayPredicate: (date) {
                //   if (date.weekday == 6 || date.weekday == 7) {
                //     return false;
                //   }
                //   return true;
                // },
                onChanged: (val) => setState(() {
                      startTime = DateTime.parse(val);
                      print(startTime);
                    }),
                validator: (val) {
                  //setState(() => _valueToValidate1 = val ?? '');
                  return null;
                },
                onSaved: (val) {} //setState(() => _valueSaved1 = val ?? ''),
                ),
            DateTimePicker(
                enableInteractiveSelection: true,
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                //controller: _controller2,
                initialValue: endTime.toString(),
                //_controller2.text,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: const Icon(Icons.event),
                dateLabelText: 'End Date',
                timeLabelText: "End Time",
                //use24HourFormat: false,
                //locale: Locale('pt', 'BR'),
                // selectableDayPredicate: (date) {
                //   if (date.weekday == 6 || date.weekday == 7) {
                //     return false;
                //   }
                //   return true;
                // },
                onChanged: (val) => setState(() {
                      //_valueChanged2 = val;
                      endTime = DateTime.parse(val);

                      // if(endTime.isBefore(startTime)){
                      //   print('hi');
                      //   _controller2.clear();
                      //   //_controller2.text = _controller1.text;
                      // }
                      // else{
                      //   _controller2 = TextEditingController(text: val);
                      //   endTime = DateTime.parse(val);
                      // }
                    }),
                validator: (val) {
                  //setState(() => _valueToValidate2 = val ?? '');
                  return null;
                },
                onSaved: (val) {} //=> setState(() => _valueSaved2 = val ?? ''),
                ),
          ],
        ),
      ),
    );
  }
}

class groupInfo {
  groupInfo({required this.groupName, docId, members});
  List<userInfo> members = [];
  String docId = "";
  String groupName;
}

class Schedule {
  Schedule({required this.title, required this.dateTime});
  String title;
  String dateTime;
}
