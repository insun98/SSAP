import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/FriendProvider.dart';
import '../Provider/GroupProvider.dart';
import 'addGroup.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final _controller = TextEditingController();
  List<userInfo> groupMembers = [];

  String name = "";
  List<userInfo> foundUsers = [];
  userInfo user = userInfo(id: "", name: "", uid: "", image: "");
  @override
  Widget build(BuildContext context) {
    FriendProvider friendProvider = Provider.of<FriendProvider>(context);
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        title: Text(
          'Add Friend',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.cancel,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

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
                        user = groupProvider.searchUser(_controller.text);
                      }
                      String name = value;
                      user = groupProvider.searchUser(_controller.text);
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

                                  friendProvider.addFriend(foundUsers[index]);
                            },
                            child: Text(
                              "${foundUsers[index].name}(${foundUsers[index].id})",
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