import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/services/auth/auth_exceptions.dart';
import 'package:club_event_management/services/auth/auth_service.dart';
import 'package:club_event_management/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
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
                await AuthService.firebase().createUser(email: email, password: password,);
                
                await AuthService.firebase().sendEmailVerification();
                if(!mounted) return;
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordAuthException {
                  if(!mounted) return;
                  showErrorDialog(context,
                  'Weak Password',);
              } on EmailAlreadyInUseAuthException {
                  if(!mounted) return;
                  showErrorDialog(context, 'Email is already in use',);
              } on InvalidEmailAuthException {
                if(!mounted) return;
                showErrorDialog(context, 'Invalid Email',);
              } on GenericAuthException {
                if(!mounted) return;
                showErrorDialog(context, 'Failed To Register');
              }catch (e) {
                print('Error: $e');
                if (!mounted) return;
                await showErrorDialog(
                  context,
                  'Error: $e',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                userLoginRoute,
                (route) => false,
              );
            },
            child: const Text("Already registered? Login here"),
          ),
        ],
      ),
    );
  }
}
