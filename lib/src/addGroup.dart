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
import 'package:provider/provider.dart';
import 'package:shrine/src/ViewGroup.dart';

import '../Provider/GroupProvider.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({Key? key}) : super(key: key);

  @override
  _AddGroupPageState createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final _controller = TextEditingController();
  List<User> groupMembers = [];

  String name = "";
  User user = User(Userid: "", name: "", index: 0, uid: "");
  @override
  Widget build(BuildContext context) {
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.cancel,
            color: Colors.grey,
          ),
          onPressed: () {},
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
        child: Center(
          child: Consumer<GroupProvider>(
            builder: (context, group, _) => Container(
              padding: const EdgeInsets.all(10),
              child: Column(
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
                        String name = value;
                        user = groupProvider.searchUser(_controller.text)!;
                      });
                    },
                  ),

                  TextButton(
                    onPressed: () {
                      groupMembers.add(user);
                      print(user.name);
                      _controller.clear();
                    },
                    child: Text(
                        user.name != "" ? "${user.name}(${user.Userid})" : ""),
                  ),
                  // RadioGrou
                  //           users: groupProvider.user,
                  //         ),
                ],
              ),
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

class RadioGroup extends StatefulWidget {
  final List<User> groupMembers;
  const RadioGroup({required this.groupMembers});
  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}

class RadioGroupWidget extends State<RadioGroup> {
  // Default Radio Button Item
  String radioItem = 'intothesun98';

  // Group Value for Radio Button.
  int id = 1;
  final _controller = TextEditingController();
  Schedule schedule = Schedule(title: "", dateTime: "");
  groupInfo group = groupInfo(groupName: "", schedule: "", members: []);
  @override
  Widget build(BuildContext context) {
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.cancel,
            color: Colors.grey,
          ),
          onPressed: () {},
        ),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: const Text('OK'),
              style: ElevatedButton.styleFrom(primary: const Color(0xFFB9C98C)),
              onPressed: () async {group.members = widget.groupMembers; print(group.members[0].name);group.groupName= _controller.text;groupProvider.addGroup(widget.groupMembers, _controller.text);  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewGroup(group: group)));},
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
                  decoration:  const InputDecoration(
                    hintText:  'GroupName',
                  ),
                ),
                const SizedBox(height:20),
                SizedBox(
                  height:500,
                child:ListView.separated(
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
                      )
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

enum makeGroup { selectMember, setGroupName }
class groupInfo{
  groupInfo({required this.members, required this.schedule, required this.groupName});
  List<User> members;
  String schedule;
  String groupName;



}
class Schedule{
  Schedule({required this.title, required this.dateTime});
  String title;
  String dateTime;

}
