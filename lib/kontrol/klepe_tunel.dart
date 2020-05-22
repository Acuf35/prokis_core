import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/genel_ayarlar/kontrol.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_2x0.dart';
import 'package:prokis/yardimci/deger_giris_3x0.dart';
import 'klepe_kalibrasyon.dart';
import 'package:prokis/languages/select.dart';

class KlepeTunel extends StatefulWidget {
  List<Map> gelenDBveri;
  KlepeTunel(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return KlepeTunelState(gelenDBveri);
  }
}

class KlepeTunelState extends State<KlepeTunel> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String klepeAdet = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _index = 0;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  List<String> aktuelAciklik = new List(11);
  List<String> klepeBasDusFanMik = new List(11);
  List<String> klepeBasDusFanMikMan = new List(11);
  List<String> klepeBasDusFanModu = new List(11);
  List<String> calismaSirasi = new List(11);
  List<String> minAciklik = new List(11);
  List<String> maksAciklik = new List(11);
  List<String> minHavAciklikOrani = new List(11);

  String baglantiDurum="";
  String alarmDurum="0";


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  KlepeTunelState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 37) {
        klepeAdet = dbVeri[i]["veri1"];
      }
    }

    for (int i = 1; i <= 10; i++) {
      aktuelAciklik[i] = "0";
      klepeBasDusFanMik[i] = "0";
      klepeBasDusFanMikMan[i] = "0";
      klepeBasDusFanModu[i] = "0";
      calismaSirasi[i] = "0";
      minAciklik[i] = "0";
      maksAciklik[i] = "0";
      minHavAciklikOrani[i] = "0";
    }
    

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

