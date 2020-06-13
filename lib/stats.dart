import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:mahadalzahra/homepagebackground.dart';
import 'package:mahadalzahra/plus_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:mahadalzahra/services/authentication.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}
final fb = FirebaseDatabase.instance.reference();
Future getstat() async{
  var r=(await fb.child('user_state').child(userappid).once()).value;
  var er=(await fb.child('global_stats').once()).value;
  return [r,er];
}
Future getglobalstat() async{
  var r=(await fb.child('global_stats').once()).value;
  return r;
}
class _StatsState extends State<Stats> {
  List<Color> colours=[];
  String day="0";
  String week="0";
  String maq_att="0";
  String maq_unatt="0";
  String quran_tamam="0";
  List<int> ajza=[];
  String global_users="0";
  String global_maqarat="0";
  String global_qur="0";
  Future r;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('stat dispose');
  }
  @override
  void initState() {
    super.initState();
    print("stats...");
    for(var i=0; i<31; i++){
      colours.add(Colors.white);
    }
    r=getstat();/*then((val){
      setState(() {
        day=val['days'].toString();
        week=val['weeks'].toString();
        maq_att=val['total_maqarat'].toString();
        maq_unatt=val['unattended_maqarat'].toString().split(',').length.toString();
        quran_tamam=val['total_quran'].toString();
        ajza=val['ajza'].toString().split(',').map(int.parse).toList();
        for(var i in ajza){
          colours[i]=Colors.green;
        }

      });
    });*/
    /*getglobalstat().then((value) {
      setState(() {
        global_maqarat=value['total_maqarat'].toString();
        global_qur=value['total_quran'].toString();
        global_users=value['total_users'].toString();
      });
    });*/
    
  }
  void populate(Map val,Map value){
    day=val['days'].toString();
    week=val['weeks'].toString();
    maq_att=val['total_maqarat'].toString();
    if(val['unattended_maqarat'].toString()!=""){
    maq_unatt=val['unattended_maqarat'].toString().split(',').length.toString();}
    else{maq_unatt="0";}
    quran_tamam=val['total_quran'].toString();
    if(val['ajza'].toString()!=""){
    ajza=val['ajza'].toString().split(',').map(int.parse).toList();}
    else{
      ajza=[0];
    }
    for(var i in ajza){
      colours[i]=Color(0xff00ff00);
    }
    global_maqarat=value['total_maqarat'].toString();
    global_qur=value['total_quran'].toString();
    global_users=value['total_users'].toString();
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
          print(snapshot.data[0]);
          print(snapshot.data[1]);
          populate(Map.from(snapshot.data[0]),Map.from(snapshot.data[1]));
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
                height: MediaQuery.of(context).size.height * 0.007325, //5.0
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.02435,left: MediaQuery.of(context).size.width *
                    0.02435), //10.0
                child: Row(
                  children: <Widget>[
                    Icon(Icons.account_circle,color: Colors.white,size:21,),
                    Text(" Burhanuddin Shabbir Bhai",style: TextStyle(     //FROM DATABASE
                      fontFamily: "Segoe UI",
                      fontWeight: FontWeight.w400,
                      fontSize:
                      19.0,
                      //40.0
                      color: Colors.white,
                        fontFeatures: [FontFeature.tabularFigures(),]
                    ),),
                    Spacer(),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.0879, //60.0
                      width: MediaQuery.of(context).size.width * 0.12175, //50.00,
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
                height: MediaQuery.of(context).size.height * 0.01465, //10.0
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      border: Border.all(
                        width: MediaQuery.of(context).size.width * 0.002435,
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
                                      MediaQuery.of(context).size.width * 0.0487,
                                  vertical: MediaQuery.of(context).size.height *
                                      0.007), //20.0 - 5.0
                              child: Text(
                                "My Stats",
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
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.01465,
                                  right: MediaQuery.of(context).size.width *
                                      0.036525,
                                  left: MediaQuery.of(context).size.width *
                                      0.036525), //10.0 - 15.0 - 15.0
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      height: MediaQuery.of(context).size.height *
                                          0.312045, //213
                                      width: MediaQuery.of(context).size.width *
                                          0.44317, //182
                                      decoration: BoxDecoration(
                                        color: Color(0xffffE4E4E4),
                                        border: Border.all(
                                          width: 1.00,
                                          color: Color(0xffffffff),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0.00, 3.00),
                                            color: Color(0xff000000)
                                                .withOpacity(0.53),
                                            blurRadius: 6,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(20.00),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "Streaks",
                                              style: TextStyle(
                                                fontFamily: "Segoe UI",
                                                fontWeight: FontWeight.w600,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.08279,
                                                //28
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01758), //12.0
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.16701, //114
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.27759, //114
                                                decoration: BoxDecoration(
                                                  color: Color(0xfff62e2e),
                                                  border: Border.all(
                                                    width: 1.00,
                                                    color: Color(0xff707070),
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Container(
                                                      height: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.142105,
                                                      //97
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.236195,
                                                      //97
                                                      decoration: BoxDecoration(
                                                        color: Color(0xff771616),
                                                        border: Border.all(
                                                          width: 1.00,
                                                          color: Color(0xff707070),
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.01758), //12
                                                        child: SingleChildScrollView(
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text(
                                                                "Day",
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      "Segoe UI",
                                                                  fontWeight:
                                                                      FontWeight.w600,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.07305,
                                                                  //23
                                                                  color: Color(
                                                                      0xffffffff),
                                                                ),
                                                              ),
                                                              Text(
                                                                "$day",
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      "Segoe UI",
                                                                  fontWeight:
                                                                      FontWeight.w600,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.10714,
                                                                  //44
                                                                  color: Color(
                                                                      0xffffffff),
                                                                    fontFeatures: [FontFeature.tabularFigures(),]
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Spacer(),
                                                Text(
                                                  "Weeks",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.07305,
                                                    //23
                                                    color: Color(0xff070101),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.01948), //8
                                                  child: Text(
                                                    "$week",
                                                    style: TextStyle(
                                                      fontFamily: "Segoe UI",
                                                      fontWeight: FontWeight.w600,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.129055,
                                                      //44
                                                      color: Color(0xff771616),
                                                        fontFeatures: [FontFeature.tabularFigures(),]
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                  Spacer(),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.312045, // 213
                                    width: MediaQuery.of(context).size.width *
                                        0.44317, //182
                                    decoration: BoxDecoration(
                                      color: Color(0xffffE4E4E4),
                                      border: Border.all(
                                        width: 1.00,
                                        color: Color(0xffffffff),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0.00, 3.00),
                                          color:
                                              Color(0xff000000).withOpacity(0.53),
                                          blurRadius: 6,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20.00),
                                    ),

                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Ajza",
                                          style: TextStyle(
                                            fontFamily: "Segoe UI",
                                            fontWeight: FontWeight.w600,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08279,
                                            //28
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01172), //8.0
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.007305),
                                                //3.0
                                                child: Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03809,
                                                    // 26
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06331,
                                                    //26
                                                    decoration: BoxDecoration(
                                                      color: colours[1],
                                                      border: Border.all(
                                                        width: 1.00,
                                                        color: Color(0xff707070),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "1",
                                                        style: TextStyle(
                                                          fontFamily: "Segoe UI",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.036525,
                                                          //17
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[2],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "2",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[3],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "3",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[4],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "4",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[5],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "5",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.007305),
                                                child: Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03809,
                                                    // 26
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06331,
                                                    //26
                                                    decoration: BoxDecoration(
                                                      color: colours[6],
                                                      border: Border.all(
                                                        width: 1.00,
                                                        color: Color(0xff707070),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "6",
                                                        style: TextStyle(
                                                          fontFamily: "Segoe UI",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.036525,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.00586), //4.0
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.007305),
                                                child: Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03809,
                                                    // 26
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06331,
                                                    //26
                                                    decoration: BoxDecoration(
                                                      color: colours[7],
                                                      border: Border.all(
                                                        width: 1.00,
                                                        color: Color(0xff707070),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "7",
                                                        style: TextStyle(
                                                          fontFamily: "Segoe UI",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.036525,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[8],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "8",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[9],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "9",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[10],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "10",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[11],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "11",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.007305),
                                                child: Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03809,
                                                    // 26
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06331,
                                                    //26
                                                    decoration: BoxDecoration(
                                                      color: colours[12],
                                                      border: Border.all(
                                                        width: 1.00,
                                                        color: Color(0xff707070),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "12",
                                                        style: TextStyle(
                                                          fontFamily: "Segoe UI",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.036525,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.00586),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.007305),
                                                child: Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03809,
                                                    // 26
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06331,
                                                    //26
                                                    decoration: BoxDecoration(
                                                      color: colours[13],
                                                      border: Border.all(
                                                        width: 1.00,
                                                        color: Color(0xff707070),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "13",
                                                        style: TextStyle(
                                                          fontFamily: "Segoe UI",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.036525,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[14],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "14",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[15],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "15",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[16],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "16",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[17],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "17",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.007305),
                                                child: Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03809,
                                                    // 26
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06331,
                                                    //26
                                                    decoration: BoxDecoration(
                                                      color: colours[18],
                                                      border: Border.all(
                                                        width: 1.00,
                                                        color: Color(0xff707070),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "18",
                                                        style: TextStyle(
                                                          fontFamily: "Segoe UI",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.036525,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.00586),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.007305),
                                                child: Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03809,
                                                    // 26
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06331,
                                                    //26
                                                    decoration: BoxDecoration(
                                                      color: colours[19],
                                                      border: Border.all(
                                                        width: 1.00,
                                                        color: Color(0xff707070),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "19",
                                                        style: TextStyle(
                                                          fontFamily: "Segoe UI",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.036525,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[20],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "20",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[21],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "21",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[22],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "22",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[23],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "23",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.007305),
                                                child: Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03809,
                                                    // 26
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06331,
                                                    //26
                                                    decoration: BoxDecoration(
                                                      color: colours[24],
                                                      border: Border.all(
                                                        width: 1.00,
                                                        color: Color(0xff707070),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "24",
                                                        style: TextStyle(
                                                          fontFamily: "Segoe UI",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.036525,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.00586),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.007305),
                                                child: Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03809,
                                                    // 26
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06331,
                                                    //26
                                                    decoration: BoxDecoration(
                                                      color: colours[25],
                                                      border: Border.all(
                                                        width: 1.00,
                                                        color: Color(0xff707070),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "25",
                                                        style: TextStyle(
                                                          fontFamily: "Segoe UI",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.036525,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[26],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "26",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[27],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "27",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[28],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "28",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03809, // 26
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.06331, //26
                                                  decoration: BoxDecoration(
                                                    color: colours[29],
                                                    border: Border.all(
                                                      width: 1.00,
                                                      color: Color(0xff707070),
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "29",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.036525,
                                                        color: Color(0xff000000),
                                                      ),
                                                    ),
                                                  )),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.007305),
                                                child: Container(
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.03809,
                                                    // 26
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06331,
                                                    //26
                                                    decoration: BoxDecoration(
                                                      color: colours[30],
                                                      border: Border.all(
                                                        width: 1.00,
                                                        color: Color(0xff707070),
                                                      ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "30",
                                                        style: TextStyle(
                                                          fontFamily: "Segoe UI",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.036525,
                                                          color:
                                                              Color(0xff000000),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.0293,
                                  right: MediaQuery.of(context).size.width *
                                      0.036525,
                                  left: MediaQuery.of(context).size.width *
                                      0.036525), //20.0,15.0,15.0
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.312045, //213
                                    width: MediaQuery.of(context).size.width *
                                        0.44317, //182
                                    decoration: BoxDecoration(
                                      color: Color(0xffffE4E4E4),
                                      border: Border.all(
                                        width: 1.00,
                                        color: Color(0xffffffff),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0.00, 3.00),
                                          color:
                                              Color(0xff000000).withOpacity(0.53),
                                          blurRadius: 6,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20.00),
                                    ),

                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "History",
                                            style: TextStyle(
                                              fontFamily: "Segoe UI",
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08279,
                                              //28
                                              color: Colors.black,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01948,
                                            ), //8.0-8.0
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Attended",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.046265,
                                                    //19
                                                    color: Color(0xff121000),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948), //8.0
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "$maq_att",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.04102,
                                                    //28
                                                    color: Color(0xffff484000),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948), //8.0
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Quran Tamam",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.046265,
                                                    //19
                                                    color: Color(0xff121000),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "$quran_tamam",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.04102,
                                                    //28
                                                    color: Color(0xff484000),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948), //8.0-8.0
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Unattended",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.046265,
                                                    //19
                                                    color: Color(0xff121000),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948), //8.0
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "$maq_unatt",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.04102,
                                                    //28
                                                    color: Color(0xffff484000),
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return Plus_Button(int.parse(userappid));
                                                    }));
                                                  },
                                                  child: Icon(
                                                    Icons.add_circle,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.0974, //40
                                                    color: Color(
                                                        0xff484000), //Color from Database
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.312045, //213
                                    width: MediaQuery.of(context).size.width *
                                        0.44317, //182
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xff003ce7), Colors.black],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      color: Color(0xff003ce7),
                                      border: Border.all(
                                        width: 1.00,
                                        color: Color(0xffffffff),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0.00, 3.00),
                                          color:
                                              Color(0xff000000).withOpacity(0.53),
                                          blurRadius: 6,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20.00),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Global",
                                            style: TextStyle(
                                              fontFamily: "Segoe UI",
                                              fontWeight: FontWeight.w600,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08279,
                                              // 28
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948,
                                                ),
                                            // 8.0 - 8.0
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Total Users",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.056005,
                                                    //19
                                                    color: Color(0xff00ffe5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948), //8
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "$global_users",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.04102,
                                                    //28
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Total Maqarats",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.056005,
                                                    color: Color(0xff00ffe5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "$global_maqarat",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.04102,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Total Quran",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.056005,
                                                    color: Color(0xff00ffe5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01948),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "$global_qur",
                                                  style: TextStyle(
                                                    fontFamily: "Segoe UI",
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.04102,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    )),
              ),
            ],
          )),
        ],
      );}}
    );
  }
}
