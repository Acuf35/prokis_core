import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/adetler.dart';
import 'package:prokis/airinlet_haritasi.dart';
import 'package:prokis/aluyay.dart';
import 'package:prokis/bacafan_haritasi.dart';
import 'package:prokis/fan_haritasi.dart';
import 'package:prokis/kurulum_ayarlari.dart';
import 'package:prokis/uz_debi_nem.dart';
import 'package:toast/toast.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'isisensor_haritasi.dart';
import 'kumes_olustur.dart';
import 'languages/select.dart';

class DilSecimi extends StatefulWidget {
  List<Map> gelenDBveri;
  bool gelenDurum;
  DilSecimi(List<Map> dbVeriler,bool durum) {
    gelenDBveri = dbVeriler;
    gelenDurum = durum;
  }
  @override
  State<StatefulWidget> createState() {
    return DilSecimiState(gelenDBveri,gelenDurum);
  }
}

class DilSecimiState extends State<DilSecimi> {
//++++++++++++++++++++++++++DEĞİŞKENLER TANIMLAMA+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "EN";
  List<Map> dbVeriler;
  bool durum=false;
//--------------------------DEĞİŞKENLER TANIMLAMA--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  DilSecimiState(List<Map> dbVeri,bool drm) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
    }
    durum=drm;
    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
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
                      Dil().sec(dilSecimi, "tv1"),
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
        //Dil seçim bölümü
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey.shade600,
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Spacer(flex:5,),
                Expanded(flex:3,
                  child: Row(
                      children: <Widget>[
                        Spacer(flex: 4,),
                        Expanded(flex: 5,
                            child: Container(color: Colors.white,padding: EdgeInsets.only(left: 10*oran),
                              child: LayoutBuilder(builder:
                  (context, constraint) {
                                      return DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  isDense: true,
                                  value: dilSecimi == "EN" ? "ENGLISH" : "TÜRKÇE",
                                  elevation: 16,
                                  iconEnabledColor: Colors.black,
                                  iconSize: constraint.biggest.height,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    backgroundColor: Colors.white,
                                    fontFamily: 'Audio Wide',
                                    fontSize: constraint.biggest.height*0.8,
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
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                          );
                                    }),
                            ),
                        ),
                        Spacer(flex: 4,)
                      ],
                    ),
                           ),
                Spacer(flex:5,),
              ],
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
                  child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                      child: RawMaterialButton(
                      onPressed: () {
                        var veri;
                        for(int i=0;i<dbVeriler.length;i++){
                          if(dbVeriler[i]['id']==21){
                            veri=dbVeriler[i];
                          }
                        }
                        print(veri);
                      },
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Expanded(flex: 3,
                             child: LayoutBuilder(builder:
                                (context, constraint) {
                              return Icon(
                                Icons.arrow_back_ios,
                                color: Colors.grey.shade400,
                                size: constraint
                                    .biggest.height,
                              );
                            }),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                //ileri ok
                Expanded(
                  flex: 2,
                  child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                      child: RawMaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => KumesOlustur(dbVeriler,true)),
                      );
                      },
                      child: Column(
                        children: <Widget>[
                          Spacer(),
                          Expanded(flex: 3,
                             child: LayoutBuilder(builder:
                                (context, constraint) {
                              return Icon(
                                Icons.arrow_forward_ios,
                                size: constraint
                                    .biggest.height,
                              );
                            }),
                          ),
                          Spacer()
                        ],
                      ),
                    ),
                  ),
                ),
              
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    ),

    floatingActionButton: Visibility(visible: !durum,
          child: Container(width: 40*oran,height: 40*oran,
            child: FittedBox(
                        child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
                  );
                },
                backgroundColor: Colors.grey[700],
                child: Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ),
    ),
    
    );
        
        
        
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
