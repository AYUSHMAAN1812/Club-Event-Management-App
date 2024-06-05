import 'package:club_event_management/constants/routes.dart';
import 'package:club_event_management/views/login_admin_view.dart';
import 'package:club_event_management/views/login_user_view.dart';
import 'package:club_event_management/views/register_user_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade400),
        useMaterial3: true,
      ),
      home: const Homepage(),
      routes: {
        loginUserRoute: (context) => const LoginUserView(),
        loginAdminRoute: (context) => const LoginAdminView(),
        registerUserRoute: (context) => const RegisterView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
                    registerUserRoute,
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
                    loginUserRoute,
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
                    loginAdminRoute,
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
