import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel/metotlar.dart';
import 'package:prokis/kontrol.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x0.dart';
import 'genel/deger_giris_2x1.dart';
import 'genel/deger_giris_3x0.dart';
import 'languages/select.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Aydinlatma extends StatefulWidget {
  List<Map> gelenDBveri;
  Aydinlatma(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return AydinlatmaState(gelenDBveri);
  }
}

class AydinlatmaState extends State<Aydinlatma> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String dimmerVarMi = "0";
  List<Map> dbVeriler;


  String gunduzAydinlikYuzdesi1 = "75";
  String geceAydinlikYuzdesi1 = "0";
  String gunduzAydinlikYuzdesi2 = "75";
  String geceAydinlikYuzdesi2 = "0";
  String dogusBatisSuresi = "180";


  String acSaati1Saat="07";
  String acSaati1Dakika="00";
  String acSaati2Saat="09";
  String acSaati2Dakika="00";
  String kapaSaati1Saat="18";
  String kapaSaati1Dakika="00";
  String kapaSaati2Saat="20";
  String kapaSaati2Dakika="00";

  String anlikAydinlikYuzdesi="40.0";

  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _index = 0;

  List<charts.Series> seriesList;
  bool animate;

  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci = 4;

  bool acKapaSaati2Aktiflik=false;

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  AydinlatmaState(List<Map> dbVeri) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 31) {
        dimmerVarMi = dbVeri[i]["veri4"];
      }
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    if (timerSayac == 0) {
      _takipEt();

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          _takipEt();
        }
      });
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;
    

    return Scaffold(
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv112'),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                              child: Container(alignment: Alignment.centerLeft,color: Colors.grey[300],padding: EdgeInsets.only(left: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemTime(),
                            style: TextStyle(
                                  color: Colors.grey[700],
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
                            Metotlar().getSystemDate(),
                            style: TextStyle(
                                  color: Colors.grey[700],
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
                  Expanded(
                    flex: 22,
                    child: Row(
                      children: <Widget>[
                        //Set ve süre girişleri
                        Expanded(flex: 8,
                          child: Column(
                            children: <Widget>[
                              Spacer(),
                              //Gece ve Gündüz Aydınlık Yüzdesi
                              Visibility(visible: dimmerVarMi=='1' ? true : false,
                                child: Expanded(
                                  flex: 6,
                                  child: Container(color: Colors.blue[100],
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Spacer(),
                                        //Gece-Gündüz Aydınlık yüzdesi 1
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
                                                            dilSecimi, "tv335"),
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
                                                          int sayi=int.parse(gunduzAydinlikYuzdesi1);
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
                                                              "tv343",
                                                              "");
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
                                                              gunduzAydinlikYuzdesi1,
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
                                                        "%",
                                                        textScaleFactor: oran,
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      RawMaterialButton(
                                                        onPressed: () {
                                                          _index = 2;
                                                          int sayi=int.parse(geceAydinlikYuzdesi1);
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
                                                              "tv345",
                                                              "");
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
                                                                    .black,
                                                              );
                                                            }),
                                                            Text(
                                                              geceAydinlikYuzdesi1,
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
                                                        "%",
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
                                        Spacer(flex: 2,),
                                       
                                        //Gece-Gündüz Aydınlık yüzdesi 2
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
                                                            dilSecimi, "tv336"),
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
                                                          if(acKapaSaati2Aktiflik){
                                                          _index = 1;
                                                          int sayi=int.parse(gunduzAydinlikYuzdesi2);
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
                                                              "tv344",
                                                              "");
                                                          }else{
                                                            Toast.show(Dil().sec(dilSecimi, "toast74"), context);
                                                          }
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
                                                                color: acKapaSaati2Aktiflik ? Colors.blue[700] : Colors.grey[700],
                                                              );
                                                            }),
                                                            Text(
                                                              gunduzAydinlikYuzdesi2,
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
                                                        "%",
                                                        textScaleFactor: oran,
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      RawMaterialButton(
                                                        onPressed: () {
                                                          if(acKapaSaati2Aktiflik){
                                                          _index = 2;
                                                          int sayi=int.parse(geceAydinlikYuzdesi2);
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
                                                              "tv346",
                                                              "");
                                                          }else{
                                                            Toast.show(Dil().sec(dilSecimi, "toast74"), context);
                                                          }
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
                                                                color: acKapaSaati2Aktiflik ? Colors.black : Colors.grey[700],
                                                              );
                                                            }),
                                                            Text(
                                                              geceAydinlikYuzdesi2,
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
                                                        "%",
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
                                ),
                              ),
                              Expanded(child: Container(color: dimmerVarMi=="1" ? Colors.white : Colors.white,),
                                flex: 1,
                              ),
                              //Aç Saatleri
                              Expanded(
                                flex: 6,
                                child: Container(color:dimmerVarMi=="1" ? Colors.blue[100] : Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Spacer(),
                                      //Aç Saati 1
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
                                                          dilSecimi, "tv329"),
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
                                                        int sayi=int.parse(acSaati1Saat);
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris2X0(
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv338",);
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
                                                                  .green[800],
                                                            );
                                                          }),
                                                          Text(
                                                            acSaati1Saat,
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
                                                      ":",
                                                      textScaleFactor: oran,
                                                      style:
                                                          TextStyle(fontSize: 34,fontFamily: 'Audio wide'),
                                                    ),
                                                    RawMaterialButton(
                                                      onPressed: () {
                                                        _index = 5;
                                                        int sayi=int.parse(acSaati1Dakika);
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris2X0(
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv339",);
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
                                                            acSaati1Dakika,
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
                                                    
                                            
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(flex: 2,child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(dilSecimi, "tv333"),textAlign: TextAlign.center,
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
                                              if (!acKapaSaati2Aktiflik) {
                                                acKapaSaati2Aktiflik = true;
                                              } else {
                                                acKapaSaati2Aktiflik = false;
                                              }
                                              String veri =
                                                  acKapaSaati2Aktiflik == true ? "1" : "0";
                                              _veriGonder("15*$_index*$veri");
                                              setState(() {});
                                            },
                                            child: Icon(
                                                acKapaSaati2Aktiflik == true
                                                    ? Icons.check_box
                                                    : Icons.check_box_outline_blank,
                                                color: acKapaSaati2Aktiflik == true
                                                    ? Colors.green.shade500
                                                    : Colors.black,
                                                size: 30 * oran),
                                          ),
                                        ],
                                      ),
                              ),
                                      //Aç Saati 2
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
                                                          dilSecimi, "tv330"),
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
                                                        if(acKapaSaati2Aktiflik){
                                                        _index = 6;
                                                        int sayi=int.parse(acSaati2Saat);
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris2X0(
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv338",);
                                                        }else{
                                                          Toast.show(Dil().sec(dilSecimi, "toast74"), context,duration: 3);
                                                        }
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
                                                              color: acKapaSaati2Aktiflik ? Colors.green[700] : Colors.grey[700],
                                                            );
                                                          }),
                                                          Text(
                                                            acSaati2Saat,
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
                                                      ":",
                                                      textScaleFactor: oran,
                                                      style:
                                                          TextStyle(fontSize: 34,fontFamily: 'Audio wide'),
                                                    ),
                                                    RawMaterialButton(
                                                      onPressed: () {
                                                        if(acKapaSaati2Aktiflik){
                                                        _index = 7;
                                                        int sayi=int.parse(acSaati2Dakika);
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris2X0(
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv339",);
                                                        }else{
                                                          Toast.show(Dil().sec(dilSecimi, "toast74"), context,duration: 3);
                                                        }
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
                                                              color: acKapaSaati2Aktiflik ? Colors.red[700] : Colors.grey[700],
                                                            );
                                                          }),
                                                          Text(
                                                            acSaati2Dakika,
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
                              Expanded(child: Container(color: dimmerVarMi=="1" ? Colors.blue[100] : Colors.white,),
                                flex: 1,
                              ),
                              //Kapa Saatleri
                              Expanded(
                                flex: 6,
                                child: Container(color: dimmerVarMi=="1" ? Colors.blue[100] : Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Spacer(),
                                      //Kapa Saati 1
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
                                                          dilSecimi, "tv331"),
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
                                                        int sayi=int.parse(kapaSaati1Saat);
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris2X0(
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv338",);
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
                                                                  .green[800],
                                                            );
                                                          }),
                                                          Text(
                                                            kapaSaati1Saat,
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
                                                      ":",
                                                      textScaleFactor: oran,
                                                      style:
                                                          TextStyle(fontSize: 34,fontFamily: 'Audio wide'),
                                                    ),
                                                    RawMaterialButton(
                                                      onPressed: () {
                                                        _index = 9;
                                                        int sayi=int.parse(kapaSaati1Dakika);
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris2X0(
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv339",);
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
                                                            kapaSaati1Dakika,
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
                                                    
                                            
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Spacer(flex: 2,),
                                      //Kapa Saati 2
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
                                                          dilSecimi, "tv332"),
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
                                                        if(acKapaSaati2Aktiflik){
                                                        _index = 10;
                                                        int sayi=int.parse(kapaSaati2Saat);
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris2X0(
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv338",);
                                                        }else{
                                                          Toast.show(Dil().sec(dilSecimi, "toast74"), context,duration: 3);
                                                        }
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
                                                              color: acKapaSaati2Aktiflik ? Colors.green[700] : Colors.grey[700],
                                                            );
                                                          }),
                                                          Text(
                                                            kapaSaati2Saat,
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
                                                      ":",
                                                      textScaleFactor: oran,
                                                      style:
                                                          TextStyle(fontSize: 34,fontFamily: 'Audio wide'),
                                                    ),
                                                    RawMaterialButton(
                                                      onPressed: () {
                                                        if(acKapaSaati2Aktiflik){
                                                        _index = 11;
                                                        int sayi=int.parse(kapaSaati2Dakika);
                                                        _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                        _birler=sayi%10;

                                                        _degergiris2X0(
                                                            _onlar,
                                                            _birler,
                                                            _index,
                                                            oran,
                                                            dilSecimi,
                                                            "tv339",);
                                                        }else{
                                                          Toast.show(Dil().sec(dilSecimi, "toast74"), context,duration: 3);
                                                        }
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
                                                              color: acKapaSaati2Aktiflik ? Colors.red[700] : Colors.grey[700],
                                                            );
                                                          }),
                                                          Text(
                                                            kapaSaati2Dakika,
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
                              Spacer(
                                flex: dimmerVarMi=="1" ? 1 : 6,
                              ),
                            ],
                          ),
                        ),
                        Visibility(visible: dimmerVarMi=="1" ? true : false,
                                                  child: Expanded(
                            child: Column(
                            children: <Widget>[
                              Spacer(flex: 5,),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: AutoSizeText(
                                                Dil().sec(
                                                    dilSecimi, "tv337"),
                                                textAlign:
                                                    TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 50.0,
                                                    fontFamily:
                                                        'Kelly Slab',
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 2,
                                                minFontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              RawMaterialButton(
                                                onPressed: () {
                                                  _index = 3;
                                                  int sayi=int.parse(dogusBatisSuresi);
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
                                                      "tv337",
                                                      "");
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
                                                      dogusBatisSuresi,
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Spacer(flex: 6,)
                            ],
                          )),
                        )
                      ],
                    ),
                  ),
                  //Sıcaklık çizelgesi bölümü
                  Expanded(
                    flex: 6,
                    child: Visibility(visible: dimmerVarMi=="1" ? true : false,
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
                                        Dil().sec(dilSecimi, "tv342"),
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
                                      _grafikData(
                                          double.parse(anlikAydinlikYuzdesi),
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
                                            charts.TickSpec<num>(10),
                                            charts.TickSpec<num>(20),
                                            charts.TickSpec<num>(
                                                double.parse(anlikAydinlikYuzdesi)),
                                            charts.TickSpec<num>(95),
                                            charts.TickSpec<num>(100),
                                            
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
                      Dil().sec(dilSecimi, "tv112"), 
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
                          subtitle: Text(
                            dimmerVarMi=="1" ? Dil().sec(dilSecimi, "info18") : Dil().sec(dilSecimi, "info19"),
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

  Future _degergiris2X0(int onlarUnsur, int birlerUnsur, int index,
      double oran, String dil, String baslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X0.Deger(
            onlarUnsur, birlerUnsur, index, oran, dil, baslik);
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

      String veri = '';

      if (index == 4) {
        acSaati1Saat=(_onlar*10+_birler).toString();
        veri = acSaati1Saat;
      }

      if (index == 5) {
        acSaati1Dakika=(_onlar*10+_birler).toString();
        veri = acSaati1Dakika;
      }

      if (index == 6) {
        acSaati2Saat=(_onlar*10+_birler).toString();
        veri = acSaati2Saat;
      }

      if (index == 7) {
        acSaati2Dakika=(_onlar*10+_birler).toString();
        veri = acSaati2Dakika;
      }

      if (index == 8) {
        kapaSaati1Saat=(_onlar*10+_birler).toString();
        veri = kapaSaati1Saat;
      }

      if (index == 9) {
        kapaSaati1Dakika=(_onlar*10+_birler).toString();
        veri = kapaSaati1Dakika;
      }

      if (index == 10) {
        kapaSaati2Saat=(_onlar*10+_birler).toString();
        veri = kapaSaati2Saat;
      }

      if (index == 11) {
        kapaSaati2Dakika=(_onlar*10+_birler).toString();
        veri = kapaSaati2Dakika;
      }

      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        _veriGonder("15*$_index*$veri");
      }

      


    });
  }


  Future _degergiris3X0(int yuzler , onlar , birler, index, double oran,
      String dil, baslik, onBaslik) async {
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

      if (index == 1) {
        gunduzAydinlikYuzdesi1=(_yuzler*100+_onlar*10+_birler).toString();
        veri = gunduzAydinlikYuzdesi1;
      }

      if (index == 2) {
        geceAydinlikYuzdesi1=(_yuzler*100+_onlar*10+_birler).toString();
        veri = geceAydinlikYuzdesi1;
      }

      if (index == 3) {
        dogusBatisSuresi=(_yuzler*100+_onlar*10+_birler).toString();
        veri = dogusBatisSuresi;
      }

      if (index == 13) {
        gunduzAydinlikYuzdesi1=(_yuzler*100+_onlar*10+_birler).toString();
        veri = gunduzAydinlikYuzdesi2;
      }

      if (index == 14) {
        geceAydinlikYuzdesi1=(_yuzler*100+_onlar*10+_birler).toString();
        veri = geceAydinlikYuzdesi2;
      }

     

      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        _veriGonder("15*$_index*$veri");
      }

      setState(() {});
    });
  }


 
  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

  static List<charts.Series<GrafikSicaklikCizelgesiLineerCapraz, String>>
      _grafikData(double aydinlikYuzdesi, String dil) {
    final aydYuzdesi = [
      new GrafikSicaklikCizelgesiLineerCapraz(
          Dil().sec(dil, "tv340"), aydinlikYuzdesi, Colors.blue[700]),
    ];

    return [
      new charts.Series<GrafikSicaklikCizelgesiLineerCapraz, String>(
        id: Dil().sec(dil, "tv341"),
        domainFn: (GrafikSicaklikCizelgesiLineerCapraz deger, _) =>
            deger.baslik,
        measureFn: (GrafikSicaklikCizelgesiLineerCapraz deger, _) =>
            deger.deger,
        colorFn: (GrafikSicaklikCizelgesiLineerCapraz clickData, _) =>
            clickData.color,
        data: aydYuzdesi,
      ),
    ];
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
              Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 2);
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
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context, duration: 3);
      baglanti = false;
    }
  }

  _takipEt() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2236).then((socket) {
        socket.add(utf8.encode('14*'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);

            if (gelenMesaj != "") {
              var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              gunduzAydinlikYuzdesi1 = degerler[0];              
              geceAydinlikYuzdesi1 = degerler[1];
              gunduzAydinlikYuzdesi2 = degerler[2];              
              geceAydinlikYuzdesi2 = degerler[3];
              dogusBatisSuresi = degerler[4];
              acSaati1Saat = degerler[5];
              acSaati1Dakika = degerler[6];
              acSaati2Saat = degerler[7];
              acSaati2Dakika = degerler[8];
              kapaSaati1Saat= degerler[9];
              kapaSaati1Dakika = degerler[10];
              kapaSaati2Saat = degerler[11];
              kapaSaati2Dakika = degerler[12];
              acKapaSaati2Aktiflik = degerler[13]=="True" ? true : false;
              anlikAydinlikYuzdesi = degerler[14];

              socket.add(utf8.encode('ok'));
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
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context, duration: 3);
      baglanti = false;
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
