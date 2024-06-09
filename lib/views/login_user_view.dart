import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/main.dart';
import 'package:club_event_management/services/auth/auth_exceptions.dart';
import 'package:club_event_management/services/auth/auth_service.dart';
import 'package:club_event_management/utilities/show_error_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LoginUserView extends StatefulWidget {
  const LoginUserView({super.key});

  @override
  State<LoginUserView> createState() => _LoginUserViewState();
}

class _LoginUserViewState extends State<LoginUserView> {
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
        appBar: AppBar(
          title: const Text('Login as User'),
          backgroundColor: Homepage.primaryColor,
          foregroundColor: Colors.blue,
        ),
        body: Stack(
          children: [
            Container(
              height: 400.0,
              decoration: const BoxDecoration(
                  color: Homepage.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )),
            ),
            Padding(
              // padding: const EdgeInsets.all(16.0) ,
              padding: const EdgeInsets.fromLTRB(16.0, 150.0, 16.0, 16.0),
              child: Column(
                children: [
                  const Text(
                    'Login As User',
                    style: TextStyle(fontSize: 25.0),
                  ),
                  const SizedBox(height: 50.0),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Enter your email here",
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Enter your password here",
                    ),
                  ),
                  const SizedBox(height: 100.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 15, // Font size
                        fontFamily: 'Roboto', // Font family
                        fontWeight: FontWeight.bold, // Font weight
                      ), backgroundColor: Colors.orange,
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
                            try {
                              await AuthService.firebase().logIn(
                                email: email,
                                password: password,
                              );
                              final user = AuthService.firebase().currentUser;
                              if (user?.isEmailVerified ?? false) {
                                // user's email is verified
                                await initializeUserToken(email);
                                if (!context.mounted) return;
                                Navigator.of(context)
                                    .pushNamed(userEventsRoute);
                              } else {
                                // user's email is not verified
                                if (!context.mounted) return;
                                Navigator.of(context)
                                    .pushNamed(verifyEmailRoute);
                              }
                            } on UserNotFoundAuthException {
                              if (!context.mounted) return;
                              await showErrorDialog(
                                context,
                                'User Not Found',
                              );
                            } on WrongPasswordAuthException {
                              if (!context.mounted) return;
                              await showErrorDialog(
                                context,
                                'Wrong Credentials',
                              );
                            } on GenericAuthException {
                              if (!context.mounted) return;
                              await showErrorDialog(
                                context,
                                'Authentication Error',
                              );
                            } catch (e) {
                              log('Error: $e');
                              if (!context.mounted) return;
                              await showErrorDialog(
                                context,
                                'Error: $e',
                              );
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
                        : const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        userRegisterRoute,
                      );
                    },
                    child: const Text("Not registered yet? Register here"),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
