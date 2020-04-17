import 'package:flutter/material.dart';
import 'package:prokis/languages/select.dart';

class SifreGirisAdmin extends StatefulWidget {
  double oran;
  String dil;

  SifreGirisAdmin.Deger(
    String gelenDil,double gelenOran,
  ) {
    dil=gelenDil;
    oran = gelenOran;
  }

  @override
  _SifreGirisAdminState createState() => new _SifreGirisAdminState.Deger(dil,oran);
}

class _SifreGirisAdminState extends State<SifreGirisAdmin> {
  double oran;
  String dil="TR";
  String girilenSifre="";

  _SifreGirisAdminState.Deger(String gelenDil,double gelenOran) {
    dil = gelenDil;
    oran = gelenOran;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController tec1 = new TextEditingController(text: girilenSifre);
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 10 * oran, bottom: 10 * oran),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0 * oran))),
      backgroundColor: Colors.deepOrange.shade800,
      title: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    Dil().sec(dil, "tv300"),
                    style: TextStyle(
                        fontFamily: 'Kelly Slab',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textScaleFactor: oran,
                  ),
                  SizedBox(width: 200*oran,
                                      child: Container(color: Colors.white,
                                        child: TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                        fontSize: 22 * oran,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Audio wide'),
                    textAlign: TextAlign.center,
                    cursorColor: Colors.pink,
                    maxLength: 4,
                    obscureText: true,
                    controller: tec1,
                    onChanged: (String metin) {
                      girilenSifre = metin;
                    },
                    
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          bottom: 2 * oran, top: 5 * oran),
                      isDense: true,
                      counterStyle: TextStyle(
                          fontSize: 14 * oran,
                          color: Colors.black,
                          fontFamily: 'Kelly Slab'),
                      hintText: Dil()
                          .sec(dil, "tv301"),
                      hintStyle: TextStyle(
                          fontSize: 14 * oran,
                          fontFamily: 'Kelly Slab'),
                    ),
                                            ),
                                      ),
                  ),
                  ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 10 * oran),
          alignment: Alignment.center,
          width: 400 * oran,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20 * oran),
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () {
                    var deger = ['1',girilenSifre];
                    Navigator.of(context).pop(deger);
                  },
                  child: Text(
                    Dil().sec(dil, "btn2"),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25 * oran,
                        fontFamily: 'Audio wide'),
                  ),
                ),
              ),
              Container(
                child: RaisedButton(
                  color: Colors.indigo,
                  onPressed: () {
                    var deger = ['0',girilenSifre];
                    Navigator.of(context).pop(deger);
                  },
                  child: Text(
                    Dil().sec(dil, "btn3"),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25 * oran,
                        fontFamily: 'Audio wide'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
