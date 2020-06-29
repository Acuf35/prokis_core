import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/alarm/harici_alarm.dart';
import 'package:prokis/alarm/korna_iptal.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/deger_giris_2x0.dart';
import 'package:prokis/yardimci/deger_giris_3x0.dart';
import 'package:prokis/yardimci/deger_giris_6x0.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_2x1.dart';
import 'package:prokis/languages/select.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Alarm extends StatefulWidget {
  List<Map> gelenDBveri;
  Alarm(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return AlarmState(gelenDBveri);
  }
}

class AlarmState extends State<Alarm> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  double gun1 = 33.0;
  double gun7 = 31.0;
  double gun14 = 29.0;
  double gun21 = 27.0;
  double gun28 = 25.0;
  double gun35 = 23.0;
  double gun42 = 21.0;
  double gun1Min = 0.0;
  double gun7Min = 0.0;
  double gun14Min = 0.0;
  double gun21Min = 0.0;
  double gun28Min = 0.0;
  double gun35Min = 0.0;
  double gun42Min = 0.0;
  double gun1Max = 38.0;
  double gun7Max = 38.0;
  double gun14Max = 38.0;
  double gun21Max = 38.0;
  double gun28Max = 38.0;
  double gun35Max = 38.0;
  double gun42Max = 38.0;
  List<String> gun = new List(43);
  List<String> gunMin = new List.filled(43, "30.0");
  List<String> gunMax = new List.filled(43, "35.0");

  String setSic = "23.0";
  String minSic = "19.0";
  String maxSic = "28.0";
  String minNem = "25.0";
  String maxNem = "85.0";

  bool gun1AraDegerGoster = false;
  bool gun7AraDegerGoster = false;
  bool gun14AraDegerGoster = false;
  bool gun21AraDegerGoster = false;
  bool gun28AraDegerGoster = false;
  bool gun35AraDegerGoster = false;
  bool gun42AraDegerGoster = false;

  String yukVeDusNemveSicAlarmGecikmesi="10";
  String birSayacIcinMinTukMiktari="100";
  String pedBakimZamaniGeldiDonguSuresi="250";
  String pedBakimZamaniGeldiKalanSure="250";
  String sistemBakimZamaniGeldiDonguSuresi="365";
  String sistemBakimZamaniGeldiKalanSure="365";
  String kornaSusSuresi="200";
  bool kornaSus=false;

  int _yuzBinler = 0;
  int _onBinler = 0;
  int _binler = 0;
  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _ondalik = 0;
  int _index = 0;

  String hariciAlarmText="";

  
  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci = 4;

  String baglantiDurum = "";
  String alarmDurum="00000000000000000000000000000000000000000000000000000000000000000000000000000000";

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  AlarmState(List<Map> dbVeri) {
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
  void dispose() {
    timerCancel = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dbProkis = Provider.of<DBProkis>(context);


    //_textFieldCursorPosition(tec1, provider.getklepeNo==null ? "" : provider.getklepeNo);

    if (timerSayac == 0) {
      Metotlar().takipEt('31*', 2236).then((veri) {
        if (veri.split("*")[0] == "error") {
          baglanti = false;
          baglantiDurum =
              Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
          setState(() {});
        } else {
          takipEtVeriIsleme(veri);
          baglantiDurum = "";
        }
      });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;

          Metotlar().takipEt('31*', 2236).then((veri) {
            if (veri.split("*")[0] == "error") {
              baglanti = false;
              baglantiDurum =
                  Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
              setState(() {});
            } else {
              takipEtVeriIsleme(veri);
              baglantiDurum = "";
            }
          });
        }
      });
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv702', baglantiDurum, alarmDurum),
      body: Column(
        children: <Widget>[
          //Saat&Tarih
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.grey[300],
                  padding: EdgeInsets.only(left: 10 * oran),
                  child: TimerBuilder.periodic(Duration(seconds: 1),
                      builder: (context) {
                    return Text(
                      Metotlar().getSystemTime(dbVeriler),
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontFamily: 'Kelly Slab',
                          fontSize: 12 * oran,
                          fontWeight: FontWeight.bold),
                    );
                  }),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.grey[300],
                  padding: EdgeInsets.only(right: 10 * oran),
                  child: TimerBuilder.periodic(Duration(seconds: 1),
                      builder: (context) {
                    return Text(
                      Metotlar().getSystemDate(dbVeriler),
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontFamily: 'Kelly Slab',
                          fontSize: 12 * oran,
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
                  Spacer(),
                  //M,n-max değerler
                  Expanded(flex: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(flex: 4,),
                        //Min-Max sıcaklık
                        Expanded(flex: 7,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(flex: 4,
                                        child: SizedBox(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 10 * oran,
                                                right: 10 * oran),
                                            alignment: Alignment.center,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv699"),
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
                                      Spacer(),
                                      Expanded(flex: 4,
                                        child: SizedBox(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8 * oran,
                                                right: 8 * oran),
                                            alignment: Alignment.center,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv700"),
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
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20 * oran)),
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
                                                            Dil().sec(dilSecimi,
                                                                "tv701"),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Kelly Slab',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textScaleFactor:
                                                                oran,
                                                          )),
                                                        ),
                                                        //42 günlük set sıcaklığı giriş bölümü
                                                        Expanded(
                                                          flex: 11,
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Container(
                                                              color:
                                                                  Colors.white,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: <
                                                                    Widget>[
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        oran,
                                                                  ),
                                                                  //1-6 günler
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            //"1. Gün" başlık
                                                                            Flexible(
                                                                              flex: 1,
                                                                              child: RotatedBox(
                                                                                quarterTurns: -1,
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv173"),
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Kelly Slab',
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                        fontSize: 30,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      minFontSize: 5,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //1. gün min maks sıcaklık girişi
                                                                            Flexible(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 1;
                                                                                        _onlar = int.parse(gun1Max.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun1Max.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun1Max.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun1Max.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv706", Dil().sec(dilSecimi, "tv173") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv704"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun1Max.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: SizedBox(
                                                                                      child: Container(
                                                                                        child: AutoSizeText(
                                                                                          Dil().sec(dilSecimi, "tv708") + gun1.toString(),
                                                                                          style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                                                                                          maxLines: 1,
                                                                                          minFontSize: 3,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 2;
                                                                                        _onlar = int.parse(gun1Min.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun1Min.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun1Min.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun1Min.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv705", Dil().sec(dilSecimi, "tv173") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv703"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun1Min.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
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
                                                                        flex: 3,
                                                                        child:
                                                                            Stack(
                                                                              children: <Widget>[

                                                                                Visibility(visible: !gun1AraDegerGoster,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Spacer(flex: 1,),
                                                                                      Expanded(
                                                                                        flex: 3,
                                                                                        child: SizedBox(
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            child: AutoSizeText(
                                                                                              Dil().sec(dilSecimi, "tv709"),
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Kelly Slab',
                                                                                                color: Colors.black,
                                                                                                fontSize: 30,
                                                                                                //fontWeight: FontWeight.bold
                                                                                              ),
                                                                                              maxLines: 3,
                                                                                              minFontSize: 8,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 2,
                                                                                        child: IconButton(alignment: Alignment.topCenter,
                                                                                          padding: EdgeInsets.all(0),
                                                                                          onPressed: () {

                                                                                            if (!gun1AraDegerGoster) {
                                                                                              gun1AraDegerGoster = true;
                                                                                            } else {
                                                                                              gun1AraDegerGoster = false;
                                                                                            }


                                                                                            bottomDrawerIcindeGuncelle(state);
                                                                                            

                                                                                          },
                                                                                          icon: Icon(
                                                                                              gun1AraDegerGoster == true
                                                                                                  ? Icons.check_box
                                                                                                  : Icons.check_box_outline_blank),
                                                                                          color: gun1AraDegerGoster == true
                                                                                              ? Colors.green.shade500
                                                                                              : Colors.blue.shade600,
                                                                                          iconSize: 30 * oran,
                                                                                        ),
                                                                                      ),
                                                                                      
                                                                                    ],
                                                                                  ),
                                                                                ),

                                                                                Visibility(visible: gun1AraDegerGoster,
                                                                                  child: Row(
                                                                          mainAxisSize:
                                                                                    MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                                    MainAxisAlignment.spaceEvenly,
                                                                          children: <
                                                                                    Widget>[
                                                                                  //Gün nolar
                                                                                  Flexible(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv406"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "01",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "02",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "03",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "04",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "05",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "06",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Min sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv705"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[1],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[2],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[3],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[4],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[5],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[6],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Set Sıcaklığı
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv707"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[1],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[2],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[3],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[4],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[5],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[6],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Max sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv706"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[1],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[2],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[3],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[4],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[5],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[6],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
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
                                                                              ],
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        oran,
                                                                  ),
                                                                  //7-13 günler
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            //"7. Gün" başlık
                                                                            Flexible(
                                                                              flex: 1,
                                                                              child: RotatedBox(
                                                                                quarterTurns: -1,
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv174"),
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Kelly Slab',
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                        fontSize: 30,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      minFontSize: 5,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //7. gün min maks sıcaklık girişi
                                                                            Flexible(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 3;
                                                                                        _onlar = int.parse(gun7Max.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun7Max.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun7Max.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun7Max.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv706", Dil().sec(dilSecimi, "tv174") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv704"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun7Max.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: SizedBox(
                                                                                      child: Container(
                                                                                        child: AutoSizeText(
                                                                                          Dil().sec(dilSecimi, "tv708") + gun7.toString(),
                                                                                          style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                                                                                          maxLines: 1,
                                                                                          minFontSize: 3,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 4;
                                                                                        _onlar = int.parse(gun7Min.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun7Min.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun7Min.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun7Min.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv705", Dil().sec(dilSecimi, "tv174") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv703"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun7Min.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
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
                                                                        flex: 3,
                                                                        child:
                                                                            Stack(
                                                                              children: <Widget>[
                                                                                Visibility(visible: !gun7AraDegerGoster,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Spacer(flex: 1,),
                                                                                      Expanded(
                                                                                        flex: 3,
                                                                                        child: SizedBox(
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            child: AutoSizeText(
                                                                                              Dil().sec(dilSecimi, "tv709"),
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Kelly Slab',
                                                                                                color: Colors.black,
                                                                                                fontSize: 30,
                                                                                                //fontWeight: FontWeight.bold
                                                                                              ),
                                                                                              maxLines: 3,
                                                                                              minFontSize: 8,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 2,
                                                                                        child: IconButton(alignment: Alignment.topCenter,
                                                                                          padding: EdgeInsets.all(0),
                                                                                          onPressed: () {

                                                                                            if (!gun7AraDegerGoster) {
                                                                                              gun7AraDegerGoster = true;
                                                                                            } else {
                                                                                              gun7AraDegerGoster = false;
                                                                                            }


                                                                                            bottomDrawerIcindeGuncelle(state);
                                                                                            

                                                                                          },
                                                                                          icon: Icon(
                                                                                              gun7AraDegerGoster == true
                                                                                                  ? Icons.check_box
                                                                                                  : Icons.check_box_outline_blank),
                                                                                          color: gun7AraDegerGoster == true
                                                                                              ? Colors.green.shade500
                                                                                              : Colors.blue.shade600,
                                                                                          iconSize: 30 * oran,
                                                                                        ),
                                                                                      ),
                                                                                      
                                                                                    ],
                                                                                  ),
                                                                                ),


                                                                                Visibility(visible: gun7AraDegerGoster,
                                                                                  child: Row(
                                                                          mainAxisSize:
                                                                                    MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                                    MainAxisAlignment.spaceEvenly,
                                                                          children: <
                                                                                    Widget>[
                                                                                  //Gün nolar
                                                                                  Flexible(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv406"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "07",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "08",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "09",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "10",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "11",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "12",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "13",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Min sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv705"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[7],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[8],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[9],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[10],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[11],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[12],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[13],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Set Sıcaklığı
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv707"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[7],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[8],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[9],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[10],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[11],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[12],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[13],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Max sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv706"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[7],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[8],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[9],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[10],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[11],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[12],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[13],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
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
                                                                              ],
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        oran,
                                                                  ),
                                                                  //14-20 günler
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            //"14. Gün" başlık
                                                                            Flexible(
                                                                              flex: 1,
                                                                              child: RotatedBox(
                                                                                quarterTurns: -1,
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv175"),
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Kelly Slab',
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                        fontSize: 30,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      minFontSize: 5,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //14. gün min maks sıcaklık girişi
                                                                            Flexible(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 5;
                                                                                        _onlar = int.parse(gun14Max.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun14Max.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun14Max.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun14Max.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv706", Dil().sec(dilSecimi, "tv175") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv704"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun14Max.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: SizedBox(
                                                                                      child: Container(
                                                                                        child: AutoSizeText(
                                                                                          Dil().sec(dilSecimi, "tv708") + gun14.toString(),
                                                                                          style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                                                                                          maxLines: 1,
                                                                                          minFontSize: 3,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 6;
                                                                                        _onlar = int.parse(gun14Min.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun14Min.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun14Min.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun14Min.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv705", Dil().sec(dilSecimi, "tv175") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv703"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun14Min.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
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
                                                                        flex: 3,
                                                                        child:
                                                                            Stack(
                                                                              children: <Widget>[
                                                                                Visibility(visible: !gun14AraDegerGoster,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Spacer(flex: 1,),
                                                                                      Expanded(
                                                                                        flex: 3,
                                                                                        child: SizedBox(
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            child: AutoSizeText(
                                                                                              Dil().sec(dilSecimi, "tv709"),
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Kelly Slab',
                                                                                                color: Colors.black,
                                                                                                fontSize: 30,
                                                                                                //fontWeight: FontWeight.bold
                                                                                              ),
                                                                                              maxLines: 3,
                                                                                              minFontSize: 8,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 2,
                                                                                        child: IconButton(alignment: Alignment.topCenter,
                                                                                          padding: EdgeInsets.all(0),
                                                                                          onPressed: () {

                                                                                            if (!gun14AraDegerGoster) {
                                                                                              gun14AraDegerGoster = true;
                                                                                            } else {
                                                                                              gun14AraDegerGoster = false;
                                                                                            }


                                                                                            bottomDrawerIcindeGuncelle(state);
                                                                                            

                                                                                          },
                                                                                          icon: Icon(
                                                                                              gun14AraDegerGoster == true
                                                                                                  ? Icons.check_box
                                                                                                  : Icons.check_box_outline_blank),
                                                                                          color: gun14AraDegerGoster == true
                                                                                              ? Colors.green.shade500
                                                                                              : Colors.blue.shade600,
                                                                                          iconSize: 30 * oran,
                                                                                        ),
                                                                                      ),
                                                                                      
                                                                                    ],
                                                                                  ),
                                                                                ),


                                                                                Visibility(visible: gun14AraDegerGoster,
                                                                                  child: Row(
                                                                          mainAxisSize:
                                                                                    MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                                    MainAxisAlignment.spaceEvenly,
                                                                          children: <
                                                                                    Widget>[
                                                                                  //Gün nolar
                                                                                  Flexible(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv406"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "14",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "15",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "16",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "17",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "18",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "19",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "20",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Min sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv705"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[14],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[15],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[16],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[17],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[18],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[19],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[20],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Set Sıcaklığı
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv707"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[14],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[15],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[16],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[17],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[18],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[19],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[20],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Max sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv706"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[14],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[15],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[16],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[17],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[18],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[19],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[20],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
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
                                                                              ],
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        oran,
                                                                  ),
                                                                  //21-27 günler
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            //"21. Gün" başlık
                                                                            Flexible(
                                                                              flex: 1,
                                                                              child: RotatedBox(
                                                                                quarterTurns: -1,
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv176"),
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Kelly Slab',
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                        fontSize: 30,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      minFontSize: 5,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //21. gün min maks sıcaklık girişi
                                                                            Flexible(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 7;
                                                                                        _onlar = int.parse(gun21Max.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun21Max.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun21Max.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun21Max.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv706", Dil().sec(dilSecimi, "tv176") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv704"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun21Max.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: SizedBox(
                                                                                      child: Container(
                                                                                        child: AutoSizeText(
                                                                                          Dil().sec(dilSecimi, "tv708") + gun21.toString(),
                                                                                          style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                                                                                          maxLines: 1,
                                                                                          minFontSize: 3,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 8;
                                                                                        _onlar = int.parse(gun21Min.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun21Min.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun21Min.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun21Min.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv705", Dil().sec(dilSecimi, "tv176") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv703"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun21Min.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
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
                                                                        flex: 3,
                                                                        child:
                                                                            Stack(
                                                                              children: <Widget>[
                                                                                Visibility(visible: !gun21AraDegerGoster,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Spacer(flex: 1,),
                                                                                      Expanded(
                                                                                        flex: 3,
                                                                                        child: SizedBox(
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            child: AutoSizeText(
                                                                                              Dil().sec(dilSecimi, "tv709"),
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Kelly Slab',
                                                                                                color: Colors.black,
                                                                                                fontSize: 30,
                                                                                                //fontWeight: FontWeight.bold
                                                                                              ),
                                                                                              maxLines: 3,
                                                                                              minFontSize: 8,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 2,
                                                                                        child: IconButton(alignment: Alignment.topCenter,
                                                                                          padding: EdgeInsets.all(0),
                                                                                          onPressed: () {

                                                                                            if (!gun21AraDegerGoster) {
                                                                                              gun21AraDegerGoster = true;
                                                                                            } else {
                                                                                              gun21AraDegerGoster = false;
                                                                                            }


                                                                                            bottomDrawerIcindeGuncelle(state);
                                                                                            

                                                                                          },
                                                                                          icon: Icon(
                                                                                              gun21AraDegerGoster == true
                                                                                                  ? Icons.check_box
                                                                                                  : Icons.check_box_outline_blank),
                                                                                          color: gun21AraDegerGoster == true
                                                                                              ? Colors.green.shade500
                                                                                              : Colors.blue.shade600,
                                                                                          iconSize: 30 * oran,
                                                                                        ),
                                                                                      ),
                                                                                      
                                                                                    ],
                                                                                  ),
                                                                                ),



                                                                                Visibility(visible: gun21AraDegerGoster,
                                                                                  child: Row(
                                                                          mainAxisSize:
                                                                                    MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                                    MainAxisAlignment.spaceEvenly,
                                                                          children: <
                                                                                    Widget>[
                                                                                  //Gün nolar
                                                                                  Flexible(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv406"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "21",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "22",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "23",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "24",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "25",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "26",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "27",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Min sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv705"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[21],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[22],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[23],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[24],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[25],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[26],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[27],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Set Sıcaklığı
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv707"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[21],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[22],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[23],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[24],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[25],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[26],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[27],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Max sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv706"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[21],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[22],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[23],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[24],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[25],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[26],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[27],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
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
                                                                              ],
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        oran,
                                                                  ),
                                                                  //28-34 günler
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            //"28. Gün" başlık
                                                                            Flexible(
                                                                              flex: 1,
                                                                              child: RotatedBox(
                                                                                quarterTurns: -1,
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv177"),
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Kelly Slab',
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                        fontSize: 30,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      minFontSize: 5,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //28. gün min maks sıcaklık girişi
                                                                            Flexible(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 9;
                                                                                        _onlar = int.parse(gun28Max.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun28Max.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun28Max.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun28Max.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv706", Dil().sec(dilSecimi, "tv177") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv704"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun28Max.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: SizedBox(
                                                                                      child: Container(
                                                                                        child: AutoSizeText(
                                                                                          Dil().sec(dilSecimi, "tv708") + gun28.toString(),
                                                                                          style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                                                                                          maxLines: 1,
                                                                                          minFontSize: 3,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 10;
                                                                                        _onlar = int.parse(gun28Min.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun28Min.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun28Min.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun28Min.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv705", Dil().sec(dilSecimi, "tv177") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv703"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun28Min.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
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
                                                                        flex: 3,
                                                                        child:
                                                                            Stack(
                                                                              children: <Widget>[
                                                                                Visibility(visible: !gun28AraDegerGoster,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Spacer(flex: 1,),
                                                                                      Expanded(
                                                                                        flex: 3,
                                                                                        child: SizedBox(
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            child: AutoSizeText(
                                                                                              Dil().sec(dilSecimi, "tv709"),
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Kelly Slab',
                                                                                                color: Colors.black,
                                                                                                fontSize: 30,
                                                                                                //fontWeight: FontWeight.bold
                                                                                              ),
                                                                                              maxLines: 3,
                                                                                              minFontSize: 8,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 2,
                                                                                        child: IconButton(alignment: Alignment.topCenter,
                                                                                          padding: EdgeInsets.all(0),
                                                                                          onPressed: () {

                                                                                            if (!gun28AraDegerGoster) {
                                                                                              gun28AraDegerGoster = true;
                                                                                            } else {
                                                                                              gun28AraDegerGoster = false;
                                                                                            }


                                                                                            bottomDrawerIcindeGuncelle(state);
                                                                                            

                                                                                          },
                                                                                          icon: Icon(
                                                                                              gun28AraDegerGoster == true
                                                                                                  ? Icons.check_box
                                                                                                  : Icons.check_box_outline_blank),
                                                                                          color: gun28AraDegerGoster == true
                                                                                              ? Colors.green.shade500
                                                                                              : Colors.blue.shade600,
                                                                                          iconSize: 30 * oran,
                                                                                        ),
                                                                                      ),
                                                                                      
                                                                                    ],
                                                                                  ),
                                                                                ),



                                                                                Visibility(visible: gun28AraDegerGoster,
                                                                                  child: Row(
                                                                          mainAxisSize:
                                                                                    MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                                    MainAxisAlignment.spaceEvenly,
                                                                          children: <
                                                                                    Widget>[
                                                                                  //Gün nolar
                                                                                  Flexible(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv406"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "28",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "29",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "30",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "31",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "32",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "33",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "34",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Min sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv705"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[28],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[29],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[30],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[31],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[32],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[33],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[34],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Set Sıcaklığı
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv707"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[28],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[29],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[30],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[31],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[32],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[33],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[34],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Max sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv706"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[28],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[29],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[30],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[31],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[32],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[33],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[34],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
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
                                                                              ],
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        oran,
                                                                  ),
                                                                  //35-41 günler
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            //"35. Gün" başlık
                                                                            Flexible(
                                                                              flex: 1,
                                                                              child: RotatedBox(
                                                                                quarterTurns: -1,
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv178"),
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Kelly Slab',
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                        fontSize: 30,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      minFontSize: 5,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //28. gün min maks sıcaklık girişi
                                                                            Flexible(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 11;
                                                                                        _onlar = int.parse(gun35Max.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun35Max.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun35Max.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun35Max.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv706", Dil().sec(dilSecimi, "tv178") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv704"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun35Max.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: SizedBox(
                                                                                      child: Container(
                                                                                        child: AutoSizeText(
                                                                                          Dil().sec(dilSecimi, "tv708") + gun35.toString(),
                                                                                          style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                                                                                          maxLines: 1,
                                                                                          minFontSize: 3,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 12;
                                                                                        _onlar = int.parse(gun35Min.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun35Min.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun35Min.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun35Min.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv705", Dil().sec(dilSecimi, "tv178") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv703"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun35Min.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
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
                                                                        flex: 3,
                                                                        child:
                                                                            Stack(
                                                                              children: <Widget>[
                                                                                Visibility(visible: !gun35AraDegerGoster,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Spacer(flex: 1,),
                                                                                      Expanded(
                                                                                        flex: 3,
                                                                                        child: SizedBox(
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            child: AutoSizeText(
                                                                                              Dil().sec(dilSecimi, "tv709"),
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Kelly Slab',
                                                                                                color: Colors.black,
                                                                                                fontSize: 30,
                                                                                                //fontWeight: FontWeight.bold
                                                                                              ),
                                                                                              maxLines: 3,
                                                                                              minFontSize: 8,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 2,
                                                                                        child: IconButton(alignment: Alignment.topCenter,
                                                                                          padding: EdgeInsets.all(0),
                                                                                          onPressed: () {

                                                                                            if (!gun35AraDegerGoster) {
                                                                                              gun35AraDegerGoster = true;
                                                                                            } else {
                                                                                              gun35AraDegerGoster = false;
                                                                                            }


                                                                                            bottomDrawerIcindeGuncelle(state);
                                                                                            

                                                                                          },
                                                                                          icon: Icon(
                                                                                              gun35AraDegerGoster == true
                                                                                                  ? Icons.check_box
                                                                                                  : Icons.check_box_outline_blank),
                                                                                          color: gun35AraDegerGoster == true
                                                                                              ? Colors.green.shade500
                                                                                              : Colors.blue.shade600,
                                                                                          iconSize: 30 * oran,
                                                                                        ),
                                                                                      ),
                                                                                      
                                                                                    ],
                                                                                  ),
                                                                                ),



                                                                                Visibility(visible: gun35AraDegerGoster,
                                                                                  child: Row(
                                                                          mainAxisSize:
                                                                                    MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                                    MainAxisAlignment.spaceEvenly,
                                                                          children: <
                                                                                    Widget>[
                                                                                  //Gün nolar
                                                                                  Flexible(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv406"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "35",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "36",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "37",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "38",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "39",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "40",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "41",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Min sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv705"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[35],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[36],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[37],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[38],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[39],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[40],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[41],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Set Sıcaklığı
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv707"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[35],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[36],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[37],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[38],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[39],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[40],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[41],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Max sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv706"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[35],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[36],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[37],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[38],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[39],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[40],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[41],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
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
                                                                              ],
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        oran,
                                                                  ),
                                                                  //42. gün
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            //"42. Gün" başlık
                                                                            Flexible(
                                                                              flex: 1,
                                                                              child: RotatedBox(
                                                                                quarterTurns: -1,
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv179"),
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Kelly Slab',
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                        fontSize: 30,
                                                                                      ),
                                                                                      maxLines: 1,
                                                                                      minFontSize: 5,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //28. gün min maks sıcaklık girişi
                                                                            Flexible(
                                                                              flex: 4,
                                                                              child: Column(
                                                                                children: <Widget>[
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 13;
                                                                                        _onlar = int.parse(gun42Max.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun42Max.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun42Max.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun42Max.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv706", Dil().sec(dilSecimi, "tv179") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv704"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun42Max.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: SizedBox(
                                                                                      child: Container(
                                                                                        child: AutoSizeText(
                                                                                          Dil().sec(dilSecimi, "tv708") + gun42.toString(),
                                                                                          style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                                                                                          maxLines: 1,
                                                                                          minFontSize: 3,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 3,
                                                                                    child: RawMaterialButton(
                                                                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                                      fillColor: Colors.blue[700],
                                                                                      //constraints: BoxConstraints(),
                                                                                      onPressed: () {
                                                                                        _index = 14;
                                                                                        _onlar = int.parse(gun42Min.toString().split(".")[0]) < 10 ? 0 : (int.parse(gun42Min.toString().split(".")[0]) ~/ 10);
                                                                                        _birler = int.parse(gun42Min.toString().split(".")[0]) % 10;
                                                                                        _ondalik = int.parse(gun42Min.toString().split(".")[1]);

                                                                                        _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv705", Dil().sec(dilSecimi, "tv179") + " ", dbProkis).then((onValue) {
                                                                                          bottomDrawerIcindeGuncelle(state);
                                                                                        });
                                                                                      },
                                                                                      child: SizedBox(
                                                                                        child: Container(
                                                                                          child: Row(
                                                                                            children: <Widget>[
                                                                                              AutoSizeText(
                                                                                                Dil().sec(dilSecimi, "tv703"),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 10, color: Colors.yellow),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                              AutoSizeText(
                                                                                                gun42Min.toString(),
                                                                                                style: TextStyle(fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
                                                                                                maxLines: 1,
                                                                                              ),
                                                                                            ],
                                                                                          ),
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
                                                                        flex: 3,
                                                                        child:
                                                                            Stack(
                                                                              children: <Widget>[
                                                                                Visibility(visible: !gun42AraDegerGoster,
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: <Widget>[
                                                                                      Spacer(flex: 1,),
                                                                                      Expanded(
                                                                                        flex: 3,
                                                                                        child: SizedBox(
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            child: AutoSizeText(
                                                                                              Dil().sec(dilSecimi, "tv709"),
                                                                                              textAlign: TextAlign.center,
                                                                                              style: TextStyle(
                                                                                                fontFamily: 'Kelly Slab',
                                                                                                color: Colors.black,
                                                                                                fontSize: 30,
                                                                                                //fontWeight: FontWeight.bold
                                                                                              ),
                                                                                              maxLines: 3,
                                                                                              minFontSize: 8,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Expanded(
                                                                                        flex: 2,
                                                                                        child: IconButton(alignment: Alignment.topCenter,
                                                                                          padding: EdgeInsets.all(0),
                                                                                          onPressed: () {

                                                                                            if (!gun42AraDegerGoster) {
                                                                                              gun42AraDegerGoster = true;
                                                                                            } else {
                                                                                              gun42AraDegerGoster = false;
                                                                                            }


                                                                                            bottomDrawerIcindeGuncelle(state);
                                                                                            

                                                                                          },
                                                                                          icon: Icon(
                                                                                              gun42AraDegerGoster == true
                                                                                                  ? Icons.check_box
                                                                                                  : Icons.check_box_outline_blank),
                                                                                          color: gun42AraDegerGoster == true
                                                                                              ? Colors.green.shade500
                                                                                              : Colors.blue.shade600,
                                                                                          iconSize: 30 * oran,
                                                                                        ),
                                                                                      ),
                                                                                      
                                                                                    ],
                                                                                  ),
                                                                                ),



                                                                                Visibility(visible: gun42AraDegerGoster,
                                                                                  child: Row(
                                                                          mainAxisSize:
                                                                                    MainAxisSize.min,
                                                                          mainAxisAlignment:
                                                                                    MainAxisAlignment.spaceEvenly,
                                                                          children: <
                                                                                    Widget>[
                                                                                  //Gün nolar
                                                                                  Flexible(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv406"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  "42",
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Spacer(
                                                                                            flex: 6,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Min sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv705"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMin[42],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Spacer(
                                                                                            flex: 6,
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Set Sıcaklığı
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.grey[200],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv707"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gun[42],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Spacer(
                                                                                            flex: 6,
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  //Max sicaklik
                                                                                  Flexible(
                                                                                    flex: 3,
                                                                                    child: Container(
                                                                                      color: Colors.yellow[300],
                                                                                      alignment: Alignment.center,
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  Dil().sec(dilSecimi, "tv706"),
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Expanded(
                                                                                            child: SizedBox(
                                                                                              child: Container(
                                                                                                child: AutoSizeText(
                                                                                                  gunMax[42],
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 20,
                                                                                                  ),
                                                                                                  maxLines: 1,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Spacer(
                                                                                            flex: 6,
                                                                                          )
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
                                                                  SizedBox(
                                                                    width: 10 *
                                                                        oran,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }).then((onValue){
                                              gun1AraDegerGoster=false;
                                              gun7AraDegerGoster=false;
                                              gun14AraDegerGoster=false;
                                              gun21AraDegerGoster=false;
                                              gun28AraDegerGoster=false;
                                              gun35AraDegerGoster=false;
                                              gun42AraDegerGoster=false;
                                            });
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
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
                                                  minSic,
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
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  Dil().sec(
                                                          dilSecimi, "tv708") +
                                                      "\n" +
                                                      setSic,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
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
                                                  maxSic,
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
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(
                          flex: 3,
                        ),
                        //Min-Max nem
                        Expanded(
                          flex: 7,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(flex: 4,
                                        child: SizedBox(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8 * oran,
                                                right: 8 * oran),
                                            alignment: Alignment.center,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv482"),
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
                                      Spacer(),
                                      Expanded(flex: 4,
                                        child: SizedBox(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8 * oran,
                                                right: 8 * oran),
                                            alignment: Alignment.center,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv250"),
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
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20 * oran)),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: RawMaterialButton(
                                            onPressed: () {

                                              _index = 15;
                                              _onlar = int.parse(minNem.split(".")[0]) < 10 ? 0 : (int.parse(minNem.split(".")[0]) ~/ 10);
                                              _birler = int.parse(minNem.split(".")[0]) % 10;
                                              _ondalik = int.parse(minNem.split(".")[1]);

                                              _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv482", "", dbProkis);
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
                                                  minNem,
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
                                        Spacer(),
                                        Expanded(
                                          flex: 3,
                                          child: RawMaterialButton(
                                            onPressed: () {

                                              _index = 16;
                                              _onlar = int.parse(maxNem.split(".")[0]) < 10 ? 0 : (int.parse(maxNem.split(".")[0]) ~/ 10);
                                              _birler = int.parse(maxNem.split(".")[0]) % 10;
                                              _ondalik = int.parse(maxNem.split(".")[1]);

                                              _degergiris2X1(_onlar, _birler, _ondalik, _index, oran, dilSecimi, "tv250", "", dbProkis);

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
                                                  maxNem,
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

                        Spacer(
                          flex: 4,
                        )
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  //Turuncu butonlar
                  Expanded(
                    flex: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Spacer(flex: 2,),
                        //Yüksek ve düşük nem ve sıcaklık için alarm gecikmesi
                        Expanded(flex: 9,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(flex: 2,
                                  child: SizedBox(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8 * oran,
                                          right: 8 * oran),
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv710"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20 * oran)),
                                    child: RawMaterialButton(
                                      onPressed: () {

                                        _index = 17;
                                        int sayi=int.parse(yukVeDusNemveSicAlarmGecikmesi);
                                        _onlar=sayi<10 ? 0 :sayi~/10;
                                        _birler=sayi%10;

                                        _degergiris2X0(
                                            _onlar,
                                            _birler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv710",dbProkis);
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
                                              color: Colors.orange[700],
                                            );
                                          }),
                                          Text(
                                            yukVeDusNemveSicAlarmGecikmesi,
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
                                ),
                              
                              ],
                            ),
                          ),
                        ),
                        Spacer(flex: 2,),
                        //Bir sayaç için günlük minimum tüketim miktarı
                        Expanded(flex: 9,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(flex: 2,
                                  child: SizedBox(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8 * oran,
                                          right: 8 * oran),
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv711"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20 * oran)),
                                    child: RawMaterialButton(
                                      onPressed: () {

                                        _index = 18;
                                        int sayi =
                                                int.parse(birSayacIcinMinTukMiktari);
                                            _yuzBinler = sayi < 100000
                                                ? 0
                                                : (sayi ~/ 100000).toInt();
                                            _onBinler = sayi < 10000
                                                ? 0
                                                : ((sayi % 100000) ~/ 10000)
                                                    .toInt();
                                            _binler = sayi < 1000
                                                ? 0
                                                : ((sayi % 10000) ~/ 1000)
                                                    .toInt();
                                            _yuzler = sayi < 100
                                                ? 0
                                                : ((sayi % 1000) ~/ 100)
                                                    .toInt();
                                            _onlar = sayi < 10
                                                ? 0
                                                : ((sayi % 100) ~/ 10).toInt();
                                            _birler = sayi % 10;

                                            _degergiris6X0(
                                                _yuzBinler,
                                                _onBinler,
                                                _binler,
                                                _yuzler,
                                                _onlar,
                                                _birler,
                                                _index,
                                                oran,
                                                dilSecimi,
                                                "tv711",
                                                "",dbProkis);
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
                                              color: Colors.orange[700],
                                            );
                                          }),
                                          Text(
                                            birSayacIcinMinTukMiktari,
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
                                ),
                              
                              ],
                            ),
                          ),
                        ),
                        Spacer(flex: 2,),
                        //Ped bakım zamanı döngü süresi
                        Expanded(flex: 9,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(flex: 2,
                                  child: SizedBox(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8 * oran,
                                          right: 8 * oran),
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv712"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20 * oran)),
                                    child: RawMaterialButton(
                                      onPressed: () {

                                        _index = 19;
                                        int sayi=int.parse(pedBakimZamaniGeldiDonguSuresi);
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
                                            "tv712",
                                            "",dbProkis);
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(flex: 5,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                LayoutBuilder(builder:
                                                    (context, constraint) {
                                                  return Icon(
                                                    Icons.brightness_1,
                                                    size: constraint
                                                        .biggest.height,
                                                    color: Colors.orange[700],
                                                  );
                                                }),
                                                Text(
                                                  pedBakimZamaniGeldiDonguSuresi,
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
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv655")+": "+pedBakimZamaniGeldiKalanSure,
                                                  style: TextStyle(
                                                    fontSize: 30
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              
                              ],
                            ),
                          ),
                        ),
                        Spacer(flex: 2,),
                        //Sistem bakım zamanı döngü süresi
                        Expanded(flex: 9,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Expanded(flex: 2,
                                  child: SizedBox(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8 * oran,
                                          right: 8 * oran),
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv713"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20 * oran)),
                                    child: RawMaterialButton(
                                      onPressed: () {

                                        _index = 20;
                                        int sayi=int.parse(sistemBakimZamaniGeldiDonguSuresi);
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
                                            "tv713",
                                            "",dbProkis);
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(flex: 5,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: <Widget>[
                                                LayoutBuilder(builder:
                                                    (context, constraint) {
                                                  return Icon(
                                                    Icons.brightness_1,
                                                    size: constraint
                                                        .biggest.height,
                                                    color: Colors.orange[700],
                                                  );
                                                }),
                                                Text(
                                                  sistemBakimZamaniGeldiDonguSuresi,
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
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv655")+": "+sistemBakimZamaniGeldiKalanSure,
                                                  style: TextStyle(
                                                    fontSize: 30
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              
                              ],
                            ),
                          ),
                        ),
                        Spacer(flex: 2,),
                      ],
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  //Korna Sus Butonu ve süresi ve korna sus sayfası
                  Expanded(
                    flex: 8,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Expanded(flex: 7,
                            child: Row(
                              children: <Widget>[
                                Spacer(flex: 1,),
                                Expanded(
                                flex: 7,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(flex: 2,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(flex: 3,
                                              child: SizedBox(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10 * oran,
                                                      right: 10 * oran),
                                                  alignment: Alignment.bottomCenter,
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, "tv714"),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily: 'Kelly Slab',
                                                        fontWeight: FontWeight.bold),
                                                    maxLines: 2,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Expanded(flex: 3,
                                              child: SizedBox(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 8 * oran,
                                                      right: 8 * oran),
                                                  alignment: Alignment.bottomCenter,
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, "tv715"),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily: 'Kelly Slab',
                                                        fontWeight: FontWeight.bold),
                                                    maxLines: 2,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(flex: 5,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 3,
                                              child: RawMaterialButton(
                                                onPressed: () {

                                                  if(!kornaSus){
                                                    kornaSus=true;
                                                  }

                                                  

                                                  _index= 22;
                                                  String veri=kornaSus ? "1" : "0";

                                                  yazmaSonrasiGecikmeSayaci = 0;
                                                  String komut ="37*$_index*$veri";
                                                  Metotlar().veriGonder(komut, 2235).then((value) {
                                                    if (value.split("*")[0] == "error") {
                                                      Toast.show(
                                                          Dil().sec(dilSecimi, "toast101"),
                                                          context,
                                                          duration: 3);
                                                    } else {
                                                      Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 3);

                                                      baglanti = false;
                                                      Metotlar().takipEt('31*', 2236).then((veri) {
                                                        if (veri.split("*")[0] == "error") {
                                                          baglanti = false;
                                                          baglantiDurum =
                                                              Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
                                                          setState(() {});
                                                        } else {
                                                          takipEtVeriIsleme(veri);
                                                          baglantiDurum = "";
                                                        }
                                                      });
                                                    }
                                                  });

                                                  
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
                                                        color: kornaSus ? Colors.green : Colors.blue[700],
                                                      );
                                                    }),
                                                    Text(
                                                      kornaSus ? Dil().sec(dilSecimi, "tv236") : Dil().sec(dilSecimi, "tv237"),
                                                      style: TextStyle(
                                                          fontSize: 20 * oran,
                                                          fontFamily: 'Kelly Slab',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            Expanded(
                                              flex: 3,
                                              child: RawMaterialButton(
                                                onPressed: () {

                                                  _index = 21;
                                                  int sayi=int.parse(kornaSusSuresi);
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
                                                      "tv715",
                                                      "",dbProkis);

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
                                                      kornaSusSuresi,
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
                                Spacer(flex: 1,),
                                Expanded(flex: 7,
                                  child: RaisedButton(
                                    onPressed: (){
                                      timerCancel=true;
                                    
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HariciAlarm(dbVeriler)),
                                    );
                                    },
                                    child: Text(
                                      Dil().sec(dilSecimi, "tv722"),
                                      style: TextStyle(
                                        fontSize: 18*oran,
                                        fontFamily: 'Kelly Slab',
                                        color: Colors.white
                                      ),
                                      textAlign: TextAlign.center,
                                      
                                    ),
                                    color: Colors.teal[600],
                                    elevation: 16,
                                  ),
                                ),
                                Spacer(flex: 1,),
                                Expanded(flex: 7,
                                  child: RaisedButton(
                                    onPressed: (){
                                      timerCancel=true;
                                    
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              KornaIptal(dbVeriler)),
                                    );
                                    },
                                    child: Text(
                                      Dil().sec(dilSecimi, "tv716"),
                                      style: TextStyle(
                                        fontSize: 18*oran,
                                        fontFamily: 'Kelly Slab',
                                        color: Colors.white
                                      ),
                                      textAlign: TextAlign.center,
                                      
                                    ),
                                    color: Colors.teal[600],
                                    elevation: 16,
                                  ),
                                ),
                                Spacer(flex: 4,),
                              ],
                            ),
                          ),
                          Spacer()
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
                MaterialPageRoute(
                    builder: (context) => GenelAyarlar(dbVeriler)),
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
      endDrawer:SizedBox(
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
                      Dil().sec(dilSecimi, "tv702"), 
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
                                  text: Dil().sec(dilSecimi, "info50"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv699")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info50a"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv700")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info50b"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv482")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info50c"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv250")+":",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info50d"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv710")+":\n",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info50e"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv711")+":\n",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info50f"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv712")+":\n",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info50g"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),


                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv713")+":\n",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info50h"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),



                                TextSpan(
                                  text: Dil().sec(dilSecimi, "tv714")+":\n",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info50h"),
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

      String veri="";

      if (index == 1) {
        gun1Max = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun1Max.toString();
        _gunlerMaxSic();
      }

      if (index == 2) {
        gun1Min = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun1Min.toString();
        _gunlerMinSic();
      }


      if (index == 3) {
        gun7Max = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun7Max.toString();
        _gunlerMaxSic();
        
      }

      if (index == 4) {
        gun7Min = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun7Min.toString();
        _gunlerMinSic();
      }


      if (index == 5) {
        gun14Max = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun14Max.toString();
        _gunlerMaxSic();
      }

      if (index == 6) {
        gun14Min = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun14Min.toString();
        _gunlerMinSic();
      }


      if (index == 7) {
        gun21Max = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun21Max.toString();
        _gunlerMaxSic();
      }

      if (index == 8) {
        gun21Min = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun21Min.toString();
        _gunlerMinSic();
      }


      if (index == 9) {
        gun28Max = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun28Max.toString();
        _gunlerMaxSic();
      }

      if (index == 10) {
        gun28Min = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun28Min.toString();
        _gunlerMinSic();
      }


      if (index == 11) {
        gun35Max = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun35Max.toString();
        _gunlerMaxSic();
      }

      if (index == 12) {
        gun35Min = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun35Min.toString();
        _gunlerMinSic();
      }

      if (index == 13) {
        gun42Max = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun42Max.toString();
        _gunlerMaxSic();
      }

      if (index == 14) {
        gun42Min = double.parse((_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString());
        veri = gun42Min.toString();
        _gunlerMinSic();
      }


      if (index == 15) {
        minNem = (_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString();
        veri = minNem;
      }

      if (index == 16) {
        maxNem = (_onlar == 0 ? "" : _onlar.toString()) + _birler.toString() + "." + _ondalik.toString();
        veri = maxNem;
      }
      

      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        String komut =
            "37*$_index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value) {
          if (value.split("*")[0] == "error") {
            Toast.show(
                Dil().sec(dilSecimi, "toast101"),
                context,
                duration: 3);
          } else {
            Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 3);

            baglanti = false;
            Metotlar().takipEt('31*', 2236).then((veri) {
              if (veri.split("*")[0] == "error") {
                baglanti = false;
                baglantiDurum =
                    Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
                setState(() {});
              } else {
                takipEtVeriIsleme(veri);
                baglantiDurum = "";
              }
            });
          }
        });
      }

      setState(() {});
    });
  }

  Future _degergiris2X0(int onlarUnsur, int birlerUnsur, int index,
        double oran, String dil, String baslik, DBProkis dbProkis) async {
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

        if(_index==17){
          yukVeDusNemveSicAlarmGecikmesi=(_onlar*10+_birler).toString();
          veri=yukVeDusNemveSicAlarmGecikmesi;
        }


        if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        String komut ="37*$_index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value) {
          if (value.split("*")[0] == "error") {
            Toast.show(
                Dil().sec(dilSecimi, "toast101"),
                context,
                duration: 3);
          } else {
            Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 3);

            baglanti = false;
            Metotlar().takipEt('31*', 2236).then((veri) {
              if (veri.split("*")[0] == "error") {
                baglanti = false;
                baglantiDurum = Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
                setState(() {});
              } else {
                takipEtVeriIsleme(veri);
                baglantiDurum = "";
              }
            });
          }
        });
      }

      setState(() {});


      });
    }

  Future _degergiris6X0(
      int yuzBinlerUnsur,
      int onBinlerUnsur,
      int binlerUnsur,
      int yuzlerUnsur,
      int onlarUnsur,
      int birlerUnsur,
      int indexNo,
      double oran,
      String dil,
      String baslik,
      String onBaslik,
      DBProkis dbProkis) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris6X0.Deger(
            yuzBinlerUnsur,
            onBinlerUnsur,
            binlerUnsur,
            yuzlerUnsur,
            onlarUnsur,
            birlerUnsur,
            indexNo,
            oran,
            dil,
            baslik,
            onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_yuzBinler != val[0] ||
          _onBinler != val[1] ||
          _binler != val[2] ||
          _yuzler != val[3] ||
          _onlar != val[4] ||
          _birler != val[5]) {
        veriGonderilsinMi = true;
      }

      _yuzBinler = val[0];
      _onBinler = val[1];
      _binler = val[2];
      _yuzler = val[3];
      _onlar = val[4];
      _birler = val[5];
      _index = val[6];

      String veri="";

        if (_index == 18) {
        birSayacIcinMinTukMiktari = (_yuzBinler * 100000 +
                _onBinler * 10000 +
                _binler * 1000 +
                _yuzler * 100 +
                _onlar * 10 +
                _birler)
            .toString();

            veri=birSayacIcinMinTukMiktari;
      }


        if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        String komut ="37*$_index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value) {
          if (value.split("*")[0] == "error") {
            Toast.show(
                Dil().sec(dilSecimi, "toast101"),
                context,
                duration: 3);
          } else {
            Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 3);

            baglanti = false;
            Metotlar().takipEt('31*', 2236).then((veri) {
              if (veri.split("*")[0] == "error") {
                baglanti = false;
                baglantiDurum = Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
                setState(() {});
              } else {
                takipEtVeriIsleme(veri);
                baglantiDurum = "";
              }
            });
          }
        });
      }


      setState(() {});
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


      String veri = "";

      if (_index == 19) {
        pedBakimZamaniGeldiDonguSuresi= (_yuzler * 100 + _onlar * 10 + _birler).toString();
        veri = pedBakimZamaniGeldiDonguSuresi;
      }

      if (_index == 20) {
        sistemBakimZamaniGeldiDonguSuresi= (_yuzler * 100 + _onlar * 10 + _birler).toString();
        veri = sistemBakimZamaniGeldiDonguSuresi;
      }

      if (_index == 21) {
        kornaSusSuresi= (_yuzler * 100 + _onlar * 10 + _birler).toString();
        veri = kornaSusSuresi;
      }


     

      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        String komut ="37*$_index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value) {
          if (value.split("*")[0] == "error") {
            Toast.show(
                Dil().sec(dilSecimi, "toast101"),
                context,
                duration: 3);
          } else {
            Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 3);

            baglanti = false;
            Metotlar().takipEt('31*', 2236).then((veri) {
              if (veri.split("*")[0] == "error") {
                baglanti = false;
                baglantiDurum = Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
                setState(() {});
              } else {
                takipEtVeriIsleme(veri);
                baglantiDurum = "";
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

  _gunlerMinSic() {
    gunMin[1] = gun1Min.toString();
    gunMin[2] = _gunSetHesap(gun7Min, gun1Min, 6, 1);
    gunMin[3] = _gunSetHesap(gun7Min, gun1Min, 6, 2);
    gunMin[4] = _gunSetHesap(gun7Min, gun1Min, 6, 3);
    gunMin[5] = _gunSetHesap(gun7Min, gun1Min, 6, 4);
    gunMin[6] = _gunSetHesap(gun7Min, gun1Min, 6, 5);

    gunMin[7] = gun7Min.toString();
    gunMin[8] = _gunSetHesap(gun14Min, gun7Min, 7, 1);
    gunMin[9] = _gunSetHesap(gun14Min, gun7Min, 7, 2);
    gunMin[10] = _gunSetHesap(gun14Min, gun7Min, 7, 3);
    gunMin[11] = _gunSetHesap(gun14Min, gun7Min, 7, 4);
    gunMin[12] = _gunSetHesap(gun14Min, gun7Min, 7, 5);
    gunMin[13] = _gunSetHesap(gun14Min, gun7Min, 7, 6);

    gunMin[14] = gun14Min.toString();
    gunMin[15] = _gunSetHesap(gun21Min, gun14Min, 7, 1);
    gunMin[16] = _gunSetHesap(gun21Min, gun14Min, 7, 2);
    gunMin[17] = _gunSetHesap(gun21Min, gun14Min, 7, 3);
    gunMin[18] = _gunSetHesap(gun21Min, gun14Min, 7, 4);
    gunMin[19] = _gunSetHesap(gun21Min, gun14Min, 7, 5);
    gunMin[20] = _gunSetHesap(gun21Min, gun14Min, 7, 6);

    gunMin[21] = gun21Min.toString();
    gunMin[22] = _gunSetHesap(gun28Min, gun21Min, 7, 1);
    gunMin[23] = _gunSetHesap(gun28Min, gun21Min, 7, 2);
    gunMin[24] = _gunSetHesap(gun28Min, gun21Min, 7, 3);
    gunMin[25] = _gunSetHesap(gun28Min, gun21Min, 7, 4);
    gunMin[26] = _gunSetHesap(gun28Min, gun21Min, 7, 5);
    gunMin[27] = _gunSetHesap(gun28Min, gun21Min, 7, 6);

    gunMin[28] = gun28Min.toString();
    gunMin[29] = _gunSetHesap(gun35Min, gun28Min, 7, 1);
    gunMin[30] = _gunSetHesap(gun35Min, gun28Min, 7, 2);
    gunMin[31] = _gunSetHesap(gun35Min, gun28Min, 7, 3);
    gunMin[32] = _gunSetHesap(gun35Min, gun28Min, 7, 4);
    gunMin[33] = _gunSetHesap(gun35Min, gun28Min, 7, 5);
    gunMin[34] = _gunSetHesap(gun35Min, gun28Min, 7, 6);

    gunMin[35] = gun35Min.toString();
    gunMin[36] = _gunSetHesap(gun42Min, gun35Min, 7, 1);
    gunMin[37] = _gunSetHesap(gun42Min, gun35Min, 7, 2);
    gunMin[38] = _gunSetHesap(gun42Min, gun35Min, 7, 3);
    gunMin[39] = _gunSetHesap(gun42Min, gun35Min, 7, 4);
    gunMin[40] = _gunSetHesap(gun42Min, gun35Min, 7, 5);
    gunMin[41] = _gunSetHesap(gun42Min, gun35Min, 7, 6);
    gunMin[42] = gun42Min.toString();
  }


  _gunlerMaxSic() {
    gunMax[1] = gun1Max.toString();
    gunMax[2] = _gunSetHesap(gun7Max, gun1Max, 6, 1);
    gunMax[3] = _gunSetHesap(gun7Max, gun1Max, 6, 2);
    gunMax[4] = _gunSetHesap(gun7Max, gun1Max, 6, 3);
    gunMax[5] = _gunSetHesap(gun7Max, gun1Max, 6, 4);
    gunMax[6] = _gunSetHesap(gun7Max, gun1Max, 6, 5);

    gunMax[7] = gun7Max.toString();
    gunMax[8] = _gunSetHesap(gun14Max, gun7Max, 7, 1);
    gunMax[9] = _gunSetHesap(gun14Max, gun7Max, 7, 2);
    gunMax[10] = _gunSetHesap(gun14Max, gun7Max, 7, 3);
    gunMax[11] = _gunSetHesap(gun14Max, gun7Max, 7, 4);
    gunMax[12] = _gunSetHesap(gun14Max, gun7Max, 7, 5);
    gunMax[13] = _gunSetHesap(gun14Max, gun7Max, 7, 6);

    gunMax[14] = gun14Max.toString();
    gunMax[15] = _gunSetHesap(gun21Max, gun14Max, 7, 1);
    gunMax[16] = _gunSetHesap(gun21Max, gun14Max, 7, 2);
    gunMax[17] = _gunSetHesap(gun21Max, gun14Max, 7, 3);
    gunMax[18] = _gunSetHesap(gun21Max, gun14Max, 7, 4);
    gunMax[19] = _gunSetHesap(gun21Max, gun14Max, 7, 5);
    gunMax[20] = _gunSetHesap(gun21Max, gun14Max, 7, 6);

    gunMax[21] = gun21Max.toString();
    gunMax[22] = _gunSetHesap(gun28Max, gun21Max, 7, 1);
    gunMax[23] = _gunSetHesap(gun28Max, gun21Max, 7, 2);
    gunMax[24] = _gunSetHesap(gun28Max, gun21Max, 7, 3);
    gunMax[25] = _gunSetHesap(gun28Max, gun21Max, 7, 4);
    gunMax[26] = _gunSetHesap(gun28Max, gun21Max, 7, 5);
    gunMax[27] = _gunSetHesap(gun28Max, gun21Max, 7, 6);

    gunMax[28] = gun28Max.toString();
    gunMax[29] = _gunSetHesap(gun35Max, gun28Max, 7, 1);
    gunMax[30] = _gunSetHesap(gun35Max, gun28Max, 7, 2);
    gunMax[31] = _gunSetHesap(gun35Max, gun28Max, 7, 3);
    gunMax[32] = _gunSetHesap(gun35Max, gun28Max, 7, 4);
    gunMax[33] = _gunSetHesap(gun35Max, gun28Max, 7, 5);
    gunMax[34] = _gunSetHesap(gun35Max, gun28Max, 7, 6);

    gunMax[35] = gun35Max.toString();
    gunMax[36] = _gunSetHesap(gun42Max, gun35Max, 7, 1);
    gunMax[37] = _gunSetHesap(gun42Max, gun35Max, 7, 2);
    gunMax[38] = _gunSetHesap(gun42Max, gun35Max, 7, 3);
    gunMax[39] = _gunSetHesap(gun42Max, gun35Max, 7, 4);
    gunMax[40] = _gunSetHesap(gun42Max, gun35Max, 7, 5);
    gunMax[41] = _gunSetHesap(gun42Max, gun35Max, 7, 6);
    gunMax[42] = gun42Max.toString();
  }

  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

  takipEtVeriIsleme(String gelenMesaj) {
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
    gun1Min = double.parse(degerler[7]);
    gun7Min = double.parse(degerler[8]);
    gun14Min = double.parse(degerler[9]);
    gun21Min = double.parse(degerler[10]);
    gun28Min = double.parse(degerler[11]);
    gun35Min = double.parse(degerler[12]);
    gun42Min = double.parse(degerler[13]);
    gun1Max = double.parse(degerler[14]);
    gun7Max = double.parse(degerler[15]);
    gun14Max = double.parse(degerler[16]);
    gun21Max = double.parse(degerler[17]);
    gun28Max = double.parse(degerler[18]);
    gun35Max = double.parse(degerler[19]);
    gun42Max = double.parse(degerler[20]);
    setSic = degerler[21];
    minSic = degerler[22];
    maxSic = degerler[23];
    minNem = degerler[24];
    maxNem = degerler[25];
    yukVeDusNemveSicAlarmGecikmesi = degerler[26];
    birSayacIcinMinTukMiktari = degerler[27];
    pedBakimZamaniGeldiDonguSuresi = degerler[28];
    pedBakimZamaniGeldiKalanSure = degerler[29];
    sistemBakimZamaniGeldiDonguSuresi= degerler[30];
    sistemBakimZamaniGeldiKalanSure= degerler[31];
    kornaSus= degerler[32] == "True" ? true : false;
    kornaSusSuresi = degerler[33];

    alarmDurum = degerler[34];

    _gunlerSet();
    _gunlerMinSic();
    _gunlerMaxSic();

    baglanti = false;
    if (!timerCancel) {
      setState(() {});
    }
  }

  //--------------------------METOTLAR--------------------------------

}
