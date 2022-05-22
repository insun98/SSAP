import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shrine/Provider/scheduleProvider.dart';
import 'package:shrine/src/friendCalendar.dart';

class FriendLIst extends StatefulWidget {
  const FriendLIst({Key? key}) : super(key: key);

  @override
  State<FriendLIst> createState() => _FriendLIstState();
}

class _FriendLIstState extends State<FriendLIst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            ListTile(
                title: Text('노은호(eunho111'),
                onTap: () {
                  context.read<ScheduleProvider>().getFriendSchedules('s2MVJDiwX7heYDR5xiD07mi6AKC2');
                  Navigator.pushNamed(
                    context,
                    '/friendCalendar'
                  );
                })
          ],
        ),
      ),
    );
  }
}
