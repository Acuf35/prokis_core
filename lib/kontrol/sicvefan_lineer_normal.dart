import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';

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
import 'package:prokis/yardimci/deger_giris_1x0.dart';
import 'package:prokis/yardimci/deger_giris_2x1.dart';
import 'package:prokis/languages/select.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SicVeFanLineerNormal extends StatefulWidget {
  List<Map> gelenDBveri;
  SicVeFanLineerNormal(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return SicVeFanLineerNormalState(gelenDBveri);
  }
}

class SicVeFanLineerNormalState extends State<SicVeFanLineerNormal> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  String dogalBolgeB = "1.0";
  String capHavFarkC = "0.0";
  String setSicA = "21.0";
  String maksFanFarkiH = "5.0";
  String fanKademesi = "1";

  bool mhDANthYAGECISTEdebiyiKORU=false;

  double gun1 = 33.0;
  double gun7 = 31.0;
  double gun14 = 29.0;
  double gun21 = 27.0;
  double gun28 = 25.0;
  double gun35 = 23.0;
  double gun42 = 21.0;
  List<String> gun = new List(43);
  List<double> fanSet = new List(61);

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
  String alarmDurum="0";


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  SicVeFanLineerNormalState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
    }



    _gunlerSet();

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
      
      Metotlar().takipEt('1*', 2236).then((veri){
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
          
          Metotlar().takipEt('1*', 2236).then((veri){
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
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv181',baglantiDurum, alarmDurum),
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
              color: Colors.grey[300],
              child: Column(
                children: <Widget>[
                  Spacer(
                    flex: 1,
                  ),
                  //Set Sıcaklığı
                  Expanded(
                    flex: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(),
                        //Set Sıcaklığı giriş butonu
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
                                        Dil()
                                            .sec(dilSecimi, "tv125"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
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
                                                          Dil()
                                                              .sec(
                                                                  dilSecimi,
                                                                  "tv180"),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Kelly Slab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                      ),
                                                      //42 günlük set sıcaklığı giriş bölümü
                                                      Expanded(
                                                        flex: 11,
                                                        child: Container(
                                                          color: Colors.white,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: <Widget>[
                                                              //1-6 günler
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                            Dil().sec(dilSecimi,
                                                                                "tv173"),
                                                                            style: TextStyle(
                                                                                fontFamily: 'Kelly Slab',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                        RawMaterialButton(
                                                                          materialTapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                          fillColor:
                                                                              Colors.blue[700],
                                                                          constraints:
                                                                              BoxConstraints(),
                                                                          onPressed:
                                                                              () {
                                                                            _index =
                                                                                4;
                                                                            _onlar = int.parse(gun1.toString().split(".")[0]) < 10
                                                                                ? 0
                                                                                : (int.parse(gun1.toString().split(".")[0]) ~/ 10);
                                                                            _birler =
                                                                                int.parse(gun1.toString().split(".")[0]) % 10;
                                                                            _ondalik =
                                                                                int.parse(gun1.toString().split(".")[1]);

                                                                            _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv173","",dbProkis).then((onValue) {
                                                                              bottomDrawerIcindeGuncelle(state);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 4,
                                                                                bottom: 4,
                                                                                left: 10,
                                                                                right: 10),
                                                                            child:
                                                                                Text(gun1.toString(), style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24 * oran, color: Colors.white)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv131"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[1],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv132"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[2],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv133"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[3],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv134"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[4],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv135"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[5],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv136"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[6],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              //7-13 günler
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                            Dil().sec(dilSecimi,
                                                                                "tv174"),
                                                                            style: TextStyle(
                                                                                fontFamily: 'Kelly Slab',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                        RawMaterialButton(
                                                                          materialTapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                          fillColor:
                                                                              Colors.blue[700],
                                                                          constraints:
                                                                              BoxConstraints(),
                                                                          onPressed:
                                                                              () {
                                                                            _index =
                                                                                5;
                                                                            _onlar = int.parse(gun7.toString().split(".")[0]) < 10
                                                                                ? 0
                                                                                : (int.parse(gun7.toString().split(".")[0]) ~/ 10);
                                                                            _birler =
                                                                                int.parse(gun7.toString().split(".")[0]) % 10;
                                                                            _ondalik =
                                                                                int.parse(gun7.toString().split(".")[1]);

                                                                            _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv174","",dbProkis).then((onValue) {
                                                                              bottomDrawerIcindeGuncelle(state);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 4,
                                                                                bottom: 4,
                                                                                left: 10,
                                                                                right: 10),
                                                                            child:
                                                                                Text(gun7.toString(), style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24 * oran, color: Colors.white)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv137"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[7],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv138"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[8],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv139"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[9],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv140"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[10],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv141"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[11],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv142"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[12],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv143"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[13],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              //14-20 günler
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                            Dil().sec(dilSecimi,
                                                                                "tv175"),
                                                                            style: TextStyle(
                                                                                fontFamily: 'Kelly Slab',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                        RawMaterialButton(
                                                                          materialTapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                          fillColor:
                                                                              Colors.blue[700],
                                                                          constraints:
                                                                              BoxConstraints(),
                                                                          onPressed:
                                                                              () {
                                                                            _index =
                                                                                6;
                                                                            _onlar = int.parse(gun14.toString().split(".")[0]) < 10
                                                                                ? 0
                                                                                : (int.parse(gun14.toString().split(".")[0]) ~/ 10);
                                                                            _birler =
                                                                                int.parse(gun14.toString().split(".")[0]) % 10;
                                                                            _ondalik =
                                                                                int.parse(gun14.toString().split(".")[1]);

                                                                            _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv175","",dbProkis).then((onValue) {
                                                                              bottomDrawerIcindeGuncelle(state);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 4,
                                                                                bottom: 4,
                                                                                left: 10,
                                                                                right: 10),
                                                                            child:
                                                                                Text(gun14.toString(), style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24 * oran, color: Colors.white)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv144"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[14],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv145"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[15],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv146"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[16],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv147"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[17],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv148"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[18],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv149"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[19],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv150"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[20],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              //21-27 günler
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                            Dil().sec(dilSecimi,
                                                                                "tv176"),
                                                                            style: TextStyle(
                                                                                fontFamily: 'Kelly Slab',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                        RawMaterialButton(
                                                                          materialTapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                          fillColor:
                                                                              Colors.blue[700],
                                                                          constraints:
                                                                              BoxConstraints(),
                                                                          onPressed:
                                                                              () {
                                                                            _index =
                                                                                7;
                                                                            _onlar = int.parse(gun21.toString().split(".")[0]) < 10
                                                                                ? 0
                                                                                : (int.parse(gun21.toString().split(".")[0]) ~/ 10);
                                                                            _birler =
                                                                                int.parse(gun21.toString().split(".")[0]) % 10;
                                                                            _ondalik =
                                                                                int.parse(gun21.toString().split(".")[1]);

                                                                            _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv176","",dbProkis).then((onValue) {
                                                                              bottomDrawerIcindeGuncelle(state);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 4,
                                                                                bottom: 4,
                                                                                left: 10,
                                                                                right: 10),
                                                                            child:
                                                                                Text(gun21.toString(), style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24 * oran, color: Colors.white)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv151"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[21],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv152"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[22],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv153"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[23],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv154"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[24],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv155"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[25],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv156"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[26],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv157"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[27],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              //28-34 günler
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                            Dil().sec(dilSecimi,
                                                                                "tv177"),
                                                                            style: TextStyle(
                                                                                fontFamily: 'Kelly Slab',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                        RawMaterialButton(
                                                                          materialTapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                          fillColor:
                                                                              Colors.blue[700],
                                                                          constraints:
                                                                              BoxConstraints(),
                                                                          onPressed:
                                                                              () {
                                                                            _index =
                                                                                8;
                                                                            _onlar = int.parse(gun28.toString().split(".")[0]) < 10
                                                                                ? 0
                                                                                : (int.parse(gun28.toString().split(".")[0]) ~/ 10);
                                                                            _birler =
                                                                                int.parse(gun28.toString().split(".")[0]) % 10;
                                                                            _ondalik =
                                                                                int.parse(gun28.toString().split(".")[1]);

                                                                            _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv177","",dbProkis).then((onValue) {
                                                                              bottomDrawerIcindeGuncelle(state);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 4,
                                                                                bottom: 4,
                                                                                left: 10,
                                                                                right: 10),
                                                                            child:
                                                                                Text(gun28.toString(), style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24 * oran, color: Colors.white)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv158"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[28],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv159"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[29],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv160"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[30],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv161"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[31],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv162"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[32],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv163"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[33],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv164"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[34],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              //35-41 günler
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                            Dil().sec(dilSecimi,
                                                                                "tv178"),
                                                                            style: TextStyle(
                                                                                fontFamily: 'Kelly Slab',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                        RawMaterialButton(
                                                                          materialTapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                          fillColor:
                                                                              Colors.blue[700],
                                                                          constraints:
                                                                              BoxConstraints(),
                                                                          onPressed:
                                                                              () {
                                                                            _index =
                                                                                9;
                                                                            _onlar = int.parse(gun35.toString().split(".")[0]) < 10
                                                                                ? 0
                                                                                : (int.parse(gun35.toString().split(".")[0]) ~/ 10);
                                                                            _birler =
                                                                                int.parse(gun35.toString().split(".")[0]) % 10;
                                                                            _ondalik =
                                                                                int.parse(gun35.toString().split(".")[1]);

                                                                            _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv178","",dbProkis).then((onValue) {
                                                                              bottomDrawerIcindeGuncelle(state);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 4,
                                                                                bottom: 4,
                                                                                left: 10,
                                                                                right: 10),
                                                                            child:
                                                                                Text(gun35.toString(), style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24 * oran, color: Colors.white)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv165"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[35],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv166"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[36],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv167"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[37],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv168"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[38],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv169"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[39],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv170"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[40],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv171"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[41],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              //42. gün
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                            Dil().sec(dilSecimi,
                                                                                "tv179"),
                                                                            style: TextStyle(
                                                                                fontFamily: 'Kelly Slab',
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black)),
                                                                        RawMaterialButton(
                                                                          materialTapTargetSize:
                                                                              MaterialTapTargetSize.shrinkWrap,
                                                                          fillColor:
                                                                              Colors.blue[700],
                                                                          constraints:
                                                                              BoxConstraints(),
                                                                          onPressed:
                                                                              () {
                                                                            _index =
                                                                                10;
                                                                            _onlar = int.parse(gun42.toString().split(".")[0]) < 10
                                                                                ? 0
                                                                                : (int.parse(gun42.toString().split(".")[0]) ~/ 10);
                                                                            _birler =
                                                                                int.parse(gun42.toString().split(".")[0]) % 10;
                                                                            _ondalik =
                                                                                int.parse(gun42.toString().split(".")[1]);

                                                                            _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv179","",dbProkis).then((onValue) {
                                                                              bottomDrawerIcindeGuncelle(state);
                                                                            });
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                top: 4,
                                                                                bottom: 4,
                                                                                left: 10,
                                                                                right: 10),
                                                                            child:
                                                                                Text(gun42.toString(), style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24 * oran, color: Colors.white)),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Row(
                                                                          children: <
                                                                              Widget>[
                                                                            Text(Dil().sec(dilSecimi, "tv172"),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Kelly Slab',
                                                                                )),
                                                                            Text(gun[42],
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontFamily: 'Kelly Slab',
                                                                                ))
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
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
                                        LayoutBuilder(
                                            builder: (context, constraint) {
                                          return Icon(
                                            Icons.brightness_1,
                                            size: constraint.biggest.height,
                                            color: Colors.blue[700],
                                          );
                                        }),
                                        Text(
                                          setSicA,
                                          style: TextStyle(
                                              fontSize: 25 * oran,
                                              fontFamily: 'Kelly Slab',
                                              fontWeight: FontWeight.bold,
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
                        Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            
                                            Expanded(
                                              flex: 2,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, "tv480"),
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
                                                  if (!mhDANthYAGECISTEdebiyiKORU) {
                                                    mhDANthYAGECISTEdebiyiKORU = true;
                                                  } else {
                                                    mhDANthYAGECISTEdebiyiKORU = false;
                                                  }

                                                  String veri=mhDANthYAGECISTEdebiyiKORU==true ? '1' : '0';
                                                  
                                                  yazmaSonrasiGecikmeSayaci = 0;
                                                  String komut="1*$gun1*$gun7*$gun14*$gun21*$gun28*$gun35*$gun42*$dogalBolgeB*$capHavFarkC*$maksFanFarkiH*$fanKademesi*$veri";
                                                  Metotlar().veriGonder(komut, 2235).then((value){
                                                    if(value.split("*")[0]=="error"){
                                                      Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
                                                    }else{
                                                      Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                      
                                                      baglanti = false;
                                                      Metotlar().takipEt('1*', 2236).then((veri){
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
                                                icon: Icon(
                                                    mhDANthYAGECISTEdebiyiKORU == true
                                                        ? Icons.check_box
                                                        : Icons.check_box_outline_blank),
                                                color: mhDANthYAGECISTEdebiyiKORU == true
                                                    ? Colors.green.shade500
                                                    : Colors.blue.shade600,
                                                iconSize: 30 * oran,
                                              ),
                                            ),
                                            //Spacer(flex: 1,)
                                          ],
                                        ),
                                      ),
                           
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  //Diğerleri
                  Expanded(
                    flex: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(),
                        //Doğal Bölge giriş butonu
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
                                        Dil()
                                            .sec(dilSecimi, "tv126"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      _index = 0;
                                      _onlar = int.parse(
                                                  dogalBolgeB.split(".")[0]) <
                                              10
                                          ? 0
                                          : (int.parse(
                                                  dogalBolgeB.split(".")[0]) ~/
                                              10);
                                      _birler =
                                          int.parse(dogalBolgeB.split(".")[0]) %
                                              10;
                                      _ondalik =
                                          int.parse(dogalBolgeB.split(".")[1]);

                                      _degergiris2X1(_onlar, _birler, _ondalik,
                                          _index, oran, dilSecimi, "tv126","",dbProkis);
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        LayoutBuilder(
                                            builder: (context, constraint) {
                                          return Icon(
                                            Icons.brightness_1,
                                            size: constraint.biggest.height,
                                            color: Colors.green[700],
                                          );
                                        }),
                                        Text(
                                          dogalBolgeB,
                                          style: TextStyle(
                                              fontSize: 25 * oran,
                                              fontFamily: 'Kelly Slab',
                                              fontWeight: FontWeight.bold,
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
                        Spacer(),
                        //Maksimum fan sıcaklığı giriş butonu
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
                                        Dil()
                                            .sec(dilSecimi, "tv130"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      _index = 3;
                                      _onlar = int.parse(
                                                  maksFanFarkiH.split(".")[0]) <
                                              10
                                          ? 0
                                          : (int.parse(maksFanFarkiH
                                                  .split(".")[0]) ~/
                                              10);
                                      _birler = int.parse(
                                              maksFanFarkiH.split(".")[0]) %
                                          10;
                                      _ondalik = int.parse(
                                          maksFanFarkiH.split(".")[1]);

                                      _degergiris2X1(_onlar, _birler, _ondalik,
                                          _index, oran, dilSecimi, "tv130","",dbProkis);
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        LayoutBuilder(
                                            builder: (context, constraint) {
                                          return Icon(
                                            Icons.brightness_1,
                                            size: constraint.biggest.height,
                                            color: Colors.red[700],
                                          );
                                        }),
                                        Text(
                                          maksFanFarkiH,
                                          style: TextStyle(
                                              fontSize: 25 * oran,
                                              fontFamily: 'Kelly Slab',
                                              fontWeight: FontWeight.bold,
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
                        Spacer(),
                        //Adet kademe giriş butonu
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
                                        Dil()
                                            .sec(dilSecimi, "tv182"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      _index = 11;
                                      _birler = int.parse(fanKademesi);

                                      _degergiris1X0(_birler, _index, oran,
                                          dilSecimi, "tv182", 4,dbProkis);
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        LayoutBuilder(
                                            builder: (context, constraint) {
                                          return Icon(
                                            Icons.brightness_1,
                                            size: constraint.biggest.height,
                                            color: Colors.cyan[800],
                                          );
                                        }),
                                        Text(
                                          fanKademesi,
                                          style: TextStyle(
                                              fontSize: 25 * oran,
                                              fontFamily: 'Kelly Slab',
                                              fontWeight: FontWeight.bold,
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
                        Spacer(),
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  //Sıcaklık çizelgesi bölümü
                  Expanded(
                    flex: 10,
                    child: Container(
                      color: Colors.white,
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
                                  child: Text(Dil()
                                      .sec(dilSecimi, "tv184"),textScaleFactor: oran),
                                ),
                                Expanded(
                                    flex: 3,
                                    child: charts.BarChart(
                                      _grafikDataLineerNormal(
                                          double.parse(setSicA),
                                          double.parse(dogalBolgeB),
                                          double.parse(maksFanFarkiH),
                                          dilSecimi),


                                          domainAxis: new charts.OrdinalAxisSpec(
                                          
                                          renderSpec: new charts.SmallTickRendererSpec(
                                          
                                              // Tick and Label styling here.
                                            labelStyle: new charts.TextStyleSpec(
                                              fontSize: (12*oran).floor(), // size in Pts.
                                              color: charts.MaterialPalette.black)
                                            )
                                        ),




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
                                            charts.TickSpec<num>(16),
                                            charts.TickSpec<num>(
                                                double.parse(setSicA)),
                                            charts.TickSpec<num>(
                                                double.parse(setSicA) +
                                                    double.parse(dogalBolgeB)),
                                            charts.TickSpec<num>(double.parse(
                                                    setSicA) +
                                                double.parse(dogalBolgeB) +
                                                double.parse(maksFanFarkiH)),
                                            charts.TickSpec<num>(double.parse(
                                                    setSicA) +
                                                double.parse(dogalBolgeB) +
                                                double.parse(maksFanFarkiH) +
                                                1),
                                            charts.TickSpec<num>(double.parse(
                                                    setSicA) +
                                                double.parse(dogalBolgeB) +
                                                double.parse(maksFanFarkiH) +
                                                2),
                                            charts.TickSpec<num>(double.parse(
                                                    setSicA) +
                                                double.parse(dogalBolgeB) +
                                                double.parse(maksFanFarkiH) +
                                                3),
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
                      Dil()
                          .sec(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
                                    'assets/images/diagram_lineer_normal.jpg'),
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
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "A",
                                            style: TextStyle(fontSize: 13 *oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "A+B",
                                            style: TextStyle(fontSize: 13 *oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "D",
                                            style: TextStyle(fontSize: 13 *oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "F",
                                            style: TextStyle(fontSize: 13 *oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "G",
                                            style: TextStyle(fontSize: 13 *oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "A+B+H",textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 13 *oran),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(
                                                    dilSecimi, "tv115"),
                                            style: TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(
                                                    dilSecimi, "tv116"),
                                            style: TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(
                                                    dilSecimi, "tv118"),
                                            style: TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(
                                                    dilSecimi, "tv120"),
                                            style: TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(
                                                    dilSecimi, "tv121"),
                                            style: TextStyle(fontSize: 13 * oran),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            " : " +
                                                Dil().sec(
                                                    dilSecimi, "tv122"),
                                            style: TextStyle(fontSize: 13 * oran),
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
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        ListTile(
                          dense: false,
                          title: Text(
                              Dil().sec(dilSecimi, "tv186"),textScaleFactor: oran,),
                          subtitle: Text(
                            Dil().sec(dilSecimi, "info2"),
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

  Future _degergiris2X1(int onlar, birler, ondalik, index, double oran,
      String dil, baslik, onBaslik,DBProkis dbProkis) async {
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

      if (index == 0) {
        dogalBolgeB = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
      }
      if (index == 1) {
        setSicA =
            _onlar.toString() + _birler.toString() + "." + _ondalik.toString();
      }
      if (index == 2) {
        capHavFarkC = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
      }
      if (index == 3) {
        maksFanFarkiH = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
      }
      if (index == 4) {
        gun1 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 5) {
        gun7 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 6) {
        gun14 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 7) {
        gun21 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 8) {
        gun28 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 9) {
        gun35 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 10) {
        gun42 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }

      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        capHavFarkC = "0";
        String veri=mhDANthYAGECISTEdebiyiKORU==true ? '1' : '0';
        
        yazmaSonrasiGecikmeSayaci = 0;
        String komut="1*$gun1*$gun7*$gun14*$gun21*$gun28*$gun35*$gun42*$dogalBolgeB*$capHavFarkC*$maksFanFarkiH*$fanKademesi*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('1*', 2236).then((veri){
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

  Future _degergiris1X0(
      int birlerX, index, double oran, String dil, baslik, int ustLimit, DBProkis dbProkis) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris1X0.Deger(ustLimit, birlerX, index, oran, dil, baslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_birler != val[0]) {
        veriGonderilsinMi = true;
      }
      _birler = val[0];
      _index = val[1];

      fanKademesi = _birler.toString();
      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        capHavFarkC = "0";
        String veri=mhDANthYAGECISTEdebiyiKORU==true ? '1' : '0';
        
        yazmaSonrasiGecikmeSayaci = 0;
        String komut="1*$gun1*$gun7*$gun14*$gun21*$gun28*$gun35*$gun42*$dogalBolgeB*$capHavFarkC*$maksFanFarkiH*$fanKademesi*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1],dbProkis), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('1*', 2236).then((veri){
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

  String _gunSetHesap(double gunBuyuk, gunKucuk, int bolum, carpim) {
    return ((gunKucuk - (((gunKucuk - gunBuyuk) * carpim) / bolum)).toString())
        .substring(0, 4);
  }

  _gunlerSet() {
    gun[1] = gun1.toString();
    gun[2] = _gunSetHesap(gun7, gun1, 6, 1);
    gun[3] = _gunSetHesap(gun7, gun1, 6, 2);
    gun[4] = _gunSetHesap(gun7, gun1, 6, 3);
    gun[5] = _gunSetHesap(gun7, gun1, 6, 4);
    gun[6] = _gunSetHesap(gun7, gun1, 6, 5);

    gun[7] = gun7.toString();
    gun[8] = _gunSetHesap(gun14, gun7, 7, 1);
    gun[9] = _gunSetHesap(gun14, gun7, 7, 2);
    gun[10] = _gunSetHesap(gun14, gun7, 7, 3);
    gun[11] = _gunSetHesap(gun14, gun7, 7, 4);
    gun[12] = _gunSetHesap(gun14, gun7, 7, 5);
    gun[13] = _gunSetHesap(gun14, gun7, 7, 6);

    gun[14] = gun14.toString();
    gun[15] = _gunSetHesap(gun21, gun14, 7, 1);
    gun[16] = _gunSetHesap(gun21, gun14, 7, 2);
    gun[17] = _gunSetHesap(gun21, gun14, 7, 3);
    gun[18] = _gunSetHesap(gun21, gun14, 7, 4);
    gun[19] = _gunSetHesap(gun21, gun14, 7, 5);
    gun[20] = _gunSetHesap(gun21, gun14, 7, 6);

    gun[21] = gun21.toString();
    gun[22] = _gunSetHesap(gun28, gun21, 7, 1);
    gun[23] = _gunSetHesap(gun28, gun21, 7, 2);
    gun[24] = _gunSetHesap(gun28, gun21, 7, 3);
    gun[25] = _gunSetHesap(gun28, gun21, 7, 4);
    gun[26] = _gunSetHesap(gun28, gun21, 7, 5);
    gun[27] = _gunSetHesap(gun28, gun21, 7, 6);

    gun[28] = gun28.toString();
    gun[29] = _gunSetHesap(gun35, gun28, 7, 1);
    gun[30] = _gunSetHesap(gun35, gun28, 7, 2);
    gun[31] = _gunSetHesap(gun35, gun28, 7, 3);
    gun[32] = _gunSetHesap(gun35, gun28, 7, 4);
    gun[33] = _gunSetHesap(gun35, gun28, 7, 5);
    gun[34] = _gunSetHesap(gun35, gun28, 7, 6);

    gun[35] = gun35.toString();
    gun[36] = _gunSetHesap(gun42, gun35, 7, 1);
    gun[37] = _gunSetHesap(gun42, gun35, 7, 2);
    gun[38] = _gunSetHesap(gun42, gun35, 7, 3);
    gun[39] = _gunSetHesap(gun42, gun35, 7, 4);
    gun[40] = _gunSetHesap(gun42, gun35, 7, 5);
    gun[41] = _gunSetHesap(gun42, gun35, 7, 6);
    gun[42] = gun42.toString();
  }

  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

  static List<charts.Series<GrafikSicaklikCizelgesi, String>>
      _grafikDataLineerNormal(double setSic, dogBol, maksFanFark, String dil) {
    final fasilaBolgesi = [
      new GrafikSicaklikCizelgesi(Dil().sec(dil, "tv183"),
          setSic, Colors.blue[700]),
    ];

    final dogalBolge = [
      new GrafikSicaklikCizelgesi(Dil().sec(dil, "tv183"),
          dogBol, Colors.green[700]),
    ];

    final tunelBolge = [
      new GrafikSicaklikCizelgesi(Dil().sec(dil, "tv183"),
          maksFanFark, Colors.red[700]),
    ];

    return [
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: Dil().sec(dil, "tv188"),
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: fasilaBolgesi,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: Dil().sec(dil, "tv187"),
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: dogalBolge,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: Dil().sec(dil, "tv190"),
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: tunelBolge,
      ),
    ];
  }

 
  takipEtVeriIsleme(String gelenMesaj){
    
    var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              gun1 = double.parse(degerler[0]);
              gun7 = double.parse(degerler[1]);
              gun14 = double.parse(degerler[2]);
              gun21 = double.parse(degerler[3]);
              gun28 = double.parse(degerler[4]);
              gun35 = double.parse(degerler[5]);
              gun42 = double.parse(degerler[6]);
              dogalBolgeB = degerler[7];
              capHavFarkC = degerler[8];
              maksFanFarkiH = degerler[9];
              fanKademesi = degerler[10];
              setSicA = degerler[11];
              mhDANthYAGECISTEdebiyiKORU=degerler[12]=="True" ? true : false;

              alarmDurum=degerler[13];


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 

  //--------------------------METOTLAR--------------------------------

}

class GrafikSicaklikCizelgesi {
  final String baslik;
  final double deger;
  final charts.Color color;

  GrafikSicaklikCizelgesi(this.baslik, this.deger, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
