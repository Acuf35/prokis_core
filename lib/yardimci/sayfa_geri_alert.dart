



import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

class SayfaGeriAlert extends StatefulWidget {
  String dilSecimi = "TR";
  String gelenuyariMetni = "";

  SayfaGeriAlert.deger(String x, String y) {
    print(x);
    dilSecimi = x;
    gelenuyariMetni=y;
  }

  @override
  _SayfaGeriAlertState createState() => new _SayfaGeriAlertState.deger(dilSecimi,gelenuyariMetni);
}


class _SayfaGeriAlertState extends State<SayfaGeriAlert> {
  String dilSecimi = "TR";
  String uyariMetni = "";

  _SayfaGeriAlertState.deger(String x, String y) {
    dilSecimi = x;
    uyariMetni=y;

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
                  Dil().sec(dilSecimi, uyariMetni),
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
