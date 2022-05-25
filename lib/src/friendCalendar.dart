
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:shrine/src/scheduleView.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
//import 'package:ntp/ntp.dart';
import '../Provider/UserProvider.dart';
import '../Provider/scheduleProvider.dart';
import 'EditProfile.dart';
import 'login.dart';

class FriendCalendar extends StatefulWidget {
  const FriendCalendar({Key? key,}) : super(key: key);

  //final String friendID;
  @override
  // ignore: library_private_types_in_public_api
  _FriendCalendarState createState() => _FriendCalendarState();
}

class _FriendCalendarState extends State<FriendCalendar> {
  bool status = true;
  bool month = false;
  List<Meeting> meetings = ScheduleProvider().getSchedules;
  final CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    meetings = context.watch<ScheduleProvider>().friendSchedules;
    return Scaffold(
      backgroundColor: Colors.white,
      drawerScrimColor: Colors.black,
      appBar: AppBar(
        title: Text(
          context.watch<ScheduleProvider>().FriendName,
          style: TextStyle(color: Colors.black),
        ),
        //centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0.0,
        leading: Builder(
          builder: (context) => IconButton(
            color: Colors.black,
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  month = !month;
                  if (month) {
                    _controller.view = CalendarView.month;
                  } else {
                    _controller.view = CalendarView.week;
                  }
                });
              },
              icon: const Icon(
                Icons.swap_vert_outlined,
                color: Color(0xFFB9C98C),
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  month = true;
                  if (kDebugMode) {
                    print(month);
                  }
                });
              },
              icon: const Icon(
                Icons.search,
                color: Color(0xFFB9C98C),
              )),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const Padding(
              child: Text(
                'SSAP calendar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              padding: EdgeInsets.only(top: 40, left: 10),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
              title: Text(userProvider.singleUser.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.people,
                color: Color(0xFFB9C98C),
              ),
              title: const Text(
                'Group List',
                style: TextStyle(color: Color(0xFFB9C98C)),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/groupList');

              },
            ),
            ListTile(
              leading: const Icon(
                Icons.people,
                color: Colors.black,
              ),
              title: const Text('My Friend List'),
              onTap: () {
                Navigator.pushNamed(context, '/friendlist');

              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Color(0xFFB9C98C),
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfile()),
                );

              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: const Text(
                    'Pubic/Private View',
                    style: TextStyle(),
                  )),
              Container(
                padding: const EdgeInsets.only(right: 16),
                child: FlutterSwitch(
                  onToggle: (val) {
                    context.read<ScheduleProvider>().changePrivate(val);
                  },
                  value: context.watch<ScheduleProvider>().private,//status,
                  width: 40.0,
                  height: 20.0,
                  valueFontSize: 10.0,
                  toggleSize: 15.0,
                  borderRadius: 30.0,
                  toggleColor: Colors.white,
                  activeColor: const Color(0xFFB9C98C),
                ),
              ),
            ]),
            ListTile(
              title: const Text('Sign out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginWidget()),
                );

              },
            ),
          ],
        ),
      ),
      body: Consumer<ScheduleProvider>(
        builder: (context, state, _) => SfCalendar(
          controller: _controller,
          view: CalendarView.week,
          initialSelectedDate: DateTime.now(),
          initialDisplayDate: DateTime.now(),
          showDatePickerButton: true,
          dataSource: MeetingDataSource(meetings),
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              showAgenda: true),
          todayHighlightColor: const Color(0xFFB9C98C),
          timeZone: 'Korea Standard Time',
          allowDragAndDrop: true,
          // loadMoreWidgetBuilder:
          //     (BuildContext context, LoadMoreCallback loadMoreAppointments) {
          //   return FutureBuilder<void>(
          //     future: loadMoreAppointments(),
          //     builder: (context, snapShot) {
          //       return Container(
          //           height: _controller.view == CalendarView.schedule
          //               ? 50
          //               : double.infinity,
          //           width: double.infinity,
          //           alignment: Alignment.center,
          //           child: CircularProgressIndicator(
          //               valueColor: AlwaysStoppedAnimation(Colors.blue)));
          //     },
          //   );
          // },
          // dragAndDropSettings: const DragAndDropSettings(
          //   allowNavigation: true,
          //   autoNavigateDelay: Duration(seconds: 100),
          //   indicatorTimeFormat: 'HH:mm a',
          //   showTimeIndicator: true,
          // ),
          // onDragStart: (AppointmentDragStartDetails details) {
          //   dynamic appointment = details.appointment!;
          //   CalendarResource? resource = details.resource;
          // },
          //timeSlotViewSettings: const TimeSlotViewSettings(
          //     timeIntervalHeight: 50,
          //     timeInterval: Duration(hours: 1),
          //     minimumAppointmentDuration: Duration(minutes: 30)),
          // showCurrentTimeIndicator: true,
          //showWeekNumber: true,
          onTap: (value) {
            // print(value.appointments!.first);
            Meeting sch = value.appointments?.first;
            if(value.appointments!.first != null && value.targetElement.toString() != 'CalendarElement.calendarCell'){
              showGeneralDialog(
                barrierLabel: "Label",
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 500),
                context: context,
                pageBuilder: (context, anim1, anim2) {
                  return DetailSchedule(schedule: sch);
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  return SlideTransition(
                    position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
                        .animate(anim1),
                    child: child,
                  );
                },
              );
            }
          },
          //allowViewNavigation: true,
        ),
      ),
    );
  }
}

class DetailSchedule extends StatefulWidget {
  DetailSchedule({Key? key, required this.schedule}) : super(key: key);

  Meeting schedule;

  @override
  State<DetailSchedule> createState() => _DetailScheduleState();
}

class _DetailScheduleState extends State<DetailSchedule> {
  final List<String> _type = ['type1', 'type2', 'type3'];

  String _curType = 'type1';
  late DateTime startTime;
  late DateTime endTime;

  @override
  Widget build(BuildContext context) {
    startTime = widget.schedule.from;
    endTime = widget.schedule.to;
    TextEditingController _controller1 =
    TextEditingController(text: widget.schedule.eventName);
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
        //IconButton(icon: Icons.clear, color: Colors.black,),
        actions: [
          TextButton(
            onPressed: () {
              widget.schedule.eventName = _controller1.text;
              context.read<ScheduleProvider>().editSchedule(widget.schedule);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('update schedule'),
              ));
            },
            child: const Text(
              'edit',
              style: TextStyle(
                color: Color(0xFFB9C98C),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ScheduleProvider>().deleteSchedule(widget.schedule);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Deleted!'),
              ));
            },
            child: const Text(
              'delete',
              style: TextStyle(
                color: Color(0xFFB9C98C),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        //width: MediaQuery.of(context).size.width - 10,
        //height: MediaQuery.of(context).size.height - 80,
        //padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            DropdownButton(
              items: _type.map((value) {
                return DropdownMenuItem(
                    value: value,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          value,
                        )));
              }).toList(),
              value: _curType,
              onChanged: (value) {
                setState(() {
                  _curType = value.toString();
                });
              },
              isExpanded: true,
            ),
            TextFormField(
              controller: _controller1,
              decoration: const InputDecoration(
                  labelText: 'title',
                  hintText: 'Enter title',
                  contentPadding: EdgeInsets.only(left: 20)),
            ),
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

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  // @override
  // String getRecurrenceRule(int index) {
  //   return appointments![index].recurrenceRule;
  // }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
