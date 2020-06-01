import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_util/date_util.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mahadalzahra/homepage.dart';
import 'package:mahadalzahra/homepagebackground.dart';
import 'package:flutter/material.dart';
import 'package:mahadalzahra/list_maqarat.dart';
import 'package:mahadalzahra/profile_page_blue.dart';
import 'package:mahadalzahra/services/authentication.dart';

class NewMaqarat extends StatefulWidget {
  @override
  _NewMaqaratState createState() => _NewMaqaratState();
}
final Map<String, String> utc_times = {
  "7:00": "1:30",
  "9:00": "3:30",
  "16:00": "10:30",
  "17:00": "11:30",
  "21:00": "15:30",
  "22:00": "16:30"
};
var todate = DateTime.now().toUtc();
String today = todate.day.toString() +
    " " +
    DateUtil().month(todate.month).toString().substring(0, 3) +
    " " +
    todate.year.toString();


final fs = Firestore.instance;
final fb = FirebaseDatabase.instance.reference();

Future<QuerySnapshot> getdates() async {
  QuerySnapshot r = await fs.collection('maqarat_male').getDocuments();
  return r;
}

class Slots {
  final String time;

  const Slots(
      this.time
      );
}
List<Slots> _slotList=[
  new Slots(
      "7:00"
  ),
  new Slots(
      "9:00"
  ),
  new Slots(
      "16:00"
  ),
  new Slots(
      "17:00"
  ),
  new Slots(
      "21:00"
  ),
  new Slots(
      "22:00"
  ),
];
List L=_slotList;
List<Slots> todaylist=[];
Future<bool> _waitfordata() async {

  await Future.delayed(Duration(milliseconds: 2000), () {});

  return true;
}
confirmResult(String date,DocumentSnapshot juzdoc,String time,bool action, BuildContext context) {
  if (action) {
    print(juzdoc.documentID+" "+time);
    bool pass=false;
    for(var i=1; i<6; i++){
      if(juzdoc.data[time]['participants']['user$i']!=userappid){
        pass=true;
      }
    }
    if(pass==true){
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshcopy= await transaction.get(juzdoc.reference);
        Map fresh=freshcopy.data;
        if(fresh[time]["no_participants"]==0){
          fresh[time]['participants']['user1']=userappid;
          fresh[time]["no_participants"]=fresh[time]["no_participants"]+1;
          await transaction.update(freshcopy.reference, fresh);
          for(var k=1; k<=fresh[time]["no_participants"]; k++){
            await FirebaseDatabase.instance.reference().child('user_maqarat_booked').child(fresh[time]['participants']['user$k']).child(date).
            update(<String,dynamic>{fresh[time]['maqaratID']:{'juz':int.parse(freshcopy.documentID),'time':time,'participants':fresh[time]["no_participants"]}});};
        }
        else if(freshcopy.data[time]["no_participants"]==1){
          fresh[time]['participants']['user2']=userappid;
          fresh[time]["no_participants"]=fresh[time]["no_participants"]+1;
          await transaction.update(freshcopy.reference, fresh);//update in live maqarat
          await FirebaseDatabase.instance.reference().child('buffer_lobby').
          update(<String,dynamic>{fresh[time]['maqaratID'].toString():{'channel':fresh[time]['maqaratID'].toString(),
            'juz':int.parse(fresh['juz']), 'time': time, 'user_number':2,
            'users':fresh[time]['participants']['user1'].toString()+','+fresh[time]['participants']['user2'].toString()}});//update buffer lobby
          for(var k=1; k<=fresh[time]["no_participants"]; k++){
            await FirebaseDatabase.instance.reference().child('user_maqarat_booked').child(fresh[time]['participants']['user$k']).child(date).
            update(<String,dynamic>{fresh[time]['maqaratID']:{'juz':int.parse(freshcopy.documentID),'time':time,'participants':fresh[time]["no_participants"]}});}//update user maqarat booked
        }
        else if(freshcopy.data[time]["no_participants"]==2){
          fresh[time]['participants']['user3']=userappid;
          fresh[time]["no_participants"]=fresh[time]["no_participants"]+1;
          await transaction.update(freshcopy.reference, fresh);//update in live maqarat
          await FirebaseDatabase.instance.reference().child('buffer_lobby').
          update(<String,dynamic>{fresh[time]['maqaratID'].toString():{'channel':fresh[time]['maqaratID'].toString(),
            'juz':int.parse(fresh['juz']), 'time': time, 'user_number':3,
            'users':fresh[time]['participants']['user1'].toString()+','+fresh[time]['participants']['user2'].toString()+','+fresh[time]['participants']['user3'].toString()}});//update buffer lobby
          for(var k=1; k<=fresh[time]["no_participants"]; k++){
            await FirebaseDatabase.instance.reference().child('user_maqarat_booked').child(fresh[time]['participants']['user$k']).child(date).
            update(<String,dynamic>{fresh[time]['maqaratID']:{'juz':int.parse(freshcopy.documentID),'time':time,'participants':fresh[time]["no_participants"]}});}//update user maqarat booked
        }
        else if(freshcopy.data[time]["no_participants"]==3){
          fresh[time]['participants']['user4']=userappid;
          fresh[time]["no_participants"]=fresh[time]["no_participants"]+1;
          await transaction.update(freshcopy.reference, fresh);//update in live maqarat
          await FirebaseDatabase.instance.reference().child('buffer_lobby').
          update(<String,dynamic>{fresh[time]['maqaratID'].toString():{'channel':fresh[time]['maqaratID'].toString(),
            'juz':int.parse(fresh['juz']), 'time': time, 'user_number':4,
            'users':fresh[time]['participants']['user1'].toString()+','+fresh[time]['participants']['user2'].toString()+','+
                fresh[time]['participants']['user3'].toString()+','+fresh[time]['participants']['user4'].toString()}});//update buffer lobby
          for(var k=1; k<=fresh[time]["no_participants"]; k++){
            await FirebaseDatabase.instance.reference().child('user_maqarat_booked').child(fresh[time]['participants']['user$k']).child(date).
            update(<String,dynamic>{fresh[time]['maqaratID']:{'juz':int.parse(freshcopy.documentID),'time':time,'participants':fresh[time]["no_participants"]}});}//update user maqarat booked
        }
        else if(freshcopy.data[time]["no_participants"]==4){
          Map newver=fresh;
          newver[time]["no_participants"]=0;
          newver[time]['version']=fresh[time]['version']+1;
          newver[time]['maqaratID']=newver[time]['version']+fresh[time]['maqaratID'].toString().substring(1,);
          for(var j=1; j<6; j++){
            newver[time]['participants']['user$j']="";}
          fresh[time]['participants']['user5']=userappid;
          fresh[time]["no_participants"]=fresh[time]["no_participants"]+1;
          await transaction.update(freshcopy.reference, newver);//update in live maqarat
          await FirebaseDatabase.instance.reference().child('buffer_lobby').
          update(<String,dynamic>{fresh[time]['maqaratID'].toString():{'channel':fresh[time]['maqaratID'].toString(),
            'juz':int.parse(fresh['juz']), 'time': time, 'user_number':4,
            'users':fresh[time]['participants']['user1'].toString()+','+fresh[time]['participants']['user2'].toString()+','+
                fresh[time]['participants']['user3'].toString()+','+fresh[time]['participants']['user4'].toString()}});//update buffer lobby
          for(var k=1; k<=fresh[time]["no_participants"]; k++){
            await FirebaseDatabase.instance.reference().child('user_maqarat_booked').child(fresh[time]['participants']['user$k']).child(date).
            update(<String,dynamic>{fresh[time]['maqaratID']:{'juz':int.parse(freshcopy.documentID),'time':time,'participants':fresh[time]["no_participants"]}});}//update user maqarat booked

          await fs.collection('maqarat_male').document(date).collection('flag maqarat').document(fresh[time]['maqaratID'].toString()).
          setData(<String,dynamic>{'juz':freshcopy.documentID, 'maqaratID':fresh[time]['maqaratID'], 'no_participants':fresh[time]["no_participants"],
            'participants':newver[time]['participants'],'status':"lobby full",'time':time});
        }
      });}

    //CODE FROMDATABASE
    //CircularProgressIndicator();
    _waitfordata().then((value) {
      if(value){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
        );
      }
    });

  } else {
    Navigator.pop(context);
  }
}


