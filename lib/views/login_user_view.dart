import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/services/auth/auth_exceptions.dart';
import 'package:club_event_management/services/auth/auth_service.dart';
import 'package:club_event_management/utilities/show_error_dialog.dart';
import 'package:club_event_management/views/user_events_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LoginUserView extends StatefulWidget {
  const LoginUserView({super.key});

  @override
  State<LoginUserView> createState() => _LoginUserViewState();
}
var email;
initializeUserToken() async {
  await FirebaseMessaging.instance.getToken().then((token) {
    userCollection.doc(email.toString()).set({"user-token":token});
  });
}
class _LoginUserViewState extends State<LoginUserView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login as User'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const Text('Log In'),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your email here",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password here",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // user's email is verified
                  if(!mounted) return;
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                    userEventsRoute,
                    (route) => false,
                  );
                } else {
                  // user's email is not verified
                  if(!mounted) return;
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                if(!mounted) return;
                await showErrorDialog(
                  context,
                  'User Not Found',
                );
              } on WrongPasswordAuthException {
                if(!mounted) return;
                await showErrorDialog(
                    context,
                    'Wrong Credentials',
                  );
              } on GenericAuthException {
                if(!mounted) return;
                await showErrorDialog(
                    context,
                    'Authentication Error',
                  );
              }
            },
            child: const Text('Login'),
          ),
          initializeUserToken(),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                userRegisterRoute,
                (route) => false,
              );
            },
            child: const Text("Not registered yet? Register here"),
          ),
        ],
      ),
    );
  }
}
