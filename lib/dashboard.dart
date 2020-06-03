import 'package:mahadalzahra/homepagebackground.dart';
import 'package:mahadalzahra/maqarat_display.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:date_util/date_util.dart';
import 'package:intl/intl.dart';
import 'package:mahadalzahra/services/authentication.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

final Map<String, String> utc_times = {
  "7:00": "1:30",
  "9:00": "3:30",
  "16:00": "10:30",
  "17:00": "'11:30",
  "21:00": "15:30",
  "22:00": "16:30"
};
final Map<int, String> day_map = {
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
  7: "Sunday"
};
final fb = FirebaseDatabase.instance.reference();

Future getbooked() async {
  var r = (await fb.child('user_maqarat_booked').child(userappid).once()).value;
  return r;
}

class DateSelect {
  final int dat;
  final String day;
  final int cnt_maqarat;
  final String month;

  DateSelect(
    this.dat,
    this.day,
    this.cnt_maqarat,
    this.month,
  );
}

class Maqarat {
  final String time;
  final int juz;
  final String participants;
  final bool isTime;

  const Maqarat(
    this.time,
    this.juz,
    this.participants,
    this.isTime,
  );
}

List<String> dlist = [];

List<DateSelect> getdata(var value) {
  List<DateSelect> datList = [];
  List<DateTime> dates = [];
  int cnt;
  var temp_date = DateTime.now();
  for (var i = 0; i < 7; i++) {
    dates.add(temp_date);
    temp_date = temp_date.add(new Duration(days: 1));
  }
  for (var i = 0; i < 7; i++) {
    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(dates[i]);
    dlist.add(formatted);
    if (value == null) {
      cnt = 0;
    } else if (value[formatted] != null) {
      cnt = Map<String, dynamic>.from(value[formatted]).length;
    } else {
      cnt = 0;
    }
    datList.add(new DateSelect(
        dates[i].day,
        day_map[dates[i].weekday].substring(0, 3),
        cnt,
        DateUtil().month(dates[i].month) + " " + dates[i].year.toString()));
  }
  return datList;
}



class _DashboardState extends State<Dashboard> {
  Future val;
  int selectedIndex = 0;
  List<DateSelect> _datList;
  Map info;
  String dkey;
  List<Maqarat> _maqaratList = [];

