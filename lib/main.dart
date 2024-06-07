import 'dart:developer';
import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/event_model.dart';
import 'package:club_event_management/views/login_admin_view.dart';
import 'package:club_event_management/views/login_user_view.dart';
import 'package:club_event_management/views/register_user_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
        useMaterial3: true,
      ),
      home:  const Homepage(),
      routes: {
        homePage: (context) => const Homepage(),
        userLoginRoute: (context) => const LoginUserView(),
        adminLoginRoute: (context) => const LoginAdminView(),
        userRegisterRoute: (context) => const RegisterView(),
      },
    ),
  );
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static const primaryColor = Colors.orange;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<void> setUpInteractedMessage() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    ///Configure notification permissions
    //IOS
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    //Android
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    //Get the message from tapping on the notification when app is not in foreground
    RemoteMessage? initialMessage = await messaging.getInitialMessage();

    //If the message contains a club, navigate to the admin
    if (initialMessage != null) {
      await _mapMessageToUser(initialMessage);
    }

    //This listens for messages when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_mapMessageToUser);

    //Listen to messages in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      //Initialize FlutterLocalNotifications
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'schedular_channel', // id
        'Schedular Notifications', // title
        description:
            'This channel is used for Schedular app notifications.', // description
        importance: Importance.max,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      //Construct local notification using our created channel
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: "@mipmap/ic_launcher", //Your app icon goes here
                // other properties...
              ),
            ));
      }
    });
  }

  _mapMessageToUser(RemoteMessage message) {
    Map<String, dynamic> json = message.data;

    if (message.data['club'] != null) {
      Event event = Event(
          name: json['name'],
          time: DateTime.parse(json['time']),
          club: json['club'],
          status: json['status'],
          id: json['id']);
      Navigator.of(context).pushNamed(eventDetails, arguments: event);
    } else {
      Navigator.of(context).pushNamed(userLoginRoute, arguments: json);
    }
  }

  @override
  void initState() {
    super.initState();
    setUpInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orange.shade100,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'CLUBS OF IITH',
                style: TextStyle(color: Colors.green, fontSize: 40),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.orange.shade300,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    userRegisterRoute,
                    (route) => false,
                  );
                },
                child: const Text('Register as a User'),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.orange.shade300,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    userLoginRoute,
                    (route) => false,
                  );
                },
                child: const Text('Login as a User'),
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  backgroundColor: Colors.orange.shade300,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    adminLoginRoute,
                    (route) => false,
                  );
                },
                child: const Text('Login as an Admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> showLogOutDialogBox(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure to sign out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
