import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:date_util/date_util.dart';

class Plus_Button extends StatefulWidget {
  final int appid;

  Plus_Button(this.appid);

  @override
  _Plus_ButtonState createState() => _Plus_ButtonState();
}

final fb = FirebaseDatabase.instance.reference();

class Maqarat {
  final String date;
  final String time;
  final int juz;

  const Maqarat(
    this.date,
    this.time,
    this.juz,
  );
}

class Juz_count {
  final int juz;
  final int count;

  const Juz_count(
    this.juz,
    this.count,
  );
}

class _Plus_ButtonState extends State<Plus_Button> {
  Future gethist() async {
    var r =
        (await fb.child('user_history').child(widget.appid.toString()).once()).value;
    return r;
  }

  List<Maqarat> _maqaratList = [];
  List<Juz_count> _juz_list = [];
  Map dates_hist;
  List dates;
  Future r;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    r=gethist();/*then((val) {
      setState(() {
        int j = 1;
        for (var i in val['ajza_count'].toString().split(',').map(int.parse).toList()) {
          _juz_list.add(Juz_count(j++, i));
        }
        if(val['date_wise'] != null) {
          dates_hist = Map<String, dynamic>.from(val['date_wise']);
          dates = dates_hist.keys.toList();
          var o = DateUtil();
          for (var k in dates) {
            var temp = k.toString().split('-');
            var temp_day = temp[0].toString() + " ";
            var temp_month = o.month(int.parse(temp[1])).toString().substring(
                0, 3) + " ";
            var temp_year = temp[2].toString();
            _maqaratList.add(Maqarat((temp_day + temp_month + temp_year),
                dates_hist[k]['time'].toString(),
                int.parse(dates_hist[k]['juz'].toString())));
          }
        }
      });
    });*/
  }
void populate(Map val){
  int j = 1;
  for (var i in val['ajza_count'].toString().split(',').map(int.parse).toList()) {
    _juz_list.add(Juz_count(j++, i));
  }
  if(val['date_wise'] != null) {
    dates_hist = Map<String, dynamic>.from(val['date_wise']);
    dates = dates_hist.keys.toList();
    var o = DateUtil();
    for (var k in dates) {
      var temp = k.toString().split('-');
      var temp_day = temp[0].toString() + " ";
      var temp_month = o.month(int.parse(temp[1])).toString().substring(
          0, 3) + " ";
      var temp_year = temp[2].toString();
      _maqaratList.add(Maqarat((temp_day + temp_month + temp_year),
          dates_hist[k]['time'].toString(),
          int.parse(dates_hist[k]['juz'].toString())));
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: r,
      builder: (context,snapshot){

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        else{
          populate(Map.from(snapshot.data));
      return DefaultTabController(
          length: 2,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text("History"),
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: 'DATE WISE',
                    ),
                    Tab(
                      text: 'JUZ WISE',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  ListView.builder(
                    itemCount: _maqaratList.length,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01172), //8
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02435,
                            left:
                                MediaQuery.of(context).size.width * 0.02435), //10
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.01172), //8.0
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.1172, //80
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.00,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: MediaQuery.of(context).size.width *
                                            0.02435,
                                        right: MediaQuery.of(context).size.width *
                                            0.02435),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          _maqaratList[index].date,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.030765),
                                        ),
                                        Spacer(),
                                        Text(_maqaratList[index].time + ' IST',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.024905)),
                                        Spacer(),
                                        Text(
                                            'Juz ' +
                                                _maqaratList[index]
                                                    .juz
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.030765))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: _juz_list.length,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01172),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02435,
                            left: MediaQuery.of(context).size.width * 0.02435),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.01172),
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.1172, //80
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.00,
                                      color: Colors.black,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: MediaQuery.of(context).size.width *
                                            0.02435,
                                        right: MediaQuery.of(context).size.width *
                                            0.02435),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Juz ' +
                                              _juz_list[index].juz.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.030765),
                                        ),
                                        Spacer(),
                                        Text(
                                            'Count: ' +
                                                _juz_list[index].count.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.030765))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ));}}
    );
  }
}
