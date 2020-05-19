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

  String suSayacResetSaatiSaat="07";
  String suSayacResetSaatiDakika="00";
  bool suSayacResetSaatiAM=false;
  bool suSayacResetSaatiPM=true;

  String olculenMinMaksResetSaatiSaat="07";
  String olculenMinMaksResetSaatiDakika="00";
  bool olculenMinMaksResetSaatiAM=false;
  bool olculenMinMaksResetSaatiPM=true;

  String yemTuketimResetSaatiSaat="07";
  String yemTuketimResetSaatiDakika="00";
  bool yemTuketimResetSaatiAM=false;
  bool yemTuketimResetSaatiPM=true;

  bool format24saatlik=true;

  String baglantiDurum="";


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
      if (dbVeri[i]["id"] == 34) {
        format24saatlik = dbVeri[i]["veri1"] =="1" ? true: false;
      }
    }
    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    if (timerSayac == 0) {
      
      Metotlar().takipEt('27*', 2236).then((veri){
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
          
          Metotlar().takipEt('27*', 2236).then((veri){
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
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv481',baglantiDurum),
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
                                //opsiyon 1
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
                                                          
                                                          yazmaSonrasiGecikmeSayaci = 0;
                                                          String komut="32*$_index*$veri";
                                                          Metotlar().veriGonder(komut, 2235).then((value){
                                                            if(value.split("*")[0]=="error"){
                                                              Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                            }else{
                                                              Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                              
                                                              baglanti = false;
                                                              Metotlar().takipEt('27*', 2236).then((veri){
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
                                                              

                                                              yazmaSonrasiGecikmeSayaci = 0;
                                                              String komut="32*$_index*$veri";
                                                              Metotlar().veriGonder(komut, 2235).then((value){
                                                                if(value.split("*")[0]=="error"){
                                                                  Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                }else{
                                                                  Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                  
                                                                  baglanti = false;
                                                                  Metotlar().takipEt('27*', 2236).then((veri){
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
                                //opsiyon 2
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
                                //opsiyon 3
                                Expanded(
                                  flex: 20,
                                  child: Column(
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv676"),style: TextStyle(
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

                                                                  _degergiris2X0(_onlar, _birler, _index, 4, oran, dilSecimi, "tv200");
                                                                  
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
                                //opsiyon 4
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
                                                          

                                                          yazmaSonrasiGecikmeSayaci = 0;
                                                          String komut="32*$_index*$veri";
                                                          Metotlar().veriGonder(komut, 2235).then((value){
                                                            if(value.split("*")[0]=="error"){
                                                              Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                            }else{
                                                              Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                              
                                                              baglanti = false;
                                                              Metotlar().takipEt('27*', 2236).then((veri){
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
                                                               6,
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
                                                               7,
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
                                Spacer(),
                                //opsiyon 5
                                Expanded(
                                  flex: 20,
                                  child: Column(
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv663"),style: TextStyle(
                                        fontFamily: 'Kelly Slab'
                                      ),
                                      textScaleFactor: oran,
                                      ),
                                      Expanded(
                                         child: Container(color: Colors.blue[50],
                                           child: Column(
                                             children: <Widget>[
                                               Expanded(flex: 3,
                                                 child: SizedBox(
                                                   child: Container(
                                                     alignment: Alignment.center,
                                                     child: AutoSizeText(
                                                       Dil().sec(
                                                           dilSecimi, "tv664"),
                                                       textAlign: TextAlign.center,
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
                                               Expanded(flex: 5,
                                                 child: Row(
                                                   mainAxisAlignment:
                                                       MainAxisAlignment.center,
                                                   children: <Widget>[
                                                     Visibility(visible: !format24saatlik,
                                                       child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                         children: <Widget>[

                                                           Row(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           children: <Widget>[
                                                             
                                                             RawMaterialButton(
                                                               materialTapTargetSize:
                                                                   MaterialTapTargetSize.shrinkWrap,
                                                               constraints: BoxConstraints(),
                                                               onPressed: () {

                                                                 if (!suSayacResetSaatiAM) {
                                                                   suSayacResetSaatiAM = true;
                                                                   suSayacResetSaatiPM = false;
                                                                 } 
                                                                
                                                        
                                                                 yazmaSonrasiGecikmeSayaci = 0;
                                                                String komut="32*10*$suSayacResetSaatiSaat";
                                                                Metotlar().veriGonder(komut, 2235).then((value){
                                                                  if(value.split("*")[0]=="error"){
                                                                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                  }else{
                                                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                    
                                                                    baglanti = false;
                                                                    Metotlar().takipEt('27*', 2236).then((veri){
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

                                                                 setState(() {});
                                                               },
                                                               child: Icon(
                                                                   suSayacResetSaatiAM == true
                                                                       ? Icons.check_box
                                                                       : Icons.check_box_outline_blank,
                                                                   color: suSayacResetSaatiAM == true
                                                                       ? Colors.green.shade500
                                                                       : Colors.black,
                                                                   size: 20 * oran),
                                                             ),
                                                             Text(
                                                               'AM',textAlign: TextAlign.center,
                                                               style: TextStyle(
                                                                   fontFamily: 'Kelly Slab',
                                                                   fontWeight: FontWeight.bold),
                                                               textScaleFactor: oran,
                                                               
                                                             ),
                                                             Container(width: 5*oran,)
                                                           ],
                                                           ),
                                                           Row(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           children: <Widget>[
                                                             
                                                             RawMaterialButton(
                                                               materialTapTargetSize:
                                                                   MaterialTapTargetSize.shrinkWrap,
                                                               constraints: BoxConstraints(),
                                                               onPressed: () {

                                                                 if (!suSayacResetSaatiPM) {
                                                                   suSayacResetSaatiPM = true;
                                                                   suSayacResetSaatiAM = false;
                                                                 } 

                                                                 String veri= suSayacResetSaatiSaat=="12" ? '0' : (int.parse(suSayacResetSaatiSaat)+12).toString();

                                                                 

                                                                yazmaSonrasiGecikmeSayaci = 0;
                                                                String komut="32*10*$veri";
                                                                Metotlar().veriGonder(komut, 2235).then((value){
                                                                  if(value.split("*")[0]=="error"){
                                                                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                  }else{
                                                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                    
                                                                    baglanti = false;
                                                                    Metotlar().takipEt('27*', 2236).then((veri){
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

                                                                 setState(() {});
                                                               },
                                                               child: Icon(
                                                                   suSayacResetSaatiPM == true
                                                                       ? Icons.check_box
                                                                       : Icons.check_box_outline_blank,
                                                                   color: suSayacResetSaatiPM == true
                                                                       ? Colors.green.shade500
                                                                       : Colors.black,
                                                                   size: 20 * oran),
                                                             ),
                                                             Text(
                                                               'PM',textAlign: TextAlign.center,
                                                               style: TextStyle(
                                                                   fontFamily: 'Kelly Slab',
                                                                   fontWeight: FontWeight.bold),
                                                               textScaleFactor: oran,
                                                               
                                                             ),
                                                             Container(width: 5*oran,)
                                                           ],
                                                   ),
                                                         
                                                         
                                                         ],
                                                       ),
                                                     ),
                                                   
                                                     RawMaterialButton(
                                                       onPressed: () {
                                                         _index = 8;
                                                         int sayi=int.parse(suSayacResetSaatiSaat);
                                                         _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                         _birler=sayi%10;

                                                         _degergiris2X0(
                                                             _onlar,
                                                             _birler,
                                                             _index,
                                                             8,
                                                             oran,
                                                             dilSecimi,
                                                             "tv338",);
                                                       },
                                                       child: Text(
                                                         suSayacResetSaatiSaat,
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
                                                       fillColor: Colors.green[800],
                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10*oran)),
                                                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                       constraints: BoxConstraints(),
                                                       padding: EdgeInsets.only(top:5*oran,bottom: 5*oran,left: 15*oran,right: 15*oran),
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
                                                         int sayi=int.parse(suSayacResetSaatiDakika);
                                                         _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                         _birler=sayi%10;

                                                         _degergiris2X0(
                                                             _onlar,
                                                             _birler,
                                                             _index,
                                                             9,
                                                             oran,
                                                             dilSecimi,
                                                             "tv339",);
                                                       },
                                                       child: Text(
                                                         suSayacResetSaatiDakika,
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
                                                       fillColor: Colors.red[700],
                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10*oran)),
                                                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                       constraints: BoxConstraints(),
                                                       padding: EdgeInsets.only(top:5*oran,bottom: 5*oran,left: 15*oran,right: 15*oran),
                                                     ),
                                                     
                                             
                                                   ],
                                                 ),
                                               ),
                                               Spacer(flex: 1,)
                                             ],
                                           ),
                                         ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                //opsiyon 6
                                Expanded(
                                  flex: 20,
                                  child: Column(
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv669"),style: TextStyle(
                                        fontFamily: 'Kelly Slab'
                                      ),
                                      textScaleFactor: oran,
                                      ),
                                      Expanded(
                                         child: Container(color: Colors.blue[50],
                                           child: Column(
                                             children: <Widget>[
                                               Expanded(flex: 3,
                                                 child: SizedBox(
                                                   child: Container(
                                                     alignment: Alignment.center,
                                                     child: AutoSizeText(
                                                       Dil().sec(
                                                           dilSecimi, "tv670"),
                                                       textAlign: TextAlign.center,
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
                                               Expanded(flex: 5,
                                                 child: Row(
                                                   mainAxisAlignment:
                                                       MainAxisAlignment.center,
                                                   children: <Widget>[
                                                     Visibility(visible: !format24saatlik,
                                                       child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                         children: <Widget>[

                                                           Row(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           children: <Widget>[
                                                             
                                                             RawMaterialButton(
                                                               materialTapTargetSize:
                                                                   MaterialTapTargetSize.shrinkWrap,
                                                               constraints: BoxConstraints(),
                                                               onPressed: () {

                                                                 if (!olculenMinMaksResetSaatiAM) {
                                                                   olculenMinMaksResetSaatiAM = true;
                                                                   olculenMinMaksResetSaatiPM = false;
                                                                 } 
                                                                
                                                                 
                                                                yazmaSonrasiGecikmeSayaci = 0;
                                                                String komut="32*13*$olculenMinMaksResetSaatiSaat";
                                                                Metotlar().veriGonder(komut, 2235).then((value){
                                                                  if(value.split("*")[0]=="error"){
                                                                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                  }else{
                                                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                    
                                                                    baglanti = false;
                                                                    Metotlar().takipEt('27*', 2236).then((veri){
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

                                                                 setState(() {});
                                                               },
                                                               child: Icon(
                                                                   olculenMinMaksResetSaatiAM == true
                                                                       ? Icons.check_box
                                                                       : Icons.check_box_outline_blank,
                                                                   color: olculenMinMaksResetSaatiAM == true
                                                                       ? Colors.green.shade500
                                                                       : Colors.black,
                                                                   size: 20 * oran),
                                                             ),
                                                             Text(
                                                               'AM',textAlign: TextAlign.center,
                                                               style: TextStyle(
                                                                   fontFamily: 'Kelly Slab',
                                                                   fontWeight: FontWeight.bold),
                                                               textScaleFactor: oran,
                                                               
                                                             ),
                                                             Container(width: 5*oran,)
                                                           ],
                                                           ),
                                                           Row(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           children: <Widget>[
                                                             
                                                             RawMaterialButton(
                                                               materialTapTargetSize:
                                                                   MaterialTapTargetSize.shrinkWrap,
                                                               constraints: BoxConstraints(),
                                                               onPressed: () {

                                                                 if (!olculenMinMaksResetSaatiPM) {
                                                                   olculenMinMaksResetSaatiPM = true;
                                                                   olculenMinMaksResetSaatiAM = false;
                                                                 } 

                                                                 String veri= olculenMinMaksResetSaatiSaat=="12" ? '0' : (int.parse(olculenMinMaksResetSaatiSaat)+12).toString();

                                                                 

                                                                yazmaSonrasiGecikmeSayaci = 0;
                                                                String komut="32*13*$veri";
                                                                Metotlar().veriGonder(komut, 2235).then((value){
                                                                  if(value.split("*")[0]=="error"){
                                                                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                  }else{
                                                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                    
                                                                    baglanti = false;
                                                                    Metotlar().takipEt('27*', 2236).then((veri){
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

                                                                 setState(() {});
                                                               },
                                                               child: Icon(
                                                                   olculenMinMaksResetSaatiPM == true
                                                                       ? Icons.check_box
                                                                       : Icons.check_box_outline_blank,
                                                                   color: olculenMinMaksResetSaatiPM == true
                                                                       ? Colors.green.shade500
                                                                       : Colors.black,
                                                                   size: 20 * oran),
                                                             ),
                                                             Text(
                                                               'PM',textAlign: TextAlign.center,
                                                               style: TextStyle(
                                                                   fontFamily: 'Kelly Slab',
                                                                   fontWeight: FontWeight.bold),
                                                               textScaleFactor: oran,
                                                               
                                                             ),
                                                             Container(width: 5*oran,)
                                                           ],
                                                   ),
                                                         
                                                         
                                                         ],
                                                       ),
                                                     ),
                                                   
                                                     RawMaterialButton(
                                                       onPressed: () {
                                                         _index = 11;
                                                         int sayi=int.parse(olculenMinMaksResetSaatiSaat);
                                                         _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                         _birler=sayi%10;

                                                         _degergiris2X0(
                                                             _onlar,
                                                             _birler,
                                                             _index,
                                                             11,
                                                             oran,
                                                             dilSecimi,
                                                             "tv338",);
                                                       },
                                                       child: Text(
                                                         olculenMinMaksResetSaatiSaat,
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
                                                       fillColor: Colors.green[800],
                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10*oran)),
                                                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                       constraints: BoxConstraints(),
                                                       padding: EdgeInsets.only(top:5*oran,bottom: 5*oran,left: 15*oran,right: 15*oran),
                                                     ),
                                                     Text(
                                                       ":",
                                                       textScaleFactor: oran,
                                                       style:
                                                           TextStyle(fontSize: 34,fontFamily: 'Audio wide'),
                                                           
                                                     ),
                                                     RawMaterialButton(
                                                       onPressed: () {
                                                         _index = 12;
                                                         int sayi=int.parse(olculenMinMaksResetSaatiDakika);
                                                         _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                         _birler=sayi%10;

                                                         _degergiris2X0(
                                                             _onlar,
                                                             _birler,
                                                             _index,
                                                             12,
                                                             oran,
                                                             dilSecimi,
                                                             "tv339",);
                                                       },
                                                       child: Text(
                                                         olculenMinMaksResetSaatiDakika,
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
                                                       fillColor: Colors.red[700],
                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10*oran)),
                                                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                       constraints: BoxConstraints(),
                                                       padding: EdgeInsets.only(top:5*oran,bottom: 5*oran,left: 15*oran,right: 15*oran),
                                                     ),
                                                     
                                             
                                                   ],
                                                 ),
                                               ),
                                               Spacer(flex: 1,)
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
                          
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                //opsiyon 7
                                Expanded(
                                  flex: 20,
                                  child: Column(
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv671"),style: TextStyle(
                                        fontFamily: 'Kelly Slab'
                                      ),
                                      textScaleFactor: oran,
                                      ),
                                      Expanded(
                                         child: Container(color: Colors.blue[50],
                                           child: Column(
                                             children: <Widget>[
                                               Expanded(flex: 3,
                                                 child: SizedBox(
                                                   child: Container(
                                                     alignment: Alignment.center,
                                                     child: AutoSizeText(
                                                       Dil().sec(
                                                           dilSecimi, "tv672"),
                                                       textAlign: TextAlign.center,
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
                                               Expanded(flex: 5,
                                                 child: Row(
                                                   mainAxisAlignment:
                                                       MainAxisAlignment.center,
                                                   children: <Widget>[
                                                     Visibility(visible: !format24saatlik,
                                                       child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                         children: <Widget>[

                                                           Row(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           children: <Widget>[
                                                             
                                                             RawMaterialButton(
                                                               materialTapTargetSize:
                                                                   MaterialTapTargetSize.shrinkWrap,
                                                               constraints: BoxConstraints(),
                                                               onPressed: () {

                                                                 if (!yemTuketimResetSaatiAM) {
                                                                   yemTuketimResetSaatiAM = true;
                                                                   yemTuketimResetSaatiPM = false;
                                                                 } 
                                                                
                                        
                                                                 yazmaSonrasiGecikmeSayaci = 0;
                                                                String komut="32*16*$yemTuketimResetSaatiSaat";
                                                                Metotlar().veriGonder(komut, 2235).then((value){
                                                                  if(value.split("*")[0]=="error"){
                                                                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                  }else{
                                                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                    
                                                                    baglanti = false;
                                                                    Metotlar().takipEt('27*', 2236).then((veri){
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

                                                                 setState(() {});
                                                               },
                                                               child: Icon(
                                                                   yemTuketimResetSaatiAM == true
                                                                       ? Icons.check_box
                                                                       : Icons.check_box_outline_blank,
                                                                   color: yemTuketimResetSaatiAM == true
                                                                       ? Colors.green.shade500
                                                                       : Colors.black,
                                                                   size: 20 * oran),
                                                             ),
                                                             Text(
                                                               'AM',textAlign: TextAlign.center,
                                                               style: TextStyle(
                                                                   fontFamily: 'Kelly Slab',
                                                                   fontWeight: FontWeight.bold),
                                                               textScaleFactor: oran,
                                                               
                                                             ),
                                                             Container(width: 5*oran,)
                                                           ],
                                                           ),
                                                           Row(
                                                           mainAxisAlignment: MainAxisAlignment.center,
                                                           children: <Widget>[
                                                             
                                                             RawMaterialButton(
                                                               materialTapTargetSize:
                                                                   MaterialTapTargetSize.shrinkWrap,
                                                               constraints: BoxConstraints(),
                                                               onPressed: () {

                                                                 if (!yemTuketimResetSaatiPM) {
                                                                   yemTuketimResetSaatiPM = true;
                                                                   yemTuketimResetSaatiAM = false;
                                                                 } 

                                                                 String veri= yemTuketimResetSaatiSaat=="12" ? '0' : (int.parse(yemTuketimResetSaatiSaat)+12).toString();

                                                                 

                                                                 yazmaSonrasiGecikmeSayaci = 0;
                                                                String komut="32*16*$veri";
                                                                Metotlar().veriGonder(komut, 2235).then((value){
                                                                  if(value.split("*")[0]=="error"){
                                                                    Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                  }else{
                                                                    Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                    
                                                                    baglanti = false;
                                                                    Metotlar().takipEt('27*', 2236).then((veri){
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

                                                                 setState(() {});
                                                               },
                                                               child: Icon(
                                                                   yemTuketimResetSaatiPM == true
                                                                       ? Icons.check_box
                                                                       : Icons.check_box_outline_blank,
                                                                   color: yemTuketimResetSaatiPM == true
                                                                       ? Colors.green.shade500
                                                                       : Colors.black,
                                                                   size: 20 * oran),
                                                             ),
                                                             Text(
                                                               'PM',textAlign: TextAlign.center,
                                                               style: TextStyle(
                                                                   fontFamily: 'Kelly Slab',
                                                                   fontWeight: FontWeight.bold),
                                                               textScaleFactor: oran,
                                                               
                                                             ),
                                                             Container(width: 5*oran,)
                                                           ],
                                                   ),
                                                         
                                                         
                                                         ],
                                                       ),
                                                     ),
                                                   
                                                     RawMaterialButton(
                                                       onPressed: () {
                                                         _index = 14;
                                                         int sayi=int.parse(yemTuketimResetSaatiSaat);
                                                         _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                         _birler=sayi%10;

                                                         _degergiris2X0(
                                                             _onlar,
                                                             _birler,
                                                             _index,
                                                             14,
                                                             oran,
                                                             dilSecimi,
                                                             "tv338",);
                                                       },
                                                       child: Text(
                                                         yemTuketimResetSaatiSaat,
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
                                                       fillColor: Colors.green[800],
                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10*oran)),
                                                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                       constraints: BoxConstraints(),
                                                       padding: EdgeInsets.only(top:5*oran,bottom: 5*oran,left: 15*oran,right: 15*oran),
                                                     ),
                                                     Text(
                                                       ":",
                                                       textScaleFactor: oran,
                                                       style:
                                                           TextStyle(fontSize: 34,fontFamily: 'Audio wide'),
                                                           
                                                     ),
                                                     RawMaterialButton(
                                                       onPressed: () {
                                                         _index = 15;
                                                         int sayi=int.parse(yemTuketimResetSaatiDakika);
                                                         _onlar=sayi<10 ? 0 :(sayi>99 ? (sayi-100*_yuzler)~/10 : sayi~/10);
                                                         _birler=sayi%10;

                                                         _degergiris2X0(
                                                             _onlar,
                                                             _birler,
                                                             _index,
                                                             15,
                                                             oran,
                                                             dilSecimi,
                                                             "tv339",);
                                                       },
                                                       child: Text(
                                                         yemTuketimResetSaatiDakika,
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
                                                       fillColor: Colors.red[700],
                                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10*oran)),
                                                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                       constraints: BoxConstraints(),
                                                       padding: EdgeInsets.only(top:5*oran,bottom: 5*oran,left: 15*oran,right: 15*oran),
                                                     ),
                                                     
                                             
                                                   ],
                                                 ),
                                               ),
                                               Spacer(flex: 1,)
                                             ],
                                           ),
                                         ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(flex: 42,)
                                
                              ],
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
                            subtitle: RichText(
                            text: TextSpan(
                              children: <TextSpan>[

                                //Giriş metni
                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info28"),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13*oran
                                  )
                                ),



                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv496")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info28a"),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13*oran
                                  )
                                ),



                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv497")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info28b"),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13*oran
                                  )
                                ),




                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv676")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info28c"),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13*oran
                                  )
                                ),




                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv565")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info28d"),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13*oran
                                  )
                                ),



                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv663")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info28e"),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13*oran
                                  )
                                ),




                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv669")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info28f"),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13*oran
                                  )
                                ),




                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv671")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info28g"),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13*oran
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
        String komut="32*$index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('27*', 2236).then((veri){
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

Future _degergiris2X0(int onlarUnsur, int birlerUnsur, int index, int paramIndex,
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

      String veri="";
      if(index==4){
        fanMinimumCalismaSuresi=(_yuzler*100+_onlar*10+_birler).toString();
        veri=fanMinimumCalismaSuresi;
      }

      if(index==6){
        tFanYumGecisDongu=(_yuzler*100+_onlar*10+_birler).toString();
        veri=tFanYumGecisDongu;
      }

      if(index==7){
        tFanYumGecisAdet=(_yuzler*100+_onlar*10+_birler).toString();
        veri=tFanYumGecisAdet;
      }

      if (index == 8) {

        if(!format24saatlik){
          
          if(_onlar*10+_birler<13){
            suSayacResetSaatiSaat=(_onlar*10+_birler).toString();
              
            if(suSayacResetSaatiPM){
              veri=(int.parse(suSayacResetSaatiSaat)==12 ? '0' : int.parse(suSayacResetSaatiSaat)+12).toString();
            }else{
              veri=suSayacResetSaatiSaat;
            }

          }else{
            veriGonderilsinMi=false;
            Toast.show(Dil().sec(dilSecimi, "toast89"),context,duration: 3);
          }

        }else{
          suSayacResetSaatiSaat=(_onlar*10+_birler).toString();
          veri = suSayacResetSaatiSaat;
        }
        
      }

      if (index == 9) {
        suSayacResetSaatiDakika=(_onlar*10+_birler).toString();
        veri = suSayacResetSaatiDakika;
      }


      if (index == 11) {

        if(!format24saatlik){
          
          if(_onlar*10+_birler<13){
            olculenMinMaksResetSaatiSaat=(_onlar*10+_birler).toString();
              
            if(olculenMinMaksResetSaatiPM){
              veri=(int.parse(olculenMinMaksResetSaatiSaat)==12 ? '0' : int.parse(olculenMinMaksResetSaatiSaat)+12).toString();
            }else{
              veri=olculenMinMaksResetSaatiSaat;
            }

          }else{
            veriGonderilsinMi=false;
            Toast.show(Dil().sec(dilSecimi, "toast89"),context,duration: 3);
          }

        }else{
          olculenMinMaksResetSaatiSaat=(_onlar*10+_birler).toString();
          veri = olculenMinMaksResetSaatiSaat;
        }
        
      }

      if (index == 12) {
        olculenMinMaksResetSaatiDakika=(_onlar*10+_birler).toString();
        veri = olculenMinMaksResetSaatiDakika;
      }


      if (index == 14) {

        if(!format24saatlik){
          
          if(_onlar*10+_birler<13){
            yemTuketimResetSaatiSaat=(_onlar*10+_birler).toString();
              
            if(yemTuketimResetSaatiPM){
              veri=(int.parse(yemTuketimResetSaatiSaat)==12 ? '0' : int.parse(yemTuketimResetSaatiSaat)+12).toString();
            }else{
              veri=yemTuketimResetSaatiSaat;
            }

          }else{
            veriGonderilsinMi=false;
            Toast.show(Dil().sec(dilSecimi, "toast89"),context,duration: 3);
          }

        }else{
          yemTuketimResetSaatiSaat=(_onlar*10+_birler).toString();
          veri = yemTuketimResetSaatiSaat;
        }
        
      }

      if (index == 15) {
        yemTuketimResetSaatiDakika=(_onlar*10+_birler).toString();
        veri = yemTuketimResetSaatiDakika;
      }
      
      


      if (veriGonderilsinMi) {

        yazmaSonrasiGecikmeSayaci = 0;
        String komut="32*$_index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('27*', 2236).then((veri){
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
  

  
  takipEtVeriIsleme(String gelenMesaj){
    
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
              suSayacResetSaatiSaat = degerler[7];
              suSayacResetSaatiDakika = degerler[8];
              olculenMinMaksResetSaatiSaat = degerler[9];
              olculenMinMaksResetSaatiDakika = degerler[10];
              yemTuketimResetSaatiSaat = degerler[11];
              yemTuketimResetSaatiDakika = degerler[12];


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 


  
  //--------------------------METOTLAR--------------------------------

}
