



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

class ResetAlert extends StatefulWidget {
  String dilSecimi = "TR";

  ResetAlert.deger(String x) {
    print(x);
    dilSecimi = x;
  }

  @override
  _ResetAlertState createState() => new _ResetAlertState.deger(dilSecimi);
}


class _ResetAlertState extends State<ResetAlert> {
  String dilSecimi = "TR";

  _ResetAlertState.deger(String x) {
    dilSecimi = x;
  }

  @override
  Widget build(BuildContext context) {
    var oran;

    try {
      var width = MediaQuery.of(context).size.width *
          MediaQuery.of(context).devicePixelRatio;
      var height = MediaQuery.of(context).size.height *
          MediaQuery.of(context).devicePixelRatio;
      var carpim = width * height;
      oran = carpim / 2073600.0;
    } catch (Exception) {
      print("Hata VAR!!!");
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0*oran))),
      backgroundColor: Colors.deepOrange.shade800,
      title: Container(
        padding: EdgeInsets.all(10 * oran),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  SelectLanguage().selectStrings(dilSecimi, 'tv37'),
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Kelly Slab'),
                  textAlign: TextAlign.center,textScaleFactor: oran,
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 20 * oran),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 20 * oran),
                    child: RaisedButton(
                      color: Colors.indigo,
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        SelectLanguage().selectStrings(dilSecimi, 'btn7'),
                        textScaleFactor: oran,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Audio wide'),
                      ),
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      color: Colors.indigo,
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        SelectLanguage().selectStrings(dilSecimi, 'btn8'),
                        textScaleFactor: oran,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Audio wide'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
