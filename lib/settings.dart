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
                                    fontSize: MediaQuery.of(context).size.height *0.0586, //40.0
                                    color:Color(0xff000000),
                                  ),
                                ),
                              )
                            ],
                          ),

                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding:  EdgeInsets.only(left:MediaQuery.of(context).size.width * 0.01948, right:MediaQuery.of(context).size.width * 0.01948), //8.0, 8.0
                                  child: Column(
                                    children: <Widget>[
                                      Align(  alignment: Alignment.center, child: Text("Join Maqarat",style: TextStyle(fontSize: 25.0, fontFamily: "Segoe UI",fontWeight: FontWeight.w500,  ))),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft, child: Text("1. A maximum of 2 Maqarats are allowed in a day",style: TextStyle(fontSize: 19.0))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft, child: Text("2. Two(2) Maqarats cannot be booked for the same time",style: TextStyle(fontSize: 19.0))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft,child: Text("3. Ajza are divided between days as Odd Ajza and Even Ajza",style: TextStyle(fontSize: 19.0))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft,child: Text("4. Maqarat(s) can be booked for upto seven days at a time",style: TextStyle(fontSize: 19.0))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft,child: Text("5. Days will be incremented daily",style: TextStyle(fontSize: 19.0))),
                                      ),
                                      Text(''),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.center,child: Text("Dashboard",style: TextStyle(fontSize: 25.0, fontFamily: "Segoe UI",fontWeight: FontWeight.w500,  ))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft,child: Text("1. Maqarat will be activated 6 minutes before Maqarat time and locked 1 minute before Maqarat time",style: TextStyle(fontSize: 19.0))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft,child: Text("2. Maqarat will not be displayed after Maqarat time",style: TextStyle(fontSize: 19.0))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft,child: Text("3. During the active phase, wait for few seconds until lobby is created",style: TextStyle(fontSize: 19.0))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft,child: Text("4. After lobby creation, wait till Maqarat time after which a countdown for 30 seconds will begin",style: TextStyle(fontSize: 19.0))),
                                      ),
                                      //
                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft,child: Text("5. During the countdown Safahaat to be recited will be displayed and then the Maqarat will start",style: TextStyle(fontSize: 19.0))),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top:5.0),
                                        child: Align(alignment: Alignment.centerLeft,child: Text("6. During the 30 second countdown you are not allowed to leave the lobby",style: TextStyle(fontSize: 19.0))),
                                      ),
                                      Text(""),
                                      Align(alignment: Alignment.center,child: Text("Feedback",style: TextStyle(fontSize: 25.0, fontFamily: "Segoe UI",fontWeight: FontWeight.w500,  ))),
                                      //  Material(child: InkWell(child: Icon(Icons.feedback, color: Color(0xFF003CE7), size: 40,),))
                                      RaisedButton(
                                        color: Colors.white,
                                        child: Icon(Icons.feedback, color: Color(0xFF003CE7), size: 40,),
                                        onPressed: (){launchURL(url);},
                                      )



                                    ],
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