import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/genel_ayarlar/kontrol.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_2x0.dart';
import 'package:prokis/yardimci/deger_giris_3x0.dart';
import 'klepe_kalibrasyon.dart';
import 'package:prokis/languages/select.dart';

class KlepeKlasik extends StatefulWidget {
  List<Map> gelenDBveri;
  KlepeKlasik(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return KlepeKlasikState(gelenDBveri);
  }
}

class KlepeKlasikState extends State<KlepeKlasik> {
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
  List<String> calisanFanSayisi1 = new List(11);
  List<String> calisanFanSayisi2 = new List(11);
  List<String> calisanFanSayisi3 = new List(11);
  List<String> calisanFanSayisi4 = new List(11);
  List<String> klepeAciklik1 = new List(11);
  List<String> klepeAciklik2 = new List(11);
  List<String> klepeAciklik3 = new List(11);
  List<String> klepeAciklik4 = new List(11);
  List<String> minHavAciklikOrani = new List(11);

  String baglantiDurum="";
  String alarmDurum="00000000000000000000000000000000000000000000000000000000000000000000000000000000";


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  KlepeKlasikState(List<Map> dbVeri) {
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
      calisanFanSayisi1[i] = "0";
      calisanFanSayisi2[i] = "0";
      calisanFanSayisi3[i] = "0";
      calisanFanSayisi4[i] = "0";
      klepeAciklik1[i] = "0";
      klepeAciklik2[i] = "0";
      klepeAciklik3[i] = "0";
      klepeAciklik4[i] = "0";
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
final dbProkis = Provider.of<DBProkis>(context);
    if (timerSayac == 0) {

      Metotlar().takipEt('6*', 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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
          
          Metotlar().takipEt('6*', 2236).then((veri){
              if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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
                                    child: Container(color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv194"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv195"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv196"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv197"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv198"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv199"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(visible: int.parse(klepeAdet)>0,child: _klepeKlasikUnsur(oran, 1,dbProkis)),
                          Visibility(visible: int.parse(klepeAdet)>1,child: _klepeKlasikUnsur(oran, 2,dbProkis)),
                          Visibility(visible: int.parse(klepeAdet)>2,child: _klepeKlasikUnsur(oran, 3,dbProkis)),
                          Visibility(visible: int.parse(klepeAdet)>3,child: _klepeKlasikUnsur(oran, 4,dbProkis)),
                          Visibility(visible: int.parse(klepeAdet)>4,child: _klepeKlasikUnsur(oran, 5,dbProkis)),
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
                            flex: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: Visibility(visible: int.parse(klepeAdet)>5,
                                                          child: Column(
                                children: <Widget>[
                                  Spacer(flex: 4),
                                  Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv194"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                  Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv195"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                  Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv196"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                  Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv197"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                  Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[100],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv198"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                  Expanded(
                                  child: SizedBox(
                                    child: Container(color: Colors.grey[300],
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv199"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.black,
                                            fontSize: 60,),
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
                          Visibility(visible: int.parse(klepeAdet)>5,child: _klepeKlasikUnsur(oran, 6,dbProkis)),
                          Visibility(visible: int.parse(klepeAdet)>6,child: _klepeKlasikUnsur(oran, 7,dbProkis)),
                          Visibility(visible: int.parse(klepeAdet)>7,child: _klepeKlasikUnsur(oran, 8,dbProkis)),
                          Visibility(visible: int.parse(klepeAdet)>8,child: _klepeKlasikUnsur(oran, 9,dbProkis)),
                          Visibility(visible: int.parse(klepeAdet)>9,child: _klepeKlasikUnsur(oran, 10,dbProkis)),
                          Spacer(
                            flex: 4,
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
                                            "assets/images/diagram_klepe_klasik1.jpg"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  child: Container(
                                    width: 2,
                                    color: Colors.black,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            "assets/images/diagram_klepe_klasik2.jpg"),
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
                                  subtitle: Text(
                                    Dil()
                                        .sec(dilSecimi, "info7"),
                                    style: TextStyle(
                                      fontSize: 13 * oran,
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
                                        child: Text(Dil().sec(dilSecimi, "tv200"),
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
                                        child: Text(Dil().sec(dilSecimi, "tv201"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "C :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(Dil().sec(dilSecimi, "tv202"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "D :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(Dil().sec(dilSecimi, "tv203"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "E :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(Dil().sec(dilSecimi, "tv204"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "F :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(Dil().sec(dilSecimi, "tv205"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "G :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(Dil().sec(dilSecimi, "tv206"),
                                            textScaleFactor: oran,
                                            style: TextStyle(fontSize: 12))),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          "H :",
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        )),
                                    Expanded(
                                        flex: 5,
                                        child: Text(Dil().sec(dilSecimi, "tv207"),
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
                                        child: Text(Dil().sec(dilSecimi, "tv208"),
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
                                        child: Text(Dil().sec(dilSecimi, "tv209"),
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
                                        child: Text(Dil().sec(dilSecimi, "tv210"),
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
                                        child: Text(Dil().sec(dilSecimi, "tv211"),
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

  Future _degergiris2X0(int onlarUnsur, int birlerUnsur, int klepeIndex, int paramIndex,
      double oran, String dil, String baslik, DBProkis dbProkis) async {
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
      if (
          _onlar != val[0] ||
          _birler != val[1] ||
          _index != val[2]) {
          veriGonderilsinMi = true;
      }

      _onlar = val[0];
      _birler = val[1];
      _index = val[2];

      if(paramIndex==1){
        calisanFanSayisi1[klepeIndex]=(_yuzler*100+_onlar*10+_birler).toString();
      }else if(paramIndex==2){
        calisanFanSayisi2[klepeIndex]=(_yuzler*100+_onlar*10+_birler).toString();
      }else if(paramIndex==3){
        calisanFanSayisi3[klepeIndex]=(_yuzler*100+_onlar*10+_birler).toString();
      }else if(paramIndex==4){
        calisanFanSayisi4[klepeIndex]=(_yuzler*100+_onlar*10+_birler).toString();
      }

      String veri="";
      veri=calisanFanSayisi1[klepeIndex]+"#"+
      calisanFanSayisi2[klepeIndex]+"#"+
      klepeAciklik1[klepeIndex]+"#"+
      klepeAciklik2[klepeIndex]+"#"+
      calisanFanSayisi3[klepeIndex]+"#"+
      calisanFanSayisi4[klepeIndex]+"#"+
      klepeAciklik3[klepeIndex]+"#"+
      klepeAciklik4[klepeIndex]+"#"+
      minHavAciklikOrani[klepeIndex];

      



      if (veriGonderilsinMi) {

        yazmaSonrasiGecikmeSayaci = 0;
        String komut='6*$klepeIndex*$veri';
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('6*', 2236).then((veri){
                if(veri.split("*")[0]=="error"){
                  baglanti=false;
                  baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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


  Future _degergiris3X0(int yuzler , onlar , birler, klepeIndex,paramIndex, double oran,
      String dil, baslik, onBaslik, DBProkis dbProkis) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris3X0.Deger(
            yuzler,onlar, birler, klepeIndex, oran, dil, baslik, onBaslik);
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

      if(paramIndex==5){
        klepeAciklik1[klepeIndex]=(_yuzler*100+_onlar*10+_birler).toString();
      }else if(paramIndex==6){
        klepeAciklik2[klepeIndex]=(_yuzler*100+_onlar*10+_birler).toString();
      }else if(paramIndex==7){
        klepeAciklik3[klepeIndex]=(_yuzler*100+_onlar*10+_birler).toString();
      }else if(paramIndex==8){
        klepeAciklik4[klepeIndex]=(_yuzler*100+_onlar*10+_birler).toString();
      }else if(paramIndex==9){
        minHavAciklikOrani[klepeIndex]=(_yuzler*100+_onlar*10+_birler).toString();
      }

      String veri="";
      veri=calisanFanSayisi1[klepeIndex]+"#"+
      calisanFanSayisi2[klepeIndex]+"#"+
      klepeAciklik1[klepeIndex]+"#"+
      klepeAciklik2[klepeIndex]+"#"+
      calisanFanSayisi3[klepeIndex]+"#"+
      calisanFanSayisi4[klepeIndex]+"#"+
      klepeAciklik3[klepeIndex]+"#"+
      klepeAciklik4[klepeIndex]+"#"+
      minHavAciklikOrani[klepeIndex];

      



      if (veriGonderilsinMi) {

        yazmaSonrasiGecikmeSayaci = 0;
        String komut='6*$klepeIndex*$veri';
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('6*', 2236).then((veri){
                if(veri.split("*")[0]=="error"){
                  baglanti=false;
                  baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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

  takipEtVeriIsleme(String gelenMesaj){
    
    var degerler = gelenMesaj.split('*');
    print(degerler);
    print(yazmaSonrasiGecikmeSayaci);


    var gelenKlepe1=degerler[0].split('#');
    calisanFanSayisi1[1]=gelenKlepe1[0];
    calisanFanSayisi2[1]=gelenKlepe1[1];
    klepeAciklik1[1]=gelenKlepe1[2];
    klepeAciklik2[1]=gelenKlepe1[3];
    calisanFanSayisi3[1]=gelenKlepe1[4];
    calisanFanSayisi4[1]=gelenKlepe1[5];
    klepeAciklik3[1]=gelenKlepe1[6];
    klepeAciklik4[1]=gelenKlepe1[7];
    aktuelAciklik[1]=gelenKlepe1[8];
    minHavAciklikOrani[1]=gelenKlepe1[9];

    var gelenKlepe2=degerler[1].split('#');
    calisanFanSayisi1[2]=gelenKlepe2[0];
    calisanFanSayisi2[2]=gelenKlepe2[1];
    klepeAciklik1[2]=gelenKlepe2[2];
    klepeAciklik2[2]=gelenKlepe2[3];
    calisanFanSayisi3[2]=gelenKlepe2[4];
    calisanFanSayisi4[2]=gelenKlepe2[5];
    klepeAciklik3[2]=gelenKlepe2[6];
    klepeAciklik4[2]=gelenKlepe2[7];
    aktuelAciklik[2]=gelenKlepe2[8];
    minHavAciklikOrani[2]=gelenKlepe2[9];

    var gelenKlepe3=degerler[2].split('#');
    calisanFanSayisi1[3]=gelenKlepe3[0];
    calisanFanSayisi2[3]=gelenKlepe3[1];
    klepeAciklik1[3]=gelenKlepe3[2];
    klepeAciklik2[3]=gelenKlepe3[3];
    calisanFanSayisi3[3]=gelenKlepe3[4];
    calisanFanSayisi4[3]=gelenKlepe3[5];
    klepeAciklik3[3]=gelenKlepe3[6];
    klepeAciklik4[3]=gelenKlepe3[7];
    aktuelAciklik[3]=gelenKlepe3[8];
    minHavAciklikOrani[3]=gelenKlepe3[9];


    var gelenKlepe4=degerler[3].split('#');
    calisanFanSayisi1[4]=gelenKlepe4[0];
    calisanFanSayisi2[4]=gelenKlepe4[1];
    klepeAciklik1[4]=gelenKlepe4[2];
    klepeAciklik2[4]=gelenKlepe4[3];
    calisanFanSayisi3[4]=gelenKlepe4[4];
    calisanFanSayisi4[4]=gelenKlepe4[5];
    klepeAciklik3[4]=gelenKlepe4[6];
    klepeAciklik4[4]=gelenKlepe4[7];
    aktuelAciklik[4]=gelenKlepe4[8];
    minHavAciklikOrani[4]=gelenKlepe4[9];

    var gelenKlepe5=degerler[4].split('#');
    calisanFanSayisi1[5]=gelenKlepe5[0];
    calisanFanSayisi2[5]=gelenKlepe5[1];
    klepeAciklik1[5]=gelenKlepe5[2];
    klepeAciklik2[5]=gelenKlepe5[3];
    calisanFanSayisi3[5]=gelenKlepe5[4];
    calisanFanSayisi4[5]=gelenKlepe5[5];
    klepeAciklik3[5]=gelenKlepe5[6];
    klepeAciklik4[5]=gelenKlepe5[7];
    aktuelAciklik[5]=gelenKlepe5[8];
    minHavAciklikOrani[5]=gelenKlepe5[9];

    var gelenKlepe6=degerler[5].split('#');
    calisanFanSayisi1[6]=gelenKlepe6[0];
    calisanFanSayisi2[6]=gelenKlepe6[1];
    klepeAciklik1[6]=gelenKlepe6[2];
    klepeAciklik2[6]=gelenKlepe6[3];
    calisanFanSayisi3[6]=gelenKlepe6[4];
    calisanFanSayisi4[6]=gelenKlepe6[5];
    klepeAciklik3[6]=gelenKlepe6[6];
    klepeAciklik4[6]=gelenKlepe6[7];
    aktuelAciklik[6]=gelenKlepe6[8];
    minHavAciklikOrani[6]=gelenKlepe6[9];

    var gelenKlepe7=degerler[6].split('#');
    calisanFanSayisi1[7]=gelenKlepe7[0];
    calisanFanSayisi2[7]=gelenKlepe7[1];
    klepeAciklik1[7]=gelenKlepe7[2];
    klepeAciklik2[7]=gelenKlepe7[3];
    calisanFanSayisi3[7]=gelenKlepe7[4];
    calisanFanSayisi4[7]=gelenKlepe7[5];
    klepeAciklik3[7]=gelenKlepe7[6];
    klepeAciklik4[7]=gelenKlepe7[7];
    aktuelAciklik[7]=gelenKlepe7[8];
    minHavAciklikOrani[7]=gelenKlepe7[9];

    var gelenKlepe8=degerler[7].split('#');
    calisanFanSayisi1[8]=gelenKlepe8[0];
    calisanFanSayisi2[8]=gelenKlepe8[1];
    klepeAciklik1[8]=gelenKlepe8[2];
    klepeAciklik2[8]=gelenKlepe8[3];
    calisanFanSayisi3[8]=gelenKlepe8[4];
    calisanFanSayisi4[8]=gelenKlepe8[5];
    klepeAciklik3[8]=gelenKlepe8[6];
    klepeAciklik4[8]=gelenKlepe8[7];
    aktuelAciklik[8]=gelenKlepe8[8];
    minHavAciklikOrani[8]=gelenKlepe8[9];

    var gelenKlepe9=degerler[8].split('#');
    calisanFanSayisi1[9]=gelenKlepe9[0];
    calisanFanSayisi2[9]=gelenKlepe9[1];
    klepeAciklik1[9]=gelenKlepe9[2];
    klepeAciklik2[9]=gelenKlepe9[3];
    calisanFanSayisi3[9]=gelenKlepe9[4];
    calisanFanSayisi4[9]=gelenKlepe9[5];
    klepeAciklik3[9]=gelenKlepe9[6];
    klepeAciklik4[9]=gelenKlepe9[7];
    aktuelAciklik[9]=gelenKlepe9[8];
    minHavAciklikOrani[9]=gelenKlepe9[9];

    var gelenKlepe10=degerler[9].split('#');
    calisanFanSayisi1[10]=gelenKlepe10[0];
    calisanFanSayisi2[10]=gelenKlepe10[1];
    klepeAciklik1[10]=gelenKlepe10[2];
    klepeAciklik2[10]=gelenKlepe10[3];
    calisanFanSayisi3[10]=gelenKlepe10[4];
    calisanFanSayisi4[10]=gelenKlepe10[5];
    klepeAciklik3[10]=gelenKlepe10[6];
    klepeAciklik4[10]=gelenKlepe10[7];
    aktuelAciklik[10]=gelenKlepe10[8];
    minHavAciklikOrani[10]=gelenKlepe10[9];

    alarmDurum=degerler[10];
              


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 

  Widget _klepeKlasikUnsur(double oran, int klepeNo, DBProkis dbProkis) {
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
                                                  dilSecimi, "tv212")+Dil().sec(
                                                  dilSecimi, "tv192")+" $klepeNo",
                                                  textScaleFactor: oran,
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
                                                                Dil().sec(dilSecimi, "tv200"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor: oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi=int.parse(calisanFanSayisi1[klepeNo]);
                                                                  _index = klepeNo;
                                                                  _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                  _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                  _birler=sayi%10;

                                                                  _degergiris2X0(_onlar, _birler, _index, 1, oran, dilSecimi, "tv200",dbProkis).then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                  
                                                                  
                                                                },
                                                                color: Colors.blue[700],
                                                                child: Text(
                                                                  calisanFanSayisi1[klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',fontSize: 20,color: Colors.white),textScaleFactor: oran,
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
                                                                Dil().sec(dilSecimi, "tv204"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor: oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi=int.parse(klepeAciklik1[klepeNo]);
                                                                  print(sayi);
                                                                  _index = klepeNo;
                                                                  _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                  _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                  _birler=sayi%10;

                                                                  _degergiris3X0(_yuzler, _onlar, _birler, _index, 5, oran, dilSecimi, "tv204","",dbProkis).then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                },
                                                                color: Colors.blue[700],
                                                                child: Text(
                                                                  klepeAciklik1[klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',fontSize: 20,color: Colors.white),textScaleFactor: oran,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      
                                                      ],
                                                    ),
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
                                                                Dil().sec(dilSecimi, "tv201"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor: oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi=int.parse(calisanFanSayisi2[klepeNo]);
                                                                  _index = klepeNo;
                                                                  _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                  _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                  _birler=sayi%10;

                                                                  _degergiris2X0(_onlar, _birler, _index, 2, oran, dilSecimi, "tv201",dbProkis).then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                  
                                                                  
                                                                },
                                                                color: Colors.blue[700],
                                                                child: Text(
                                                                  calisanFanSayisi2[klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',fontSize: 20,color: Colors.white),textScaleFactor: oran,
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
                                                                Dil().sec(dilSecimi, "tv205"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor: oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi=int.parse(klepeAciklik2[klepeNo]);
                                                                  print(sayi);
                                                                  _index = klepeNo;
                                                                  _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                  _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                  _birler=sayi%10;
                                                                  print("$_yuzler  , $_onlar  , $_birler");

                                                                  _degergiris3X0(_yuzler, _onlar, _birler, _index, 6, oran, dilSecimi, "tv205","",dbProkis).then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                },
                                                                color: Colors.blue[700],
                                                                child: Text(
                                                                  klepeAciklik2[klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',fontSize: 20,color: Colors.white),textScaleFactor: oran,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      
                                                      ],
                                                    ),
                                                  ),
                                                  Container(width: 2,color: Colors.black,),
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
                                                                Dil().sec(dilSecimi, "tv202"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor: oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi=int.parse(calisanFanSayisi3[klepeNo]);
                                                                  _index = klepeNo;
                                                                  _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                  _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                  _birler=sayi%10;

                                                                  _degergiris2X0(_onlar, _birler, _index, 3, oran, dilSecimi, "tv202",dbProkis).then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                  
                                                                  
                                                                },
                                                                color: Colors.blue[700],
                                                                child: Text(
                                                                  calisanFanSayisi3[klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',fontSize: 20,color: Colors.white),textScaleFactor: oran,
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
                                                                Dil().sec(dilSecimi, "tv206"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor: oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi=int.parse(klepeAciklik3[klepeNo]);
                                                                  print(sayi);
                                                                  _index = klepeNo;
                                                                  _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                  _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                  _birler=sayi%10;
                                                                  print("$_yuzler  , $_onlar  , $_birler");

                                                                  _degergiris3X0(_yuzler, _onlar, _birler, _index, 7, oran, dilSecimi, "tv206","",dbProkis).then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                },
                                                                color: Colors.blue[700],
                                                                child: Text(
                                                                  klepeAciklik3[klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',fontSize: 20,color: Colors.white),textScaleFactor: oran,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      
                                                      ],
                                                    ),
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
                                                                Dil().sec(dilSecimi, "tv203"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor: oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi=int.parse(calisanFanSayisi4[klepeNo]);
                                                                  _index = klepeNo;
                                                                  _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                  _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                  _birler=sayi%10;

                                                                  _degergiris2X0(_onlar, _birler, _index, 4, oran, dilSecimi, "tv203",dbProkis).then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                  
                                                                  
                                                                },
                                                                color: Colors.blue[700],
                                                                child: Text(
                                                                  calisanFanSayisi4[klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',fontSize: 20,color: Colors.white),textScaleFactor: oran,
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
                                                                Dil().sec(dilSecimi, "tv207"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor: oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi=int.parse(klepeAciklik4[klepeNo]);
                                                                  print(sayi);
                                                                  _index = klepeNo;
                                                                  _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                  _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                  _birler=sayi%10;
                                                                  print("$_yuzler  , $_onlar  , $_birler");

                                                                  _degergiris3X0(_yuzler, _onlar, _birler, _index, 8, oran, dilSecimi, "tv207","",dbProkis).then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                },
                                                                color: Colors.blue[700],
                                                                child: Text(
                                                                  klepeAciklik4[klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',fontSize: 20,color: Colors.white),textScaleFactor: oran,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      
                                                      ],
                                                    ),
                                                  ),
                                                  Container(width: 2,color: Colors.black,),
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
                                                                Dil().sec(dilSecimi, "tv199"),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Kelly Slab"),
                                                                textScaleFactor: oran,
                                                              ),
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  int sayi=int.parse(minHavAciklikOrani[klepeNo]);
                                                                  _index = klepeNo;
                                                                  _yuzler=sayi<100 ? 0 : sayi~/100;
                                                                  _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                                  _birler=sayi%10;

                                                                  _degergiris3X0(_yuzler, _onlar, _birler, _index, 9, oran, dilSecimi, "tv199","",dbProkis).then((onValue){
                                                                    bottomDrawerIcindeGuncelle(state);
                                                                  });
                                                                },
                                                                color: Colors.blue[700],
                                                                child: Text(
                                                                  minHavAciklikOrani[klepeNo],
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          'Kelly Slab',fontSize: 20,color: Colors.white),textScaleFactor: oran,
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
                  Text(calisanFanSayisi1[klepeNo], textScaleFactor: oran),
                  Text(" - ", textScaleFactor: oran),
                  Text(calisanFanSayisi2[klepeNo], textScaleFactor: oran),
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
                  Text(klepeAciklik1[klepeNo], textScaleFactor: oran),
                  Text(" - ", textScaleFactor: oran),
                  Text(klepeAciklik2[klepeNo], textScaleFactor: oran),
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
                  Text(calisanFanSayisi3[klepeNo], textScaleFactor: oran),
                  Text(" - ", textScaleFactor: oran),
                  Text(calisanFanSayisi4[klepeNo], textScaleFactor: oran),
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
                  Text(klepeAciklik3[klepeNo], textScaleFactor: oran),
                  Text(" - ", textScaleFactor: oran),
                  Text(klepeAciklik4[klepeNo], textScaleFactor: oran),
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

