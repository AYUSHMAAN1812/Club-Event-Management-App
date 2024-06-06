import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_event_management/event_model.dart';
import 'package:club_event_management/views/user_events_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

//Check if Date is Today
bool isToday(String date) {
  DateTime now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate =
      DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

  if (checkDate == today) {
    return true;
  }

  return false;
}

//Check if Date is Tomorrow
bool isTomorrow(String date) {
  DateTime now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);

  DateTime dateConvert = DateTime.parse(date);
  final checkDate =
      DateTime(dateConvert.year, dateConvert.month, dateConvert.day);

  if (checkDate == tomorrow) {
    return true;
  }

  return false;
}

///Function to check if date is today or tomorrow
checkDate(DateTime date) {
  if (isToday(getDate(date))) {
    return "Today";
  }

  if (isTomorrow(getDate(date))) {
    return "Tomorrow";
  }

  return getDate(date);
}

//Function to get Local time
getTime(date) {
  String hour = "${date.toLocal()}".split(' ')[1].split(':')[0];

  String min = "${date.toLocal()}".split(' ')[1].split(':')[1];
  return "$hour:$min";
}

//Function to get Local date
getDate(date) {
  String day = "${date.toLocal()}".split(' ')[0];

  return day;
}

//Send Event Notifification To Users
sendNotificationToUsers({required Event event}) async {
  // Our API Key
  var serverKey = dotenv.get('API_KEY');
  QuerySnapshot querySnapshot = await userCollection.get();

  // Get user tokens from Firestore DB
  for (var document in querySnapshot.docs) {
    var token = '';
    await userCollection
        .doc(document.id)
        .get()
        .then((snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            token = snapshot['id'];
          }
        });

    // Create Message with Notification Payload
    String constructFCMPayload(String token) {
      String day = checkDate(event.time);
      String time = getTime(event.time);
      return jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': "You have a new event for $time $day",
            'title': "New event",
          },
          'data': <String, dynamic>{
            'name': event.name,
            'time': event.time.toString(),
            'club': event.club,
            'status': event.status,
            'id': event.id
          },
          'to': token
        },
      );
    }

    if (token.isEmpty) {
      log('Unable to send FCM message, no token exists for user: ${document.id}');
      continue;
    }

    try {
      // Send Message
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': 'key=$serverKey',
              },
              body: constructFCMPayload(token));

      if (response.statusCode == 200) {
        log("Message Sent Successfully to ${document.id}!");
      } else {
        log("Failed to send message to ${document.id}: ${response.statusCode}");
      }
    } catch (e) {
      log("Error sending push notification to ${document.id}: $e");
    }
  }
}