import 'package:flutter/services.dart';
import 'package:mahadalzahra/dashboard.dart';
import 'package:mahadalzahra/new_maqarat.dart';
import 'package:mahadalzahra/profile_page_blue.dart';
import 'package:mahadalzahra/services/authentication.dart';
import 'package:mahadalzahra/settings.dart';
import 'package:mahadalzahra/stats.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:mahadalzahra/user.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //static var db;
  int _currentIndex = 0;
  DateTime currentBackPressTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  var tabs = [
    Dashboard(),
    Stats(),
    NewMaqarat(),
    ProfileBlue(),
    Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 50.0,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          iconSize: MediaQuery.of(context).size.width * 0.07305,
          //30.
          selectedFontSize: MediaQuery.of(context).size.width * 0.031655,
          //13
          unselectedFontSize: MediaQuery.of(context).size.width * 0.02922,
          //12

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                'Dashboard',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              title: Text(
                'Stats',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline,
              ),
              title: Text('Join Maqarat',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              activeIcon: Icon(Icons.add_circle),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              title: Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.info,
              ),
              title: Text(
                'Info',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
      onWillPop: onWillPop,
    );
  }
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 4)) {
      currentBackPressTime = now;
      Toast.show("Press again to exit", context, duration: Toast.LENGTH_LONG);

      return Future.value(false);
    }

    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    dispose();
    return Future.value(true);
  }
}
