import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:mahadalzahra/buffer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mahadalzahra/services/authentication.dart';
String channel;
class MaqaratPage extends StatefulWidget {
  Map info;
  String dkey;


  MaqaratPage(this.info, this.dkey);

  @override
  _MaqaratPageState createState() => _MaqaratPageState();
}
final Map<String, String> utc_times = {
  "7:00": "1:30",
  "9:00": "3:30",
  "16:00": "10:30",
  "17:00": "11:30",
  "21:00": "15:30",
  "22:00": "16:30"
};
Future<bool> _waitfordata() async {

  await Future.delayed(Duration(milliseconds: 500), () {});

  return true;
}

createbuffer(BuildContext context,Maqarat maqarat)async{
  final dataRef = FirebaseDatabase.instance.reference().child('buffer_lobby');
  bool admin;
  var now=DateTime.now();
  var formatter = new DateFormat('dd-MM-yyyy');
  String formatted = formatter.format(now);
 var trans= dataRef.runTransaction((MutableData transaction) async{
   DataSnapshot r= await dataRef.child(maqarat.channel).once();
   print(r.value);
   if(r.value==null){
     await FirebaseDatabase.instance.reference().child('buffer_lobby').
     update(<String,dynamic>{maqarat.channel.toString():{userappid:{'channel':maqarat.channel,'juz':maqarat.juz, 'time': maqarat.time, 'isadmin':true, 'bool1': false, 'bool2':true}}});
     admin=true;
   }
   else{
     await FirebaseDatabase.instance.reference().child('buffer_lobby').child(maqarat.channel).
     update(<String,dynamic>{userappid:{'channel':maqarat.channel,'juz':maqarat.juz, 'time': maqarat.time, 'isadmin':false, 'bool1': false, 'bool2':false}});
     admin=false;
   }
   await Firestore.instance.collection('maqarat_male').document(formatted).collection('flag maqarat').document(maqarat.channel).
   setData(<String,dynamic>{'juz':maqarat.juz.toString(), 'maqaratID':maqarat.channel, 'no_participants': 0,
     'participants':{'user1':"", 'user2':"",'user3':"", 'user4':"", 'user5':""},'status':"maqarat completed",'time':maqarat.time});
    return transaction;
  });
  await trans;


 _waitfordata().then((value) {
    if(value){
      channel=maqarat.channel;
      /*Navigator.push(context,
          MaterialPageRoute(
              builder: (context) {
                return Buffer(admin,maqarat);
              }));*/
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Buffer(admin,maqarat,maqarat.channel))
      );
    }
  });

}
class Maqarat {
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
}



