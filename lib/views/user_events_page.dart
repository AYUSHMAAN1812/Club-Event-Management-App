import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/event_model.dart';
import 'package:club_event_management/helper_functions.dart';
import 'package:club_event_management/main.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;
final eventCollection = db.collection('events');
final userCollection = db.collection('users');


class UserEventsPage extends StatefulWidget {
  const UserEventsPage({super.key});

  @override
  State<UserEventsPage> createState() => _UserEventsPage();
}


class _UserEventsPage extends State<UserEventsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 200.0,
              decoration: const BoxDecoration(
                  color: Homepage.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    const Text("Welcome User,",
                        style: TextStyle(
                            fontSize: 24.0,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 10.0),
                    const Text("Here are your upcoming events",
                        style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          child: const Text(
                            "View all",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.white70),
                          ),
                          onPressed: () {}),
                    ),
                    const Schedule(),
                    const SizedBox(height: 30.0),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class Schedule extends StatelessWidget {
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: StreamBuilder(
          stream: getEvents,
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.docs.isEmpty) {
              return const SizedBox(
                height: 300.0,
                child: Center(
                    child: Text("You do not have any new events!")),
              );
            }

            if (snapshot.hasData) {
              List<Event> events = [];

              for (var doc in snapshot.data!.docs) {
                final event =
                    Event.fromJson(doc.data() as Map<String, dynamic>);

                events.add(event);
              }
              return SizedBox(
                height: 300.0,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed(eventDetails, arguments: events[index]),
                        child: ScheduleCard(events[index]));
                  },
                ),
              );
            }

            return const SizedBox();
          }),
        ));
  }
}

//Stream to get all Events from today
DateTime now = DateTime.now();
DateTime today = DateTime(now.year, now.month, now.day);

final Stream<QuerySnapshot> getEvents = eventCollection
    .orderBy('time')
    .where('time', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
    .snapshots();

class ScheduleCard extends StatelessWidget {
  final Event event;
  const ScheduleCard(this.event, {super.key});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: 50.0,
      margin: const EdgeInsets.only(bottom: 10.0),

      //width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          //Service color tag
          Container(
            width: 5.0,
          ),

          Expanded(
            child: SizedBox(
              height: 50.0,
              child: Card(
                elevation: 5.0,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 10.0, top: 10.0, left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 110.0,
                                child: Column(
                                  children: [
                                    Text(event.name,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                )),

                            //Appointmemt date
                            Text(checkDate(event.time)),

                            //Event time
                            Text(getTime(event.time)),
                          ]),
                      Text(
                        event.status,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: event.status == 'upcoming'
                                ? Colors.red
                                : event.status == 'ongoing'
                                ?Colors.yellow: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
