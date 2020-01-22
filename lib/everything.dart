import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'tasks.dart';

class Everything extends StatefulWidget {
  final String employeeid;
  Everything({Key key, @required this.employeeid}) : super(key: key);
  @override
  _EverythingState createState() => _EverythingState();
}

class _EverythingState extends State<Everything> {

  bool isData = false;
  List everything = List();

  _geteverything() async {
    var response = await http.post("http://192.168.43.18/api/everything", body: {
      "emp_id": "${widget.employeeid}",
    });

    if(response.statusCode == 200) {
      everything = json.decode(response.body);
      isData = true;
      setState(() {
        print("Everything retrieved");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _geteverything();
  }

  List _getofferings(String bvid, List off) {
    List<Widget> children = List();
    for(int i = 0; i < off.length; i++) {
      children.add(
        ExpansionTile(
          title: Center(
            child: Text(off[i]["offering_name"]),
          ),
          children: _getclients(bvid,off[i]["offering_id"].toString(),off[i]["clients"]),
        ),
      );
    }
    return children;
  }

  List _getclients(String bvid, String offid, List cli) {
    List<Widget> children = List();
    for(int i = 0; i < cli.length; i++) {
      children.add(
        InkWell(
          child: ListTile(
            title: Center(
              child: Text(cli[i]["client_name"]),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Tasks(employeeid: "${widget.employeeid}", bvid: bvid, offid: offid, clientid: cli[i]["client_id"].toString()), 
              )
            );
          },
        ),
      );
    }
    return children;
  }

  Widget everythingPage() {
    return ListView.builder(
      itemCount: everything.length,
      itemBuilder: (BuildContext context, int index) {
        return ExpansionTile(
          title: ListTile(
            title: Text(everything[index]["bv_name"]),
          ),
          children: _getofferings(everything[index]["bv_id"].toString(),everything[index]["offerings"]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Something Else"),
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
            : everythingPage(),
    );
  }
}