import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class Login extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  String msg = '';

  bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  Future<List> _login() async {
    final response = await http.post("http://192.168.43.18/api/login", body: {
      "employee_id": user.text,
      "password": pass.text
    });
    var datauser = json.decode(response.body);
    if(datauser.length == 0) {
      setState(() {
        msg = "Login Failed";
      });
    }
    else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('employee_id', user.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(employeeid: user.text),
        ),
      );
    }
    return datauser;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Timesheet Logger"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            
            TextFormField(
              controller: user,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Employee Id',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                enabledBorder: OutlineInputBorder(                  
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(                  
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),

            SizedBox(height: 15.0),

            TextFormField(
              controller: pass,
              autofocus: false,
              obscureText: passwordVisible,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                focusColor: Colors.black,
                enabledBorder: OutlineInputBorder(                  
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(                  
                  borderSide: BorderSide(color: Colors.black),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ?
                    Icons.visibility_off :
                    Icons.visibility
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });                    
                  },
                  color: Colors.black,
                )
              ),
            ),
            
            SizedBox(height: 25.0),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.black,      
                elevation: 5.0,
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 42.0,
                  onPressed: () {
                    _login();
                  },
                  child: Text('Log In', style: TextStyle(color: Colors.white),)
                )
              ),
            ),

            FlatButton(
              child: Text('Forgot password?', style: TextStyle(color: Colors.black45)),
              onPressed: () {},
            ),

            Text(
              msg,
              style:TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            )
          ],
        )
      )
    );
  }
}