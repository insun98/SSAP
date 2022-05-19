import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/GroupProvider.dart';
import 'addGroup.dart';

class ViewGroup extends StatefulWidget {
  final groupInfo group;
  const ViewGroup({required this.group});
  @override
  _ViewGroupState createState() => _ViewGroupState();
}

class _ViewGroupState extends State<ViewGroup> {
  @override
  Widget build(BuildContext context) {
    GroupProvider groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0.0,
        elevation: 0.0,
        title: Text(
          widget.group.groupName,
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.grey,
          ),
          onPressed: () {},
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
            onPressed: () {},
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
      body: SafeArea(
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
                              itemCount: widget.group.members.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 30,
                                  child: Text(
                                    "${widget.group.members[index].name}(${widget.group.members[index].Userid})",
                                    style: const TextStyle(color: Colors.black),
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
                        const SizedBox(
                          height: 100,
                        ),
                        Text('Unconfirmed Meeting',
                            style: TextStyle(
                                fontSize: 17, color: Colors.grey[600])),
                        const Divider(
                          height: 8,
                          thickness: 1,
                          indent: 0,
                          endIndent: 8,
                          color: Colors.grey,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
