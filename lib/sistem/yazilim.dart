import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar/sistem.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';

class Yazilim extends StatefulWidget {
  List<Map> gelenDBveri;
  Yazilim(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return YazilimState(gelenDBveri);
  }
}

class YazilimState extends State<Yazilim> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  String baglantiDurum="";

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  YazilimState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
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

    var oran = MediaQuery.of(context).size.width / 731.4;
    final dbProkis = Provider.of<DBProkis>(context);
    

    return Scaffold(
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv677',Colors.grey[600],baglantiDurum),
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
        child: FittedBox(
                    child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Sistem()),
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
    
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                              child: Container(alignment: Alignment.centerLeft,color: Colors.grey[300],padding: EdgeInsets.only(left: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemTime(dbProkis.getDbVeri),
                            style: TextStyle(
                                  color: Colors.blue[800],
                                  fontFamily: 'Kelly Slab',
                                  fontSize: 12*oran,
                                  fontWeight: FontWeight.bold),
                          );
                        }),
                              ),
              ),
              
              Expanded(
                              child: Container(alignment: Alignment.centerRight,color: Colors.grey[300],padding: EdgeInsets.only(right: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemDate(dbProkis.getDbVeri),
                            style: TextStyle(
                                  color: Colors.blue[800],
                                  fontFamily: 'Kelly Slab',
                                  fontSize: 12*oran,
                                  fontWeight: FontWeight.bold),
                          );
                        }),
                              ),
              ),
            ],
          ),
          
          Expanded(
            flex: 40,
            child: Column(
              children: <Widget>[
                Spacer(),
                Expanded(flex: 1,
                  child: SizedBox(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        Dil().sec(dilSecimi, "tv678"),
                        
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.grey,
                          decoration: TextDecoration.underline
                        ),
                        maxLines: 1,
                        

                      ),
                    ),
                  ),
                ),
                Expanded(flex: 3,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Expanded(flex: 4,
                                              child: SizedBox(
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: AutoSizeText(
                              Dil().sec(dilSecimi, "tv679"),
                              style: TextStyle(
                                fontFamily: 'Audio wide',
                                fontSize: 50,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,

                            ),
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                Spacer(),
                Expanded(flex: 1,
                  child: SizedBox(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                          Dil().sec(dilSecimi, "tv680"),
                        
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.grey,
                          decoration: TextDecoration.underline
                        ),
                        maxLines: 1,
                        

                      ),
                    ),
                  ),
                ),
                Expanded(flex: 3,
                  child: SizedBox(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: AutoSizeText(
                        Dil().sec(dilSecimi, "tv681"),
                        style: TextStyle(
                          fontFamily: 'Audio wide',
                          fontSize: 50,
                        ),
                        maxLines: 1,

                      ),
                    ),
                  ),
                ),
                Spacer(),
                Expanded(flex: 1,
                  child: SizedBox(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        Dil().sec(dilSecimi, "tv682"),
                        
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.grey,
                          decoration: TextDecoration.underline
                        ),
                        maxLines: 1,
                        

                      ),
                    ),
                  ),
                ),
                Expanded(flex: 3,
                  child: SizedBox(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: AutoSizeText(
                        Dil().sec(dilSecimi, "tv683"),
                        style: TextStyle(
                          fontFamily: 'Audio wide',
                          fontSize: 50,
                        ),
                        maxLines: 1,

                      ),
                    ),
                  ),
                ),
                Spacer()
                
                
              ],
            ),
          )
        ],
      ),
      endDrawer: SizedBox(
        width: 320 * oran,
        child: Drawer(
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      Dil().sec(dilSecimi, "tv677"), 
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: 'Kelly Slab',
                      ),
                      textScaleFactor: oran,
                    ),
                    color: Colors.yellow[700],
                  ),
                ),
                Expanded(
                  flex: 17,
                  child: Container(
                    color: Colors.yellow[100],
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        ListTile(
                          dense: false,
                          title: Text(
                            Dil().sec(dilSecimi, "tv186"),
                            textScaleFactor: oran,
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                //Giriş metni
                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info47"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),
                              ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
     
      );
  }

  _satirlar(List<Map> satirlar) {
    dbVeriler = satirlar;
  }

  _dbVeriCekme(){
    dbSatirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => dbSatirSayisi = satirSayisi);
    satirSayisi.whenComplete(() {
      dbSatirlar.then((List<Map> satir) => _satirlar(satir));
    });
  }



}





