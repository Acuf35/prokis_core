import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'kumes_olustur.dart';
import 'languages/select.dart';

class DilSecimi extends StatefulWidget {
  List<Map> gelenDBveri;
  DilSecimi(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }
  @override
  State<StatefulWidget> createState() {
    return DilSecimiState(gelenDBveri);
  }
}

class DilSecimiState extends State<DilSecimi> {
//++++++++++++++++++++++++++DEĞİŞKENLER TANIMLAMA+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "EN";
  List<Map> dbVeriler;
//--------------------------DEĞİŞKENLER TANIMLAMA--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  DilSecimiState(List<Map> dbVeri) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
    }
    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
        body: Column(
      children: <Widget>[
        //Başlık bölümü
        Expanded(
            child: Container(
          child: Column(
            children: <Widget>[
              Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: AutoSizeText(
                      SelectLanguage().selectStrings(dilSecimi, "tv1"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Kelly Slab',
                          color: Colors.grey.shade600,
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: 2,
              )
            ],
          ),
          alignment: Alignment.center,
        )),
        //Dİl seçim bölümü
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey.shade600,
            alignment: Alignment.center,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 10 * oran),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isDense: true,
                  value: dilSecimi == "EN" ? "ENGLISH" : "TÜRKÇE",
                  elevation: 16,
                  iconEnabledColor: Colors.black,
                  iconSize: 50 * oran,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    backgroundColor: Colors.white,
                    fontFamily: 'Audio Wide',
                    fontSize: 30 * oran,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (String newValue) {
                    newValue == "ENGLISH" ? dilSecimi = "EN" : dilSecimi = "TR";
                    newValue == "ENGLISH"
                        ? dbHelper
                            .veriYOKSAekleVARSAguncelle(1, "EN", "0", "0", "0")
                            .then((onValue) {
                            _dbVeriCekme();
                          })
                        : dbHelper
                            .veriYOKSAekleVARSAguncelle(1, "TR", "0", "0", "0")
                            .then((onValue) {
                            _dbVeriCekme();
                          });

                    setState(() {});
                  },
                  items: <String>['ENGLISH', 'TÜRKÇE']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        child: Text(value),
                        padding: EdgeInsets.only(right: 5 * oran),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),

        //ileri geri ok bölümü
        Expanded(
          child: Container(
            child: Row(
              children: <Widget>[
                Spacer(
                  flex: 20,
                ),
                //geri ok
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        Toast.show(dbSatirSayisi.toString(), context,
                            duration: 3);
                      },
                      color: Colors.grey.shade400,
                    )),
                Spacer(
                  flex: 1,
                ),
                //ileri ok
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KumesOlustur(dbVeriler)),
                          //MaterialPageRoute(builder: (context) => IsiSensorHaritasi(dilSecimi)),
                        ).then((onValue) {
                          _dbVeriCekme();
                        });
                      },
                      color: Colors.black,
                    )),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
//--------------------------SCAFFOLD--------------------------------
  }

//++++++++++++++++++++++++++METOTLAR+++++++++++++++++++++++++++++++

  _satirlar(List<Map> satirlar) {
    dbVeriler = satirlar;
  }

  _dbVeriCekme() {
    dbSatirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => dbSatirSayisi = satirSayisi);
    satirSayisi.whenComplete(() {
      dbSatirlar.then((List<Map> satir) => _satirlar(satir));
    });
  }

  Future _cikisAlert(String x) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return CikisAlert.deger(x);
      },
    );
  }

//--------------------------METOTLAR--------------------------------

}
