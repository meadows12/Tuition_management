import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/Calendar/add_event.dart';
import 'package:sampleproject/Calendar/view_event.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:sampleproject/Calendar/event.dart';

import 'event.dart';

class CalendarStudent extends StatefulWidget {
  final EventModel eventModel;

  const CalendarStudent({Key key, this.eventModel}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CalendarStudent> {
  List er = [];
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  List<Map<dynamic, dynamic>> allEvents = <Map<dynamic, dynamic>>[];
  List dates;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _events = {};
    _selectedEvents = [];
    dates = [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      if (event != null) {
        //   String title = event['title'];
        //  String description = event['description'];
        DateTime y = event['eventDate'].toDate();
        print(y);
        DateTime date = DateTime(y.year, y.month, y.day, 12);
        if (data[date] == null) data[date] = [];
        data[date].add(event);
        print(data.keys);
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Calendar'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Org')
              .doc('Org 2')
              .collection('Assignment')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              snapshot.data.docs.forEach((doc) {
                allEvents = List.from(doc.data()["9"]["English"]);
              });

              for (Map m in allEvents) {
                dates.add({
                  'title': m['title'],
                  'description': m['description'],
                  'eventDate': m['eventDate']
                });
              }

              _events = _groupEvents(dates);
              if (_events != null) {
                dates = [];
              }
              print("--------------EVENTS--------------");
              print(_events);
            } else {
              _events = {};
              _selectedEvents = [];
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TableCalendar(
                    events: _events,
                    initialCalendarFormat: CalendarFormat.week,
                    calendarStyle: CalendarStyle(
                        canEventMarkersOverflow: true,
                        todayColor: Colors.orange,
                        selectedColor: Theme.of(context).primaryColor,
                        todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white)),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      formatButtonTextStyle: TextStyle(color: Colors.white),
                      formatButtonShowsNext: false,
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: (date, events) {
                      setState(() {
                        _selectedEvents = events;
                      });
                    },
                    builders: CalendarBuilders(
                      selectedDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                      todayDayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    calendarController: _controller,
                  ),
                  ..._selectedEvents.map((event) => ListTile(
                        title: Text(event['title']),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EventDetailsPage(
                                        event: event,
                                      )));
                        },
                      )),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/add_event'),
      ),
    );
  }
}
