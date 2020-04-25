
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
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  IzlemeState(List<Map> dbVeri) {
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

    return Scaffold(
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv569'),
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
        child: FittedBox(
                    child: FloatingActionButton(
            onPressed: () {
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
                Spacer(),
                Expanded(flex: 30,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      Spacer(
                        flex: 3,
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        ],
      )
      );
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
}