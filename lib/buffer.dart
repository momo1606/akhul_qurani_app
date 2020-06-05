import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:mahadalzahra/homepage.dart';
import 'package:mahadalzahra/homepagebackground.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahadalzahra/maqarat_display.dart';
import 'package:mahadalzahra/services/authentication.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/async.dart';
import 'package:mahadalzahra/src/pages/call.dart';

class Buffer extends StatefulWidget {
  final Maqarat maqarat;
  final String channel;
  Buffer(this.maqarat,this.channel);
  @override
  _BufferState createState() => _BufferState();
}
//var notesReference = FirebaseDatabase.instance.reference().child('buffer_lobby').child(channel);
/*class Maqarat {
  final String time;
  final int juz;
  final String participants;
  final bool isTime;
  final String channel;

  const Maqarat(
      this.time,
      this.juz,
      this.participants,
      this.isTime,
      this.channel,
      );
}*/

class App_Id {
  final String appid;
   bool isadmin;
  final bool bool1;
  final bool bool2;
  final String time;
  final int juz;
  App_Id(
    this.appid,
    this.isadmin,
      this.bool1,
      this.bool2,
      this.time,
      this.juz,
  );
}

final List<App_Id> _idList = [];
var x = _idList.length;

class Safah_fiveuser {
  final String safahats;

  Safah_fiveuser(
    this.safahats,
  );
}

final List<Safah_fiveuser> _safListFive = [
  new Safah_fiveuser("1,2, 11,12"),
  new Safah_fiveuser("7,8, 17,18"),
  new Safah_fiveuser("3,4, 13,14"),
  new Safah_fiveuser("9,10, 19,20"),
  new Safah_fiveuser("5,6, 15,16"),
];

class Safah_fouruser {
  final String safahats;

  Safah_fouruser(
    this.safahats,
  );
}

final List<Safah_fouruser> _safListFour = [
  new Safah_fouruser("1,2, 9-11"),
  new Safah_fouruser("7,8, 15-17"),
  new Safah_fouruser("3,4, 12-14"),
  new Safah_fouruser("5,6, 18-20"),
];

class Safah_threeuser {
  final String safahats;

  Safah_threeuser(
    this.safahats,
  );
}

final List<Safah_threeuser> _safListThree = [
  new Safah_threeuser("1-4, 18-20"),
  new Safah_threeuser("5-8, 13-14"),
  new Safah_threeuser("9-12, 15-17"),
];

class Safah_twouser {
  final String safahats;

  Safah_twouser(
    this.safahats,
  );
}

final List<Safah_twouser> _safListTwo = [
  new Safah_twouser("1-5, 11-15"),
  new Safah_twouser("6-10, 16-20"),
];

class _BufferState extends State<Buffer> {


  List<App_Id> _idList;
  StreamSubscription<Event> _onNoteAddedSubscription;
  StreamSubscription<Event> _onNoteChangedSubscription;
  String Safah(int users, index) {
    if (users == 1) {
      return "";
    }
    if (users == 2) {
      return _safListTwo[index].safahats;
    } else if (users == 3) {
      //return '3,4';
      return _safListThree[index].safahats;
    } else if (users == 4) {
      //return '2,3';
      return _safListFour[index].safahats;
    } else if (users == 5) {
      // return '2,2';
      return _safListFive[index].safahats;
    }
  }
  var sub;
  Timer _timer;

  confirmResult(bool action, BuildContext context) {
    if (action) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }
  var notesReference;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onNoteAddedSubscription.cancel();
    _onNoteChangedSubscription.cancel();
    if(_idList.length>1){
    sub.cancel();}
    _timer.cancel();

  }
  @override
  void initState() {
    notesReference = FirebaseDatabase.instance.reference().child('buffer_lobby').child(widget.maqarat.channel);
    super.initState();
    _idList=new List();
    _onNoteAddedSubscription = notesReference.onChildAdded.listen(_onNoteAdded);
    _onNoteChangedSubscription = notesReference.onChildChanged.listen(_onNoteUpdated);
    if(mounted){
    test();}
  }

  bool flag = false;
int temp=0;

  Future test() async {
    _timer=Timer.periodic(Duration(seconds: 1), (timer) //COUNTDOWN TILL LOCK  -  DATABASE
        {
          List temp=utc_times[widget.maqarat.time.toString()].split(':');
          print(widget.maqarat.time);
          print('timer on');
          DateTime now=DateTime.now().toUtc();
          if(DateTime.utc(1,1,1,int.parse(temp[0]),int.parse(temp[1])).difference(DateTime.utc(1,1,1,now.hour,now.minute,now.second)).inSeconds<0){
            timer.cancel();
          if(mounted){
      setState(() {
        flag = true;
        _idList[0].isadmin=true;
        if (_idList.length == 1) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Maqarat Cancelled",
                  ),
                  content: Text(
                      "Due to no participants, Maqarat is cancelled.\nPlease join a Maqarat with participants"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: (){
                        update();
                        confirmResult(true, context);},
                    ),
                  ],
                );
              });
        } else {
          startTimer();
        }
      });}}

    });
  }

  int _start = 30;
  int _current = 30;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

     sub = countDownTimer.listen(null);
     countDownTimer.elapsed;
    sub.onData((duration) {
      if(mounted){
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });}
    });

    sub.onDone(() async {
      print("Done"); //CALL START ---
      sub.cancel();
      await _handleCameraAndMic();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CallPage(channelName: widget.maqarat.channel, users: _idList)));
    });
  }
