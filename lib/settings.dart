import 'package:mahadalzahra/homepagebackground.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'homepagebackground.dart';

const url = "https://docs.google.com/forms/d/e/1FAIpQLSeaJWdoi4AVm2Fp35_PJfLlxm9Ewmk_kj1039nJxztvP807IQ/viewform?usp=sf_link";

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {
  Future launchURL(String url) async {
    if(await canLaunch(url)){
      await launch(url, forceSafariVC: true, forceWebView: true,enableJavaScript: true );
    }
    else{
      print('cant launch');
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        HomePageBackground(screenHeight: MediaQuery.of(context).size.height,),
        SafeArea(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.007325, //5.0
                ),
                Padding(
                  padding:  EdgeInsets.only(right:MediaQuery.of(context).size.height * 0.02435), //
                  child: Row(
                    children: <Widget>[

                      Spacer(),

                      Container(
                        height: MediaQuery.of(context).size.height *0.0879, //60.0
                        width: MediaQuery.of(context).size.width *0.12175, //50.00,
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
                  height: MediaQuery.of(context).size.height *0.01465, //10.0
                ),
                Expanded(
                  child: Container(

                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        border: Border.all(width: MediaQuery.of(context).size.width *0.002435, color: Color(0xffffffff),),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(1.00,1.00),
                            color: Color(0xffffffff).withOpacity(0.53),
                            blurRadius: 6,
                          ),
                        ], borderRadius: BorderRadius.only(topLeft: Radius.circular(30.00), topRight: Radius.circular(30.00), ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.0487, vertical: MediaQuery.of(context).size.height * 0.007325), //20,5
                                child: Text(
                                  "Information",
                                  style: TextStyle(
                                    fontFamily: "Segoe UI",fontWeight: FontWeight.w600,
                                    fontSize: MediaQuery.of(context).size.width *
                                        0.0974, //40.0
                                    color:Color(0xff000000),
                                  ),
                                ),
                              )
                            ],
                          ),

                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Scrollbar(
                                isAlwaysShown:true,
                                controller: _scrollController,
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Padding(
                                    padding:  EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.01948, right:MediaQuery.of(context).size.width * 0.01948), //8.0, 8.0
                                    child: Column(
                                      children: <Widget>[
                                        Align(  alignment: Alignment.center, child: Text("Joining a Maqarat",style: TextStyle(fontSize: 25.0, fontFamily: "Segoe UI",fontWeight: FontWeight.w500,  ))),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft, child: Text("1. A maximum of 2 Maqarats are allowed in a day",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft, child: Text("2. Two Maqarats cannot be booked for the same time slot of a given date",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("3. A Maqarat cannot be booked 15 mins prior to a maqarat slot of a given date",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("4. Ajza are divided between days as Odd Ajza and Even Ajza",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("5. Maqarat(s) can be booked for upto seven days at a time",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("6. Days will be incremented daily",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Text(''),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.center,child: Text("Dashboard",style: TextStyle(fontSize: 25.0, fontFamily: "Segoe UI",fontWeight: FontWeight.w500,  ))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("1. Scroll down to refresh dashboard",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("2. Maqarat will be activated 6 minutes before Maqarat time and locked 1 minute before Maqarat time",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("3. Maqarat will not be displayed after Maqarat time",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("4. During the active phase, wait for few seconds until lobby is created",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("5. After lobby creation, wait till Maqarat time after which a countdown for 30 seconds will begin",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        //
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("6. During the countdown Safahaat to be recited will be displayed and then the Maqarat will start",style: TextStyle(fontSize: 19.0))),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("7. During the 30 second countdown you are not allowed to leave the lobby",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("8. Each Maqarat will be of a duration of 50 minutes after which the lobby will be disposed",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("9. Ending an ongoing Maqarat call will lead to the user not being able to rejoin",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top:5.0),
                                          child: Align(alignment: Alignment.centerLeft,child: Text("10. Each Maqarat will have a user who will be the admin of that Maqarat, who will be responsible for prompting Tanbee/Talqeen",style: TextStyle(fontSize: 19.0))),
                                        ),
                                        Text(""),
                                        Row(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Align(alignment: Alignment.center,child: Text("Feedback",style: TextStyle(fontSize: 25.0, fontFamily: "Segoe UI",fontWeight: FontWeight.w500,  ))),
                                                //  Material(child: InkWell(child: Icon(Icons.feedback, color: Color(0xFF003CE7), size: 40,),))
                                                RaisedButton(
                                                  color: Colors.white,
                                                  child: Icon(Icons.feedback, color: Color(0xFF003CE7), size: 40,),
                                                  onPressed: (){launchURL(url);},
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                            Container(width:1.0,height:75.0,color:Colors.black),
                                            Spacer(),
                                            Column(
                                              children: <Widget>[
                                                Align(alignment: Alignment.center,child: Text("Upcoming Features",style: TextStyle(fontSize: 25.0, fontFamily: "Segoe UI",fontWeight: FontWeight.w500,  ))),
                                                //  Material(child: InkWell(child: Icon(Icons.feedback, color: Color(0xFF003CE7), size: 40,),))
                                                RaisedButton(
                                                  color: Colors.white,
                                                  child: Icon(Icons.star, color: Color(0xFF003CE7), size: 40,),
                                                  onPressed: (){

                                                    showDialog(
                                                        context:
                                                        context,
                                                        builder:
                                                            (BuildContext
                                                        context) {
                                                          return AlertDialog(
                                                            title:
                                                            Text(
                                                              "Upcoming Features",
                                                            ),
                                                            content: Text("1. Allowing users to send invites and create private lobbies\n2. Notification System\n3. Users will be able to send Emoticons during Maqarat call\n4. Enhanced UI\n5. More Stats",style: TextStyle(fontSize: 19.0,)),
                                                            actions: <
                                                                Widget>[
                                                              FlatButton(
                                                                  child:
                                                                  Text("OK",),
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  }
                                                              ),
                                                            ],
                                                          );
                                                        });


                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),







                                      ],
                                    ),
                                  ),
                                ),
                              ),


                            ),

                          ),




                        ],

                      )

                  ),
                ),


              ],
            )
        ),
      ],
    );
  }
}

