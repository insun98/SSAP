import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shrine/Provider/scheduleProvider.dart';

import 'GroupProvider.dart';

class GroupTime {
  List<GroupTimeData> available = [];
  List<Meeting> allGroup = [];
  List<GroupTimeData> result = [];
  List<GroupTimeData> tem = [];

  Future<int> addGroupSchedule(String groupId, Duration dur, bool down,
      DateTime start, DateTime end, List<dynamic> members,
      String scheduleName) async {
    QuerySnapshot<Map<String, dynamic>> info = await FirebaseFirestore.instance
        .collection('group')
        .doc(groupId)
        .collection('pending')
        .snapshots()
        .first;
    print(info.size);


    print('$groupId, $dur, $start, $end, $members');
    for (final member in members) {
      print(member);
      await FirebaseFirestore.instance
          .collection('schedules')
          .doc(member)
          .collection('schedules')
          .get()
          .then((value) {
        for (final schedule in value.docs) {
          if (!(start.isAfter(schedule.data()['schedule end'].toDate()) ||
              end.isBefore(schedule.data()['schedule start'].toDate()))) {
            allGroup.add(Meeting(
              eventName: schedule.data()['schedule name'] as String,
              from: schedule.data()['schedule start'].toDate(),
              to: schedule.data()['schedule end'].toDate(),
              isAllDay: false,
              docId: schedule.id,
              background: schedule.data()['type'] == "Personal"
                  ? const Color(0xFFB9C98C)
                  : const Color(0xFF123123),
              type: schedule.data()['type'],
            ));
          }
        }
      });
    }
    available.add(GroupTimeData(
        startTime: start,
        endTime: end,
        duration: Duration(minutes: end
            .difference(start)
            .inMinutes))); //이거 오류

    for (final schedule in allGroup) {
      //print(schedule.docId);
      for (final avatime in available) {
        //가능시간 가운데 스케줄이 있어서 가능시간이 둘로 나뉘는 경우 => 둘본을 둘로 나누고 원본 삭제
        //print('ava start time: ${avatime.startTime} ,   ava end time: ${avatime.endTime}');
        //print('schedule start time: ${schedule.from},   schedule end time: ${schedule.to}');
        if (schedule.from.isAfter(avatime.endTime)) {
          tem.add(avatime);
        }
        else if (schedule.to.isBefore(avatime.startTime)) {
          tem.add(avatime);
        }
        else if (schedule.from.isAfter(avatime.startTime) &&
            schedule.to.isBefore(avatime.endTime)) {
          tem.add(GroupTimeData(
              startTime: avatime.startTime,
              endTime: schedule.from,
              duration: Duration(
                  minutes:
                  schedule.from
                      .difference(avatime.startTime)
                      .inMinutes)));
          tem.add(GroupTimeData(
              startTime: schedule.to,
              endTime: avatime.endTime,
              duration: Duration(
                  minutes: avatime.endTime
                      .difference(schedule.to)
                      .inMinutes)));
          //print('사이');
        }
        //스케줄 시간이 가능시간의 시작시간을 포함 한 경우 => 가능시간의 시작시간을 스케줄의 끝시간으로 변결
        else if (schedule.from.isBefore(avatime.startTime) ||
            schedule.to.isBefore(avatime.endTime)) {
          avatime.startTime = schedule.to;
          avatime.duration = Duration(
              minutes: avatime.endTime
                  .difference(schedule.to)
                  .inMinutes);
          tem.add(avatime);
          //print('시작');
        }
        //스케줄 시간이 가능시간의 끝시간을 포함 한 경우 => 가능시간의 끝시간을 스케줄의 시작시간으로 변경

        else if (schedule.from.isAfter(avatime.startTime) ||
            schedule.to.isAfter(avatime.endTime)) {
          avatime.endTime = schedule.from;
          avatime.duration = Duration(
              minutes: schedule.from
                  .difference(avatime.startTime)
                  .inMinutes);
          tem.add(avatime);
          //print('끝');
        }
        //스케줄 시간이 가능시간을 포함하는 경우 => 가능시간 삭제
        else if (schedule.from.isBefore(avatime.startTime) &&
            schedule.to.isAfter(avatime.endTime)) {
          available.remove(avatime);
          //print('포함');
        }
        else {
          //tem.add(avatime);
        }
        // for(final a in tem){
        //   print('start: ${a.startTime}  ***  end:${a.endTime}');
        // }
        //print('*****************************************************************************');
      }
      available.clear();
      available.addAll(tem);
      tem.clear();
    }
    // print('all available time for meeting: ${available.length}');
    // print(dur.inMinutes);
    for (final avatime in available) {
      if (avatime.duration.inMinutes >= dur.inMinutes) {
        tem.add(avatime);
      }
    }
    available.clear();
    available.addAll(tem);
    tem.clear();
    //
    available.sort((a, b) => b.duration.compareTo(a.duration));
    print('all available time for meeting after filtering: ${available
        .length}');

    GroupTimeData temp;

    for (final avatime in available) {
      if (avatime.duration.inMinutes > dur.inMinutes * 2) {
        double divideN = avatime.duration.inMinutes / dur.inMinutes;
        int divideNum = divideN.floor();
        for (int i = 0; i < divideNum; i++) {
          tem.add(GroupTimeData(
              startTime: avatime.startTime.add(dur * i),
              endTime: avatime.startTime.add(dur * (i + 1)),
              duration: dur));
        }
      } else {
        tem.add(GroupTimeData(
            startTime: avatime.startTime,
            endTime: avatime.startTime.add(dur),
            duration: dur));
      }
    }
    available.clear();
    available.addAll(tem);
    tem.clear();

    if (!down) {
      for (final avatime in available) {
        if ((const TimeOfDay(hour: 2, minute: 0).hour <=
            TimeOfDay(
                hour: avatime.startTime.hour,
                minute: avatime.startTime.minute)
                .hour &&
            const TimeOfDay(hour: 8, minute: 0).hour >
                TimeOfDay(
                    hour: avatime.startTime.hour,
                    minute: avatime.startTime.minute)
                    .hour) ||
            (const TimeOfDay(hour: 2, minute: 0).hour <=
                TimeOfDay(
                    hour: avatime.endTime.hour,
                    minute: avatime.endTime.minute)
                    .hour &&
                const TimeOfDay(hour: 8, minute: 0).hour >
                    TimeOfDay(
                        hour: avatime.endTime.hour,
                        minute: avatime.endTime.minute)
                        .hour)) {
          // print('time of day: ${TimeOfDay(
          //     hour: avatime.startTime.hour,
          //     minute: avatime.startTime.minute).hour}\nstart: ${avatime.startTime} *** end: ${avatime.endTime}');
          //print('start: ${avatime.startTime} *** end: ${avatime.endTime}');
          //temp = avatime;
          //available.remove(avatime);
          //available.add(temp);
        }
        else {
          result.add(avatime);
          print(avatime.startTime);
        }
      }
    }
    print('length of result: ${result.length}');
    for (final temp in result) {
      print('start: ${temp.startTime} **** end: ${temp.endTime}');
    }
    int i = 1;
    for (final info in result) {
      print('store');
      Map<String, dynamic> scheduleInfo = <String, dynamic>{
        "schedule name": scheduleName,
        "schedule start": info.startTime,
        "schedule end": info.endTime,
        "priority": i,
        "active": i == 1 ? true : false,
        "accept": 0,
      };
      FirebaseFirestore.instance
          .collection('group')
          .doc(groupId)
          .collection('pending')
          .add(scheduleInfo);
      if (i++ > 10) {
        print('break');
        break;
      }
    }
    var collection = await FirebaseFirestore.instance.collection('group').doc(
        groupId)
        .get();
    members = collection.data()!["member"];

    for (var member in members) {

    }

    return 0;
  }
}


class GroupTimeData {
  GroupTimeData({
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  DateTime startTime;
  DateTime endTime;
  Duration duration;
}
