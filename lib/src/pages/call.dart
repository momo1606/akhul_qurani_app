import 'dart:async';
import 'dart:ffi';
import 'package:quiver/async.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mahadalzahra/buffer.dart';
import 'package:mahadalzahra/dashboard.dart';
import 'package:mahadalzahra/services/authentication.dart';
import '../../homepage.dart';
import '../utils/settings.dart';

class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;
  final List<App_Id> users;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.channelName,this.users}) : super(key: key);



  @override
  _CallPageState createState() => _CallPageState();
}
/*class App_Id {
  final String appid;
  final bool isadmin;
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
}*/

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
var fs=Firestore.instance;

class _CallPageState extends State<CallPage> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }
  int _start = 3000;
  int _current = 3000;
  var sub;

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

    sub.onDone(() {
      print("Done"); //CALL START ---
      sub.cancel();
      _onCallEnd(context);
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CallPage(channelName: widget.maqarat.channel, users: _idList)));
    });
  }
  @override
  void initState() {
    super.initState();
    startTimer();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(APP_ID);
    await AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    };

    AgoraRtcEngine.onLeaveChannel = () {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame = (
      int uid,
      int width,
      int height,
      int elapsed,
    ) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [
      AgoraRenderWidget(0, local: true, preview: true),
    ];
    _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      case 5:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4)),
                _expandedVideoRow(views.sublist(4, 5))
              ],
            ));
      case 6:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4)),
                _expandedVideoRow(views.sublist(4, 6))
              ],
            ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  Future<bool> _waitfordata() async {

    await Future.delayed(Duration(milliseconds: 1000), () {});

    return true;
  }

  void _onCallEnd(BuildContext context) {
    //final dataRef = FirebaseDatabase.instance.reference().child('buffer_lobby');
    var now=DateTime.now();

    var formatter = new DateFormat('dd-MM-yyyy');
    String formatted = formatter.format(now);

    var t=Firestore.instance.runTransaction((transaction) async{
      if(widget.users[0].appid==userappid){
        DataSnapshot dsglob= await FirebaseDatabase.instance.reference().child('global_stats').once();
        await FirebaseDatabase.instance.reference().child('global_stats').update({'total_maqarat': dsglob.value['total_maqarat']+1});
      }
      DataSnapshot psglob= await FirebaseDatabase.instance.reference().child('user_history').child(userappid).once();
      List ajzac=psglob.value['ajza_count'].toString().split(',').map(int.parse).toList();

      ajzac[widget.users[0].juz-1]+=1;
      String ajza="";
      for(var i=0; i<ajzac.length; i++){
        if(i==0){
          ajza=ajza+ajzac[i].toString();}
        else{
          ajza=ajza+','+ajzac[i].toString();
        }
      }

      DataSnapshot usertq= await FirebaseDatabase.instance.reference().child('user_state').child(userappid).once();
      String cju;
      bool tqflag=false;
      if(usertq.value['ajza']!=""){
      List ujc=usertq.value['ajza'].toString().split(',').map(int.parse).toList();

      if(ujc.length==30){
        cju=widget.users[0].juz.toString();
      }
      else if(ujc.length==29 && ujc.contains(widget.users[0].juz)==false){
      cju=usertq.value['ajza']+','+widget.users[0].juz.toString();
      tqflag=true;
      }
      else if(ujc.contains(widget.users[0].juz)==false){
        cju=usertq.value['ajza']+','+widget.users[0].juz.toString();
      }
      else{
        cju=usertq.value['ajza'];
      }
      }
      else{
        cju=widget.users[0].juz.toString();
      }

      if(tqflag==true){
          DataSnapshot dsglob= await FirebaseDatabase.instance.reference().child('global_stats').once();
          await FirebaseDatabase.instance.reference().child('global_stats').update({'total_maqarat': dsglob.value['total_quran']+1});
          await FirebaseDatabase.instance.reference().child('user_state').child(userappid).update({'total_quran':usertq.value['total_quran']+1});
          
      }
      int incday;
      int week;
      if(usertq.value['last_maqarat_date'].toString()==formatted){
        incday=usertq.value['days']+0;
      }else{
        incday=usertq.value['days']+1;
      }
      if(incday==7){
        week=usertq.value['weeks']+1;
        incday=0;
      }
      else{
        week=usertq.value['weeks'];
      }
      await FirebaseDatabase.instance.reference().child('user_state').child(userappid).update({'total_maqarat':usertq.value['total_maqarat']+1,'days':incday,"last_maqarat_date":formatted,'ajza':cju, 'weeks':week});
      await FirebaseDatabase.instance.reference().child('user_history').child(userappid).update({'ajza_count':ajza});
      await FirebaseDatabase.instance.reference().child('user_history').child(userappid).update({'ajza_count':ajza, 'date_wise':{formatted:{'juz':widget.users[0].juz,'time':widget.users[0].time}}});
      await FirebaseDatabase.instance.reference().child('user_maqarat_booked').child(userappid).child(formatted).child(widget.channelName).remove();
      await FirebaseDatabase.instance.reference().child('buffer_lobby').child(widget.channelName).remove();


      QuerySnapshot r = await fs.collection('maqarat_male').document(formatted).collection('flag maqarat').where('maqaratID',isEqualTo: widget.channelName.toString()).getDocuments();
      DocumentSnapshot freshcopy=r.documents[0];

      Map fresh=freshcopy.data;


      if(freshcopy.data['no_participants']==0){
        await fs.collection('maqarat_male').document(formatted).collection('flag maqarat').document(widget.channelName).
        updateData(<String,dynamic>{'juz':widget.users[0].juz.toString(), 'maqaratID':widget.channelName, 'no_participants': 1,
          'participants':{'user1':userappid, 'user2':"",'user3':"", 'user4':"", 'user5':""},'status':"maqarat completed",'time':widget.users[0].time});
        }
        else if(freshcopy.data['no_participants']==1){
          await fs.collection('maqarat_male').document(formatted).collection('flag maqarat').document(widget.channelName).
          setData(<String,dynamic>{'juz':widget.users[0].juz.toString(), 'maqaratID':widget.channelName, 'no_participants': 2,
            'participants':{'user1':fresh['participants']['user1'], 'user2':userappid,'user3':"", 'user4':"", 'user5':""},'status':"maqarat completed",'time':widget.users[0].time});
        }
        else if(freshcopy.data['no_participants']==2){
          await fs.collection('maqarat_male').document(formatted).collection('flag maqarat').document(widget.channelName).
          setData(<String,dynamic>{'juz':widget.users[0].juz.toString(), 'maqaratID':widget.channelName, 'no_participants': 3,
            'participants':{'user1':fresh['participants']['user1'], 'user2':fresh['participants']['user2'],'user3':userappid, 'user4':"", 'user5':""},'status':"maqarat completed",'time':widget.users[0].time});
        }
        else if(freshcopy.data['no_participants']==3){
          await fs.collection('maqarat_male').document(formatted).collection('flag maqarat').document(widget.channelName).
          setData(<String,dynamic>{'juz':widget.users[0].juz.toString(), 'maqaratID':widget.channelName, 'no_participants': 4,
            'participants':{'user1':fresh['participants']['user1'], 'user2':fresh['participants']['user2'],'user3':fresh['participants']['user3'], 'user4':userappid, 'user5':""},'status':"maqarat completed",'time':widget.users[0].time});
        }
        else if(freshcopy.data['no_participants']==4){
          await fs.collection('maqarat_male').document(formatted).collection('flag maqarat').document(widget.channelName).
          setData(<String,dynamic>{'juz':widget.users[0].juz.toString(), 'maqaratID':widget.channelName, 'no_participants': 5,
            'participants':{'user1':fresh['participants']['user1'], 'user2':fresh['participants']['user2'],'user3':fresh['participants']['user3'], 'user4':fresh['participants']['user4'], 'user5':userappid},'status':"maqarat completed",'time':widget.users[0].time});
        }


    });
    _waitfordata().then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
      );
    });

  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Al Akhul Qurani'),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            //_panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
