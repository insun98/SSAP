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
                      user = group.searchingUser(_controller.text);
                    });
                  },
                ),
                TextButton(
                  onPressed: () {
                    _controller.clear();
                    friendProvider.addFriend(user.uid);
                    group.clear();


                  },
                  child:  user.name.isNotEmpty?Text(
                      "${user.name}(${user.id})", style: TextStyle(color: Colors.black)):const Text(""),

                ),
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}