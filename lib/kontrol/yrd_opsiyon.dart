import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/kontrol/klepe_prob_kontrol.dart';
import 'package:prokis/genel_ayarlar/kontrol.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_2x0.dart';
import 'package:prokis/yardimci/deger_giris_3x0.dart';
import 'package:prokis/languages/select.dart';

class YrdOpsiyon extends StatefulWidget {
  List<Map> gelenDBveri;
  YrdOpsiyon(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return YrdOpsiyonState(gelenDBveri);
  }
}

class YrdOpsiyonState extends State<YrdOpsiyon> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String disNemAktif = "1";

  String info = "info12";
  List<Map> dbVeriler;

  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _index = 0;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  bool yuksekNemdeTumFanlarCalissin = false;
  bool disNemUstLimitAktif = false;
  String disNemUstLimit = "85";

  String fanMinimumCalismaSuresi="10";

  bool elekKesildigindeSistemiDurdur=false;
  String tFanYumGecisDongu="3";
  String tFanYumGecisAdet="3";

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  YrdOpsiyonState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 13) {
        disNemAktif = dbVeri[i]["veri4"];
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
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv481'),
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 0 * oran,
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                Expanded(
                                  flex: 20,
                                  child: Column(
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv496"),style: TextStyle(
                                        fontFamily: 'Kelly Slab'
                                      ),
                                      textScaleFactor: oran,
                                      ),
                                      Expanded(
                                         child: Container(color: Colors.blue[50],
                                           child: Row(
                                            children: <Widget>[
                                              Expanded(flex: 6,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    
                                                    Expanded(
                                                      flex: 2,
                                                      child: SizedBox(
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            Dil().sec(dilSecimi, "tv489"),
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontFamily: 'Kelly Slab',
                                                              color: Colors.black,
                                                              fontSize: 60,
                                                              fontWeight: FontWeight.bold
                                                            ),
                                                            maxLines: 3,
                                                            minFontSize: 8,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: IconButton(
                                                        padding: EdgeInsets.all(0),
                                                        onPressed: () {

                                                          _index = 1;
                                                          if (!yuksekNemdeTumFanlarCalissin) {
                                                            yuksekNemdeTumFanlarCalissin = true;
                                                          } else {
                                                            yuksekNemdeTumFanlarCalissin = false;
                                                          }

                                                          String veri=yuksekNemdeTumFanlarCalissin==true ? '1' : '0';
                                                          yazmaSonrasiGecikmeSayaci=0;
                                                          _veriGonder(
                                                              "32*$_index*$veri");
                                                          setState(() {});
                                                          

                                                        },
                                                        icon: Icon(
                                                            yuksekNemdeTumFanlarCalissin == true
                                                                ? Icons.check_box
                                                                : Icons.check_box_outline_blank),
                                                        color: yuksekNemdeTumFanlarCalissin == true
                                                            ? Colors.green.shade500
                                                            : Colors.blue.shade600,
                                                        iconSize: 30 * oran,
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,)
                                                  ],
                                                ),
                                              ),
                                              Expanded(flex: 5,
                                                child: Visibility(visible: yuksekNemdeTumFanlarCalissin,
                                                                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      
                                                      Expanded(
                                                        flex: 2,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            child: AutoSizeText(
                                                              Dil().sec(dilSecimi, "tv490"),
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                fontFamily: 'Kelly Slab',
                                                                color: Colors.black,
                                                                fontSize: 60,
                                                                fontWeight: FontWeight.bold
                                                              ),
                                                              maxLines: 3,
                                                              minFontSize: 8,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: IconButton(
                                                          padding: EdgeInsets.all(0),
                                                          onPressed: () {

                                                            if(disNemAktif=="1"){
                                                              _index = 2;
                                                              if (!disNemUstLimitAktif) {
                                                                disNemUstLimitAktif = true;
                                                              } else {
                                                                disNemUstLimitAktif = false;
                                                              }

                                                              String veri=disNemUstLimitAktif==true ? '1' : '0';
                                                              yazmaSonrasiGecikmeSayaci=0;
                                                              _veriGonder(
                                                                  "32*$_index*$veri");
                                                              setState(() {});
                                                            }else{
                                                              Toast.show(Dil().sec(dilSecimi, "toast82"), context,duration: 3);
                                                            }

                                                            
                                                            

                                                          },
                                                          icon: Icon(
                                                              disNemUstLimitAktif == true
                                                                  ? Icons.check_box
                                                                  : Icons.check_box_outline_blank),
                                                          color: disNemUstLimitAktif == true
                                                              ? Colors.green.shade500
                                                              : Colors.blue.shade600,
                                                          iconSize: 30 * oran,
                                                        ),
                                                      ),
                                                      Spacer(flex: 2,)
                                                    ],
                                                  ),
                                                ),
                                              ),                                          
                                              Expanded(flex: 5,
                                               child: Visibility(visible: disNemUstLimitAktif,
                                                                                                child: Column(
                                                   children: <Widget>[
                                                     Expanded(
                                                       child: SizedBox(
                                                         child: Container(
                                                           alignment: Alignment.bottomCenter,
                                                           child: AutoSizeText(
                                                             Dil().sec(dilSecimi, "tv491"),
                                                             textAlign: TextAlign.center,
                                                             style: TextStyle(
                                                                 fontSize: 50.0,
                                                                 fontFamily: 'Kelly Slab',
                                                                 fontWeight:
                                                                     FontWeight.bold),
                                                             maxLines: 2,
                                                             minFontSize: 8,
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                     Expanded(
                                                       flex: 3,
                                                       child: RawMaterialButton(
                                                         onPressed: () {
                                                           int sayi =
                                                               int.parse(disNemUstLimit);
                                                           _index = 3;
                                                           _yuzler =
                                                               sayi < 100 ? 0 : sayi ~/ 100;
                                                           _onlar = sayi < 10
                                                               ? 0
                                                               : (sayi > 99
                                                                   ? (sayi -
                                                                           100 * _yuzler) ~/
                                                                       10
                                                                   : sayi ~/ 10);
                                                           _birler = sayi % 10;

                                                           _degergiris3X0(
                                                               _yuzler,
                                                               _onlar,
                                                               _birler,
                                                               _index,
                                                               3,
                                                               oran,
                                                               dilSecimi,
                                                               "tv491",
                                                               "");
                                                         },
                                                         child: Stack(
                                                           alignment: Alignment.center,
                                                           children: <Widget>[
                                                             LayoutBuilder(builder:
                                                                 (context, constraint) {
                                                               return Icon(
                                                                 Icons.brightness_1,
                                                                 size: constraint
                                                                     .biggest.height,
                                                                 color: Colors.blue[700],
                                                               );
                                                             }),
                                                             Text(
                                                               disNemUstLimit,
                                                               style: TextStyle(
                                                                   fontSize: 25 * oran,
                                                                   fontFamily: 'Kelly Slab',
                                                                   fontWeight:
                                                                       FontWeight.bold,
                                                                   color: Colors.white),
                                                             ),
                                                           ],
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
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Expanded(
                                  flex: 20,
                                  child: Column(
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv497"),style: TextStyle(
                                        fontFamily: 'Kelly Slab'
                                      ),
                                      textScaleFactor: oran,
                                      ),
                                      Expanded(
                                         child: Container(color: Colors.blue[50],
                                           child: Row(
                                            children: <Widget>[
                                              Expanded(
                                               child: Column(
                                                   children: <Widget>[
                                                     Expanded(
                                                       child: SizedBox(
                                                         child: Container(
                                                           alignment: Alignment.bottomCenter,
                                                           child: AutoSizeText(
                                                             Dil().sec(dilSecimi, "tv498"),
                                                             textAlign: TextAlign.center,
                                                             style: TextStyle(
                                                                 fontSize: 50.0,
                                                                 fontFamily: 'Kelly Slab',
                                                                 fontWeight:
                                                                     FontWeight.bold),
                                                             maxLines: 2,
                                                             minFontSize: 8,
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                     Expanded(
                                                       flex: 3,
                                                       child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                         children: <Widget>[
                                                           Padding(
                                                             padding:  EdgeInsets.only(left: 10*oran,right: 10*oran),
                                                             child: RawMaterialButton(
                                                               fillColor: Colors.cyan[700],
                                                               elevation: 16,
                                                               onPressed: () {
                                                                 timerCancel=true;

                                                                 Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(builder: (context) => KlepeProbKontrol(dbVeriler)),
                                                                );

                                                               },
                                                               child: Stack(
                                                                 alignment: Alignment.center,
                                                                 children: <Widget>[
                                                                   Container(color: Colors.yellow,),
                                                                   Text(
                                                                     Dil().sec(dilSecimi, "tv499"),
                                                                     style: TextStyle(
                                                                         fontSize: 25 * oran,
                                                                         fontFamily: 'Kelly Slab',
                                                                         fontWeight:
                                                                             FontWeight.bold,
                                                                         color: Colors.white),
                                                                   ),
                                                                 ],
                                                               ),
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
                                ),
                                Spacer(),
                                Expanded(
                                  flex: 20,
                                  child: Column(
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv496"),style: TextStyle(
                                        fontFamily: 'Kelly Slab'
                                      ),
                                      textScaleFactor: oran,
                                      ),
                                      Expanded(
                                         child: Container(color: Colors.blue[50],
                                           child: Row(
                                            children: <Widget>[
                                              Expanded(flex: 5,
                                               child: Column(
                                                   children: <Widget>[
                                                     Expanded(
                                                       child: SizedBox(
                                                         child: Container(
                                                           alignment: Alignment.bottomCenter,
                                                           child: AutoSizeText(
                                                             Dil().sec(dilSecimi, "tv562"),
                                                             textAlign: TextAlign.center,
                                                             style: TextStyle(
                                                                 fontSize: 50.0,
                                                                 fontFamily: 'Kelly Slab',
                                                                 fontWeight:
                                                                     FontWeight.bold),
                                                             maxLines: 2,
                                                             minFontSize: 8,
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                     Expanded(
                                                       flex: 3,
                                                       child: RawMaterialButton(
                                                         onPressed: () {
                                                           int sayi=int.parse(fanMinimumCalismaSuresi);
                                                                  _index = 4;
                                                                  _onlar=sayi<10 ? 0 :sayi~/10;
                                                                  _birler=sayi%10;

                                                                  _degergiris2X0(_onlar, _birler, _index, 1, oran, dilSecimi, "tv200");
                                                                  
                                                         },
                                                         child: Stack(
                                                           alignment: Alignment.center,
                                                           children: <Widget>[
                                                             LayoutBuilder(builder:
                                                                 (context, constraint) {
                                                               return Icon(
                                                                 Icons.brightness_1,
                                                                 size: constraint
                                                                     .biggest.height,
                                                                 color: Colors.blue[700],
                                                               );
                                                             }),
                                                             Text(
                                                               fanMinimumCalismaSuresi,
                                                               style: TextStyle(
                                                                   fontSize: 25 * oran,
                                                                   fontFamily: 'Kelly Slab',
                                                                   fontWeight:
                                                                       FontWeight.bold,
                                                                   color: Colors.white),
                                                             ),
                                                           ],
                                                         ),
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
                                ),
                                Spacer(),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                Expanded(
                                  flex: 20,
                                  child: Column(
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv565"),style: TextStyle(
                                        fontFamily: 'Kelly Slab'
                                      ),
                                      textScaleFactor: oran,
                                      ),
                                      Expanded(
                                         child: Container(color: Colors.blue[50],
                                           child: Row(
                                            children: <Widget>[
                                              Expanded(flex: 1,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    
                                                    Expanded(
                                                      flex: 2,
                                                      child: SizedBox(
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            Dil().sec(dilSecimi, "tv566"),
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              fontFamily: 'Kelly Slab',
                                                              color: Colors.black,
                                                              fontSize: 60,
                                                              fontWeight: FontWeight.bold
                                                            ),
                                                            maxLines: 3,
                                                            minFontSize: 8,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: IconButton(
                                                        padding: EdgeInsets.all(0),
                                                        onPressed: () {

                                                          _index = 5;
                                                          if (!elekKesildigindeSistemiDurdur) {
                                                            elekKesildigindeSistemiDurdur = true;
                                                          } else {
                                                            elekKesildigindeSistemiDurdur = false;
                                                          }

                                                          String veri=elekKesildigindeSistemiDurdur==true ? '1' : '0';
                                                          yazmaSonrasiGecikmeSayaci=0;
                                                          _veriGonder(
                                                              "32*$_index*$veri");
                                                          setState(() {});
                                                          

                                                        },
                                                        icon: Icon(
                                                            elekKesildigindeSistemiDurdur == true
                                                                ? Icons.check_box
                                                                : Icons.check_box_outline_blank),
                                                        color: elekKesildigindeSistemiDurdur == true
                                                            ? Colors.green.shade500
                                                            : Colors.blue.shade600,
                                                        iconSize: 30 * oran,
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,)
                                                  ],
                                                ),
                                              ),
                                              Expanded(flex: 1,
                                               child: Column(
                                                   children: <Widget>[
                                                     Expanded(
                                                       child: SizedBox(
                                                         child: Container(
                                                           alignment: Alignment.bottomCenter,
                                                           child: AutoSizeText(
                                                             Dil().sec(dilSecimi, "tv567"),
                                                             textAlign: TextAlign.center,
                                                             style: TextStyle(
                                                                 fontSize: 50.0,
                                                                 fontFamily: 'Kelly Slab',
                                                                 fontWeight:
                                                                     FontWeight.bold),
                                                             maxLines: 2,
                                                             minFontSize: 8,
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                     Expanded(
                                                       flex: 3,
                                                       child: RawMaterialButton(
                                                         onPressed: () {
                                                           int sayi =
                                                               int.parse(tFanYumGecisDongu);
                                                           _index = 6;
                                                           _onlar = sayi < 10
                                                               ? 0
                                                               : sayi ~/ 10;
                                                           _birler = sayi % 10;

                                                           _degergiris2X0(
                                                               _onlar,
                                                               _birler,
                                                               _index,
                                                               1,
                                                               oran,
                                                               dilSecimi,
                                                               "tv567"
                                                               );
                                                         },
                                                         child: Stack(
                                                           alignment: Alignment.center,
                                                           children: <Widget>[
                                                             LayoutBuilder(builder:
                                                                 (context, constraint) {
                                                               return Icon(
                                                                 Icons.brightness_1,
                                                                 size: constraint
                                                                     .biggest.height,
                                                                 color: Colors.blue[700],
                                                               );
                                                             }),
                                                             Text(
                                                               tFanYumGecisDongu,
                                                               style: TextStyle(
                                                                   fontSize: 25 * oran,
                                                                   fontFamily: 'Kelly Slab',
                                                                   fontWeight:
                                                                       FontWeight.bold,
                                                                   color: Colors.white),
                                                             ),
                                                           ],
                                                         ),
                                                       ),
                                                     ),
                                                   ],
                                              ),
                                                ),                                             
                                              Expanded(flex: 1,
                                               child: Column(
                                                   children: <Widget>[
                                                     Expanded(
                                                       child: SizedBox(
                                                         child: Container(
                                                           alignment: Alignment.bottomCenter,
                                                           child: AutoSizeText(
                                                             Dil().sec(dilSecimi, "tv568"),
                                                             textAlign: TextAlign.center,
                                                             style: TextStyle(
                                                                 fontSize: 50.0,
                                                                 fontFamily: 'Kelly Slab',
                                                                 fontWeight:
                                                                     FontWeight.bold),
                                                             maxLines: 2,
                                                             minFontSize: 8,
                                                           ),
                                                         ),
                                                       ),
                                                     ),
                                                     Expanded(
                                                       flex: 3,
                                                       child: RawMaterialButton(
                                                         onPressed: () {
                                                           int sayi =
                                                               int.parse(tFanYumGecisAdet);
                                                           _index = 7;
                                                           _onlar = sayi < 10
                                                               ? 0
                                                               : sayi ~/ 10;
                                                           _birler = sayi % 10;

                                                           _degergiris2X0(
                                                               _onlar,
                                                               _birler,
                                                               _index,
                                                               1,
                                                               oran,
                                                               dilSecimi,
                                                               "tv568"
                                                               );
                                                         },
                                                         child: Stack(
                                                           alignment: Alignment.center,
                                                           children: <Widget>[
                                                             LayoutBuilder(builder:
                                                                 (context, constraint) {
                                                               return Icon(
                                                                 Icons.brightness_1,
                                                                 size: constraint
                                                                     .biggest.height,
                                                                 color: Colors.blue[700],
                                                               );
                                                             }),
                                                             Text(
                                                               tFanYumGecisAdet,
                                                               style: TextStyle(
                                                                   fontSize: 25 * oran,
                                                                   fontFamily: 'Kelly Slab',
                                                                   fontWeight:
                                                                       FontWeight.bold,
                                                                   color: Colors.white),
                                                             ),
                                                           ],
                                                         ),
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
                                ),
                                Spacer(flex: 43,),
                                
                              ],
                            ),
                          ),
                          
                          Spacer(flex: 2,)
                        
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
                        Dil().sec(dilSecimi, "tv293"), //Sıcaklık diyagramı
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
                              Dil().sec(dilSecimi, info),
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

  Future _degergiris3X0(int yuzler, onlar, birler, index, paramIndex,
      double oran, String dil, baslik, onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris3X0.Deger(
            yuzler, onlar, birler, index, oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_yuzler != val[0] ||
          _onlar != val[1] ||
          _birler != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }
        _yuzler=val[0];
        _onlar=val[1];
        _birler=val[2];
        _index=val[3];
      

      String veri = "";

      if (_index == 3) {
        disNemUstLimit = (_yuzler * 100 + _onlar * 10 + _birler).toString();
        veri = disNemUstLimit;
      }
      

      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        _veriGonder("32*$index*$veri");
      }

      setState(() {});
    });
  }

Future _degergiris2X0(int onlarUnsur, int birlerUnsur, int klepeIndex, int paramIndex,
      double oran, String dil, String baslik) async {
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

      
      fanMinimumCalismaSuresi=(_yuzler*100+_onlar*10+_birler).toString();
      


      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        _veriGonder("32*$_index*$fanMinimumCalismaSuresi");
      }


    });
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
        socket.add(utf8.encode('27*'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);
            if (gelenMesaj != "") {
              var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              yuksekNemdeTumFanlarCalissin = degerler[0]=="True" ? true : false;
              disNemUstLimitAktif = degerler[1]=="True" ? true : false;
              disNemUstLimit = degerler[2];
              fanMinimumCalismaSuresi = degerler[3];
              elekKesildigindeSistemiDurdur = degerler[4]=="True" ? true : false;
              tFanYumGecisDongu = degerler[5];
              tFanYumGecisAdet = degerler[6];


              



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
