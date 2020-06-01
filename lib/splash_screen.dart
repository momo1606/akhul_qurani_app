import 'package:mahadalzahra/homepage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import './login_signup_page.dart';
import 'package:mahadalzahra/root_page.dart';
import 'package:mahadalzahra/services/authentication.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();

    _mockCheckForSession().then((status) {
      if (status) {
        _navigateToLogin();
      } else {
        _navigateToHome();
      }
    });
  }

  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 4000), () {});
    return true; //Remember me logic - database
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => HomePage(),
    ));
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => new LoginSignupPage(auth: new Auth()
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("images/backfinal.png"),
                fit: BoxFit.fill,
              )),
            ),
            Center(
              child: Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.grey,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.50,
                    width: MediaQuery.of(context).size.width * 0.60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("images/mahadlogo.png"),
                      fit: BoxFit.fill,
                    )),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
