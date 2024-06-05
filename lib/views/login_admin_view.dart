import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/services/auth/auth_exceptions.dart';
import 'package:club_event_management/services/auth/auth_service.dart';
import 'package:club_event_management/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

class LoginAdminView extends StatefulWidget {
  const LoginAdminView({super.key});

  @override
  State<LoginAdminView> createState() => _LoginAdminViewState();
}

class _LoginAdminViewState extends State<LoginAdminView> {
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
                final admin = AuthService.firebase().currentUser;
                if (admin?.isEmailVerified ?? false) {
                  // admin's email is verified
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  // admin's email is not verified
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  // ignore: use_build_context_synchronously
                  context,
                  'User Not Found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                    // ignore: use_build_context_synchronously
                    context,
                    'Wrong Credentials',
                  );
              } on GenericAuthException {
                await showErrorDialog(
                    // ignore: use_build_context_synchronously
                    context,
                    'Authentication Error',
                  );
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}