int position=0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Stack(
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
                      right: MediaQuery.of(context).size.width * 0.02435), //10.0
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Container(
                        height:
                            MediaQuery.of(context).size.height * 0.0879, //60.0
                        width:
                            MediaQuery.of(context).size.width * 0.12175, //50.00,
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
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.0487,
                                      vertical: MediaQuery.of(context).size.height *
                                          0.007), //20.0 - 5.0
                                  child: Text(
                                    "Lobby",
                                    style: TextStyle(
                                      fontFamily: "Segoe UI",
                                      fontWeight: FontWeight.w600,
                                      fontSize: MediaQuery.of(context).size.width *
                                           0.0974,
                                      //40.0
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.height *
                                          0.01465), //10.0
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.0586, //40
                                    width: MediaQuery.of(context).size.width *
                                        0.2922, //120
                                    decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      border: Border.all(
                                        width: 1.00,
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(15.00),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Juz '+  widget.maqarat.juz.toString(),
                                        style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                              MediaQuery.of(context).size.height *
                                                  0.033695,
                                          //23.0
                                          color: Color(0xff000000),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02435,
                                      right: MediaQuery.of(context).size.width *
                                          0.02435,
                                      top: MediaQuery.of(context).size.height *
                                          0.01465), //14 - 10 - 10
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Participants',
                                        style: TextStyle(
                                            fontSize:
                                                MediaQuery.of(context).size.height *
                                                    0.027835),
                                      ), //19
                                      Spacer(),
                                      Text(
                                        'Safahaat',
                                        style: TextStyle(
                                            fontSize:
                                                MediaQuery.of(context).size.height *
                                                    0.027835),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.6153, //was 275
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02435,
                                      right: MediaQuery.of(context).size.width *
                                          0.02435),
                                  decoration: BoxDecoration(),
                                  child: ListView.builder(
                                    itemBuilder: (ctx, index) {
                                      return Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1195,
                                                //80
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Colors.black,
                                                      width: 1),
                                                ),
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  //mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.021975,left:MediaQuery.of(context).size.width*0.00487), //15,2
                                                      child: Row(

                                                        children: <Widget>[
                                                          //10
                                                          Text(
                                                            'AppId :',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.w400,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.060875, //20
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                7.0,
                                                          ), //7
                                                          Text(
                                                            _idList[index]
                                                                .appid
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.060875, //23
                                                              color:
                                                                  Color(0xFF003CE7),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          _idList[index].isadmin &&
                                                                  flag
                                                              ? Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.036625,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Color(
                                                                            0xff008000),
                                                                        width: 1),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                3),
                                                                  ),
                                                                  child: Center(
                                                                      child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(2.0),
                                                                    child: Text(
                                                                      'Admin',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
                                                                          color: Color(
                                                                              0xff008000),
                                                                          letterSpacing:
                                                                              2.0),
                                                                    ),
                                                                  )))
                                                              : Text(""),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          Container(
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.1195, //80
                                            width:
                                                MediaQuery.of(context).size.width *
                                                    0.2435, //100
                                            decoration: BoxDecoration(
                                              color: Color(0xFF003CE7),
                                              //border: Border.all(color: Colors.black,width: 1),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 20.0), //25
                                                  child: flag
                                                      ? Text(
                                                          Safah(_idList.length, index),
                                                          //pass number of users , users == (num of app_id)...else error !
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.060875, //20
                                                          ),
                                                        )
                                                      : Text("")),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    itemCount: _idList.length,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.00612), //
                                  child: Text('Countdown for maqarat will start at '+ widget.maqarat.time +'IST\nDo not exit the lobby',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.036525, //20

                                      )),
                                ),
                                Text("$_current",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context).size.height *
                                          0.0293,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  void _onNoteAdded(Event event) {
    setState(() {
      _idList.add(new App_Id(event.snapshot.key.toString(),event.snapshot.value['isadmin'],event.snapshot.value['bool1'],event.snapshot.value['bool2'],event.snapshot.value['time'],event.snapshot.value['juz']));
      if(event.snapshot.key.toString()==userappid){
        position=_idList.length-1;
      }
    });
  }
  void _onNoteUpdated(Event event) {
    var oldNoteValue = _idList.singleWhere((note) => note.appid == event.snapshot.key.toString());
    setState(() {
      _idList[_idList.indexOf(oldNoteValue)] = new App_Id(event.snapshot.key.toString(),event.snapshot.value['isadmin'],event.snapshot.value['bool1'],event.snapshot.value['bool2'],event.snapshot.value['time'],event.snapshot.value['juz']);
    });

  }
  Future<bool> _deleteNote(BuildContext context, String id, int position) async {
    await FirebaseDatabase.instance.reference().child('buffer_lobby').child(widget.maqarat.channel).child(id).remove().then((_) {
      setState(() {
        _idList.removeAt(position);
      });

    });
    return Future.value(true);
  }
  Future<bool> _onBackPressed() async{
  _deleteNote(context, userappid, position);
  return true;

  }
  Future update() async{

    DataSnapshot nem= await FirebaseDatabase.instance.reference().child('non empty maqarat').child(channel).once();
    List<String> inuser=[];
    for(var t in _idList){
      inuser.add(t.appid);
    }
    List tusers=nem.value.toString().split(",");
    List<String> notatd=[];
    for(var p in tusers){
      if(inuser.contains(p)==false){
        notatd.add(p);
      }
    }
    for(var w in notatd){
      DataSnapshot incun= await FirebaseDatabase.instance.reference().child('user_state').child(w).once();
      await FirebaseDatabase.instance.reference().child('user_state').child(w).update({"unattended_maqarat":incun.value["unattended_maqarat"]+','+channel});
    }
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }


}
