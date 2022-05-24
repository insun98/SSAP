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
  userInfo user = userInfo(id: "", name: "", uid: "", image: "");
  @override
  Widget build(BuildContext context) {
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    return Consumer<GroupProvider>(
        builder: (context, group, _) =>Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        title: Text(
          'Search Friends',
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
                SizedBox(height:30,),
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xffE5E5E5),
                    hintText: 'Search by Id',
                  ),
                  onChanged: (value) {
                    setState(() {
                        user = group.searchingUser(_controller.text);
                    });
                  },
                ),
                TextButton(
                  onPressed: () {
                    _controller.clear();
                    groupMembers.add(user);
                    group.clear();


                  },
                  child:  user.name.isNotEmpty?Text(
                    "${user.name}(${user.id})", style: TextStyle(color: Colors.black)):const Text(""),

                  ),
                SizedBox(height:100),

            groupMembers.length>0? Text(' <'
                    ' Added Members>', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold
                ),) :Text(""),
                SizedBox(
                    height: 200,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: groupMembers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 30,
                            child: Row(children:[

                              Text(
                              "${groupMembers[index].name}(${groupMembers[index].id})",
                              style: TextStyle(color: Colors.black),

                          ),
                          ],
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
        ),
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


  @override
  Widget build(BuildContext context) {
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    return Consumer<GroupProvider>(
        builder: (context, group, _) => Scaffold(
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
                List<dynamic> members = [];

                for (var member in widget.groupMembers) {
                  members.add(member.uid);
                }

                String groupDocId = await groupProvider.addGroup(
                    members, _controller.text);
                print("gg${groupDocId}");

                groupInfo group = await groupProvider.setGroup(groupDocId);

                Navigator.pushNamed(context, '/viewGroup');
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
                              "${widget.groupMembers[index].name}(${widget.groupMembers[index].id})"),
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
        ),
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


