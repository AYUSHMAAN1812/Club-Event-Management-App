import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/services/auth/auth_exceptions.dart';
import 'package:club_event_management/services/auth/auth_service.dart';
import 'package:club_event_management/utilities/show_error_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class LoginAdminView extends StatefulWidget {
  const LoginAdminView({super.key});

  @override
  State<LoginAdminView> createState() => _LoginAdminViewState();
}

class _LoginAdminViewState extends State<LoginAdminView> {
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
        await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .set({"user-token": token}, SetOptions(merge: true));
      }
    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, 'Failed to get user token');
    }
  }

//   Future<String> getUserRole() async {
//   User? user = FirebaseAuth.instance.currentUser;
//   DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
//   return doc['role'];
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        // title: const Text('Login as Admin'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                )),
          ),
          Padding(
            // padding: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.fromLTRB(16.0, 150.0, 16.0, 16.0),
            child: Column(
              children: [
                const Text(
                  'Login As Admin',
                  style: TextStyle(fontSize: 25.0, color: Colors.white),
                ),
                const SizedBox(height: 50.0),
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
                const SizedBox(height: 80.0),
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
                          DocumentSnapshot doc = await FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(email)
                              .get();
                          if (doc['role'].toString() == 'user') {
                            if (!context.mounted) return;
                            await showErrorDialog(context, "Invalid Admin");
                            if (!context.mounted) return;
                            await Navigator.of(context).pushNamedAndRemoveUntil(
                              homePage,
                              (route) => false,
                            );
                          } else {
                            try {
                              await AuthService.firebase().logIn(
                                email: email,
                                password: password,
                              );

                              final admin = AuthService.firebase().currentUser;

                              if (admin?.isEmailVerified ?? false) {
                                // admin's email is verified
                                if (!context.mounted) return;
                                await Navigator.of(context)
                                    .pushNamed(adminEventsRoute);
                              } else {
                                // admin's email is not verified
                                if (!context.mounted) return;
                                await Navigator.of(context)
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
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Login'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
