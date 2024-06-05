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
        userLoginRoute: (context) => const LoginUserView(),
        adminLoginRoute: (context) => const LoginAdminView(),
        userRegisterRoute: (context) => const RegisterView(),
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


Future<bool> showLogOutDialogBox(BuildContext context)
{
  return showDialog<bool>(
    context: context, 
    builder: (context)
    {
      return  AlertDialog(
        title: const Text('Sign Out'),
        content:const Text('Are you sure to sign out?'),
        actions: [
          TextButton(
           onPressed: () {
            Navigator.of(context).pop(false);
           },
           child:  const Text('Cancel'),
           ),
          TextButton(
           onPressed: () {
            Navigator.of(context).pop(true);

           },
           child: const Text('Log Out'),
           ),
        ],
      );
    }
    ).then((value)=>value ?? false);
}