  //List dlist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    val = getbooked();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: val,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          //print(snapshot.data.runtimeType);
          else {
            _datList = getdata(snapshot.data);

            //dlist=Map<String, dynamic>.from(snapshot.data).keys.toList();
            return Stack(
              children: <Widget>[
                HomePageBackground(
                  screenHeight: MediaQuery.of(context).size.height,
                ),
                SafeArea(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.007, //5.0
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width *
                              0.02435), //10.0
                      child: Row(
                        children: <Widget>[
                          Spacer(),
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.0879, //60.0
                            width: MediaQuery.of(context).size.width *
                                0.12175, //50.00,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("images/mahadlogo.png"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height:
                          MediaQuery.of(context).size.height * 0.01465, //10.0
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            border: Border.all(
                              width:
                                  MediaQuery.of(context).size.width * 0.002435,
                              color: Color(0xffffffff),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(1.00, 1.00),
                                color: Color(0xffffffff).withOpacity(0.53),
                                blurRadius: 6,
                              ),
                            ],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.00),
                              topRight: Radius.circular(30.00),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.0487,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.007), //20.0 - 5.0
                                    child: Text(
                                      "My Maqarats",
                                      style: TextStyle(
                                        fontFamily: "Segoe UI",
                                        fontWeight: FontWeight.w600,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0974,
                                        //40.0
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              //DateSelector(),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.012175,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.007), //5.0 - 5.0
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.124525, //85.0

                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _datList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;

                                              print(selectedIndex.toString() +
                                                  " " +
                                                  dlist[selectedIndex]);
                                              /*maqaratList = [];
                                              if (_datList[selectedIndex]
                                                      .cnt_maqarat >
                                                  0) {
                                                List temp = Map.from(snapshot
                                                            .data[
                                                        dlist[selectedIndex]])
                                                    .keys
                                                    .toList();
                                                for (var i = 0;
                                                    i < temp.length;
                                                    i++) {
                                                  _maqaratList.add(new Maqarat(
                                                      snapshot
                                                          .data[dlist[selectedIndex]]
                                                              [temp[i].toString()]
                                                              ['time']
                                                          .toString(),
                                                      snapshot.data[dlist[selectedIndex]]
                                                              [temp[i].toString()]
                                                          ['juz'],
                                                      snapshot.data[dlist[selectedIndex]]
                                                                  [temp[i]
                                                                      .toString()]
                                                                  ['participants']
                                                              .toString() +
                                                          "/5",
                                                      false));
                                                }
                                              }*/
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.007,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.001465),
                                            //5.0 -1.0
                                            child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.012175),
                                                //5.0
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1172,
                                                //80.00
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.17532,
                                                //72.0
                                                decoration: BoxDecoration(
                                                  color: index == selectedIndex
                                                      ? Color(0xFF003CE7)
                                                      : Colors.white,
                                                  border: Border.all(
                                                    width: 1.0,
                                                    color:
                                                        index == selectedIndex
                                                            ? Color(0xFF003CE7)
                                                            : Colors.white,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.00),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset:
                                                          Offset(0.00, 3.00),
                                                      color: Color(0xff000000)
                                                          .withOpacity(0.40),
                                                      blurRadius: 4,
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.007),
                                                      child: Center(
                                                        child: Text(
                                                          _datList[index]
                                                                  .dat
                                                                  .toString() +
                                                              "\n" +
                                                              _datList[index]
                                                                  .day,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Segoe UI",
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.05357,
                                                            //22.0
                                                            color: index ==
                                                                    selectedIndex
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Spacer(),
                                                        Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.033695,
                                                          //23.0
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.056005,
                                                          //23.00
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            border: Border.all(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.00182625,
                                                              color: index ==
                                                                      selectedIndex
                                                                  ? Color(
                                                                      0xFF003CE7)
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              _datList[index]
                                                                  .cnt_maqarat
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Segoe UI",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,

                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.046265,
                                                                //19.0

                                                                color: index ==
                                                                        selectedIndex
                                                                    ? Color(
                                                                        0xFF003CE7)
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        );
                                      },
                                    )),
                              ),

                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.01465), //10.0
                              Expanded(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    //border: Border.all(width: MediaQuery.of(context).size.width *0.002435, color: Color(0xffffffff),),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(3.00, 3.00),
                                        color:
                                            Color(0xff000000).withOpacity(0.21),
                                        blurRadius: 12,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0)),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01465,
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.036525),
                                            //10.0 - 15.0
                                            child: Text(
                                              _datList[selectedIndex]
                                                      .dat
                                                      .toString() +
                                                  " " +
                                                  _datList[selectedIndex]
                                                      .month +
                                                  ", " +
                                                  _datList[selectedIndex].day,
                                              //DATE DISPLAY
                                              style: TextStyle(
                                                fontFamily: "Segoe UI",
                                                fontWeight: FontWeight.w400,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.060875,
                                                //21.0
                                                color: Color(0xff000000),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.007324),
                                      if (_datList[selectedIndex].cnt_maqarat >
                                          0)
                                        MaqaratPage(Map.from(snapshot.data),
                                            dlist[selectedIndex])
                                      else
                                        Container(
                                          height: 200,
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.10255,
                                              ), //70
                                              Row(
                                                children: <Widget>[
                                                  Spacer(),
                                                  Text("No Maqarat Scheduled",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.05357)),
                                                  //19
                                                  Spacer(),
                                                ],
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.0293,
                                              ), //20
                                              Row(
                                                children: <Widget>[
                                                  Spacer(),
                                                  Text(
                                                      "To schedule a Maqarat - Click on Join Maqarat",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.04383)),
                                                  //18
                                                  Spacer(),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                )),
              ],
            );
          }
        },
      ),
    );
  }
}
