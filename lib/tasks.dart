import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tasks extends StatefulWidget {
  final String employeeid;
  final String bvid;
  final String offid;
  final String clientid;
  Tasks({Key key, @required this.employeeid, @required this.bvid, @required this.offid, @required this.clientid}) : super(key: key);
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  void submitStart () {
    var curr = new DateTime.now();
    var startstamp = curr.toString();
    var dformatter = new DateFormat('yyyy-MM-dd');
    var startdate = dformatter.format(curr);
    var tformatter = new DateFormat('Hms');
    var starttime = tformatter.format(curr);
    http.post("http://192.168.43.18/api/start", body: {
      "employee_id": "${widget.employeeid}",
      "bv_id": "${widget.bvid}",
      "off_id": "${widget.offid}",
      "client_id": "${widget.clientid}",
      "start_date": startdate,
      "start_time": starttime,
      "start_stamp": startstamp,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
        backgroundColor: Colors.black,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child : new IconButton(
              icon: new Icon(Icons.exit_to_app),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("employee_id");
                Navigator.pushNamedAndRemoveUntil(context,
                  '/login',
                  ModalRoute.withName('/')
                );
              },
            )
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: InkWell(
              child: Text("Task 1"),
              onTap: () {
                submitStart();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: InkWell(
              child: Text("Task 2"),
              onTap: () {
                
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: InkWell(
              child: Text("Task 3"),
              onTap: () {
                
              },
            ),
          )
        ],
      ),
    );
  }
}