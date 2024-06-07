import 'dart:developer';
import 'package:club_event_management/event_model.dart';
import 'package:club_event_management/main.dart';
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
  @override
  Widget build(BuildContext context) {
    void editEvent(Event event) {
      setState(() {
        widget.event.status = event.status;
      });
    }

    log(widget.event.status);

    const txtHeader = Center(
        child: Text("Event Details", style: TextStyle(fontSize: 24.0)));
    final completedBtn = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15),
        color: widget.event.status == "ongoing"
            ? Colors.grey
            : Homepage.primaryColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () => widget.event.status == "ongoing"
              ? null
              : completedEvent(widget.event, editEvent),
          child: const Text(
            "Completed",
            style: TextStyle(color: Colors.white),
          ),
        ));
    final ongoingBtn = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(15),
        color: widget.event.status == "ongoing"
            ? Colors.grey
            : Homepage.primaryColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () => widget.event.status == "ongoing"
              ? null
              : ongoingEvent(widget.event, editEvent),
          child: const Text(
            "Ongoing",
            style: TextStyle(color: Colors.white),
          ),
        ));
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          txtHeader,
          const SizedBox(height: 20.0),
          BuildRow(title: "Name", details: widget.event.name),
          BuildRow(title: "Club", details: widget.event.club),
          BuildRow(title: "Date", details: getDate(widget.event.time)),
          BuildRow(
              title: "Time", details: "${getTime(widget.event.time)}"),
          BuildRow(title: "Status", details: widget.event.status),
          const SizedBox(height: 20.0),
          Row(
            children: [
              ongoingBtn,
              completedBtn,
            ],
          )
        ]),
      ),
    );
  }
}

completedEvent(
    Event event, ValueChanged<Event> update) async {
  event.status = "completed";

  await eventCollection
      .doc(event.id)
      .set(event.toJson())
      .then((value) {
    sendNotificationToUsers(event: event);
    update(event);
  });
}
ongoingEvent(
    Event event, ValueChanged<Event> update) async {
  event.status = "ongoing";

  await eventCollection
      .doc(event.id)
      .set(event.toJson())
      .then((value) {
    sendNotificationToUsers(event: event);
    update(event);
  });
}

class BuildRow extends StatelessWidget {
  final title;
  final details;
  const BuildRow({this.title, this.details, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          Text("$title:", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10.0),
          Text("$details"),
        ],
      ),
    );
  }
}
