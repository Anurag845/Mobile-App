import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

Future isLogged(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String empid = prefs.getString("employee_id");
  if(empid == null) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }
  else {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(employeeid: empid),
        ),
      );
    });
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      routes: {
        '/login': (context) => Login(),
      },
      home: Logo(),
    );
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    isLogged(context);
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}