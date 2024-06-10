import 'dart:developer';
import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/event_model.dart';
import 'package:club_event_management/views/user_events_page.dart';
import 'package:flutter/material.dart';
import '../helper_functions.dart';

class EventDetails extends StatefulWidget {
  final Event event;
  const EventDetails(this.event, {super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late Event _eventCopy;

  @override
  void initState() {
    super.initState();
    _eventCopy = Event(
      name: widget.event.name,
      time: widget.event.time,
      club: widget.event.club,
      description: widget.event.description,
      organizer: widget.event.organizer,
      status: widget.event.status,
      id: widget.event.id,
    );
  }

  void editEvent(Event event) {
    setState(() {
      _eventCopy.status = event.status;
    });
  }

  @override
  Widget build(BuildContext context) {
    log(_eventCopy.status);

    const txtHeader =
        Center(child: Text("Event Details", style: TextStyle(fontSize: 24.0, color: Colors.white)));


    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.of(context).pushNamedAndRemoveUntil(
                homePage,
                (route) => false,
              );
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height/12,
              decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              txtHeader,
              const SizedBox(height: 20.0),
              BuildRow(title: "Name", details: widget.event.name),
              BuildRow(title: "Club", details: widget.event.club),
              BuildRow(title: "Description", details: widget.event.description),
              BuildRow(title: "Organizer", details: widget.event.organizer),
              BuildRow(title: "Date", details: getDate(widget.event.time)),
              BuildRow(title: "Time", details: getTime(widget.event.time)),
              BuildRow(title: "Status", details: _eventCopy.status),
              const SizedBox(height: 20.0),
              
            ]),
          ),
        ],
      ),
    );
  }
}

Future<void> completedEvent(Event event, ValueChanged<Event> update) async {
  event.status = "Completed";

  await eventCollection.doc(event.id).set(event.toJson()).then((value) {
    sendNotificationToUsers(event: event);
    update(event);
  });
}

Future<void> ongoingEvent(Event event, ValueChanged<Event> update) async {
  event.status = "Ongoing";

  await eventCollection.doc(event.id).set(event.toJson()).then((value) {
    sendNotificationToUsers(event: event);
    update(event);
  });
}

class BuildRow extends StatelessWidget {
  final String title;
  final String details;
  const BuildRow({required this.title, required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
          const SizedBox(width: 10.0),
          Text(details),
        ],
      ),
    );
  }
}
