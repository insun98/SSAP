import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleProvider with ChangeNotifier {
  ScheduleProvider() {
    init();
  }

  List<Meeting> mySchedules = [];
  List<Meeting> friendSchedules = [];

  final scheduleDB = FirebaseFirestore.instance.collection('schedules').doc('yooisae').collection('schedules');

  init() {
    scheduleDB
        .snapshots()
        .listen((event) {
      mySchedules = [];
      for (final schedule in event.docs) {
        mySchedules.add(
          Meeting(
            eventName: schedule.data()['schedule name'],
            from: schedule.data()['schedule start'].toDate(),
            to: schedule.data()['schedule end'].toDate(),
            isAllDay: false,
            docId: schedule.id,
            background: const Color(0xFFB9C98C),
            type: 'type1',
            //recurrenceRule: 'FREQ=DAILY;INTERVAL=7;COUNT=10'
          ),
        );
        print(schedule.id);
      }
    });
    notifyListeners();
  }
  void addSchedule(String name, DateTime from, DateTime to, String? type, ) async{
    Map<String, dynamic> scheduleInfo = <String, dynamic>{
      "schedule name": name,
      "schedule start": Timestamp.fromDate(from),
      "schedule end": Timestamp.fromDate(to),
    };
    mySchedules.add(
      Meeting(
          eventName: name,
          from: from,
          to: to,
          isAllDay: false,
          docId: '-',
          background: const Color(0xFFB9C98C),
          type: 'type1'
      ),
    );

    await scheduleDB.add(scheduleInfo);
    notifyListeners();
  }

  void editSchedule(Meeting schedule){
    scheduleDB.doc(schedule.docId).update(<String, dynamic>{
      "schedule name": schedule.eventName,
      "schedule start": schedule.from,
      "schedule end": schedule.to,
    });
    notifyListeners();
  }

  void deleteSchedule(Meeting schedule) async{
    await scheduleDB.doc(schedule.docId).delete();
    notifyListeners();
  }

  List<Meeting> get getSchedules => mySchedules;

}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting(
      {required this.eventName,
      required this.from,
      required this.to,
      required this.background,
      required this.isAllDay,
      required this.docId,
      required this.type,
      //this.recurrenceRule
      });

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;

  String type;

  String docId;

  //String? recurrenceRule;
}

