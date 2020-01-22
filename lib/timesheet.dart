import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TimeSheet extends StatefulWidget {
  final String employeeid;
  final int bvid;
  final int offid;
  final int clientid;
  @override
  TimeSheet({Key key, @required this.employeeid, @required this.bvid, @required this.offid, @required this.clientid}) : super(key: key);
  _TimeSheetState createState() => _TimeSheetState();
}

class _TimeSheetState extends State<TimeSheet> {

  var startdate;
  var enddate;
  var starttime;
  var endtime;
  var startstamp;
  var endstamp;

  void submit () {
    http.post("http://192.168.43.18/Mobile/timesheet.php", body: {
      "employee_id": "${widget.employeeid}",
      "bv_id": "${widget.bvid}",
      "off_id": "${widget.offid}",
      "start_date": startdate,
      "start_time": starttime,
      "end_date": enddate,
      "end_time": endtime,
      "start_stamp": startstamp,
      "end_stamp": endstamp,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timesheet"),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 25,
            ),
            Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text("Employee Id: " + "${widget.employeeid}"),
                    Text("Busness Vertical Id: " + "${widget.bvid}"),
                    Text("Offering Id: " + "${widget.offid}"),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            FlatButton(
              onPressed: (){
                var curr = new DateTime.now();
                startstamp = curr.toString();
                var dformatter = new DateFormat('yyyy-MM-dd');
                startdate = dformatter.format(curr);
                var tformatter = new DateFormat('Hms');
                starttime = tformatter.format(curr);
              },
              padding: EdgeInsets.all(10),
              child: Text("Start"),
            ),
            SizedBox(
              height: 50,
            ),
            FlatButton(
              onPressed: () {
                var curr = new DateTime.now();
                endstamp = curr.toString();
                var dformatter = new DateFormat('yyyy-MM-dd');
                enddate = dformatter.format(curr);
                var tformatter = new DateFormat('Hms');
                endtime = tformatter.format(curr);
                submit();
              },
              padding: EdgeInsets.all(10),
              child: Text("Stop"),
            ),
          ],
        ),
      ),  
    );
  }
}