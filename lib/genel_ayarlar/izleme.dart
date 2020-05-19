
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/izleme/izleme_bfanairistc.dart';
import 'package:prokis/izleme/izleme_fanklpped.dart';
import 'package:prokis/izleme/izleme_yemsuayd.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';
import 'package:toast/toast.dart';

class Izleme extends StatefulWidget {
  List<Map> gelenDBveri;
  Izleme(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return IzlemeState(gelenDBveri);
  }
}

class IzlemeState extends State<Izleme> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;
  String bacafanAdet = "0";
  String disNemVarMi = "0";

  String setSicakligi="23.0";
  String ortSicaklik="25.6";
  String dogBolgeBitis="24.0";
  String capBolgeBitis="26.0";
  String olculenMakSic="29.0";
  String olculenMinSic="19.0";
  String olculenMakSicZmn="14:40";
  String olculenMinSicZmn="03:20";
  String olculenMakNem="86.0";
  String olculenMinNem="32.0";
  String olculenMakNemZmn="13:32";
  String olculenMinNemZmn="07:51";
  String icNem="50.0";
  String disNem="65.0";
  String ortHissedilirSicaklik="24.9";

  String olumOrani = "1.35";
  String guncelOluHayvanSayisi = "126";
  String guncelHayvanSayisi = "120000";
  String suruYasiGunluk = "140";
  String suruYasiHaftalik = "20.0";

  String havaHizi="1.0";

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  int sistemModu=3;
  int nemDurum=0;

  String baglantiDurum="";
  

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  IzlemeState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 5) {
        var xx=dbVeri[i]["veri1"].split('#'); 
        bacafanAdet = xx[0];
      }

      if (dbVeri[i]["id"] == 13) {
        disNemVarMi = dbVeri[i]["veri4"];
      }
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------
int sayac=0;
  @override
  Widget build(BuildContext context) {

    if (timerSayac == 0) {
      Metotlar().takipEt("i4*", 2236).then((veri){
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
          Metotlar().takipEt("i4*", 2236).then((veri){
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
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv569',baglantiDurum),
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
        child: FittedBox(
                    child: FloatingActionButton(
            onPressed: () {
              timerCancel=true;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GenelAyarlar(dbVeriler)),
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
            flex: 40,
            child: Column(
              children: <Widget>[
                Spacer(),
                Expanded(flex: 30,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 1,
                      ),
                      //IZLEME - FAN PED ISISENSOR KLEPE
                      Expanded(flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(flex: 2,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv598'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv641"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv642"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
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
                              Expanded(flex: 4,
                                child: RawMaterialButton(
                                    onPressed: () {
                                      timerCancel=true;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IzlemeFanKlpPed(dbVeriler)),
                                      );
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

                                        RotatedBox(quarterTurns: 1,
                                          child: LayoutBuilder(builder:
                                              (context,
                                                  constraint) {
                                            return Icon(
                                              Icons
                                                  .search,
                                              size: constraint
                                                  .biggest
                                                  .width,
                                              color: Colors
                                                  .black,
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      //IZLEME - BACAFAN AIR INLET SİRKÜLASYON FAN ISITICI
                      Expanded(flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(flex: 2,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv599'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv643"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv644"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
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
                              Expanded(flex: 4,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    timerCancel=true;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IzlemeBfanAirIstc(dbVeriler)),
                                    );
                                    
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

                                      RotatedBox(quarterTurns: 1,
                                        child: LayoutBuilder(builder:
                                            (context,
                                                constraint) {
                                          return Icon(
                                            Icons
                                                .search,
                                            size: constraint
                                                .biggest
                                                .width,
                                            color: Colors
                                                .black,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      //IZLEME - AYDINLATMA YEMLEME SU SAYAC SİLO
                      Expanded(flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(flex: 2,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv647'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv645"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv646"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 1,
                                                  minFontSize: 8,
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
                              Expanded(flex: 4,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    timerCancel=true;
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IzlemeYemSuAyd(dbVeriler)),
                                    );
                                    
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

                                      RotatedBox(quarterTurns: 1,
                                        child: LayoutBuilder(builder:
                                            (context,
                                                constraint) {
                                          return Icon(
                                            Icons
                                                .search,
                                            size: constraint
                                                .biggest
                                                .width,
                                            color: Colors
                                                .black,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      
                    ],
                  ),
                ),
                
                //AKtif MOD
                Expanded(flex: 5,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Expanded(flex: 4,
                        child: Container(
                          color: Colors.blue[900],
                          child: SizedBox(
                            child: Container(
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv571")+" "+sistemModu.toString()+": "+sistemModMetni(sistemModu,nemDurum),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50.0,
                                        fontFamily: 'Kelly Slab'),
                                    maxLines: 1,
                                    minFontSize: 5,
                                  )
                            ),
                          ),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ), 
                Expanded(flex: 31,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      //Sıcaklıklar
                      Expanded(flex: 20,
                              child: Row(
                                children: <Widget>[
                                  Spacer(),
                                  //Hissedilir Sıcaklık ve Hava hızı
                                  Expanded(flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10*oran),
                                    color: Colors.grey[300],
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(flex: 7,
                                             child: SizedBox(
                                               child: Container(
                                                 alignment: Alignment.center,
                                                 padding: EdgeInsets.only(left: 1*oran),
                                                 child: AutoSizeText(
                                                   Dil().sec(dilSecimi, "tv620"),
                                                   textAlign:
                                                       TextAlign.center,
                                                   style: TextStyle(
                                                       fontSize: 50.0,
                                                       fontFamily:'Kelly Slab',
                                                       color: Colors.red[800]
                                                       ),
                                                   maxLines: 3,
                                                   minFontSize: 5,
                                                 ),
                                               ),
                                             ),
                                         ),
                                            Expanded(flex: 11,
                                              child: Stack(
                                                children: <Widget>[
                                                  Visibility(visible: ortHissedilirSicaklik!="0"? true : false,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Spacer(flex: 1,),
                                                        Expanded(flex: 4,
                                                         child: SizedBox(
                                                           child: Container(
                                                             alignment: Alignment.centerRight,
                                                             child: AutoSizeText(
                                                               ortHissedilirSicaklik,
                                                               textAlign:TextAlign.center,
                                                               style: TextStyle(
                                                                   fontSize: 50.0,
                                                                   fontFamily:'Kelly Slab',
                                                                   color: Colors.black,
                                                                   fontWeight: FontWeight.bold
                                                                   ),
                                                               maxLines: 1,
                                                               minFontSize: 5,
                                                             ),
                                                           ),
                                                         ),
                                                       ),
                                                        Expanded(flex: 2,
                                                         child: SizedBox(
                                                           child: Container(
                                                             alignment: Alignment.centerLeft,
                                                             padding: EdgeInsets.only(right: 2*oran),
                                                             child: AutoSizeText(
                                                               "°C",
                                                               textAlign:
                                                                   TextAlign.center,
                                                               style: TextStyle(
                                                                   fontSize: 50.0,
                                                                   fontFamily:'Kelly Slab',
                                                                   color: Colors.red[800]
                                                                   ),
                                                               maxLines: 1,
                                                               minFontSize: 5,
                                                             ),
                                                           ),
                                                         ),
                                                       ),
                                                        Spacer(flex: 1,)
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(visible: ortHissedilirSicaklik=="0"? true : false,
                                                      child: SizedBox(
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            Dil().sec(dilSecimi, "tv237"),
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 50.0,
                                                                fontFamily:'Kelly Slab',
                                                                fontWeight:FontWeight.bold,
                                                                color: Colors.grey[500],
                                                                ),
                                                            maxLines: 4,
                                                            minFontSize: 8,
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
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Spacer(flex: 2,),
                                            Expanded(flex: 7,
                                             child: SizedBox(
                                               child: Container(
                                                 alignment: Alignment.center,
                                                 padding: EdgeInsets.only(left: 1*oran),
                                                 child: AutoSizeText(
                                                   Dil().sec(dilSecimi, "tv662"),
                                                   textAlign:
                                                       TextAlign.center,
                                                   style: TextStyle(
                                                       fontSize: 50.0,
                                                       fontFamily:'Kelly Slab',
                                                       color: Colors.red[800]
                                                       ),
                                                   maxLines: 3,
                                                   minFontSize: 5,
                                                 ),
                                               ),
                                             ),
                                         ),
                                            Expanded(flex: 11,
                                              child: Stack(
                                                children: <Widget>[
                                                  Visibility(visible: havaHizi!="0" ? true : false,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        child: AutoSizeText(
                                                          havaHizi,
                                                          textAlign:TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 50.0,
                                                              fontFamily:'Kelly Slab',
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold
                                                              ),
                                                          maxLines: 1,
                                                          minFontSize: 5,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(visible: havaHizi=="0"? true : false,
                                                      child: SizedBox(
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            Dil().sec(dilSecimi, "tv237"),
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 50.0,
                                                                fontFamily:'Kelly Slab',
                                                                fontWeight:FontWeight.bold,
                                                                color: Colors.grey[500],
                                                                ),
                                                            maxLines: 4,
                                                            minFontSize: 8,
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
                                      
                                    ],
                                  ),
                                ),
                              ),
                                  //İç nem Dış Nem
                                  Expanded(flex: 6,
                                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(flex: 7,
                                               child: SizedBox(
                                                 child: Container(
                                                   alignment: Alignment.center,
                                                   padding: EdgeInsets.only(left: 1*oran),
                                                   child: AutoSizeText(
                                                     Dil().sec(dilSecimi, "tv618"),
                                                     textAlign:
                                                         TextAlign.center,
                                                     style: TextStyle(
                                                         fontSize: 50.0,
                                                         fontFamily:'Kelly Slab',
                                                         color: Colors.red[800]
                                                         ),
                                                     maxLines: 1,
                                                     minFontSize: 5,
                                                   ),
                                                 ),
                                               ),
                                           ),
                                              Expanded(flex: 11,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(flex: 1,),
                                                    Expanded(flex: 4,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.centerRight,
                                                         child: AutoSizeText(
                                                           icNem,
                                                           textAlign:TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.black,
                                                               fontWeight: FontWeight.bold
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                    Expanded(flex: 2,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.centerLeft,
                                                         padding: EdgeInsets.only(right: 2*oran),
                                                         child: AutoSizeText(
                                                           "%",
                                                           textAlign:
                                                               TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.red[800]
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                    Spacer(flex: 1,)
                                                  ],
                                                ),
                                              ),
                                              Spacer(flex: 2,)
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(flex: 2,),
                                              Expanded(flex: 7,
                                               child: SizedBox(
                                                 child: Container(
                                                   alignment: Alignment.center,
                                                   padding: EdgeInsets.only(left: 1*oran),
                                                   child: AutoSizeText(
                                                     Dil().sec(dilSecimi, "tv619"),
                                                     textAlign:
                                                         TextAlign.center,
                                                     style: TextStyle(
                                                         fontSize: 50.0,
                                                         fontFamily:'Kelly Slab',
                                                         color: Colors.red[800]
                                                         ),
                                                     maxLines: 1,
                                                     minFontSize: 5,
                                                   ),
                                                 ),
                                               ),
                                           ),
                                              Expanded(flex: 11,
                                                child: Stack(fit: StackFit.expand,
                                                  children: <Widget>[
                                                    Visibility(visible: disNemVarMi=="0" ? false: true,
                                                                                                                child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerRight,
                                                               child: AutoSizeText(
                                                                 disNem,
                                                                 textAlign:TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.black,
                                                                     fontWeight: FontWeight.bold
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Expanded(flex: 2,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerLeft,
                                                               padding: EdgeInsets.only(right: 2*oran),
                                                               child: AutoSizeText(
                                                                 "%",
                                                                 textAlign:
                                                                     TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.red[800]
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(visible: disNemVarMi=="0"? true : false,
                                                      child: SizedBox(
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            Dil().sec(dilSecimi, "tv237"),
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 50.0,
                                                                fontFamily:'Kelly Slab',
                                                                fontWeight:FontWeight.bold,
                                                                color: Colors.grey[500],
                                                                ),
                                                            maxLines: 4,
                                                            minFontSize: 8,
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

                                    ],
                                  )),
                                  //Doğal Bölge Çapraz Bölge
                                  Expanded(flex: 6,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(flex: 7,
                                               child: SizedBox(
                                                 child: Container(
                                                   alignment: Alignment.center,
                                                   padding: EdgeInsets.only(left: 1*oran),
                                                   child: AutoSizeText(
                                                     Dil().sec(dilSecimi, "tv584"),
                                                     textAlign:
                                                         TextAlign.center,
                                                     style: TextStyle(
                                                         fontSize: 50.0,
                                                         fontFamily:'Kelly Slab',
                                                         color: Colors.red[800]
                                                         ),
                                                     maxLines: 1,
                                                     minFontSize: 5,
                                                   ),
                                                 ),
                                               ),
                                           ),
                                              Expanded(flex: 11,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(flex: 1,),
                                                    Expanded(flex: 4,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.centerRight,
                                                         child: AutoSizeText(
                                                           dogBolgeBitis,
                                                           textAlign:TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.black,
                                                               fontWeight: FontWeight.bold
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                    Expanded(flex: 2,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.centerLeft,
                                                         padding: EdgeInsets.only(right: 2*oran),
                                                         child: AutoSizeText(
                                                           "°C",
                                                           textAlign:
                                                               TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.red[800]
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                    Spacer(flex: 1,)
                                                  ],
                                                ),
                                              ),
                                              Spacer(flex: 2,)
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(flex: 2,),
                                              Expanded(flex: 7,
                                               child: SizedBox(
                                                 child: Container(
                                                   alignment: Alignment.center,
                                                   padding: EdgeInsets.only(left: 1*oran),
                                                   child: AutoSizeText(
                                                     Dil().sec(dilSecimi, "tv585"),
                                                     textAlign:
                                                         TextAlign.center,
                                                     style: TextStyle(
                                                         fontSize: 50.0,
                                                         fontFamily:'Kelly Slab',
                                                         color: Colors.red[800]
                                                         ),
                                                     maxLines: 1,
                                                     minFontSize: 5,
                                                   ),
                                                 ),
                                               ),
                                           ),
                                              Expanded(flex: 11,
                                                child: Stack(fit: StackFit.expand,
                                                  children: <Widget>[
                                                    Visibility(visible: bacafanAdet=="0"? false : true,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerRight,
                                                               child: AutoSizeText(
                                                                 capBolgeBitis,
                                                                 textAlign:TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.black,
                                                                     fontWeight: FontWeight.bold
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Expanded(flex: 2,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerLeft,
                                                               padding: EdgeInsets.only(right: 2*oran),
                                                               child: AutoSizeText(
                                                                 "°C",
                                                                 textAlign:
                                                                     TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.red[800]
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(visible: bacafanAdet=="0"? true : false,
                                                      child: SizedBox(
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            Dil().sec(dilSecimi, "tv237"),
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 50.0,
                                                                fontFamily:'Kelly Slab',
                                                                fontWeight:FontWeight.bold,
                                                                color: Colors.grey[500],
                                                                ),
                                                            maxLines: 4,
                                                            minFontSize: 8,
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
                                        
                                    ],
                                  )),
                                  //Set Sıcaklığı
                                  Expanded(flex: 6,
                                    child: 
                                    Column(
                                      children: <Widget>[
                                        Spacer(),
                                        Expanded(flex: 1,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.only(left: 1*oran),
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, "tv115"),
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:'Kelly Slab',
                                                        color: Colors.red[800]
                                                        ),
                                                    maxLines: 2,
                                                    minFontSize: 5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                              
                                        Expanded(flex: 2,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Spacer(flex: 2,),
                                              Expanded(flex: 6,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    setSicakligi,
                                                    textAlign:TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:'Kelly Slab',
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold
                                                        ),
                                                    maxLines: 1,
                                                    minFontSize: 5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                              Expanded(flex: 2,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.only(right: 2*oran),
                                                  child: AutoSizeText(
                                                    "°C",
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:'Kelly Slab',
                                                        color: Colors.red[800]
                                                        ),
                                                    maxLines: 1,
                                                    minFontSize: 5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                              Spacer(flex: 2,)
                                            ],
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    ),
                                  ),
                                  //Ortalama Sıcaklık Bölümü
                                  Expanded(flex: 10,
                                    child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[600],
                                      borderRadius: BorderRadius.circular(5*oran)
                                    ),
                                    
                                    child:Column(
                                      children: <Widget>[

                                        Expanded(flex: 1,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.only(left: 1*oran),
                                                    child: AutoSizeText(
                                                      Dil().sec(dilSecimi, "tv661"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.grey[200]
                                                          ),
                                                      maxLines: 2,
                                                      minFontSize: 5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(flex: 3,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(flex: 3,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      ortSicaklik,
                                                      textAlign:TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold
                                                          ),
                                                      maxLines: 1,
                                                      minFontSize: 5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(right: 2*oran),
                                                    child: AutoSizeText(
                                                      "°C",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          color: Colors.grey[200]
                                                          ),
                                                      maxLines: 1,
                                                      minFontSize: 5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                  ),
                                        ),
                                      ],
                                    )
                                  )),
                                  //Min - Max sıcaklıklar ve saatlari
                                  Expanded(flex: 12,
                                    child:Column(
                                      children: <Widget>[
                                        //Maks ve Min sıcaklıklar
                                        Expanded(flex: 6,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(flex: 7,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 1*oran),
                                                        child: AutoSizeText(
                                                          Dil().sec(dilSecimi, "tv614"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 50.0,
                                                              fontFamily:'Kelly Slab',
                                                              color: Colors.red[800]
                                                              ),
                                                          maxLines: 1,
                                                          minFontSize: 5,
                                                        ),
                                                      ),
                                                    ),
                                                ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.centerRight,
                                                              child: AutoSizeText(
                                                                olculenMakSic,
                                                                textAlign:TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Expanded(flex: 2,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.centerLeft,
                                                              padding: EdgeInsets.only(right: 2*oran),
                                                              child: AutoSizeText(
                                                                "°C",
                                                                textAlign:
                                                                    TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.red[800]
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    
                                                    Expanded(flex: 7,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 1*oran),
                                                        child: AutoSizeText(
                                                          Dil().sec(dilSecimi, "tv615"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 50.0,
                                                              fontFamily:'Kelly Slab',
                                                              color: Colors.red[800]
                                                              ),
                                                          maxLines: 1,
                                                          minFontSize: 5,
                                                        ),
                                                      ),
                                                    ),
                                                ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.centerRight,
                                                              child: AutoSizeText(
                                                                olculenMinSic,
                                                                textAlign:TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Expanded(flex: 2,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.centerLeft,
                                                              padding: EdgeInsets.only(right: 2*oran),
                                                              child: AutoSizeText(
                                                                "°C",
                                                                textAlign:
                                                                    TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.red[800]
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              
                                          ],
                                        )),
                                        //Maks ve Min sicaklık saatleri
                                        Expanded(flex: 6,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(flex: 7,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 1*oran),
                                                        child: AutoSizeText(
                                                          Dil().sec(dilSecimi, "tv616"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 50.0,
                                                              fontFamily:'Kelly Slab',
                                                              color: Colors.red[800]
                                                              ),
                                                          maxLines: 1,
                                                          minFontSize: 5,
                                                        ),
                                                      ),
                                                    ),
                                                ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              child: AutoSizeText(
                                                                olculenMakSicZmn,
                                                                textAlign:TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    
                                                    Expanded(flex: 7,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 1*oran),
                                                        child: AutoSizeText(
                                                          Dil().sec(dilSecimi, "tv617"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 50.0,
                                                              fontFamily:'Kelly Slab',
                                                              color: Colors.red[800]
                                                              ),
                                                          maxLines: 1,
                                                          minFontSize: 5,
                                                        ),
                                                      ),
                                                    ),
                                                ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              child: AutoSizeText(
                                                                olculenMinSicZmn,
                                                                textAlign:TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              
                                          ],
                                        )),
                                        

                                      ],
                                    )
                                  ),
                                  //Min - Max nem ve saatlari
                                  Expanded(flex: 12,
                                    child:Column(
                                      children: <Widget>[
                                        //Maks ve Min nem
                                        Expanded(flex: 6,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(flex: 7,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 1*oran),
                                                        child: AutoSizeText(
                                                          Dil().sec(dilSecimi, "tv665"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 50.0,
                                                              fontFamily:'Kelly Slab',
                                                              color: Colors.red[800]
                                                              ),
                                                          maxLines: 1,
                                                          minFontSize: 5,
                                                        ),
                                                      ),
                                                    ),
                                                ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.centerRight,
                                                              child: AutoSizeText(
                                                                olculenMakNem,
                                                                textAlign:TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Expanded(flex: 2,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.centerLeft,
                                                              padding: EdgeInsets.only(right: 2*oran),
                                                              child: AutoSizeText(
                                                                "%",
                                                                textAlign:
                                                                    TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.red[800]
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    
                                                    Expanded(flex: 7,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 1*oran),
                                                        child: AutoSizeText(
                                                          Dil().sec(dilSecimi, "tv666"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 50.0,
                                                              fontFamily:'Kelly Slab',
                                                              color: Colors.red[800]
                                                              ),
                                                          maxLines: 1,
                                                          minFontSize: 5,
                                                        ),
                                                      ),
                                                    ),
                                                ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.centerRight,
                                                              child: AutoSizeText(
                                                                olculenMinNem,
                                                                textAlign:TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Expanded(flex: 2,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.centerLeft,
                                                              padding: EdgeInsets.only(right: 2*oran),
                                                              child: AutoSizeText(
                                                                "%",
                                                                textAlign:
                                                                    TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.red[800]
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              
                                          ],
                                        )),
                                        //Maks ve Min nem saatleri
                                        Expanded(flex: 6,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(flex: 7,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 1*oran),
                                                        child: AutoSizeText(
                                                          Dil().sec(dilSecimi, "tv667"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 50.0,
                                                              fontFamily:'Kelly Slab',
                                                              color: Colors.red[800]
                                                              ),
                                                          maxLines: 1,
                                                          minFontSize: 5,
                                                        ),
                                                      ),
                                                    ),
                                                ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              child: AutoSizeText(
                                                                olculenMakNemZmn,
                                                                textAlign:TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    
                                                    Expanded(flex: 7,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.only(left: 1*oran),
                                                        child: AutoSizeText(
                                                          Dil().sec(dilSecimi, "tv668"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 50.0,
                                                              fontFamily:'Kelly Slab',
                                                              color: Colors.red[800]
                                                              ),
                                                          maxLines: 1,
                                                          minFontSize: 5,
                                                        ),
                                                      ),
                                                    ),
                                                ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.center,
                                                              child: AutoSizeText(
                                                                olculenMinNemZmn,
                                                                textAlign:TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              
                                          ],
                                        )),
                                        

                                      ],
                                    )
                                  ),
                                  
                                ],
                              )
                            ),
                      Spacer(),
                      Expanded(
                          flex: 20,
                          child: Row(
                              children: <Widget>[
                                Spacer(),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        Dil().sec(dilSecimi, "tv426"),
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600]),
                                        textScaleFactor: oran, textAlign:TextAlign.center,
                                      ),
                                      Text(
                                        olumOrani,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Colors.blue[200]),
                                        textScaleFactor: oran,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        Dil().sec(dilSecimi, "tv418"),
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600]),
                                        textScaleFactor: oran, textAlign:TextAlign.center,
                                      ),
                                      Text(
                                        guncelOluHayvanSayisi,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Colors.blue[200]),
                                        textScaleFactor: oran,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        Dil().sec(dilSecimi, "tv427"),
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600]),
                                        textScaleFactor: oran,textAlign:TextAlign.center,
                                      ),
                                      Text(
                                        guncelHayvanSayisi,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Colors.blue[200]),
                                        textScaleFactor: oran,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        Dil().sec(dilSecimi, "tv428"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600]),
                                        textScaleFactor: oran,
                                      ),
                                      Text(
                                        suruYasiGunluk,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Colors.blue[200]),
                                        textScaleFactor: oran,
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        Dil().sec(dilSecimi, "tv429"),
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.grey[600]),
                                        textScaleFactor: oran,textAlign:TextAlign.center,
                                      ),
                                      Text(
                                        suruYasiHaftalik,
                                        style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                            color: Colors.blue[200]),
                                        textScaleFactor: oran,
                                      )
                                    ],
                                  ),
                                ),
                                Spacer()
                              ],
                            ),
                        ), 
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(),
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
                      Dil().sec(dilSecimi, "tv569"), 
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
                                  text: Dil().sec(dilSecimi, "info23"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv614")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info23a"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv615")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info23b"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv665")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info23c"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv666")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info23d"),
                                  style: TextStyle(
                                    color: Colors.black,
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
                                  text:'\n'+ Dil().sec(dilSecimi, "ksltm1")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm2")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm3")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm4")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm5")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm6")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm7")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm8")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm9")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm10")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm11")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm12")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm13")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm14")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm15")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm16")+'\n',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11*oran,
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

  takipEtVeriIsleme(String gelenVeri){
    
    var degerler=gelenVeri.split("*");
    print(degerler);
    setSicakligi=degerler[0];
    ortSicaklik=degerler[1];
    dogBolgeBitis=degerler[2];
    capBolgeBitis=degerler[3];
    olculenMakSic=degerler[4];
    olculenMinSic=degerler[5];
    olculenMakSicZmn=degerler[6];
    olculenMinSicZmn=degerler[7];
    icNem=degerler[8];
    disNem=degerler[9];
    ortHissedilirSicaklik=degerler[10];
    olumOrani=degerler[11];
    guncelOluHayvanSayisi=degerler[12];
    guncelHayvanSayisi=degerler[13];
    suruYasiGunluk=degerler[14];
    suruYasiHaftalik=degerler[15];
    havaHizi=degerler[16];
    sistemModu=int.parse(degerler[17]);
    nemDurum=int.parse(degerler[18]);
    olculenMakNem=degerler[19];
    olculenMinNem=degerler[20];
    olculenMakNemZmn=degerler[21];
    olculenMinNemZmn=degerler[22];
    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }

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

  String sistemModMetni(int modNo, int nemDurum){
    String xx="";
    String yy=nemDurum==1 ? " - "+Dil().sec(dilSecimi, "tv577") : 
    (nemDurum==2 ? " - "+Dil().sec(dilSecimi, "tv578") : "");

    
    if(modNo==0){
      xx=Dil().sec(dilSecimi, "tv572");
    }else if(modNo==1){
      xx=Dil().sec(dilSecimi, "tv573");
    }else if(modNo==2){
      xx=Dil().sec(dilSecimi, "tv574");
    }else if(modNo==3){
      xx=Dil().sec(dilSecimi, "tv575")+yy;
    }else if(modNo==4){
      xx=Dil().sec(dilSecimi, "tv576")+yy;
    }

    return xx;

  }

}
