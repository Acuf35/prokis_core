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
import 'package:prokis/yardimci/deger_giris_2x1.dart';
import 'package:prokis/yardimci/deger_giris_3x0.dart';
import 'package:prokis/languages/select.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MinHavKlasik extends StatefulWidget {
  List<Map> gelenDBveri;
  MinHavKlasik(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return MinHavKlasikState(gelenDBveri);
  }
}

class MinHavKlasikState extends State<MinHavKlasik> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  String setSicA = "21.0";
  String fasilaSetSicC = "19.0";
  String fasilaSetSicD = "17.0";
  String fasilaSetSicE = "15.0";

  List<String> calismaSuresi = new List(5);
  List<String> durmaSuresi = new List(5);
  List<bool> fan = new List(5);

  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _ondalik = 0;
  int _index = 0;

  List<charts.Series> seriesList;
  bool animate;

  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci = 4;

  String baglantiDurum="";
  String alarmDurum="00000000000000000000000000000000000000000000000000000000000000000000000000000000";



//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  MinHavKlasikState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
    }

    for (int i = 0; i <= 4; i++) {
      calismaSuresi[i] = '180';
      durmaSuresi[i] = '120';
      fan[i]=false;
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
      
      Metotlar().takipEt('13*', 2236).then((veri){
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
          
          Metotlar().takipEt('13*', 2236).then((veri){
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
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv276',baglantiDurum, alarmDurum),
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
            child: Container(color: Colors.white,
              child: Column(
                children: <Widget>[
                  //Set ve süre girişleri ve Fan Aktifleştirme
                  Expanded(
                    flex: 22,
                    child: Row(
                      children: <Widget>[
                        //Set ve süre girişleri
                        Expanded(
                          flex: 8,
                          child: Column(
                            children: <Widget>[
                              Spacer(),
                              //Set Sıcaklığı
                              Expanded(
                                flex: 6,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Spacer(),
                                    //Fasıla Set 3
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv311"),
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  RawMaterialButton(
                                                    onPressed: () {
                                                      _index = 3;
                                                      _onlar = int.parse(fasilaSetSicE
                                                                      .toString()
                                                                      .split(
                                                                          ".")[
                                                                  0]) <
                                                              10
                                                          ? 0
                                                          : (int.parse(fasilaSetSicE
                                                                  .toString()
                                                                  .split(
                                                                      ".")[0]) ~/
                                                              10);
                                                      _birler = int.parse(
                                                              fasilaSetSicE
                                                                  .toString()
                                                                  .split(
                                                                      ".")[0]) %
                                                          10;
                                                      _ondalik = int.parse(
                                                          fasilaSetSicE
                                                              .toString()
                                                              .split(".")[1]);

                                                      _degergiris2X1(
                                                          _onlar,
                                                          _birler,
                                                          _ondalik,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv311",
                                                          "",dbProkis);
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: <Widget>[
                                                        LayoutBuilder(builder:
                                                            (context,
                                                                constraint) {
                                                          return Icon(
                                                            Icons
                                                                .brightness_1,
                                                            size: constraint
                                                                .biggest
                                                                .height,
                                                            color: Colors
                                                                .blue[700],
                                                          );
                                                        }),
                                                        Text(
                                                          fasilaSetSicE,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  25 * oran,
                                                              fontFamily:
                                                                  'Kelly Slab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    "°C",
                                                    textScaleFactor: oran,
                                                    style: TextStyle(
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    //Fasıla Set 2
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv310"),
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  RawMaterialButton(
                                                    onPressed: () {
                                                      _index = 2;
                                                      _onlar = int.parse(fasilaSetSicD
                                                                      .toString()
                                                                      .split(
                                                                          ".")[
                                                                  0]) <
                                                              10
                                                          ? 0
                                                          : (int.parse(fasilaSetSicD
                                                                  .toString()
                                                                  .split(
                                                                      ".")[0]) ~/
                                                              10);
                                                      _birler = int.parse(
                                                              fasilaSetSicD
                                                                  .toString()
                                                                  .split(
                                                                      ".")[0]) %
                                                          10;
                                                      _ondalik = int.parse(
                                                          fasilaSetSicD
                                                              .toString()
                                                              .split(".")[1]);

                                                      _degergiris2X1(
                                                          _onlar,
                                                          _birler,
                                                          _ondalik,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv310",
                                                          "",dbProkis);
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: <Widget>[
                                                        LayoutBuilder(builder:
                                                            (context,
                                                                constraint) {
                                                          return Icon(
                                                            Icons
                                                                .brightness_1,
                                                            size: constraint
                                                                .biggest
                                                                .height,
                                                            color: Colors
                                                                .red[700],
                                                          );
                                                        }),
                                                        Text(
                                                          fasilaSetSicD,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  25 * oran,
                                                              fontFamily:
                                                                  'Kelly Slab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    "°C",
                                                    textScaleFactor: oran,
                                                    style: TextStyle(
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    //Fasıla Set 1
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv309"),
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  RawMaterialButton(
                                                    onPressed: () {
                                                      _index = 1;
                                                      _onlar = int.parse(fasilaSetSicC
                                                                      .toString()
                                                                      .split(
                                                                          ".")[
                                                                  0]) <
                                                              10
                                                          ? 0
                                                          : (int.parse(fasilaSetSicC
                                                                  .toString()
                                                                  .split(
                                                                      ".")[0]) ~/
                                                              10);
                                                      _birler = int.parse(
                                                              fasilaSetSicC
                                                                  .toString()
                                                                  .split(
                                                                      ".")[0]) %
                                                          10;
                                                      _ondalik = int.parse(
                                                          fasilaSetSicC
                                                              .toString()
                                                              .split(".")[1]);

                                                      _degergiris2X1(
                                                          _onlar,
                                                          _birler,
                                                          _ondalik,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv309",
                                                          "",dbProkis);
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: <Widget>[
                                                        LayoutBuilder(builder:
                                                            (context,
                                                                constraint) {
                                                          return Icon(
                                                            Icons
                                                                .brightness_1,
                                                            size: constraint
                                                                .biggest
                                                                .height,
                                                            color: Colors
                                                                .orange[700],
                                                          );
                                                        }),
                                                        Text(
                                                          fasilaSetSicC,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  25 * oran,
                                                              fontFamily:
                                                                  'Kelly Slab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    "°C",
                                                    textScaleFactor: oran,
                                                    style: TextStyle(
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),                                   
                                    Spacer(),
                                    //SET SICAKLIĞI
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv115"),
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    setSicA,
                                                    style: TextStyle(
                                                        fontSize: 25 * oran,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .green[700]),
                                                  ),
                                                  Text(
                                                    "  °C",
                                                    textScaleFactor: oran,
                                                    style: TextStyle(
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              //Çalışma Süreleri
                              Expanded(
                                flex: 6,
                                child: Container(color: Colors.grey[300],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Spacer(),
                                      //Çalışma Süresi 4
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv315"),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:
                                                              'Kelly Slab',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    RawMaterialButton(
                                                      onPressed: () {
                                                        _index = 7;
                                                        int sayi=int.parse(calismaSuresi[4]);
                                                        _yuzler=sayi<100 ? 0 : sayi~/100;
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris3X0(
                                                            _yuzler,
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv315",
                                                            "",dbProkis);
                                                      },
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: <Widget>[
                                                          LayoutBuilder(builder:
                                                              (context,
                                                                  constraint) {
                                                            return Icon(
                                                              Icons.brightness_1,
                                                              size: constraint
                                                                  .biggest.height,
                                                              color: Colors
                                                                  .blue[800],
                                                            );
                                                          }),
                                                          Text(
                                                            calismaSuresi[4],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    25 * oran,
                                                                fontFamily:
                                                                    'Kelly Slab',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      Dil().sec(
                                                          dilSecimi, "tv238"),
                                                      textScaleFactor: oran,
                                                      style:
                                                          TextStyle(fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      //Çalışma Süresi 3
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv314"),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:
                                                              'Kelly Slab',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    RawMaterialButton(
                                                      onPressed: () {
                                                        _index = 6;
                                                        int sayi=int.parse(calismaSuresi[3]);
                                                        _yuzler=sayi<100 ? 0 : sayi~/100;
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris3X0(
                                                            _yuzler,
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv314",
                                                            "",dbProkis);
                                                      },
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: <Widget>[
                                                          LayoutBuilder(builder:
                                                              (context,
                                                                  constraint) {
                                                            return Icon(
                                                              Icons.brightness_1,
                                                              size: constraint
                                                                  .biggest.height,
                                                              color:
                                                                  Colors.red[700],
                                                            );
                                                          }),
                                                          Text(
                                                            calismaSuresi[3],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    25 * oran,
                                                                fontFamily:
                                                                    'Kelly Slab',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      Dil().sec(
                                                          dilSecimi, "tv238"),
                                                      textScaleFactor: oran,
                                                      style:
                                                          TextStyle(fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      //Çalışma Süresi 2
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv313"),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:
                                                              'Kelly Slab',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    RawMaterialButton(
                                                      onPressed: () {
                                                        _index = 5;
                                                        int sayi=int.parse(calismaSuresi[2]);
                                                        _yuzler=sayi<100 ? 0 : sayi~/100;
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris3X0(
                                                            _yuzler,
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv313",
                                                            "",dbProkis);
                                                      },
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: <Widget>[
                                                          LayoutBuilder(builder:
                                                              (context,
                                                                  constraint) {
                                                            return Icon(
                                                              Icons.brightness_1,
                                                              size: constraint
                                                                  .biggest.height,
                                                              color: Colors
                                                                  .orange[700],
                                                            );
                                                          }),
                                                          Text(
                                                            calismaSuresi[2],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    25 * oran,
                                                                fontFamily:
                                                                    'Kelly Slab',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      Dil().sec(
                                                          dilSecimi, "tv238"),
                                                      textScaleFactor: oran,
                                                      style:
                                                          TextStyle(fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      //Çalışma Süresi 1
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv312"),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:
                                                              'Kelly Slab',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      maxLines: 1,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    RawMaterialButton(
                                                      onPressed: () {
                                                        _index = 4;
                                                        int sayi=int.parse(calismaSuresi[1]);
                                                        _yuzler=sayi<100 ? 0 : sayi~/100;
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris3X0(
                                                            _yuzler,
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv312",
                                                            "",dbProkis);
                                                      },
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: <Widget>[
                                                          LayoutBuilder(builder:
                                                              (context,
                                                                  constraint) {
                                                            return Icon(
                                                              Icons.brightness_1,
                                                              size: constraint
                                                                  .biggest.height,
                                                              color: Colors
                                                                  .green[700],
                                                            );
                                                          }),
                                                          Text(
                                                            calismaSuresi[1],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    25 * oran,
                                                                fontFamily:
                                                                    'Kelly Slab',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      Dil().sec(
                                                          dilSecimi, "tv238"),
                                                      textScaleFactor: oran,
                                                      style:
                                                          TextStyle(fontSize: 14),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(child: Container(color: Colors.grey[300],),
                                flex: 1,
                              ),
                              //Durma Süreleri
                              Expanded(
                                flex: 6,
                                child: Container(color: Colors.grey[300],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Spacer(),
                                      //Durma Süresi 4
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv319"),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  RawMaterialButton(
                                                    onPressed: () {
                                                      _index = 11;
                                                      int sayi=int.parse(durmaSuresi[4]);
                                                      _yuzler=sayi<100 ? 0 : sayi~/100;
                                                      _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                      _birler=sayi%10;

                                                      _degergiris3X0(
                                                          _yuzler,
                                                          _onlar,
                                                          _birler,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv319",
                                                          "",dbProkis);
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: <Widget>[
                                                        LayoutBuilder(builder:
                                                            (context,
                                                                constraint) {
                                                          return Icon(
                                                            Icons.brightness_1,
                                                            size: constraint
                                                                .biggest.height,
                                                            color: Colors
                                                                .blue[800],
                                                          );
                                                        }),
                                                        Text(
                                                          durmaSuresi[4],
                                                          style: TextStyle(
                                                              fontSize:
                                                                  25 * oran,
                                                              fontFamily:
                                                                  'Kelly Slab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    Dil().sec(
                                                        dilSecimi, "tv238"),
                                                    textScaleFactor: oran,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      //Durma Süresi 3
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv318"),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  RawMaterialButton(
                                                    onPressed: () {
                                                      _index = 10;
                                                      int sayi=int.parse(durmaSuresi[3]);
                                                      _yuzler=sayi<100 ? 0 : sayi~/100;
                                                      _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                      _birler=sayi%10;

                                                      _degergiris3X0(
                                                          _yuzler,
                                                            _onlar,
                                                            _birler,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv318",
                                                          "",dbProkis);
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: <Widget>[
                                                        LayoutBuilder(builder:
                                                            (context,
                                                                constraint) {
                                                          return Icon(
                                                            Icons.brightness_1,
                                                            size: constraint
                                                                .biggest.height,
                                                            color:
                                                                Colors.red[700],
                                                          );
                                                        }),
                                                        Text(
                                                          durmaSuresi[3],
                                                          style: TextStyle(
                                                              fontSize:
                                                                  25 * oran,
                                                              fontFamily:
                                                                  'Kelly Slab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    Dil().sec(
                                                        dilSecimi, "tv238"),
                                                    textScaleFactor: oran,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      //Durma Süresi 2
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv317"),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  RawMaterialButton(
                                                    onPressed: () {
                                                      _index = 9;
                                                      int sayi=int.parse(durmaSuresi[2]);
                                                      _yuzler=sayi<100 ? 0 : sayi~/100;
                                                      _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                      _birler=sayi%10;

                                                      _degergiris3X0(
                                                          _yuzler,
                                                            _onlar,
                                                            _birler,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv317",
                                                          "",dbProkis);
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: <Widget>[
                                                        LayoutBuilder(builder:
                                                            (context,
                                                                constraint) {
                                                          return Icon(
                                                            Icons.brightness_1,
                                                            size: constraint
                                                                .biggest.height,
                                                            color: Colors
                                                                .orange[700],
                                                          );
                                                        }),
                                                        Text(
                                                          durmaSuresi[2],
                                                          style: TextStyle(
                                                              fontSize:
                                                                  25 * oran,
                                                              fontFamily:
                                                                  'Kelly Slab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    Dil().sec(
                                                        dilSecimi, "tv238"),
                                                    textScaleFactor: oran,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      //Durma Süresi 1
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv316"),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  RawMaterialButton(
                                                    onPressed: () {
                                                      _index = 8;
                                                      int sayi=int.parse(durmaSuresi[1]);
                                                      _yuzler=sayi<100 ? 0 : sayi~/100;
                                                      _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                      _birler=sayi%10;

                                                      _degergiris3X0(
                                                          _yuzler,
                                                            _onlar,
                                                            _birler,
                                                          _index,
                                                          oran,
                                                          dilSecimi,
                                                          "tv316",
                                                          "",dbProkis);
                                                    },
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: <Widget>[
                                                        LayoutBuilder(builder:
                                                            (context,
                                                                constraint) {
                                                          return Icon(
                                                            Icons.brightness_1,
                                                            size: constraint
                                                                .biggest.height,
                                                            color: Colors
                                                                .green[700],
                                                          );
                                                        }),
                                                        Text(
                                                          durmaSuresi[1],
                                                          style: TextStyle(
                                                              fontSize:
                                                                  25 * oran,
                                                              fontFamily:
                                                                  'Kelly Slab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    Dil().sec(
                                                        dilSecimi, "tv238"),
                                                    textScaleFactor: oran,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                        //Fan aktifleştirme bölümü
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      Dil().sec(dilSecimi, "tv324") + ' 1',
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: oran,
                                    ),
                                    RawMaterialButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                      onPressed: () {
                                        _index = 12;
                                        if (!fan[1]) {
                                          fan[1] = true;
                                        } else {
                                          fan[1] = false;
                                        }
                                        String veri =
                                            fan[1] == true ? "1" : "0";

                                        yazmaSonrasiGecikmeSayaci = 0;
                                        String komut="7*$_index*$veri";
                                        Metotlar().veriGonder(komut, 2235).then((value){
                                          if(value.split("*")[0]=="error"){
                                            Toast.show(Dil().sec(dilSecimi, "toast101"),context,duration:3);
                                          }else{
                                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                            
                                            baglanti = false;
                                            Metotlar().takipEt('13*', 2236).then((veri){
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

                                        setState(() {});
                                      },
                                      child: Icon(
                                          fan[1] == true
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: fan[1] == true
                                              ? Colors.green.shade500
                                              : Colors.blue.shade600,
                                          size: 30 * oran),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      Dil().sec(dilSecimi, "tv324") + ' 2',
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: oran,
                                    ),
                                    RawMaterialButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                      onPressed: () {
                                        _index = 13;
                                        if (!fan[2]) {
                                          fan[2] = true;
                                        } else {
                                          fan[2] = false;
                                        }
                                        String veri =
                                            fan[2] == true ? "1" : "0";

                                        yazmaSonrasiGecikmeSayaci = 0;
                                        String komut="7*$_index*$veri";
                                        Metotlar().veriGonder(komut, 2235).then((value){
                                          if(value.split("*")[0]=="error"){
                                            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                                          }else{
                                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                            
                                            baglanti = false;
                                            Metotlar().takipEt('13*', 2236).then((veri){
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

                                        setState(() {});
                                      },
                                      child: Icon(
                                          fan[2] == true
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: fan[2] == true
                                              ? Colors.green.shade500
                                              : Colors.blue.shade600,
                                          size: 30 * oran),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      Dil().sec(dilSecimi, "tv324") + ' 3',
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: oran,
                                    ),
                                    RawMaterialButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                      onPressed: () {
                                        _index = 14;
                                        if (!fan[3]) {
                                          fan[3] = true;
                                        } else {
                                          fan[3] = false;
                                        }
                                        String veri =
                                            fan[3] == true ? "1" : "0";

                                        yazmaSonrasiGecikmeSayaci = 0;
                                        String komut="7*$_index*$veri";
                                        Metotlar().veriGonder(komut, 2235).then((value){
                                          if(value.split("*")[0]=="error"){
                                            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                                          }else{
                                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                            
                                            baglanti = false;
                                            Metotlar().takipEt('13*', 2236).then((veri){
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

                                        setState(() {});
                                      },
                                      child: Icon(
                                          fan[3] == true
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: fan[3] == true
                                              ? Colors.green.shade500
                                              : Colors.blue.shade600,
                                          size: 30 * oran),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      Dil().sec(dilSecimi, "tv324") + ' 4',
                                      style: TextStyle(
                                          fontFamily: 'Kelly Slab',
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: oran,
                                    ),
                                    RawMaterialButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                      onPressed: () {
                                        _index = 15;
                                        if (!fan[4]) {
                                          fan[4] = true;
                                        } else {
                                          fan[4] = false;
                                        }
                                        String veri =
                                            fan[4] == true ? "1" : "0";

                                        yazmaSonrasiGecikmeSayaci = 0;
                                        String komut="7*$_index*$veri";
                                        Metotlar().veriGonder(komut, 2235).then((value){
                                          if(value.split("*")[0]=="error"){
                                            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                                          }else{
                                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                            
                                            baglanti = false;
                                            Metotlar().takipEt('13*', 2236).then((veri){
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

                                        setState(() {});
                                      },
                                      child: Icon(
                                          fan[4] == true
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color: fan[4] == true
                                              ? Colors.green.shade500
                                              : Colors.blue.shade600,
                                          size: 30 * oran),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  //Sıcaklık çizelgesi bölümü
                  Expanded(
                    flex: 6,
                    child: Row(
                      children: <Widget>[
                        Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 28,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil().sec(dilSecimi, "tv184"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab',
                                      ),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: charts.BarChart(
                                    _grafikDataLineerCapraz(
                                        double.parse(fasilaSetSicE),
                                        double.parse(fasilaSetSicD) -
                                            double.parse(fasilaSetSicE),
                                        double.parse(fasilaSetSicC) -
                                            double.parse(fasilaSetSicD),
                                        double.parse(setSicA) -
                                            double.parse(fasilaSetSicC),
                                        dilSecimi),
                                    domainAxis: new charts.OrdinalAxisSpec(
                                        renderSpec: new charts
                                                .SmallTickRendererSpec(

                                            // Tick and Label styling here.
                                            labelStyle: new charts
                                                    .TextStyleSpec(
                                                fontSize: (12 * oran)
                                                    .floor(), // size in Pts.
                                                color: charts
                                                    .MaterialPalette.black))),
                                    primaryMeasureAxis:
                                        new charts.NumericAxisSpec(
                                      showAxisLine: true,
                                      tickProviderSpec: new charts
                                          .StaticNumericTickProviderSpec(
                                        <charts.TickSpec<num>>[
                                          charts.TickSpec<num>(0),
                                          charts.TickSpec<num>(4),
                                          charts.TickSpec<num>(8),
                                          charts.TickSpec<num>(12),
                                          charts.TickSpec<num>(
                                              double.parse(fasilaSetSicE)),
                                          charts.TickSpec<num>(double.parse(
                                                  fasilaSetSicD) -
                                              double.parse(fasilaSetSicE)),
                                          charts.TickSpec<num>(
                                              double.parse(fasilaSetSicD)),
                                          charts.TickSpec<num>(
                                              double.parse(fasilaSetSicC)),
                                          charts.TickSpec<num>(
                                              double.parse(setSicA)),
                                          charts.TickSpec<num>(
                                              double.parse(setSicA) + 1),
                                          charts.TickSpec<num>(
                                              double.parse(setSicA) + 2),
                                        ],
                                      ),
                                      renderSpec: new charts
                                              .GridlineRendererSpec(
                                          labelRotation: 50,
                                          labelOffsetFromAxisPx:
                                              (1 * oran).round(),

                                          // Tick and Label styling here.
                                          labelStyle: new charts
                                                  .TextStyleSpec(
                                              fontSize: (8 * oran)
                                                  .round(), // size in Pts.
                                              color: charts
                                                  .MaterialPalette.black),

                                          // Change the line colors to match text color.
                                          lineStyle: new charts.LineStyleSpec(
                                              color: charts
                                                  .MaterialPalette.black)),
                                    ),
                                    behaviors: [
                                      new charts.SeriesLegend(),
                                      new charts.SlidingViewport(),
                                      new charts.PanAndZoomBehavior(),
                                    ],
                                    animate: animate,
                                    barGroupingType:
                                        charts.BarGroupingType.stacked,
                                    vertical: false,
                                  )),
                              Spacer()
                            ],
                          ),
                        ),
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
      floatingActionButton: Container(
        width: 56 * oran,
        height: 56 * oran,
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
                      Dil().sec(dilSecimi, "tv325"), 
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
                  flex: 7,
                  child: DrawerHeader(
                    padding: EdgeInsets.only(left: 10),
                    margin: EdgeInsets.all(0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.center,
                                image: AssetImage(
                                    'assets/images/diagram_mh_klasik.jpg'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.grey[100],
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "A",
                                                style: TextStyle(
                                                    fontSize: 13 * oran),
                                              ))),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "A+B",
                                                style: TextStyle(
                                                    fontSize: 13 * oran),
                                              ))),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "C",
                                                style: TextStyle(
                                                    fontSize: 13 * oran),
                                              ))),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "D",
                                                style: TextStyle(
                                                    fontSize: 13 * oran),
                                              ))),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "E",
                                                style: TextStyle(
                                                    fontSize: 13 * oran),
                                              ))),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "F",
                                                style: TextStyle(
                                                    fontSize: 13 * oran),
                                              ))),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "G",
                                                style: TextStyle(
                                                    fontSize: 13 * oran),
                                              ))),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "H",
                                                style: TextStyle(
                                                    fontSize: 13 * oran),
                                              ))),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "J",
                                                style: TextStyle(
                                                    fontSize: 13 * oran),
                                              ))),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "K",
                                                style: TextStyle(
                                                    fontSize: 10 * oran),
                                              ))),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(dilSecimi, "tv115"),
                                            style:
                                                TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(dilSecimi, "tv116"),
                                            style:
                                                TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(dilSecimi, "tv326"),
                                            style:
                                                TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(dilSecimi, "tv327"),
                                            style:
                                                TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(dilSecimi, "tv328"),
                                            style:
                                                TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(dilSecimi, "tv320"),
                                            style:
                                                TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(dilSecimi, "tv321"),
                                            style:
                                                TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(dilSecimi, "tv322"),
                                            style:
                                                TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(dilSecimi, "tv323"),
                                            style:
                                                TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(dilSecimi, "tv120"),
                                            style:
                                                TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
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
                          subtitle: Text(
                            Dil().sec(dilSecimi, "info17")+
                              Dil().sec(dilSecimi, "info14_2"),
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
              ],
            ),
          ),
        ),
      ),
    );
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

  Future _degergiris3X0(int yuzler , onlar , birler, index, double oran,
      String dil, baslik, onBaslik, DBProkis dbProkis) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris3X0.Deger(
            yuzler,onlar, birler, index, oran, dil, baslik, onBaslik);
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


      String veri = '';

      if (index == 4) {
        calismaSuresi[1]=(_yuzler*100+_onlar*10+_birler).toString();
        veri = calismaSuresi[1];
      }

      if (index == 5) {
        calismaSuresi[2]=(_yuzler*100+_onlar*10+_birler).toString();
        veri = calismaSuresi[2];
      }

      if (index == 6) {
        calismaSuresi[3]=(_yuzler*100+_onlar*10+_birler).toString();
        veri = calismaSuresi[3];
      }

      if (index == 7) {
        calismaSuresi[4]=(_yuzler*100+_onlar*10+_birler).toString();
        veri = calismaSuresi[4];
      }

      if (index == 8) {
        durmaSuresi[1]=(_yuzler*100+_onlar*10+_birler).toString();
        veri = durmaSuresi[1];
      }

      if (index == 9) {
        durmaSuresi[2]=(_yuzler*100+_onlar*10+_birler).toString();
        veri = durmaSuresi[2];
      }

      if (index == 10) {
        durmaSuresi[3]=(_yuzler*100+_onlar*10+_birler).toString();
        veri = durmaSuresi[3];
      }

      if (index == 11) {
        durmaSuresi[4]=(_yuzler*100+_onlar*10+_birler).toString();
        veri = durmaSuresi[4];
      }

      if (veriGonderilsinMi) {

        yazmaSonrasiGecikmeSayaci = 0;
        String komut="7*$_index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('13*', 2236).then((veri){
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


  Future _degergiris2X1(int onlar, birler, ondalik, index, double oran,
      String dil, baslik, onBaslik, DBProkis dbProkis) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X1.Deger(
            onlar, birler, ondalik, index, oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_onlar != val[0] ||
          _birler != val[1] ||
          _ondalik != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }
      _onlar = val[0];
      _birler = val[1];
      _ondalik = val[2];
      _index = val[3];

      String veri = '';
      if (index == 1) {
        fasilaSetSicC =
            _onlar.toString() + _birler.toString() + "." + _ondalik.toString();
        veri = fasilaSetSicC;
      }
      if (index == 2) {
        fasilaSetSicD = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
        veri = fasilaSetSicD;
      }
      if (index == 3) {
        fasilaSetSicE = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
        veri = fasilaSetSicE;
      }

      if (veriGonderilsinMi) {

        yazmaSonrasiGecikmeSayaci = 0;
        String komut="7*$_index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('13*', 2236).then((veri){
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

  static List<charts.Series<GrafikSicaklikCizelgesiLineerCapraz, String>>
      _grafikDataLineerCapraz(double fas1, fas2, fas3, fas4, String dil) {
    final fasilaBolge1 = [
      new GrafikSicaklikCizelgesiLineerCapraz(
          Dil().sec(dil, "tv183"), fas1, Colors.blue[700]),
    ];

    final fasilaBolge2 = [
      new GrafikSicaklikCizelgesiLineerCapraz(
          Dil().sec(dil, "tv183"), fas2, Colors.red[700]),
    ];

    final fasilaBolge3 = [
      new GrafikSicaklikCizelgesiLineerCapraz(
          Dil().sec(dil, "tv183"), fas3, Colors.orange[700]),
    ];

    final fasilaBolge4 = [
      new GrafikSicaklikCizelgesiLineerCapraz(
          Dil().sec(dil, "tv183"), fas4, Colors.green[700]),
    ];

    return [
      new charts.Series<GrafikSicaklikCizelgesiLineerCapraz, String>(
        id: Dil().sec(dil, "tv320"),
        domainFn: (GrafikSicaklikCizelgesiLineerCapraz deger, _) =>
            deger.baslik,
        measureFn: (GrafikSicaklikCizelgesiLineerCapraz deger, _) =>
            deger.deger,
        colorFn: (GrafikSicaklikCizelgesiLineerCapraz clickData, _) =>
            clickData.color,
        data: fasilaBolge1,
      ),
      new charts.Series<GrafikSicaklikCizelgesiLineerCapraz, String>(
        id: Dil().sec(dil, "tv321"),
        domainFn: (GrafikSicaklikCizelgesiLineerCapraz deger, _) =>
            deger.baslik,
        measureFn: (GrafikSicaklikCizelgesiLineerCapraz deger, _) =>
            deger.deger,
        colorFn: (GrafikSicaklikCizelgesiLineerCapraz clickData, _) =>
            clickData.color,
        data: fasilaBolge2,
      ),
      new charts.Series<GrafikSicaklikCizelgesiLineerCapraz, String>(
        id: Dil().sec(dil, "tv322"),
        domainFn: (GrafikSicaklikCizelgesiLineerCapraz deger, _) =>
            deger.baslik,
        measureFn: (GrafikSicaklikCizelgesiLineerCapraz deger, _) =>
            deger.deger,
        colorFn: (GrafikSicaklikCizelgesiLineerCapraz clickData, _) =>
            clickData.color,
        data: fasilaBolge3,
      ),
      new charts.Series<GrafikSicaklikCizelgesiLineerCapraz, String>(
        id: Dil().sec(dil, "tv323"),
        domainFn: (GrafikSicaklikCizelgesiLineerCapraz deger, _) =>
            deger.baslik,
        measureFn: (GrafikSicaklikCizelgesiLineerCapraz deger, _) =>
            deger.deger,
        colorFn: (GrafikSicaklikCizelgesiLineerCapraz clickData, _) =>
            clickData.color,
        data: fasilaBolge4,
      ),
    ];
  }

  takipEtVeriIsleme(String gelenMesaj){
    
    var degerler = gelenMesaj.split('*');
    print(degerler);
    print(yazmaSonrasiGecikmeSayaci);

    setSicA = degerler[0].substring(0,4);
    fasilaSetSicC = degerler[1];
    fasilaSetSicD = degerler[2];
    fasilaSetSicE = degerler[3];
    calismaSuresi[1] = degerler[4];
    calismaSuresi[2] = degerler[5];
    calismaSuresi[3] = degerler[6];
    calismaSuresi[4] = degerler[7];
    durmaSuresi[1] = degerler[8];
    durmaSuresi[2] = degerler[9];
    durmaSuresi[3] = degerler[10];
    durmaSuresi[4] = degerler[11];
    fan[1]=degerler[12]=='True' ? true: false;
    fan[2]=degerler[13]=='True' ? true: false;
    fan[3]=degerler[14]=='True' ? true: false;
    fan[4]=degerler[15]=='True' ? true: false;

    alarmDurum=degerler[16];


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 

  //--------------------------METOTLAR--------------------------------

}

class GrafikSicaklikCizelgesiLineerCapraz {
  final String baslik;
  final double deger;
  final charts.Color color;

  GrafikSicaklikCizelgesiLineerCapraz(this.baslik, this.deger, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
