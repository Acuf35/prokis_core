



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';

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
      oran = MediaQuery.of(context).size.width / 731.4;
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
                  Dil().sec(dilSecimi, 'tv37'),
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
                        Dil().sec(dilSecimi, 'btn7'),
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
                        Dil().sec(dilSecimi, 'btn8'),
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