class _MaqaratPageState extends State<MaqaratPage> {
  List<Maqarat> _maqaratList = [];
  String utc_t;
  DateTime n;
  int comp;
  bool isTime=false;
  List check_time;
  var JuzToColor = {
    1: [0xffF0E9CF, 0xffBC9D20],
    2: [0xffFFD8C8, 0xffFF4E00],
    3: [0xffFFC8C8, 0xffFF0000],
    4: [0xffCDCFDA, 0xff172353],
    5: [0xffDACDCD, 0xff531717],
    6: [0xffFFC8F0, 0xffFF00BB],
    7: [0xffC8C8C8, 0xff000000],
    8: [0xffDCD4E4, 0xff5F3782],
    9: [0xffE4D4D5, 0xff82373C],
    10: [0xffD4E3E4, 0xff377F82],
    11: [0xffEBEBEB, 0xffA2A2A2],
    12: [0xffF2E2D1, 0xffC57C29],
    13: [0xffE2F2D1, 0xff7CC529],
    14: [0xffD1E6F2, 0xff298CC5],
    15: [0xffF2D1DB, 0xffC52959],
    16: [0xffCBD8DF, 0xff0E4A6D],
    17: [0xffCBDFD7, 0xff0E6D49],
    18: [0xffFEDDFD, 0xffFC61F7],
    19: [0xffFEDDDD, 0xffFC6161],
    20: [0xffF5F4CC, 0xffD4CD13],
    21: [0xffD8EBC8, 0xff4DA203],
    22: [0xffF4C8FF, 0xffCE00FF],
    23: [0xffF5CFCF, 0xffD11F1F],
    24: [0xffCACCE8, 0xff090E92],
    25: [0xffDFE8CA, 0xff699209],
    26: [0xffE5C9E1, 0xff850074],
    27: [0xffCED7D7, 0xff194343],
    28: [0xffEDFFC9, 0xffABFF00],
    29: [0xffCCF2CC, 0xff12C712],
    30: [0xffC9FFF8, 0xff00FFDC],
  };
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('dispose maq disp...');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init maq display...");
    /*setState(() {
      if(widget.info[widget.dkey]!=null) {
        List temp = Map
            .from(widget.info[widget.dkey])
            .keys
            .toList();
        for (var i = 0; i < temp.length; i++) {
          _maqaratList.add(new Maqarat(
              widget.info[widget.dkey][temp[i].toString()]['time'].toString(),
              widget.info[widget.dkey][temp[i].toString()]['juz'],
              widget.info[widget.dkey][temp[i].toString()]['participants']
                  .toString() +
                  "/5",
              false));
        }
      }
    });*/

  }

  @override
  Widget build(BuildContext context) {
    _maqaratList=[];
    
    if(widget.info[widget.dkey]!=null) {
      List temp = Map
          .from(widget.info[widget.dkey])
          .keys
          .toList();
      for (var i = 0; i < temp.length; i++) {
        isTime=false;
        print(DateFormat('dd-MM-yyyy').format(DateTime.now()));
        print(widget.dkey);
        bool cur_date=DateFormat('dd-MM-yyyy').format(DateTime.now())==widget.dkey.toString();
        print(cur_date);
        if(cur_date){
          print(widget.info[widget.dkey][temp[i].toString()]['time']);
        utc_t=utc_times[widget.info[widget.dkey][temp[i].toString()]['time'].toString()];
        print(utc_t);
        check_time=utc_t.toString().split(':');
        print(check_time[0]);
        print(check_time[1]);
        n=DateTime.now().toUtc();
        comp=DateTime.utc(1,1,1,int.parse(check_time[0]),int.parse(check_time[1])).difference(DateTime.utc(1,1,1,n.hour,n.minute)).inSeconds;
        print(comp);
        if(comp<60){
          continue;
        }
       if(60<comp && comp<360){
         isTime=true;
       }}
       else{
         isTime=false;
       }
        _maqaratList.add(new Maqarat(
            widget.info[widget.dkey][temp[i].toString()]['time'].toString(),
            widget.info[widget.dkey][temp[i].toString()]['juz'],
            widget.info[widget.dkey][temp[i].toString()]['participants']
                .toString() +
                "/5",
            isTime,temp[i].toString()));
      }
    }
      double iconSize = MediaQuery
          .of(context)
          .size
          .height * 0.051275; //35.0
    print(_maqaratList.isEmpty);
    //if(_maqaratList.isEmpty){
      return Expanded(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.90,
          child: ListView.builder(
            itemCount: _maqaratList.length,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              if(_maqaratList.isEmpty){
                return Container(
                  child: Center(
                    child:Text("Booked Maqarats are over"
                    ),
                  )
              );}
              else{
              return Row(
                children: <Widget>[
                  Container(
                    decoration: IconDecoration(
                      iconSize: iconSize,
                      lineWidth: MediaQuery
                          .of(context)
                          .size
                          .height * 0.001465,
                      firstData: true,
                      lastData: index == _maqaratList.length - 1 ?? true,
                    ),
                    child: Icon(
                      Icons.fiber_manual_record, size: iconSize,
                      color: Color(JuzToColor[_maqaratList[index].juz]
                      [1]), //Color from Database
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.21915, //90.0
                    child: Padding(
                      padding: EdgeInsets.only(
                          left:
                          MediaQuery
                              .of(context)
                              .size
                              .width * 0.02435), //10.0
                      child: Text(
                        _maqaratList[index].time + "\n IST",
                        //Time from Database
                        style: TextStyle(
                          fontFamily: "Segoe UI",
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .height * 0.030765,
                          color: Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery
                              .of(context)
                              .size
                              .height * 0.01758,
                          bottom: MediaQuery
                              .of(context)
                              .size
                              .height *
                              0.01758), //12.0 - 12.0
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.13771, //94
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.54057, //222
                        decoration: BoxDecoration(
                          color: Color(JuzToColor[_maqaratList[index].juz][0]),
                          //Color from database - 1
                          border: Border.all(
                            width: 1.00,
                            color: Color(JuzToColor[_maqaratList[index].juz][0])
                                .withOpacity(0.21),
                          ),
                          //from database
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(1.00, 1.00),
                              color: Color(0xff000000).withOpacity(0.11),
                              blurRadius: 6,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20.00),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          0.04,
                                      top: MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.007), //17.0 - 5.0
                                  child: Text(
                                    "Juz",
                                    style: TextStyle(
                                      fontFamily: "Segoe UI",
                                      fontSize:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.030765, //21.0
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          0.192365,
                                      top: MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.007), //79.0 - 5.0
                                  child: Text(
                                    _maqaratList[index].participants,
                                    // from database
                                    style: TextStyle(
                                      fontFamily: "Segoe UI",
                                      fontSize:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.02637, //18.0
                                      color: Color(0xff000000),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          0.036525), //15.0
                                  child: Text(
                                    _maqaratList[index].juz.toString(),
                                    //from database
                                    style: TextStyle(
                                      fontFamily: "Segoe UI",
                                      fontWeight: FontWeight.w700,
                                      fontSize:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.074715, //51
                                      color: Color(
                                          JuzToColor[_maqaratList[index].juz]
                                          [1]), //Color from Database - 2
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: MediaQuery
                                          .of(context)
                                          .size
                                          .width *
                                          0.036525), //15.0
                                  child: Container(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height *
                                        0.06153, //42
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width *
                                        0.15584, //64
                                    decoration: BoxDecoration(
                                      color: Color(
                                          JuzToColor[_maqaratList[index]
                                              .juz][1]),
                                      borderRadius:
                                      BorderRadius.circular(20.00), //2
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        print('tapped');
                                        if (_maqaratList[index].isTime) {
                                          DateTime en=DateTime.now().toUtc();
                                          print(_maqaratList[index].time);
                                          List temp=_maqaratList[index].time.toString().split(':');
                                          comp=DateTime.utc(1,1,1,int.parse(temp[0]),int.parse(temp[1])).difference(DateTime.utc(1,1,1,en.hour,en.minute)).inSeconds;
                                          print(comp);
                                          if(60<comp && comp<360){
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
                                                    content: Text("Once confirmed, wait for the Lobby to be created \n"
                                                            "DO NOT EXIT THE LOBBY"),
                                                    actions: <
                                                        Widget>[
                                                      FlatButton(
                                                          child:
                                                          Text(
                                                            "Confirm",
                                                          ),
                                                          onPressed: () {

                                                            createbuffer(context,_maqaratList[index]);
                                                          }
                                                      ),
                                                    ],
                                                  );
                                                });
                                            //createbuffer(context,_maqaratList[index]);

                                        }}
                                      },
                                      child: Icon(
                                          _maqaratList[index].isTime
                                              ? Icons.arrow_forward
                                              : Icons.access_time,
                                          size:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .height *
                                              0.0586, //40.0
                                          color: Color(
                                              JuzToColor[_maqaratList[index]
                                                  .juz]
                                              [0]) //Color from Database //1
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );}

            },
          ),
        ),
      );//}
   /* else{
      return Container(
        child: Center(
          child:Text("Booked Maqarats are over",
          style: TextStyle(
          fontWeight:
          FontWeight.w600,
          fontSize: MediaQuery.of(
          context)
          .size
          .height *
          0.030765)
        ),
      )
      );
    }*/
  }
}

class IconDecoration extends Decoration {
  final double iconSize;
  final double lineWidth;
  final bool firstData;
  final bool lastData;

  IconDecoration({
    @required double iconSize,
    @required double lineWidth,
    @required bool firstData,
    @required bool lastData,
  })  : this.iconSize = iconSize,
        this.lineWidth = lineWidth,
        this.firstData = firstData,
        this.lastData = lastData;

  @override
  BoxPainter createBoxPainter([onChanged]) {
    // TODO: implement createBoxPainter
    return IconLine(
      iconSize: iconSize,
      lineWidth: lineWidth,
      firstData: firstData,
      lastData: lastData,
    );
  }
}

class IconLine extends BoxPainter {
  final double iconSize;
  final bool firstData;
  final bool lastData;
  final Paint paintLine;

  IconLine({
    @required double iconSize,
    @required double lineWidth,
    @required bool firstData,
    @required bool lastData,
  })  : this.iconSize = iconSize,
        this.firstData = firstData,
        this.lastData = lastData,
        paintLine = Paint()
          ..color = Colors.black
          ..strokeCap = StrokeCap.round
          ..strokeWidth = lineWidth
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    // TODO: implement paint

    final double iconSpace = iconSize / 1.95;

    final leftOffset = Offset(iconSize / 2, offset.dy);
    final Offset top = configuration.size.topLeft(Offset(leftOffset.dx, 0.0));
    final Offset centerTop = configuration.size
        .centerLeft(Offset(leftOffset.dx, leftOffset.dy - iconSpace)); //

    final Offset centerBottom = configuration.size
        .centerLeft(Offset(leftOffset.dx, leftOffset.dy + iconSpace)); //
    final Offset end =
        configuration.size.bottomLeft(Offset(leftOffset.dx, leftOffset.dy * 2));

    canvas.drawLine(top, centerTop, paintLine); //if(!firstData)
    if (!lastData) canvas.drawLine(centerBottom, end, paintLine); //
  }
}
