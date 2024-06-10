import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/event_model.dart';
import 'package:club_event_management/utilities/show_error_dialog.dart';
import 'package:club_event_management/views/user_events_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../helper_functions.dart';

class AdminEventsPage extends StatefulWidget {
  const AdminEventsPage({super.key});

  @override
  State<AdminEventsPage> createState() => _AdminEventsPageState();
}

class _AdminEventsPageState extends State<AdminEventsPage> {
  String? _eventName;
  bool _editForm = false;
  String _editEventId = "";

  String? _club;
  String? _status;
  DateTime time = DateTime.now();
  bool showDate = false;

  final _clubList = ["Kludge", "Lambda", "Robotix", "Torque"];
  final _statusList = ["Upcoming", "Ongoing", "Completed"];

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _organizerController = TextEditingController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _organizerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _eventName = args['name'] ?? "";
    }

    final nameField = Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.purple),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        autofocus: false,
        controller: _nameController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.event, color: Colors.purple,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          hintStyle: TextStyle(color: Colors.purple),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.purple)
      ),
    );
    final descriptionField = Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.purple),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        autofocus: false,
        controller: _descriptionController,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.description, color: Colors.purple,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Description",
          hintStyle: TextStyle(color: Colors.purple),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.purple)
      ),
    );
    final organizerField = Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.purple),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        autofocus: false,
        controller: _organizerController,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person, color: Colors.purple,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Organizer",
          hintStyle: TextStyle(color: Colors.purple),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.purple)
      ),
    );

    final searchField = Container(
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.purple),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        autofocus: false,
        controller: _searchController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Search for your events",
          hintStyle: TextStyle(color: Colors.purple),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.purple)
      ),
    );

    final clubDropDown = SizedBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 50.0,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.purple),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: DropdownButton<String>(
            dropdownColor: Colors.purple,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 28,
            iconEnabledColor: Colors.purple,
            hint: const Text("Select club", style: TextStyle(color: Colors.purple),),
            disabledHint: const Text("Select club"),
            underline: const SizedBox(),
            isExpanded: true,
            value: _club,
            onChanged: (newValue) {
              setState(() {
                _club = newValue;
              });
            },
            items: _clubList.toSet().toList().map((valueItem) {
              return DropdownMenuItem(value: valueItem, child: Text(valueItem));
            }).toList(),
          ),
        ),
      ]),
    );

    final statusDropDown = SizedBox(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: 50.0,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.purple),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: DropdownButton<String>(
            dropdownColor: Colors.purple,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 28,
            iconEnabledColor: Colors.purple,
            hint: const Text("Select status", style: TextStyle(color: Colors.purple),),
            disabledHint: const Text("Select status"),
            underline: const SizedBox(),
            isExpanded: true,
            value: _status,
            onChanged: (newValue) {
              setState(() {
                _status = newValue;
              });
            },
            items: _statusList.toSet().toList().map((valueItem) {
              return DropdownMenuItem(value: valueItem, child: Text(valueItem));
            }).toList(),
          ),
        ),
      ]),
    );

    final datePicker = Visibility(
      visible: showDate,
      child: SizedBox(
        height: 220.0,
        child: CupertinoDatePicker(
          initialDateTime: DateTime.now(),
          onDateTimeChanged: ((value) => setState(() {
                time = value;
              })),
        ),
      ),
    );

    final selectedDateAndTime = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Date: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(width: 10.0),
            Text(DateFormat('yyyy-MM-dd').format(time), style: const TextStyle(color: Colors.purple),),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            const Text("Time: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
            const SizedBox(width: 10.0),
            Text(DateFormat('HH:mm').format(time), style: const TextStyle(color: Colors.purple),),
          ],
        ),
        const SizedBox(height: 15.0),
      ],
    );

    const txtHeader =
        Center(child: Text("Book Event", style: TextStyle(color: Colors.white,fontSize: 24.0)));

    final btnShowDate = Material(
      color: Colors.purple.shade50,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            showDate = !showDate;
          });
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Say when",
              style: TextStyle(
                color: Colors.purple,
              ),
            ),
            SizedBox(width: 10.0),
            Icon(Icons.alarm, color: Colors.purple)
          ],
        ),
      ),
    );

    final btnSubmit = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15),
      color: Colors.purple,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (_nameController.text.isNotEmpty &&
              _club != null &&
              _status != null &&
              _organizerController.text.isNotEmpty) {
            Event event = Event(
              name: _nameController.text,
              club: _club!,
              status: _status!,
              description: _descriptionController.text,
              organizer: _organizerController.text,
              time: time,
            );

            if (!_editForm) {
              bookSession(event: event);
            } else {
              updateEvent(Event(
                name: _nameController.text,
                club: _club!,
                status: _status!,
                description: _descriptionController.text,
                organizer: _organizerController.text,
                time: time,
                id: _editEventId,
              ));
              setState(() {
                _editForm = false;
              });
            }
            setState(() {
              _eventName = _nameController.text;
              _nameController.clear();
              _descriptionController.clear();
              _organizerController.clear();
              _club = null;
              _status = null;
              time = DateTime.now();
            });
          } else {
            log("Please enter all fields!");
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text("Please enter all fields!")),
            // );
            showErrorDialog(context, "Please enter all fields!");
          }
        },
        child: Text(
          !_editForm ? "Book" : "Update",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );

    final btnSearch = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(15),
      color: Colors.purple,
      child: MaterialButton(
        onPressed: () {
          if (_searchController.text.isNotEmpty) {
            setState(() {
              _eventName = _searchController.text;
            });
          }
        },
        child: const Text(
          "Search",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    void editEvent(Event event) {
      setState(() {
        _nameController.text = event.name;
        _club = event.club;
        _status = event.status;
        _descriptionController.text = event.description;
        _organizerController.text = event.organizer;
        time = event.time;
        _editForm = true;
        _editEventId = event.id!;
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.purple.shade50,
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
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          
          children: [
            Container(
              height: MediaQuery.of(context).size.height/13,
              decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  txtHeader,
                  const SizedBox(height: 20.0),
                  nameField,
                  const SizedBox(height: 30.0),
                  clubDropDown,
                  const SizedBox(height: 30.0),
                  organizerField,
                  const SizedBox(height: 30.0),
                  descriptionField,
                  const SizedBox(height: 30.0),
                  statusDropDown,
                  const SizedBox(height: 30.0),
                  selectedDateAndTime,
                  datePicker,
                  btnShowDate,
                  const SizedBox(height: 60.0),
                  btnSubmit,
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: searchField),
                      const SizedBox(width: 20.0),
                      btnSearch
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  GetMyEvents(eventName: _eventName ?? "", update: editEvent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> bookSession({required Event event}) async {
  final docRef = eventCollection.doc();
  event = Event(
    name: event.name,
    time: event.time,
    club: event.club,
    description: event.description,
    organizer: event.organizer,
    status: event.status,
    id: docRef.id,
  );

  try {
    await docRef.set(event.toJson());
    log("Event booked successfully!");
  } catch (e) {
    log('Error booking event: $e');
  }

  await sendNotificationToUsers(event: event);
}

Future<void> updateEvent(Event event) async {
  try {
    await eventCollection.doc(event.id).set(event.toJson());
    log("Event updated successfully!");
  } catch (e) {
    log("Error updating event: $e");
  }
  await sendNotificationToUsers(event: event);
}

Future<void> deleteEvent(Event event) async {
  try {
    await eventCollection.doc(event.id).delete();
    log("Event deleted successfully!");
  } catch (e) {
    log("Error deleting event: $e");
  }
  await sendNotificationToUsers(event: event);
}

class GetMyEvents extends StatelessWidget {
  final String eventName;
  final ValueChanged<Event> update;
  const GetMyEvents({required this.eventName, required this.update, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0,
      child: StreamBuilder<QuerySnapshot>(
        stream: getMyEvents(eventName),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return const SizedBox();
          }

          if (snapshot.data!.docs.isEmpty) {
            return const SizedBox(
              child: Center(child: Text("You haven't booked any event yet!",style: TextStyle(color: Colors.purple),)),
            );
          }

          if (snapshot.hasData) {
            List<Event> events = [];

            for (var doc in snapshot.data!.docs) {
              final event = Event.fromJson(doc.data() as Map<String, dynamic>);
              events.add(event);
            }

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return UserScheduleCard(events[index], update: update);
              },
            );
          }

          return const SizedBox();
        }),
      ),
    );
  }
}

Stream<QuerySnapshot> getMyEvents(String eventName) {
  if (eventName.isEmpty) {
    return const Stream.empty();
  }
  return eventCollection.where('name', isEqualTo: eventName).snapshots();
}

class UserScheduleCard extends StatelessWidget {
  final Event event;
  final ValueChanged<Event> update;

  const UserScheduleCard(this.event, {required this.update, super.key});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => update(event),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => deleteEvent(event),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        tileColor: Colors.purple,
        title: Text(event.name, style: const TextStyle(color: Colors.white),),
        subtitle: Text('${event.club} - ${event.time.toLocal()}', style: const TextStyle(color: Colors.white),),
      ),
    );
  }
}
