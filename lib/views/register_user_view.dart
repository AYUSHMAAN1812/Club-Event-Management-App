import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/services/auth/auth_exceptions.dart';
import 'package:club_event_management/services/auth/auth_service.dart';
import 'package:club_event_management/utilities/show_error_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isLoading = false;

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

  Future<void> initializeUserToken(String email) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await FirebaseFirestore.instance.collection('users').doc(email).set({
          "user-token": token,
          "role": "user",
        }, SetOptions(merge: true));
      }
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, 'Failed to get user token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.purple.shade50,
        appBar: AppBar(
          // title: const Text('Register'),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/2,
              decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 80.0,),
                  const Text(
                    'Register As User',
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                  const SizedBox(height: 80.0,),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Enter your email here",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Enter your password here",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 100.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 15, // Font size
                        fontFamily: 'Roboto', // Font family
                        fontWeight: FontWeight.bold, // Font weight
                      ),
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });

                            final email = _email.text;
                            final password = _password.text;

                            if (email.isEmpty || password.isEmpty) {
                              showErrorDialog(
                                  context, 'Please fill in both fields');
                              setState(() {
                                _isLoading = false;
                              });
                              return;
                            }

                            try {
                              await AuthService.firebase().createUser(
                                email: email,
                                password: password,
                              );

                              final user = AuthService.firebase().currentUser;
                              if (user?.isEmailVerified ?? false) {
                                if (!context.mounted) return;
                                Navigator.of(context)
                                    .pushNamed(userEventsRoute);
                              } else {
                                await initializeUserToken(email);
                                if (!context.mounted) return;
                                Navigator.of(context)
                                    .pushNamed(verifyEmailRoute);
                              }
                            } on WeakPasswordAuthException {
                              showErrorDialog(context, 'Weak Password');
                            } on EmailAlreadyInUseAuthException {
                              showErrorDialog(
                                  context, 'Email is already in use');
                            } on InvalidEmailAuthException {
                              showErrorDialog(context, 'Invalid Email');
                            } on GenericAuthException {
                              showErrorDialog(context, 'Failed To Register');
                            } catch (e) {
                              log('Error: $e');
                              if (!context.mounted) return;
                              showErrorDialog(context, 'Error: $e');
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('Register'),
                  ),
                  const SizedBox(height: 10.0,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 15, // Font size
                        fontFamily: 'Roboto', // Font family
                        fontWeight: FontWeight.bold, // Font weight
                      ),
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(userLoginRoute);
                    },
                    child: const Text("Already registered? Login here"),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
