import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageBackground extends StatelessWidget {
  final screenHeight;

  const HomePageBackground({Key key, @required this.screenHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeDate = Theme.of(context);

    return Container(
      height: screenHeight * 0.5,
      decoration: BoxDecoration(
          color: themeDate.primaryColor,
      ),
      child: Stack(
        children: <Widget>[
          Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: MediaQuery.of(context).size.height *0.16115, //110.0 -- 0.16115
                    width: MediaQuery.of(context).size.width *1.000,//411.00, - 1.000785
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/grp_poly.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              ],
          )
        ],
      )
    );
  }
}
