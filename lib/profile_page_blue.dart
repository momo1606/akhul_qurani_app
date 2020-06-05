import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:mahadalzahra/services/authentication.dart';

import 'login_signup_page.dart';

class ProfileBlue extends StatefulWidget {
  /*var val;
  ProfileBlue(this.val);*/

  @override
  _ProfileBlueState createState() => _ProfileBlueState();
}

final fb = FirebaseDatabase.instance.reference();

Future getuser() async {
  var r = (await fb.child('users').child(useruid).once()).value;
  return r;
}

class User_prof {
  String ITS;
  String age;
  String appid;
  String idara;
  String mobile;
  String YOH;
  String email;
  String jamaat;
  String name;

  User_prof(
    this.ITS,
    this.age,
    this.appid,
    this.idara,
    this.mobile,
    this.YOH,
    this.email,
    this.jamaat,
    this.name,
  );
}

class _ProfileBlueState extends State<ProfileBlue> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future val;
  User_prof userp;
  String ITS;
  String age;
  String appid;
  String idara;
  String mobile;
  String YOH;
  String email;
  String jamaat;
  String name;

  @override
  void initState() {
    super.initState();
    val = getuser();
  }
  /*signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }*/
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: val,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              userp = User_prof(
                  snapshot.data['ITS'].toString(),
                  snapshot.data['Age'].toString(),
                  snapshot.data['AppID'].toString(),
                  snapshot.data['idara'].toString(),
                  snapshot.data['phone'].toString(),
                  snapshot.data['YOH'].toString(),
                  snapshot.data['email'].toString(),
                  snapshot.data['Jamaat'].toString(),
                  snapshot.data['name'].toString());
              return Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("images/prof_back.png"),
                      fit: BoxFit.fill,
                    )),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.085225,
                                  top: MediaQuery.of(context).size.height *
                                      0.0293), //35 - 20
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    0.12599, //86
                                width: MediaQuery.of(context).size.width *
                                    0.18019, //74

                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("images/mahadlogo.png"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.0487,
                              top: MediaQuery.of(context).size.height *
                                  0.01465), //20 - 10
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: MediaQuery.of(context).size.height *
                                    0.16115, //110
                                width: MediaQuery.of(context).size.width *
                                    0.26785, //110
                                decoration: BoxDecoration(
                                  color: Color(0xffffffff),
                                  border: Border.all(
                                    width: 1.00,
                                    color: Color(0xff707070),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.16115, //110
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01758), //12
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0487), //20.0
                                              child: Text(
                                                userp.name,
                                                style: TextStyle(
                                                  fontFamily: "Segoe UI",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16, //to be solved
                                                  //MediaQuery.of(context).size.height *
                                                  // 0.04102,
                                                  //28
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.0487),
                                            child: Text(
                                              userp.ITS,
                                              style: TextStyle(
                                                fontFamily: "Segoe UI",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05357, //22
                                                color: Color(0xff00ffe5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.0487),
                                            child: Text(
                                              "Hafiz in " + userp.YOH + " H.",
                                              style: TextStyle(
                                                fontFamily: "Segoe UI",
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05357, //22
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height *
                                  0.01465), //10
                          child: Container(
                            height: MediaQuery.of(context).size.height *
                                0.001465, //1
                            width: MediaQuery.of(context).size.width *
                                0.82303, //338
                            color: Color(0xffffffff).withOpacity(0.53),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.007),
                          child: Text(
                            "App Id: " + userp.appid,
                            style: TextStyle(
                              fontFamily: "Segoe UI",
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.065745,
                              //27
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height *
                                  0.007), //5
                          child: Container(
                            height: MediaQuery.of(context).size.height *
                                0.001465, //1
                            width: MediaQuery.of(context).size.width *
                                0.82303, //338
                            color: Color(0xffffffff).withOpacity(0.53),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height *
                                  0.01758), //12.0
                          child: Row(
                            //strt
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02435), //10.0
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07325, //50
                                    width: MediaQuery.of(context).size.width *
                                        0.1948, //80
                                    decoration: BoxDecoration(
                                      color: Color(0xffffdfdf),
                                      border: Border.all(
                                        width: 1.00,
                                        color: Color(0xff707070),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.00),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Age",
                                        style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0487, //20
                                          color: Color(0xff580000),
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02435,
                                      right: MediaQuery.of(context).size.width *
                                          0.02435), //10 - 10
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07325, //50.0

                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                          width: 1.00,
                                          color: Color(0xff707070),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.00),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02435),
                                          child: Text(
                                            userp.age + " Years",
                                            style: TextStyle(
                                              fontFamily: "Segoe UI",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0487,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height *
                                  0.007), //5
                          child: Row(
                            //strt
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02435),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07325, //50
                                    width: MediaQuery.of(context).size.width *
                                        0.1948, //80
                                    decoration: BoxDecoration(
                                      color: Color(0xffffdfdf),
                                      border: Border.all(
                                        width: 1.00,
                                        color: Color(0xff707070),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.00),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Idara",
                                        style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0487,
                                          color: Color(0xff580000),
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02435,
                                      right: MediaQuery.of(context).size.width *
                                          0.02435),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07325, //50.0

                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                          width: 1.00,
                                          color: Color(0xff707070),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.00),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02435),
                                          child: Text(
                                            userp.idara,
                                            style: TextStyle(
                                              fontFamily: "Segoe UI",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0487,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.007),
                          child: Row(
                            //strt
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02435),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07325, //50
                                    width: MediaQuery.of(context).size.width *
                                        0.1948, //80
                                    decoration: BoxDecoration(
                                      color: Color(0xffffdfdf),
                                      border: Border.all(
                                        width: 1.00,
                                        color: Color(0xff707070),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.00),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Jamaat",
                                        style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0487,
                                          color: Color(0xff580000),
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02435,
                                      right: MediaQuery.of(context).size.width *
                                          0.02435),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07325, //50.0

                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                          width: 1.00,
                                          color: Color(0xff707070),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.00),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02435),
                                          child: Text(
                                            userp.jamaat,
                                            style: TextStyle(
                                              fontFamily: "Segoe UI",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0487,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.007),
                          child: Row(
                            //strt
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02435),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07325, //50
                                    width: MediaQuery.of(context).size.width *
                                        0.1948, //80
                                    decoration: BoxDecoration(
                                      color: Color(0xffffdfdf),
                                      border: Border.all(
                                        width: 1.00,
                                        color: Color(0xff707070),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.00),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Mobile",
                                        style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0487,
                                          color: Color(0xff580000),
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02435,
                                      right: MediaQuery.of(context).size.width *
                                          0.02435),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07325, //50.0

                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                          width: 1.00,
                                          color: Color(0xff707070),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.00),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02435),
                                          child: Text(
                                            userp.mobile,
                                            style: TextStyle(
                                              fontFamily: "Segoe UI",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0487,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.007),
                          child: Row(
                            //strt
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.02435),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.07325, //50
                                    width: MediaQuery.of(context).size.width *
                                        0.1948, //80
                                    decoration: BoxDecoration(
                                      color: Color(0xffffdfdf),
                                      border: Border.all(
                                        width: 1.00,
                                        color: Color(0xff707070),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.00),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Email",
                                        style: TextStyle(
                                          fontFamily: "Segoe UI",
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.0487,
                                          color: Color(0xff580000),
                                        ),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.02435,
                                      right: MediaQuery.of(context).size.width *
                                          0.02435),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07325, //50.0

                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        border: Border.all(
                                          width: 1.00,
                                          color: Color(0xff707070),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.00),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02435),
                                          child: Text(
                                            userp.email,
                                            style: TextStyle(
                                              fontFamily: "Segoe UI",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0487,
                                              color: Color(0xff000000),
                                            ),
                                          ),
                                        ),
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height *
                                  0.010255), //7
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: MediaQuery.of(context).size.width *
                                        0.02435), //10
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.071785, //49
                                    width: MediaQuery.of(context).size.width *
                                        0.36525, //150
                                    decoration: BoxDecoration(
                                      color:
                                          Color(0xffffffff).withOpacity(0.72),
                                      borderRadius:
                                          BorderRadius.circular(20.00),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01948),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.power_settings_new,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07305, //30
                                              color: Colors.black,
                                            ),
                                            onPressed:(){ oauth.signOut().then((value) => SystemChannels.platform.invokeMethod('SystemNavigator.pop'));

                                            }//signOut,
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03896), //16.0
                                          child: Text(
                                            "Log out",
                                            style: TextStyle(
                                              fontFamily: "Segoe UI",
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0487, //20
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: MediaQuery.of(context).size.height *
                          0.16115, //110.0 -- 0.16115
                      width: MediaQuery.of(context).size.width *
                          1.000, //411.00, - 1.000785
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/grp_poly.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}
