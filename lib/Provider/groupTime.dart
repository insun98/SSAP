import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shrine/Provider/scheduleProvider.dart';

import 'GroupProvider.dart';

class GroupTime {
  List<GroupTimeData> available = [];
  List<Meeting> allGroup = [];
  List<GroupTimeData> result = [];

  Future<void> addGroupSchedule(String groupId, Duration dur, bool down,
      DateTime start, DateTime end, List<userInfo> members) async {
    for (final member in members) {
      await FirebaseFirestore.instance
          .collection('schedules')
          .doc(member.uid)
          .collection('schedules')
          .where('start', isGreaterThanOrEqualTo: start)
          .where('end', isLessThanOrEqualTo: end)
          .get()
          .then((value) {
        for (final schedule in value.docs) {
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
      });
    }
    available.add(GroupTimeData(
        startTime: start,
        endTime: end,
        duration: Duration(hours: start.difference(end).inHours))); //이거 오류

    for (final schedule in allGroup) {
      for (final avatime in available) {
        //가능시간 가운데 스케줄이 있어서 가능시간이 둘로 나뉘는 경우 => 둘본을 둘로 나누고 원본 삭제
        if (schedule.from.isBefore(avatime.startTime) &&
            schedule.to.isAfter(avatime.endTime)) {
          available.add(GroupTimeData(
              startTime: avatime.startTime,
              endTime: schedule.from,
              duration: Duration(
                  hours: schedule.from.difference(avatime.startTime).inHours)));
          available.add(GroupTimeData(
              startTime: schedule.to,
              endTime: avatime.endTime,
              duration: Duration(
                  hours: avatime.endTime.difference(schedule.to).inHours)));
          available.remove(avatime);
        }
        //스케줄 시간이 가능시간의 시작시간을 포함 한 경우 => 가능시간의 시작시간을 스케줄의 끝시간으로 변결
        else if (schedule.from.isBefore(avatime.startTime) &&
            schedule.to.isAfter(avatime.startTime) &&
            schedule.to.isBefore(avatime.endTime)) {
          avatime.startTime = schedule.to;
          avatime.duration = Duration(
              hours: avatime.endTime.difference(avatime.endTime).inHours);
        }
        //스케줄 시간이 가능시간의 끝시간을 포함 한 경우 => 가능시간의 끝시간을 스케줄의 시작시간으로 변경
        else if (schedule.to.isAfter(avatime.endTime) &&
            schedule.from.isBefore(avatime.endTime) &&
            schedule.from.isAfter(avatime.startTime)) {
          avatime.endTime = schedule.from;
          avatime.duration = Duration(
              hours: avatime.endTime.difference(avatime.endTime).inHours);
        }
        //스케줄 시간이 가능시간을 포함하는 경우 => 가능시간 삭제
        else if (schedule.from.isBefore(avatime.startTime) &&
            schedule.to.isAfter(avatime.endTime)) {
          available.remove(avatime);
        }
      }
    }
    for (final avatime in available) {
      if (avatime.duration.inMinutes < dur.inMinutes) {
        available.remove(avatime);
      }
    }
    available.sort((a, b) => a.duration.compareTo(b.duration));
    GroupTimeData temp;
    if (!down) {
      for (final avatime in available) {
        if ((const TimeOfDay(hour: 2, minute: 0).hour <=
                    TimeOfDay(
                            hour: avatime.startTime.hour,
                            minute: avatime.startTime.minute)
                        .hour &&
                const TimeOfDay(hour: 8, minute: 0).hour >=
                    TimeOfDay(
                            hour: avatime.startTime.hour,
                            minute: avatime.startTime.minute)
                        .hour) ||
            (const TimeOfDay(hour: 2, minute: 0).hour <=
                    TimeOfDay(
                            hour: avatime.endTime.hour,
                            minute: avatime.endTime.minute)
                        .hour &&
                const TimeOfDay(hour: 8, minute: 0).hour >=
                    TimeOfDay(
                            hour: avatime.endTime.hour,
                            minute: avatime.endTime.minute)
                        .hour)) {
          temp = avatime;
          available.remove(avatime);
          available.add(temp);
        }
      }
    }
    for (final avatime in available) {
      if (avatime.duration.inMinutes > dur.inMinutes * 2) {
        double divideN = avatime.duration.inMinutes / dur.inMinutes;
        int divideNum = divideN.floor();
        for (int i = 0; i < divideNum; i++) {
          result.add(GroupTimeData(
              startTime: avatime.startTime.add(dur * i),
              endTime: avatime.startTime.add(dur * (i+1)),
              duration: dur));
        }
      } else {
        result.add(GroupTimeData(
            startTime: avatime.startTime,
            endTime: avatime.startTime.add(dur),
            duration: dur));
      }
    }
    int i = 1;
    for (final info in result) {
      Map<String, dynamic> scheduleInfo = <String, dynamic>{
        "start Time": info.startTime,
        "end Time": info.endTime,
        "duration": info.duration,
        "priority": i++,
        "active": false,
        "accept": 0,
        "decline": 0,
      };
      FirebaseFirestore.instance
          .collection('group')
          .doc(groupId)
          .collection('pendingSchedule')
          .add(scheduleInfo);
    }
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