class _NewMaqaratState extends State<NewMaqarat> {
  var r;
  List<String> _dates = [];
  String _currentItemSelected;
  var _ajzaeven = [
    'JUZ  ',
    'Juz 2',
    'Juz 4',
    'Juz 6',
    'Juz 8',
    'Juz 10',
    'Juz 12',
    'Juz 14',
    'Juz 16',
    'Juz 18',
    'Juz 20',
    'Juz 22',
    'Juz 24',
    'Juz 26',
    'Juz 28',
    'Juz 30',
  ];

  var _ajzaodd = [
    'JUZ  ',
    'Juz 1',
    'Juz 3',
    'Juz 5',
    'Juz 7',
    'Juz 9',
    'Juz 11',
    'Juz 13',
    'Juz 15',
    'Juz 17',
    'Juz 19',
    'Juz 21',
    'Juz 23',
    'Juz 25',
    'Juz 27',
    'Juz 29',
  ];

  String selectedJuz = 'JUZ  ';
  String selectedTime;

  int selectedIndex;
  bool i = false;
  bool flag = false;

  bool date_check = false;
  bool juz_check = false;
  bool drop_juz = false;
  bool juz_flag = false;
  Future fut;
  final Map datetochance = {};
  final Map dtod = {};
  int mod_check;
  int test = 0;
  int maqarat_count = 2; //FROM DATABASE