@override
  void dispose() {
    timerCancel=true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (timerSayac == 0) {

      Metotlar().takipEt('7*', 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
              setState(() {});
            }else{
              takipEtVeriIsleme(veri);
              baglantiDurum="";
            }
        });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          
          Metotlar().takipEt('7*', 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
              setState(() {});
            }else{
              takipEtVeriIsleme(veri);
              baglantiDurum="";
            }
        });

        }
      });
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv192',baglantiDurum, alarmDurum),
        body: Column(
          children: <Widget>[
            Row(
            children: <Widget>[
              Expanded(
                              child: Container(alignment: Alignment.centerLeft,color: Colors.grey[300],padding: EdgeInsets.only(left: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemTime(dbVeriler),
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
                            Metotlar().getSystemDate(dbVeriler),
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
              child: Container(
                padding: EdgeInsets.only(bottom: 10 * oran),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: <Widget>[
                                Spacer(flex: 4),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv194"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv213"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv214"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv215"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv216"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil()
                                            .sec(dilSecimi, "tv199"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontSize: 60,
                                        ),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: int.parse(klepeAdet) > 0,
                              child: _klepeKlasikUnsur(oran, 1)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 1,
                              child: _klepeKlasikUnsur(oran, 2)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 2,
                              child: _klepeKlasikUnsur(oran, 3)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 3,
                              child: _klepeKlasikUnsur(oran, 4)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 4,
                              child: _klepeKlasikUnsur(oran, 5)),
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    children: <Widget>[
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: RawMaterialButton(
                                          onPressed: () {

                                        timerCancel = true;
                                         Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => KlepeKalibrasyon(dbVeriler)),
                                          );

                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    color: Colors.white,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: AutoSizeText(
                                                      Dil().sec(dilSecimi, "tv241"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        color: Colors.black,
                                                        fontSize: 60,
                                                      ),
                                                      maxLines: 2,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      alignment:
                                                          Alignment.center,
                                                      image: AssetImage(
                                                          'assets/images/calibration_icon.png'),
                                                      fit: BoxFit.contain,
                                                    ),
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
                                Spacer()
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Spacer(
                            flex: 2,
                          ),
                          Expanded(
                            flex: 8,
                            child: Visibility(
                              visible: int.parse(klepeAdet) > 5,
                              child: Column(
                                children: <Widget>[
                                  Spacer(flex: 4),
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        color: Colors.grey[100],
                                        alignment: Alignment.centerRight,
                                        child: AutoSizeText(
                                          Dil().sec(
                                              dilSecimi, "tv194"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,
                                          ),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        color: Colors.grey[300],
                                        alignment: Alignment.centerRight,
                                        child: AutoSizeText(
                                          Dil().sec(
                                              dilSecimi, "tv213"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,
                                          ),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        color: Colors.grey[100],
                                        alignment: Alignment.centerRight,
                                        child: AutoSizeText(
                                          Dil().sec(
                                              dilSecimi, "tv214"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,
                                          ),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        color: Colors.grey[300],
                                        alignment: Alignment.centerRight,
                                        child: AutoSizeText(
                                          Dil().sec(
                                              dilSecimi, "tv215"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,
                                          ),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        color: Colors.grey[100],
                                        alignment: Alignment.centerRight,
                                        child: AutoSizeText(
                                          Dil().sec(
                                              dilSecimi, "tv216"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,
                                          ),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        color: Colors.grey[300],
                                        alignment: Alignment.centerRight,
                                        child: AutoSizeText(
                                          Dil().sec(
                                              dilSecimi, "tv199"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,
                                          ),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                              visible: int.parse(klepeAdet) > 5,
                              child: _klepeKlasikUnsur(oran, 6)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 6,
                              child: _klepeKlasikUnsur(oran, 7)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 7,
                              child: _klepeKlasikUnsur(oran, 8)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 8,
                              child: _klepeKlasikUnsur(oran, 9)),
                          Visibility(
                              visible: int.parse(klepeAdet) > 9,
                              child: _klepeKlasikUnsur(oran, 10)),
                          Spacer(
                            flex: 3,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Container(width: 56*oran,height: 56*oran,
                  child: FittedBox(
                                      child: FloatingActionButton(
            onPressed: () {
              timerCancel = true;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Kontrol(dbVeriler)),
              );
            },
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.arrow_back,
              size: 50,
              color: Colors.white,
            ),
          ),
                  ),
        ),
        drawer: Metotlar().navigatorMenu(dilSecimi, context, oran),
        endDrawer: SizedBox(width: 320*oran,
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
                        Dil().sec(
                            dilSecimi, "tv193"), //Sıcaklık diyagramı
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
                    flex: 5,
                    child: DrawerHeader(
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.all(0),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            "assets/images/diagram_klepe_tunel.jpg"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Container(
                            color: Colors.yellow[100],
                            child: ListView(
                              // Important: Remove any padding from the ListView.
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.only(
                                      left: 2 * oran, right: 2 * oran),
                                  dense: false,
                                  title: Text(
                                    Dil()
                                        .sec(dilSecimi, "tv186"),
                                    textScaleFactor: oran,
                                  ),
                                  subtitle: RichText(
                            text: TextSpan(
                              children: <TextSpan>[

                                //Giriş metni
                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info8"),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13*oran
                                  )
                                ),

                                TextSpan(
                                  text: '\n\n'+Dil().sec(dilSecimi, "tv673"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text:'\n'+ Dil().sec(dilSecimi, "ksltm38")+'\n\n'+
                                  Dil().sec(dilSecimi, "ksltm39")+'\n\n'+
                                  Dil().sec(dilSecimi, "ksltm40")+'\n\n'+
                                  Dil().sec(dilSecimi, "ksltm41")+'\n\n\n\n',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11*oran,
                                  )
                                ),
                                
                              ]
                            ),
                          ),
                        
                                  onTap: () {
                                    // Update the state of the app.
                                    // ...
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.grey[100],
                            padding:
                                EdgeInsets.only(left: 2 * oran, right: 2 * oran),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "A :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            Dil().sec(
                                                    dilSecimi, "tv223") +
                                                '\n' +
                                                Dil().sec(
                                                    dilSecimi, "tv231"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "B :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            Dil().sec(
                                                dilSecimi, "tv224"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "K1 :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            Dil().sec(
                                                dilSecimi, "tv225"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "L1 :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            Dil().sec(
                                                dilSecimi, "tv226"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "K2 :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            Dil().sec(
                                                dilSecimi, "tv227"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "L2 :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            Dil().sec(
                                                dilSecimi, "tv228"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "S1 :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            Dil().sec(
                                                dilSecimi, "tv229"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "S2 :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            Dil().sec(
                                                dilSecimi, "tv230"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "X :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            Dil().sec(
                                                dilSecimi, "tv210"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Y :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            Dil().sec(
                                                dilSecimi, "tv211"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
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

  Future _degergiris2X0(int onlarUnsur, int birlerUnsur, int klepeIndex,
      int paramIndex, double oran, String dil, String baslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X0.Deger(
            onlarUnsur, birlerUnsur, klepeIndex, oran, dil, baslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_onlar != val[0] || _birler != val[1] || _index != val[2]) {
        veriGonderilsinMi = true;
      }

      _onlar = val[0];
      _birler = val[1];
      _index = val[2];

      if (paramIndex == 1) {
        klepeBasDusFanMikMan[klepeIndex] =
            (_yuzler * 100 + _onlar * 10 + _birler).toString();
      } else if (paramIndex == 2) {
        calismaSirasi[klepeIndex] =
            (_yuzler * 100 + _onlar * 10 + _birler).toString();
      }

      String veri = "";
      veri = klepeBasDusFanMikMan[klepeIndex] +
          "#" +
          klepeBasDusFanModu[klepeIndex] +
          "#" +
          calismaSirasi[klepeIndex] +
          "#" +
          maksAciklik[klepeIndex] +
          "#" +
          minAciklik[klepeIndex] +
          "#" +
          minHavAciklikOrani[klepeIndex];

      if (veriGonderilsinMi) {

        yazmaSonrasiGecikmeSayaci = 0;
        String komut="7*$klepeIndex*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('7*', 2236).then((veri){
                if(veri.split("*")[0]=="error"){
                  baglanti=false;
                  baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                  setState(() {});
                }else{
                  takipEtVeriIsleme(veri);
                  baglantiDurum="";
                }
            });
          }
        });


      }
    });
  }

  Future _degergiris3X0(int yuzler, onlar, birler, klepeIndex, paramIndex,
      double oran, String dil, baslik, onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris3X0.Deger(
            yuzler, onlar, birler, klepeIndex, oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_yuzler != val[0] ||
          _onlar != val[1] ||
          _birler != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }
      _yuzler = val[0];
      _onlar = val[1];
      _birler = val[2];
      _index = val[3];

      if (paramIndex == 3) {
        maksAciklik[klepeIndex] =
            (_yuzler * 100 + _onlar * 10 + _birler).toString();
      } else if (paramIndex == 4) {
        minAciklik[klepeIndex] =
            (_yuzler * 100 + _onlar * 10 + _birler).toString();
      } else if (paramIndex == 5) {
        minHavAciklikOrani[klepeIndex] =
            (_yuzler * 100 + _onlar * 10 + _birler).toString();
      }

      String veri = "";
      veri = klepeBasDusFanMikMan[klepeIndex] +
          "#" +
          klepeBasDusFanModu[klepeIndex] +
          "#" +
          calismaSirasi[klepeIndex] +
          "#" +
          maksAciklik[klepeIndex] +
          "#" +
          minAciklik[klepeIndex] +
          "#" +
          minHavAciklikOrani[klepeIndex];

      if (veriGonderilsinMi) {

        yazmaSonrasiGecikmeSayaci = 0;
        String komut="7*$klepeIndex*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('7*', 2236).then((veri){
                if(veri.split("*")[0]=="error"){
                  baglanti=false;
                  baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                  setState(() {});
                }else{
                  takipEtVeriIsleme(veri);
                  baglantiDurum="";
                }
            });
          }
        });

      }

      setState(() {});
    });
  }

  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

  _veriGonder(String emir) async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2235).then((socket) {
        String gelen_mesaj = "";

        socket.add(utf8.encode(emir));

        socket.listen(
          (List<int> event) {
            print(utf8.decode(event));
            gelen_mesaj = utf8.decode(event);
            var gelen_mesaj_parcali = gelen_mesaj.split("*");

            if (gelen_mesaj_parcali[0] == 'ok') {
              Toast.show(
                  Dil().sec(dilSecimi, "toast8"), context,
                  duration: 2);
            } else {
              Toast.show(gelen_mesaj_parcali[0], context, duration: 2);
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            _takipEt();
            setState(() {});
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show(
            Dil().sec(dilSecimi, "toast20"), context,
            duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  _takipEt() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2236).then((socket) {
        socket.add(utf8.encode('7*'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);
            if (gelenMesaj != "") {
              var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              var gelenKlepe1 = degerler[0].split('#');
              aktuelAciklik[1] = gelenKlepe1[0];
              klepeBasDusFanMik[1] = gelenKlepe1[1];
              klepeBasDusFanModu[1] = gelenKlepe1[2] == "True" ? '1' : "0";
              calismaSirasi[1] = gelenKlepe1[3];
              maksAciklik[1] = gelenKlepe1[4];
              minAciklik[1] = gelenKlepe1[5];
              minHavAciklikOrani[1] = gelenKlepe1[6];

              var gelenKlepe2 = degerler[1].split('#');
              aktuelAciklik[2] = gelenKlepe2[0];
              klepeBasDusFanMik[2] = gelenKlepe2[1];
              klepeBasDusFanModu[2] = gelenKlepe2[2] == "True" ? '1' : "0";
              calismaSirasi[2] = gelenKlepe2[3];
              maksAciklik[2] = gelenKlepe2[4];
              minAciklik[2] = gelenKlepe2[5];
              minHavAciklikOrani[2] = gelenKlepe2[6];

              var gelenKlepe3 = degerler[2].split('#');
              aktuelAciklik[3] = gelenKlepe3[0];
              klepeBasDusFanMik[3] = gelenKlepe3[1];
              klepeBasDusFanModu[3] = gelenKlepe3[2] == "True" ? '1' : "0";
              calismaSirasi[3] = gelenKlepe3[3];
              maksAciklik[3] = gelenKlepe3[4];
              minAciklik[3] = gelenKlepe3[5];
              minHavAciklikOrani[3] = gelenKlepe3[6];

              var gelenKlepe4 = degerler[3].split('#');
              aktuelAciklik[4] = gelenKlepe4[0];
              klepeBasDusFanMik[4] = gelenKlepe4[1];
              klepeBasDusFanModu[4] = gelenKlepe4[2] == "True" ? '1' : "0";
              calismaSirasi[4] = gelenKlepe4[3];
              maksAciklik[4] = gelenKlepe4[4];
              minAciklik[4] = gelenKlepe4[5];
              minHavAciklikOrani[4] = gelenKlepe4[6];

              var gelenKlepe5 = degerler[4].split('#');
              aktuelAciklik[5] = gelenKlepe5[0];
              klepeBasDusFanMik[5] = gelenKlepe5[1];
              klepeBasDusFanModu[5] = gelenKlepe5[2] == "True" ? '1' : "0";
              calismaSirasi[5] = gelenKlepe5[3];
              maksAciklik[5] = gelenKlepe5[4];
              minAciklik[5] = gelenKlepe5[5];
              minHavAciklikOrani[5] = gelenKlepe5[6];

              var gelenKlepe6 = degerler[5].split('#');
              aktuelAciklik[6] = gelenKlepe6[0];
              klepeBasDusFanMik[6] = gelenKlepe6[1];
              klepeBasDusFanModu[6] = gelenKlepe6[2] == "True" ? '1' : "0";
              calismaSirasi[6] = gelenKlepe6[3];
              maksAciklik[6] = gelenKlepe6[4];
              minAciklik[6] = gelenKlepe6[5];
              minHavAciklikOrani[6] = gelenKlepe6[6];

              var gelenKlepe7 = degerler[6].split('#');
              aktuelAciklik[7] = gelenKlepe7[0];
              klepeBasDusFanMik[7] = gelenKlepe7[1];
              klepeBasDusFanModu[7] = gelenKlepe7[2] == "True" ? '1' : "0";
              calismaSirasi[7] = gelenKlepe7[3];
              maksAciklik[7] = gelenKlepe7[4];
              minAciklik[7] = gelenKlepe7[5];
              minHavAciklikOrani[7] = gelenKlepe7[6];

              var gelenKlepe8 = degerler[7].split('#');
              aktuelAciklik[8] = gelenKlepe8[0];
              klepeBasDusFanMik[8] = gelenKlepe8[1];
              klepeBasDusFanModu[8] = gelenKlepe8[2] == "True" ? '1' : "0";
              calismaSirasi[8] = gelenKlepe8[3];
              maksAciklik[8] = gelenKlepe8[4];
              minAciklik[8] = gelenKlepe8[5];
              minHavAciklikOrani[8] = gelenKlepe8[6];

              var gelenKlepe9 = degerler[8].split('#');
              aktuelAciklik[9] = gelenKlepe9[0];
              klepeBasDusFanMik[9] = gelenKlepe9[1];
              klepeBasDusFanModu[9] = gelenKlepe9[2] == "True" ? '1' : "0";
              calismaSirasi[9] = gelenKlepe9[3];
              maksAciklik[9] = gelenKlepe9[4];
              minAciklik[9] = gelenKlepe9[5];
              minHavAciklikOrani[9] = gelenKlepe9[6];

              var gelenKlepe10 = degerler[9].split('#');
              aktuelAciklik[10] = gelenKlepe10[0];
              klepeBasDusFanMik[10] = gelenKlepe10[1];
              klepeBasDusFanModu[10] = gelenKlepe10[2] == "True" ? '1' : "0";
              calismaSirasi[10] = gelenKlepe10[3];
              maksAciklik[10] = gelenKlepe10[4];
              minAciklik[10] = gelenKlepe10[5];
              minHavAciklikOrani[10] = gelenKlepe10[6];

              //socket.add(utf8.encode('ok'));
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            if (!timerCancel) {
              setState(() {});
            }
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show(
            Dil().sec(dilSecimi, "toast20"), context,
            duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  takipEtVeriIsleme(String gelenMesaj){
    
    var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              var gelenKlepe1 = degerler[0].split('#');
              aktuelAciklik[1] = gelenKlepe1[0];
              klepeBasDusFanMik[1] = gelenKlepe1[1];
              klepeBasDusFanModu[1] = gelenKlepe1[2] == "True" ? '1' : "0";
              calismaSirasi[1] = gelenKlepe1[3];
              maksAciklik[1] = gelenKlepe1[4];
              minAciklik[1] = gelenKlepe1[5];
              minHavAciklikOrani[1] = gelenKlepe1[6];

              var gelenKlepe2 = degerler[1].split('#');
              aktuelAciklik[2] = gelenKlepe2[0];
              klepeBasDusFanMik[2] = gelenKlepe2[1];
              klepeBasDusFanModu[2] = gelenKlepe2[2] == "True" ? '1' : "0";
              calismaSirasi[2] = gelenKlepe2[3];
              maksAciklik[2] = gelenKlepe2[4];
              minAciklik[2] = gelenKlepe2[5];
              minHavAciklikOrani[2] = gelenKlepe2[6];

              var gelenKlepe3 = degerler[2].split('#');
              aktuelAciklik[3] = gelenKlepe3[0];
              klepeBasDusFanMik[3] = gelenKlepe3[1];
              klepeBasDusFanModu[3] = gelenKlepe3[2] == "True" ? '1' : "0";
              calismaSirasi[3] = gelenKlepe3[3];
              maksAciklik[3] = gelenKlepe3[4];
              minAciklik[3] = gelenKlepe3[5];
              minHavAciklikOrani[3] = gelenKlepe3[6];

              var gelenKlepe4 = degerler[3].split('#');
              aktuelAciklik[4] = gelenKlepe4[0];
              klepeBasDusFanMik[4] = gelenKlepe4[1];
              klepeBasDusFanModu[4] = gelenKlepe4[2] == "True" ? '1' : "0";
              calismaSirasi[4] = gelenKlepe4[3];
              maksAciklik[4] = gelenKlepe4[4];
              minAciklik[4] = gelenKlepe4[5];
              minHavAciklikOrani[4] = gelenKlepe4[6];

              var gelenKlepe5 = degerler[4].split('#');
              aktuelAciklik[5] = gelenKlepe5[0];
              klepeBasDusFanMik[5] = gelenKlepe5[1];
              klepeBasDusFanModu[5] = gelenKlepe5[2] == "True" ? '1' : "0";
              calismaSirasi[5] = gelenKlepe5[3];
              maksAciklik[5] = gelenKlepe5[4];
              minAciklik[5] = gelenKlepe5[5];
              minHavAciklikOrani[5] = gelenKlepe5[6];

              var gelenKlepe6 = degerler[5].split('#');
              aktuelAciklik[6] = gelenKlepe6[0];
              klepeBasDusFanMik[6] = gelenKlepe6[1];
              klepeBasDusFanModu[6] = gelenKlepe6[2] == "True" ? '1' : "0";
              calismaSirasi[6] = gelenKlepe6[3];
              maksAciklik[6] = gelenKlepe6[4];
              minAciklik[6] = gelenKlepe6[5];
              minHavAciklikOrani[6] = gelenKlepe6[6];

              var gelenKlepe7 = degerler[6].split('#');
              aktuelAciklik[7] = gelenKlepe7[0];
              klepeBasDusFanMik[7] = gelenKlepe7[1];
              klepeBasDusFanModu[7] = gelenKlepe7[2] == "True" ? '1' : "0";
              calismaSirasi[7] = gelenKlepe7[3];
              maksAciklik[7] = gelenKlepe7[4];
              minAciklik[7] = gelenKlepe7[5];
              minHavAciklikOrani[7] = gelenKlepe7[6];

              var gelenKlepe8 = degerler[7].split('#');
              aktuelAciklik[8] = gelenKlepe8[0];
              klepeBasDusFanMik[8] = gelenKlepe8[1];
              klepeBasDusFanModu[8] = gelenKlepe8[2] == "True" ? '1' : "0";
              calismaSirasi[8] = gelenKlepe8[3];
              maksAciklik[8] = gelenKlepe8[4];
              minAciklik[8] = gelenKlepe8[5];
              minHavAciklikOrani[8] = gelenKlepe8[6];

              var gelenKlepe9 = degerler[8].split('#');
              aktuelAciklik[9] = gelenKlepe9[0];
              klepeBasDusFanMik[9] = gelenKlepe9[1];
              klepeBasDusFanModu[9] = gelenKlepe9[2] == "True" ? '1' : "0";
              calismaSirasi[9] = gelenKlepe9[3];
              maksAciklik[9] = gelenKlepe9[4];
              minAciklik[9] = gelenKlepe9[5];
              minHavAciklikOrani[9] = gelenKlepe9[6];

              var gelenKlepe10 = degerler[9].split('#');
              aktuelAciklik[10] = gelenKlepe10[0];
              klepeBasDusFanMik[10] = gelenKlepe10[1];
              klepeBasDusFanModu[10] = gelenKlepe10[2] == "True" ? '1' : "0";
              calismaSirasi[10] = gelenKlepe10[3];
              maksAciklik[10] = gelenKlepe10[4];
              minAciklik[10] = gelenKlepe10[5];
              minHavAciklikOrani[10] = gelenKlepe10[6];


              alarmDurum=degerler[10];


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 

  Widget _klepeKlasikUnsur(double oran, int klepeNo) {
    return Expanded(
      flex: 5,
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: RawMaterialButton(
                        onPressed: () {
                          showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, state) {
                                    return Container(
                                      color: Colors.orange,
                                      height: double.infinity,
                                      child: Column(
                                        children: <Widget>[
                                          //Başlık bölümü
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                                child: Text(
                                              Dil().sec(
                                                      dilSecimi, "tv212") +
                                                  Dil()
                                                      .sec(
                                                          dilSecimi, "tv192") +
                                                  " $klepeNo",
                                              style: TextStyle(
                                                  fontFamily: 'Kelly Slab',
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                          //Klasik Klepe Yönteminin parametre giriş  bölümü
                                          Expanded(
                                            flex: 10,
                                            child: Container(
                                              color: Colors.white,
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                Dil()
                                                                    .sec(
                                                                        dilSecimi,
                                                                        "tv222"),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor:
                                                                    oran,
                                                              ),
                                                              RawMaterialButton(
                                                                onPressed: () {
                                                                  bool deger =
                                                                      klepeBasDusFanModu[klepeNo] ==
                                                                              '1'
                                                                          ? true
                                                                          : false;
                                                                  if (deger) {
                                                                    klepeBasDusFanModu[
                                                                            klepeNo] =
                                                                        "0";
                                                                  } else {
                                                                    klepeBasDusFanModu[
                                                                            klepeNo] =
                                                                        "1";
                                                                  }

                                                                  bottomDrawerIcindeGuncelle(
                                                                      state);

                                                                  String veri =
                                                                      "";
                                                                  veri = klepeBasDusFanMikMan[klepeNo] +
                                                                      "#" +
                                                                      klepeBasDusFanModu[
                                                                          klepeNo] +
                                                                      "#" +
                                                                      calismaSirasi[
                                                                          klepeNo] +
                                                                      "#" +
                                                                      maksAciklik[
                                                                          klepeNo] +
                                                                      "#" +
                                                                      minAciklik[
                                                                          klepeNo] +
                                                                      "#" +
                                                                      minHavAciklikOrani[
                                                                          klepeNo];


                                                                  yazmaSonrasiGecikmeSayaci = 0;
                                                                  String komut="7*$klepeNo*$veri";
                                                                  Metotlar().veriGonder(komut, 2235).then((value){
                                                                    if(value.split("*")[0]=="error"){
                                                                      Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                    }else{
                                                                      Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                      
                                                                      baglanti = false;
                                                                      Metotlar().takipEt('7*', 2236).then((veri){
                                                                          if(veri.split("*")[0]=="error"){
                                                                            baglanti=false;
                                                                            baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                                                            setState(() {});
                                                                          }else{
                                                                            takipEtVeriIsleme(veri);
                                                                            baglantiDurum="";
                                                                          }
                                                                      });
                                                                    }
                                                                  });

                                                                  setState(
                                                                      () {});
                                                                },
                                                                child: Icon(
                                                                  klepeBasDusFanModu[
                                                                              klepeNo] ==
                                                                          "1"
                                                                      ? Icons
                                                                          .check_box
                                                                      : Icons
                                                                          .check_box_outline_blank,
                                                                  color: klepeBasDusFanModu[
                                                                              klepeNo] ==
                                                                          "1"
                                                                      ? Colors.green[
                                                                          600]
                                                                      : Colors
                                                                          .black,
                                                                  size:
                                                                      25 * oran,
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(0),
                                                                materialTapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                constraints:
                                                                    BoxConstraints(),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                Dil()
                                                                    .sec(
                                                                        dilSecimi,
                                                                        "tv217"),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor:
                                                                    oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  if (klepeBasDusFanModu[
                                                                          klepeNo] ==
                                                                      '1') {
                                                                    int sayi = int.parse(
                                                                        klepeBasDusFanMikMan[
                                                                            klepeNo]);
                                                                    print(sayi);
                                                                    _index =
                                                                        klepeNo;
                                                                    _yuzler = sayi <
                                                                            100
                                                                        ? 0
                                                                        : sayi ~/
                                                                            100;
                                                                    _onlar = sayi <
                                                                            10
                                                                        ? 0
                                                                        : (sayi > 99
                                                                            ? (sayi - 100 * _yuzler) ~/
                                                                                10
                                                                            : sayi ~/
                                                                                10);
                                                                    _birler =
                                                                        sayi %
                                                                            10;
                                                                    print(
                                                                        "$_yuzler  , $_onlar  , $_birler");

                                                                    _degergiris2X0(
                                                                            _onlar,
                                                                            _birler,
                                                                            _index,
                                                                            1,
                                                                            oran,
                                                                            dilSecimi,
                                                                            "tv217")
                                                                        .then(
                                                                            (onValue) {
                                                                      bottomDrawerIcindeGuncelle(
                                                                          state);
                                                                    });
                                                                  }
                                                                },
                                                                color: klepeBasDusFanModu[klepeNo] ==
                                                                        '1'
                                                                    ? Colors.blue[
                                                                        700]
                                                                    : Colors.grey[
                                                                        700],
                                                                child: Text(
                                                                  klepeBasDusFanMikMan[
                                                                      klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .white),
                                                                  textScaleFactor:
                                                                      oran,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                Dil()
                                                                    .sec(
                                                                        dilSecimi,
                                                                        "tv215"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor:
                                                                    oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi = int.parse(
                                                                      calismaSirasi[
                                                                          klepeNo]);
                                                                  _index =
                                                                      klepeNo;
                                                                  _yuzler = sayi <
                                                                          100
                                                                      ? 0
                                                                      : sayi ~/
                                                                          100;
                                                                  _onlar = sayi < 10
                                                                      ? 0
                                                                      : (sayi >
                                                                              99
                                                                          ? (sayi - 100 * _yuzler) ~/
                                                                              10
                                                                          : sayi ~/
                                                                              10);
                                                                  _birler =
                                                                      sayi % 10;

                                                                  _degergiris2X0(
                                                                          _onlar,
                                                                          _birler,
                                                                          _index,
                                                                          2,
                                                                          oran,
                                                                          dilSecimi,
                                                                          "tv215")
                                                                      .then(
                                                                          (onValue) {
                                                                    bottomDrawerIcindeGuncelle(
                                                                        state);
                                                                  });
                                                                },
                                                                color: Colors
                                                                    .blue[700],
                                                                child: Text(
                                                                  calismaSirasi[
                                                                      klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .white),
                                                                  textScaleFactor:
                                                                      oran,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                Dil()
                                                                    .sec(
                                                                        dilSecimi,
                                                                        "tv218"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor:
                                                                    oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi = int.parse(
                                                                      maksAciklik[
                                                                          klepeNo]);
                                                                  _index =
                                                                      klepeNo;
                                                                  _yuzler = sayi <
                                                                          100
                                                                      ? 0
                                                                      : sayi ~/
                                                                          100;
                                                                  _onlar = sayi < 10
                                                                      ? 0
                                                                      : (sayi >
                                                                              99
                                                                          ? (sayi - 100 * _yuzler) ~/
                                                                              10
                                                                          : sayi ~/
                                                                              10);
                                                                  _birler =
                                                                      sayi % 10;

                                                                  _degergiris3X0(
                                                                          _yuzler,
                                                                          _onlar,
                                                                          _birler,
                                                                          _index,
                                                                          3,
                                                                          oran,
                                                                          dilSecimi,
                                                                          "tv218",
                                                                          "")
                                                                      .then(
                                                                          (onValue) {
                                                                    bottomDrawerIcindeGuncelle(
                                                                        state);
                                                                  });
                                                                },
                                                                color: Colors
                                                                    .blue[700],
                                                                child: Text(
                                                                  maksAciklik[
                                                                      klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .white),
                                                                  textScaleFactor:
                                                                      oran,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                Dil()
                                                                    .sec(
                                                                        dilSecimi,
                                                                        "tv219"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor:
                                                                    oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi = int.parse(
                                                                      minAciklik[
                                                                          klepeNo]);
                                                                  print(sayi);
                                                                  _index =
                                                                      klepeNo;
                                                                  _yuzler = sayi <
                                                                          100
                                                                      ? 0
                                                                      : sayi ~/
                                                                          100;
                                                                  _onlar = sayi < 10
                                                                      ? 0
                                                                      : (sayi >
                                                                              99
                                                                          ? (sayi - 100 * _yuzler) ~/
                                                                              10
                                                                          : sayi ~/
                                                                              10);
                                                                  _birler =
                                                                      sayi % 10;
                                                                  print(
                                                                      "$_yuzler  , $_onlar  , $_birler");

                                                                  _degergiris3X0(
                                                                          _yuzler,
                                                                          _onlar,
                                                                          _birler,
                                                                          _index,
                                                                          4,
                                                                          oran,
                                                                          dilSecimi,
                                                                          "tv219",
                                                                          "")
                                                                      .then(
                                                                          (onValue) {
                                                                    bottomDrawerIcindeGuncelle(
                                                                        state);
                                                                  });
                                                                },
                                                                color: Colors
                                                                    .blue[700],
                                                                child: Text(
                                                                  minAciklik[
                                                                      klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .white),
                                                                  textScaleFactor:
                                                                      oran,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 2,
                                                    color: Colors.black,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                Dil()
                                                                    .sec(
                                                                        dilSecimi,
                                                                        "tv199"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor:
                                                                    oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi = int.parse(
                                                                      minHavAciklikOrani[
                                                                          klepeNo]);
                                                                  _index =
                                                                      klepeNo;
                                                                  _yuzler = sayi <
                                                                          100
                                                                      ? 0
                                                                      : sayi ~/
                                                                          100;
                                                                  _onlar = sayi < 10
                                                                      ? 0
                                                                      : (sayi >
                                                                              99
                                                                          ? (sayi - 100 * _yuzler) ~/
                                                                              10
                                                                          : sayi ~/
                                                                              10);
                                                                  _birler =
                                                                      sayi % 10;

                                                                  _degergiris3X0(
                                                                          _yuzler,
                                                                          _onlar,
                                                                          _birler,
                                                                          _index,
                                                                          5,
                                                                          oran,
                                                                          dilSecimi,
                                                                          "tv199",
                                                                          "")
                                                                      .then(
                                                                          (onValue) {
                                                                    bottomDrawerIcindeGuncelle(
                                                                        state);
                                                                  });
                                                                },
                                                                color: Colors
                                                                    .blue[700],
                                                                child: Text(
                                                                  minHavAciklikOrani[
                                                                      klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .white),
                                                                  textScaleFactor:
                                                                      oran,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            LayoutBuilder(builder: (context, constraint) {
                              return Icon(
                                Icons.brightness_1,
                                size: constraint.biggest.height,
                                color: Colors.green[900],
                              );
                            }),
                            Text(
                              Dil()
                                      .sec(dilSecimi, "tv192") +
                                  "\n" +
                                  klepeNo.toString(),
                              style: TextStyle(
                                  fontSize: 14 * oran,
                                  fontFamily: 'Kelly Slab',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            child: Container(
              child: Text(aktuelAciklik[klepeNo], textScaleFactor: oran),
              alignment: Alignment.center,
              color: Colors.grey[100],
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(klepeBasDusFanMik[klepeNo], textScaleFactor: oran),
                ],
              ),
              alignment: Alignment.centerRight,
              color: Colors.grey[300],
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      klepeBasDusFanModu[klepeNo] == '0'
                          ? Dil().sec(dilSecimi, "tv220")
                          : Dil().sec(dilSecimi, "tv221"),
                      textScaleFactor: oran),
                ],
              ),
              alignment: Alignment.centerRight,
              color: Colors.grey[100],
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(calismaSirasi[klepeNo], textScaleFactor: oran),
                ],
              ),
              alignment: Alignment.centerRight,
              color: Colors.grey[300],
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(minAciklik[klepeNo], textScaleFactor: oran),
                  Text(" - ", textScaleFactor: oran),
                  Text(maksAciklik[klepeNo], textScaleFactor: oran),
                ],
              ),
              alignment: Alignment.centerRight,
              color: Colors.grey[100],
            ),
          ),
          Expanded(
            child: Container(
              child: Text(minHavAciklikOrani[klepeNo], textScaleFactor: oran),
              alignment: Alignment.center,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
  //--------------------------METOTLAR--------------------------------

}
