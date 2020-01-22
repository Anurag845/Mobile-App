import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'allocation.dart';
import 'everything.dart';

class Home extends StatefulWidget {
  final String employeeid;
  Home({Key key, @required this.employeeid}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String name;
  String firstpunch;
  String lastactive;
  int activehours;
  int billablehours;
  String bv;
  String off;
  String client;
  bool isData = false;

  _retrieve() async {
    var response = await http.post("http://192.168.43.18/api/summary", body: {
      "emp_id": "${widget.employeeid}",
    });

    Map summary = Map();
    
    if(response.statusCode == 200) {
      summary = json.decode(response.body);
      name = summary["name"];
      firstpunch = summary["firstpunch"];
      lastactive = summary["lastactive"];
      activehours = summary["activehours"];
      billablehours = summary["activehours"];
      bv = summary["bv_name"];
      off = summary["off_name"];
      client = summary["client_name"];
      isData = true;
      setState(() {
        print("Summary Loaded");
      });
    }
  }

  void stop() {
    var curr = new DateTime.now();
    var endstamp = curr.toString();
    var dformatter = new DateFormat('yyyy-MM-dd');
    var enddate = dformatter.format(curr);
    var tformatter = new DateFormat('Hms');
    var endtime = tformatter.format(curr);
    http.post("http://192.168.43.18/api/stop", body: {
      "emp_id": "${widget.employeeid}",
      "end_date": enddate,
      "end_time": endtime,
      "end_stamp": endstamp,
    });
  }

  state() {
    if("$bv" == "NA") {
      return null;
    }
    else {
      return () {
        stop();
        setState(() {
          _retrieve();
        });
      };
    }
  }

  @override
  void initState() {
    super.initState();
    _retrieve();
  }

  Widget summaryPage() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Welcome " + "$name"),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Today's Summary",style: TextStyle(fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        child: Text("First Punch: "),
                        padding: EdgeInsets.all(5),
                      ),

                      Padding(
                        child: Text("Last Active: "),
                        padding: EdgeInsets.all(5),
                      ),

                      Padding(
                        child: Text("Active Hours: "),
                        padding: EdgeInsets.all(5),
                      ),

                      Padding(
                        child: Text("Billable Hours: "),
                        padding: EdgeInsets.all(5),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        child: Text("$firstpunch"),
                        padding: EdgeInsets.all(5),
                      ),

                      Padding(
                        child: Text("$lastactive"),
                        padding: EdgeInsets.all(5),
                      ),

                      Padding(
                        child: Text("$activehours"),
                        padding: EdgeInsets.all(5),
                      ),

                      Padding(
                        child: Text("$activehours"),
                        padding: EdgeInsets.all(5),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      color: Colors.grey[350],
                      padding: EdgeInsets.all(5),
                      onPressed: () {
                        Navigator
                        .push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Allocation(employeeid: "${widget.employeeid}"),
                          ),
                        )
                        .then((value) {
                          setState(() {
                            _retrieve();
                          });
                        });
                      },
                      child: Text("My Allocation"),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      color: Colors.grey[350],
                      padding: EdgeInsets.all(5),
                      onPressed: () {
                        Navigator
                        .push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Everything(employeeid: "${widget.employeeid}"),
                          ),
                        )
                        .then((value) {
                          setState(() {
                            _retrieve();
                          });
                        });
                      },
                      child: Text("Something Else"),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Text("Currently Running",style: TextStyle(fontWeight: FontWeight.bold),),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        child: Text("BV: "),
                        padding: EdgeInsets.all(5),
                      ),

                      Padding(
                        child: Text("Off: "),
                        padding: EdgeInsets.all(5),
                      ),

                      Padding(
                        child: Text("Client: "),
                        padding: EdgeInsets.all(5),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        child: Text("$bv"),
                        padding: EdgeInsets.all(5),
                      ),

                      Padding(
                        child: Text("$off"),
                        padding: EdgeInsets.all(5),
                      ),

                      Padding(
                        child: Text("$client"),
                        padding: EdgeInsets.all(5),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(5),
              child: FlatButton(
                color: Colors.grey[350],
                padding: EdgeInsets.all(5),
                onPressed: state(),
                child: Text("Stop"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
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
      body: !isData ? new Center(
              child: new CircularProgressIndicator(),
            )
          : summaryPage(),
    );
  }
}