  @override
  Future<void> initState() {
    // TODO: implement initState
    super.initState();

    for(var i in utc_times.values){
      var n=DateTime.now().toUtc();
      List l=i.split(':');
      var comp=DateTime.utc(1,1,1,int.parse(l[0]),int.parse(l[1])).difference(DateTime.utc(1,1,1,n.hour,n.minute)).inSeconds;
      if(comp>600){
        print('yes');
        todaylist.add(new Slots(i));
      }

      print(todaylist);
      print('*********');
    }

    r = getdates().then((value) {
      populate(value.documents);
    });
  }

  void populate(List<DocumentSnapshot> documents) {
    /* var date1=DateTime.parse(documents[0].data['date'].toDate().toString());
    _currentItemSelected=date1.day.toString()+" "+DateUtil().month(date1.month).toString().substring(0,3)+" "+date1.year.toString();*/
    for (var i in documents) {
      print(i.documentID);
      var date = DateTime.parse(i.data['date'].toDate().toString());
      String temp = date.day.toString() +
          " " +
          DateUtil().month(date.month).toString().substring(0, 3) +
          " " +
          date.year.toString();
      _dates.add(temp);
      datetochance[temp] = i.data['chance'];
      dtod[temp] = i.documentID;
    }
  }
  Future getmaqcount(String date,String curdate) async{
    DataSnapshot maqcount=(await fb.child('user_maqarat_booked').child(userappid).child(date).once()).value;
    print(maqcount.value);
    return maqcount;
  }
/*void getslots(Map data){
    for(var i=0; i<_slotList.length; i++){
      String time=_slotList[i].time;
      _slotList[i].participants=data[time]['no_participants'].toString()+"/5";
    }
}*/
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: r,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            /* List<DocumentSnapshot> document=snapshot.data.documents;
          populate(document);*/
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
                          height:
                          MediaQuery.of(context).size.height * 0.007325, //5.0
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
                                                0.007325), //20.0, 5.0
                                        child: Text(
                                          "Join a Maqarat",
                                          style: TextStyle(
                                            fontFamily: "Segoe UI",
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.0586,
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
                                            top:
                                            MediaQuery.of(context).size.height *
                                                0.007325), //5.0
                                        child: Container(
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.12013, // 82
                                          width: MediaQuery.of(context).size.width *
                                              0.90095, // 370
                                          decoration: BoxDecoration(
                                            color: Color(0xffffffff),
                                            border: Border.all(
                                              width: 0.25,
                                              color: Color(0xff000000),
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(20.00),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.0487,
                                                    top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.00586), //20, 4
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Select Date",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontSize:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                            0.033695, //23
                                                        color: Color(0xff000000),
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
                                                        0.1461,
                                                    right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.0487), //60, 20
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.today,
                                                      size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.0586, //40
                                                      color: Color(
                                                          0xff003CE7), //Color from Database
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.06446, // 44
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.440735, //181
                                                      decoration: BoxDecoration(
                                                        color: Color(0xffffffff),
                                                        border: Border.all(
                                                          width: 1.00,
                                                          color: Color(0xff707070),
                                                        ),
                                                      ),

                                                      //dropdown
                                                      child: Center(
                                                        child:
                                                        DropdownButton<String>(
                                                          items: _dates.map((String
                                                          dropDownStringItem) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value:
                                                              dropDownStringItem,
                                                              child: Text(
                                                                dropDownStringItem,
                                                                style: TextStyle(
                                                                    fontSize: MediaQuery.of(
                                                                        context)
                                                                        .size
                                                                        .height *
                                                                        0.027835,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged: (String
                                                          newValueSelected) {
                                                            setState(() {
                                                              this._currentItemSelected =
                                                                  newValueSelected;
                                                              flag = false;
                                                              i = false;
                                                              date_check = true;
                                                              juz_flag = true;
                                                              //
                                                              mod_check = int.parse(
                                                                  _currentItemSelected
                                                                      .substring(
                                                                      0, 2));
                                                              selectedJuz = 'JUZ  ';
                                                              if (datetochance[
                                                              _currentItemSelected
                                                                  .toString()] ==
                                                                  "even") {
                                                                drop_juz = false;
                                                              } else {
                                                                drop_juz = true;
                                                              }
                                                            });
                                                          },
                                                          value:
                                                          _currentItemSelected,
                                                          isExpanded: false,
                                                          hint: Text(
                                                            "Date",
                                                            style: TextStyle(
                                                                fontSize: MediaQuery.of(
                                                                    context)
                                                                    .size
                                                                    .height *
                                                                    0.027835,
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                letterSpacing: 2.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top:
                                            MediaQuery.of(context).size.height *
                                                0.01172), //8.0
                                        child: Container(
                                          height:
                                          MediaQuery.of(context).size.height *
                                              0.12013, //82
                                          width: MediaQuery.of(context).size.width *
                                              0.90095, //370
                                          decoration: BoxDecoration(
                                            color: Color(0xffffffff),
                                            border: Border.all(
                                              width: 0.25,
                                              color: Color(0xff000000),
                                            ),
                                            borderRadius:
                                            BorderRadius.circular(20.00),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.0487,
                                                    top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.00586), //20, 4
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Select Juz",
                                                      style: TextStyle(
                                                        fontFamily: "Segoe UI",
                                                        fontSize:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                            0.033695, //23
                                                        color: Color(0xff000000),
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
                                                        0.1461,
                                                    right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.0487), //60, 20
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.import_contacts,
                                                      size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.0586,
                                                      color: Color(
                                                          0xff003CE7), //Color from Database
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.06446, // 44
                                                      width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                          0.440735, //181
                                                      decoration: BoxDecoration(
                                                        color: Color(0xffffffff),
                                                        border: Border.all(
                                                          width: 1.00,
                                                          color: Color(0xff707070),
                                                        ),
                                                      ),

                                                      child: drop_juz
                                                          ? Visibility(
                                                        child: Center(
                                                          child:
                                                          DropdownButton<
                                                              String>(
                                                            items: _ajzaodd
                                                                .map((String
                                                            dropDownStringItem) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                dropDownStringItem,
                                                                child: Text(
                                                                  dropDownStringItem,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      MediaQuery.of(context).size.height *
                                                                          0.027835,
                                                                      fontWeight:
                                                                      FontWeight.w600),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged: (String
                                                            newValueSelected) {
                                                              setState(() {
                                                                this.selectedJuz =
                                                                    newValueSelected;
                                                                flag = false;
                                                                i = false;
                                                                juz_check =
                                                                true;
                                                              });
                                                            },
                                                            value:
                                                            selectedJuz,
                                                            isExpanded: false,
                                                            hint: Text(
                                                              "Juz",
                                                              style: TextStyle(
                                                                  fontSize: MediaQuery.of(context)
                                                                      .size
                                                                      .height *
                                                                      0.027835,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  letterSpacing:
                                                                  2.0),
                                                            ),
                                                          ),
                                                        ),
                                                        maintainState: true,
                                                        maintainSize: true,
                                                        maintainAnimation:
                                                        true,
                                                        visible: juz_flag,
                                                      )
                                                          : Visibility(
                                                        child: Center(
                                                          child:
                                                          DropdownButton<
                                                              String>(
                                                            items: _ajzaeven
                                                                .map((String
                                                            dropDownStringItem) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                dropDownStringItem,
                                                                child: Text(
                                                                  dropDownStringItem,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      MediaQuery.of(context).size.height *
                                                                          0.027835,
                                                                      fontWeight:
                                                                      FontWeight.w600),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            onChanged: (String
                                                            newValueSelected) {
                                                              setState(() {
                                                                this.selectedJuz =
                                                                    newValueSelected;
                                                                flag = false;
                                                                i = false;
                                                                juz_check =
                                                                true;
                                                              });
                                                            },
                                                            value:
                                                            selectedJuz,
                                                            isExpanded: false,
                                                            hint: Text(
                                                              "Juz",
                                                              style: TextStyle(
                                                                  fontSize: MediaQuery.of(context)
                                                                      .size
                                                                      .height *
                                                                      0.027835,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  letterSpacing:
                                                                  2.0),
                                                            ),
                                                          ),
                                                        ),
                                                        maintainState: true,
                                                        maintainSize: true,
                                                        maintainAnimation:
                                                        true,
                                                        visible: juz_flag,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        //from here
                                        padding: EdgeInsets.only(
                                            top:
                                            MediaQuery.of(context).size.height *
                                                0.01172,
                                            right:
                                            MediaQuery.of(context).size.width *
                                                0.0487,
                                            left:
                                            MediaQuery.of(context).size.width *
                                                0.0487), //8 , 20, 20
                                        child: Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {


                                                setState(() {
                                                  print("blue_pressed");
                                                  /*if(_currentItemSelected==today){
                                                  _slotList=[];
                                                for(var i in utc_times.values){
                                                  var n=DateTime.now().toUtc();
                                                  List l=i.split(':');
                                                  var comp=DateTime.utc(1,1,1,int.parse(l[0]),int.parse(l[1])).difference(DateTime.utc(1,1,1,n.hour,n.minute)).inSeconds;
                                                  if(comp>600){
                                                    _slotList.add(new Slots(i));
                                                  }

                                                }
                                                }
                                                else{
                                                  _slotList=[
                                                    new Slots(
                                                        "7:00"
                                                    ),
                                                    new Slots(
                                                        "9:00"
                                                    ),
                                                    new Slots(
                                                        "16:00"
                                                    ),
                                                    new Slots(
                                                        "17:00"
                                                    ),
                                                    new Slots(
                                                        "21:00"
                                                    ),
                                                    new Slots(
                                                        "22:00"
                                                    ),
                                                  ];
                                                }*/
                                                  fut = getmaqcount(dtod[_currentItemSelected], _currentItemSelected);

                                                  if (date_check &&
                                                      juz_check &&
                                                      selectedJuz != 'JUZ  ') {
                                                    flag = true;
                                                    selectedIndex = -1;
                                                    i = false;
                                                  }
                                                });


                                              },
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.065925, // 45
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.280025, // 115
                                                decoration: BoxDecoration(
                                                  color: date_check &&
                                                      juz_check &&
                                                      selectedJuz != 'JUZ  '
                                                      ? Color(0xff003ce7)
                                                      : Colors.white,
                                                  border: Border.all(
                                                    width: 1.00,
                                                    color: date_check &&
                                                        juz_check &&
                                                        selectedJuz != 'JUZ  '
                                                        ? Color(0xff003ce7)
                                                        : Colors.white,
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(1.00, 1.00),
                                                      color: Color(0xff000000)
                                                          .withOpacity(0.53),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                  BorderRadius.circular(30.00),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Icon(
                                                    Icons.arrow_forward,
                                                    size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.0586,
                                                    color: date_check &&
                                                        juz_check &&
                                                        selectedJuz != 'JUZ  '
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Visibility(
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                    0.065925, //45
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.508915, //209
                                                decoration: BoxDecoration(
                                                  color: Color(0xffffffff),
                                                  border: Border.all(
                                                    width: 0.25,
                                                    color: Color(0xff707070),
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(10.00),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    maqarat_count.toString() +
                                                        " Maqarat Scheduled",
                                                    //MAQARAT COUNT
                                                    style: TextStyle(
                                                      fontFamily: "Segoe UI",
                                                      fontSize:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                          0.02637, //18
                                                      color: Color(0xff000000)
                                                          .withOpacity(0.72),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              maintainState: true,
                                              maintainSize: true,
                                              maintainAnimation: true,
                                              visible: flag,
                                            ),
                                          ],
                                        ),
                                      ),
                                      //if (maqarat_count < 2)
                                      //MaqaratList(dtod, _currentItemSelected, selectedJuz, i, flag, selectedTime, selectedIndex)
                                      Column(
                                          children: <Widget>[ FutureBuilder(
                                              future: fut,
                                              builder: (context, maqsnapshot){
                                                if (maqsnapshot.connectionState == ConnectionState.waiting) {
                                                  return Container(
                                                    child: Center(
                                                      child: CircularProgressIndicator(),
                                                    ),
                                                  );
                                                }
                                                else if(maqsnapshot.connectionState == ConnectionState.done){
                                                  print(maqsnapshot.data);
                                                  if(maqsnapshot.data != null){
                                                    maqarat_count=Map<String, dynamic>.from(maqsnapshot.data).length;}
                                                  else{
                                                    maqarat_count=0;
                                                  }
                                                  if (maqarat_count < 2){
                                                    return StreamBuilder(
                                                        stream: fs
                                                            .collection('maqarat_male')
                                                            .document(dtod[_currentItemSelected])
                                                            .collection('live maqarat')
                                                            .where("juz", isEqualTo: selectedJuz.substring(4,)). snapshots(),
                                                        builder: (context, juzsnapshot) {
                                                          if (juzsnapshot.connectionState == ConnectionState.waiting) {
                                                            return Container(
                                                              child: Center(
                                                                child:
                                                                CircularProgressIndicator(),
                                                              ),
                                                            );
                                                          } else {
                                                            print(selectedJuz);
                                                            print(juzsnapshot.data.documents);
                                                            print((dtod[_currentItemSelected]));
                                                            //DocumentSnapshot firestoreData = juzsnapshot.data;
                                                            //print(firestoreData.data);
                                                            //getslots(firestoreData.data);
                                                            return Column(
                                                              children: <Widget>[
                                                                Padding(
                                                                  //from here2
                                                                  padding: EdgeInsets.only(
                                                                      top:
                                                                      MediaQuery.of(context)
                                                                          .size
                                                                          .height *
                                                                          0.01172), //8.0
                                                                  child: Visibility(
                                                                    child: Container(
                                                                      height:
                                                                      MediaQuery.of(context)
                                                                          .size
                                                                          .height *
                                                                          0.24905, //170
                                                                      width:
                                                                      MediaQuery.of(context)
                                                                          .size
                                                                          .width *
                                                                          0.90095, //370
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                        Color(0xffffffff),
                                                                        border: Border.all(
                                                                          width: 0.25,
                                                                          color:
                                                                          Color(0xff000000),
                                                                        ),
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            20.00),
                                                                      ),

                                                                      child: ListView.builder(
                                                                        itemCount:
                                                                        6,
                                                                        itemBuilder:
                                                                            (context, index) {
                                                                          return GestureDetector(
                                                                            onTap: () {

                                                                              _currentItemSelected!=today ?  L=_slotList :  L=todaylist;
                                                                              setState(() {
                                                                                if (selectedIndex ==
                                                                                    index) {
                                                                                  selectedIndex =
                                                                                  -1;
                                                                                  i = false;
                                                                                } else {
                                                                                  selectedIndex =
                                                                                      index;
                                                                                  i = true;
                                                                                  selectedTime =
                                                                                      L[
                                                                                      index]
                                                                                          .time
                                                                                          .toString();
                                                                                }

                                                                              });
                                                                            },
                                                                            /*onDoubleTap: (){
                                                           setState(() {
                                                             selectedIndex=-1;
                                                           });
                                                         },*/
                                                                            child: Row(
                                                                              children: <
                                                                                  Widget>[
                                                                                Spacer(),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(
                                                                                      top: MediaQuery.of(context)
                                                                                          .size
                                                                                          .height *
                                                                                          0.01172),
                                                                                  //8.0
                                                                                  child: Container(
                                                                                      height: MediaQuery.of(context).size.height * 0.065925,
                                                                                      //45
                                                                                      width: MediaQuery.of(context).size.width * 0.74511,
                                                                                      //306
                                                                                      decoration: BoxDecoration(
                                                                                        color: index ==
                                                                                            selectedIndex
                                                                                            ? Color(0xff00ff00)
                                                                                            : Color(0xffffffff),
                                                                                        border:
                                                                                        Border.all(
                                                                                          width:
                                                                                          1.00,
                                                                                          color:
                                                                                          Color(0xff707070),
                                                                                        ),
                                                                                        borderRadius:
                                                                                        BorderRadius.circular(10.00),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: EdgeInsets.only(
                                                                                            left: MediaQuery.of(context).size.width *
                                                                                                0.01948,
                                                                                            right:
                                                                                            MediaQuery.of(context).size.width * 0.01948),
                                                                                        //8.0 , 8
                                                                                        child:
                                                                                        Row(
                                                                                          children: <
                                                                                              Widget>[
                                                                                            Text(
                                                                                              L[index].time + " IST",
                                                                                              style: TextStyle(
                                                                                                fontFamily: "Segoe UI",
                                                                                                fontWeight: FontWeight.w700,
                                                                                                fontSize: MediaQuery.of(context).size.height * 0.033695,
                                                                                                //23
                                                                                                color: Color(0xff000000),
                                                                                              ),
                                                                                            ),
                                                                                            Spacer(),
                                                                                            Text(
                                                                                              juzsnapshot.data.documents[0][_slotList[index].time.toString()]["no_participants"].toString()+"/5",
                                                                                              style: TextStyle(
                                                                                                fontFamily: "Segoe UI",
                                                                                                fontSize: MediaQuery.of(context).size.height * 0.02637,
                                                                                                //18
                                                                                                color: Color(0xff000000),
                                                                                              ),
                                                                                            ),
                                                                                            Spacer(),
                                                                                            Icon(
                                                                                              index == selectedIndex ? Icons.check_box : Icons.check_box_outline_blank,
                                                                                              size: MediaQuery.of(context).size.height * 0.04395, //30
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      )),
                                                                                ),
                                                                                Spacer(),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    maintainSize: true,
                                                                    maintainState: true,
                                                                    maintainAnimation: true,
                                                                    visible: flag,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      top:
                                                                      MediaQuery.of(context)
                                                                          .size
                                                                          .height *
                                                                          0.01172,
                                                                      right:
                                                                      MediaQuery.of(context)
                                                                          .size
                                                                          .width *
                                                                          0.0487), //8 , 20
                                                                  child: Align(
                                                                    alignment:
                                                                    Alignment.centerRight,
                                                                    child: Visibility(
                                                                      child: Material(
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            if (i == true) {
                                                                              showDialog(
                                                                                  context:
                                                                                  context,
                                                                                  builder:
                                                                                      (BuildContext
                                                                                  context) {
                                                                                    return AlertDialog(
                                                                                      title:
                                                                                      Text(
                                                                                        "Confirm",
                                                                                      ),
                                                                                      content: Text("Date: " +
                                                                                          _currentItemSelected +
                                                                                          "\nTime: " +
                                                                                          selectedTime +
                                                                                          " IST\nJuz: " +
                                                                                          selectedJuz +
                                                                                          "\n\nOnce confirmed Maqarat cannot be changed nor deleted\nAttendance is mandatory\n"
                                                                                              "Wait for data sync after confirming"),
                                                                                      actions: <
                                                                                          Widget>[
                                                                                        FlatButton(
                                                                                          child:
                                                                                          Text(
                                                                                            "Cancel",
                                                                                          ),
                                                                                          onPressed: () => confirmResult(dtod[_currentItemSelected],juzsnapshot.data.documents[0],
                                                                                              selectedTime,
                                                                                              false,
                                                                                              context),
                                                                                        ),
                                                                                        FlatButton(
                                                                                            child:
                                                                                            Text("Confirm"),
                                                                                            onPressed: () {

                                                                                              confirmResult(dtod[_currentItemSelected],juzsnapshot.data.documents[0],
                                                                                                  selectedTime,
                                                                                                  true,
                                                                                                  context);
                                                                                            }
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  });
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                              height: MediaQuery.of(
                                                                                  context)
                                                                                  .size
                                                                                  .height *
                                                                                  0.065925,
                                                                              //45
                                                                              width: MediaQuery.of(
                                                                                  context)
                                                                                  .size
                                                                                  .width *
                                                                                  0.2435,
                                                                              //100
                                                                              decoration:
                                                                              BoxDecoration(
                                                                                color: i
                                                                                    ? Color(
                                                                                    0xff00ff00)
                                                                                    : Color(
                                                                                    0xffffffff),
                                                                                border:
                                                                                Border.all(
                                                                                  width: 1.00,
                                                                                  color: i
                                                                                      ? Color(
                                                                                      0xff00ff00)
                                                                                      : Color(
                                                                                      0xffffffff),
                                                                                ),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    offset: Offset(
                                                                                        1.00,
                                                                                        1.00),
                                                                                    color: Color(
                                                                                        0xff000000)
                                                                                        .withOpacity(
                                                                                        0.53),
                                                                                    blurRadius:
                                                                                    6,
                                                                                  ),
                                                                                ],
                                                                                borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                    30.00),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Confirm",
                                                                                  style:
                                                                                  TextStyle(
                                                                                    fontFamily:
                                                                                    "Segoe UI",
                                                                                    fontWeight:
                                                                                    FontWeight
                                                                                        .w600,
                                                                                    fontSize: MediaQuery.of(context)
                                                                                        .size
                                                                                        .height *
                                                                                        0.027835,
                                                                                    //19
                                                                                    color: Color(
                                                                                        0xff000000),
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                      maintainSize: true,
                                                                      maintainAnimation: true,
                                                                      maintainState: true,
                                                                      visible: flag,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          }
                                                        });
                                                  }
                                                  else
                                                    Visibility(
                                                      child: Container(
                                                        height:
                                                        MediaQuery.of(context).size.height *
                                                            0.3223, //220
                                                        width:
                                                        MediaQuery.of(context).size.width,
                                                        child: Center(
                                                            child: Column(
                                                              children: <Widget>[
                                                                SizedBox(
                                                                  height: MediaQuery.of(context)
                                                                      .size
                                                                      .height *
                                                                      0.1172,
                                                                ), //80.0
                                                                Text('Maximum Limit Reached',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                            0.027835,
                                                                        fontWeight:
                                                                        FontWeight.w600)),
                                                                Text(
                                                                    'Cannot book a new Maqarat for the same date',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                            0.021975,
                                                                        fontWeight:
                                                                        FontWeight.w600)),
                                                              ],
                                                            )),
                                                      ),
                                                      maintainSize: true,
                                                      maintainState: true,
                                                      maintainAnimation: true,
                                                      visible: flag,
                                                    );
                                                }
                                                return Container(
                                                  child: Center(
                                                    child:
                                                    Text(" "),
                                                  ),
                                                );}
                                          ),
                                          ]),
                                      //else
                                      /* Visibility(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3223, //220
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Center(
                                            child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1172,
                                            ), //80.0
                                            Text('Maximum Limit Reached',
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.027835,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(
                                                'Cannot book a new Maqarat for the same date',
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.021975,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        )),
                                      ),
                                      maintainSize: true,
                                      maintainState: true,
                                      maintainAnimation: true,
                                      visible: flag,
                                    ),*/
                                    ],
                                  )
                                ],
                              )),
                        ),
                      ],
                    )),
              ],
            );
          }
        });
  }
}
