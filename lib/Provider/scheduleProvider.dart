import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleProvider with ChangeNotifier {
  ScheduleProvider() {
    init();
  }

  List<Meeting> mySchedules = [];

  final scheduleDB = FirebaseFirestore.instance
      .collection('schedules'); //.doc('yooisae').collection('schedules');
  DocumentSnapshot? curUserDB;
  String? curUserID;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) async {
      if (user != null) {
        curUserID = user.uid;
        print(curUserID);
        curUserDB = await scheduleDB.doc(curUserID).get();
        if (!curUserDB!.exists) {
          await scheduleDB.doc(user.uid).set({"private": true});
        } else {
          Map<String, dynamic> data = curUserDB!.data() as Map<String, dynamic>;
          _private = data['private'];
          print(_private);
        }
        scheduleDB
            .doc(curUserID)
            .collection('schedules')
            .snapshots()
            .listen((event) {
          mySchedules = [];
          for (final schedule in event.docs) {
            if(schedule.data().isEmpty){
              continue;
            }
            mySchedules.add(
              Meeting(
                eventName: schedule.data()['schedule name'].toString(),
                from: schedule.data()['schedule start'].toDate(),
                to: schedule.data()['schedule end'].toDate(),
                isAllDay: false,
                docId: schedule.id,
                background: schedule.data()['type'] == "Personal"?const Color(0xFFB9C98C) : const Color(0xFF123123),
                type: schedule.data()['type'],
                //recurrenceRule: 'FREQ=DAILY;INTERVAL=7;COUNT=10'
              ),
            );
            notifyListeners();
          }
        });
        notifyListeners();
      }
    });
  }

  void addSchedule(
    String name,
    DateTime from,
    DateTime to,
    String type,
  ) async {
    Map<String, dynamic> scheduleInfo = <String, dynamic>{
      "schedule name": name,
      "schedule start": Timestamp.fromDate(from),
      "schedule end": Timestamp.fromDate(to),
      "type" : type,
    };
    mySchedules.add(
      Meeting(
          eventName: name,
          from: from,
          to: to,
          isAllDay: false,
          docId: '-',
          background: type == 'Personal'?const Color(0xFFB9C98C) : const Color(0xFFB9C980),
          type: type),
    );

    await scheduleDB
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .collection('schedules')
        .add(scheduleInfo);
    notifyListeners();
  }

  void editSchedule(Meeting schedule) {
    scheduleDB
        .doc(curUserID)
        .collection('schedules')
        .doc(schedule.docId)
        .update(<String, dynamic>{
      "schedule name": schedule.eventName,
      "schedule start": schedule.from,
      "schedule end": schedule.to,
      "type" : schedule.type,
    });
    notifyListeners();
  }

  void deleteSchedule(Meeting schedule) async {
    await scheduleDB
        .doc(curUserID)
        .collection('schedules')
        .doc(schedule.docId)
        .delete();
    notifyListeners();
  }

  List<Meeting> _friendSchedules = [];

  List<Meeting> get friendSchedules => _friendSchedules;

  String? _friendName;

  String get FriendName => _friendName!;

  Future<void> getFriendSchedules(String friendID) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(friendID)
        .get()
        .then((value) => _friendName = value.data()!['name']);
    notifyListeners();
    _friendSchedules = [];
    DocumentSnapshot? friendDB = await scheduleDB.doc(friendID).get();
    if (!friendDB.exists) {
      return;
    }
    Map<String, dynamic> data = friendDB.data() as Map<String, dynamic>;
    bool fprivate = data['private'];
    print('friend privagte: $fprivate');
    scheduleDB.doc(friendID).collection('schedules').get().then((value) {
      for (final schedule in value.docs) {
        _friendSchedules.add(
          Meeting(
            eventName:
                fprivate ? 'busy' : schedule.data()['schedule name'] as String,
            from: schedule.data()['schedule start'].toDate(),
            to: schedule.data()['schedule end'].toDate(),
            isAllDay: false,
            docId: schedule.id,
            background: const Color(0xFFB9C98C),
            type: 'type1',
            //recurrenceRule: 'FREQ=DAILY;INTERVAL=7;COUNT=10'
          ),
        );
        notifyListeners();
      }
    });
  }

  bool _private = true;

  bool get private => _private;

  void changePrivate(bool private) {
    if (private) {
      scheduleDB.doc(curUserID).set({"private": true});
      _private = true;
    } else {
      scheduleDB.doc(curUserID).set({"private": false});
      _private = false;
    }
    print("private in Provider: $_private");
    notifyListeners();
  }

  List<Meeting> get getSchedules => mySchedules;
}

class Meeting {
  /// Creates a meeting class with required details.
  Meeting({
    required this.eventName,
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
