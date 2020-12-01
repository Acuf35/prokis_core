import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:prokis/genel_ayarlar/loggrafik/datalog.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';
import 'package:toast/toast.dart';

class TuketimLog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TuketimLogState();
  }
}

class TuketimLogState extends State<TuketimLog> {
  String dilSecimi = "EN";

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  String baglantiDurum = "";
  String alarmDurum =
      "00000000000000000000000000000000000000000000000000000000000000000000000000000000";

  String logDonguSuresi = "5";
  int kayitTuruIndex = 1;

  DateTime tarihIlk = DateTime.now();
  DateTime tarihSon = DateTime.now();

  int kayitAdet = 0;

  double maxValue = -99999.0;
  double minValue = 99999.0;
  double totValue = 0.0;
  double ortValue = 0.0;

  List<String> gelenSaat = [];
  List<String> gelenTarih = [];
  List<String> gelenHayvanSayisi = [];
  List<String> gelenDeger = [];

  //--------------------------DATABASE DEĞİŞKENLER--------------------------------

  @override
  void dispose() {
    timerCancel = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var oran = MediaQuery.of(context).size.width / 731.4;
    final dbProkis = Provider.of<DBProkis>(context);
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");

    if (timerSayac == 0) {
      Metotlar().takipEt("alarm*", 2236).then((veri) {
        if (veri.split("*")[0] == "error") {
          baglanti = false;
          baglantiDurum =
              Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
          setState(() {});
        } else {
          alarmDurum = veri;
          baglantiDurum = "";
          baglanti = false;
          if (!timerCancel) setState(() {});
        }
      });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          Metotlar().takipEt("alarm*", 2236).then((veri) {
            if (veri.split("*")[0] == "error") {
              baglanti = false;
              baglantiDurum =
                  Metotlar().errorToastMesaj(veri.split("*")[1], dbProkis);
              setState(() {});
            } else {
              alarmDurum = veri;
              baglantiDurum = "";
              baglanti = false;
              if (!timerCancel) setState(() {});
            }
          });
        }
      });
    }

    timerSayac++;

    String birim = "";
    if (kayitTuruIndex == 1 || kayitTuruIndex == 2) {
      birim = Dil().sec(dilSecimi, "tv777");
    } else if (kayitTuruIndex == 3) {
      birim = Dil().sec(dilSecimi, "tv604");
    } else if (kayitTuruIndex == 4) {
      birim = Dil().sec(dilSecimi, "tv780");
    } else if (kayitTuruIndex == 5) {
      birim = Dil().sec(dilSecimi, "tv778");
    } else {
      birim = Dil().sec(dilSecimi, "tv781");
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv737',
          Colors.blue, baglantiDurum, alarmDurum),
      floatingActionButton: Container(
        width: 56 * oran,
        height: 56 * oran,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              timerCancel = true;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Datalog()),
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
          //saat ve tarih
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
                      Metotlar().getSystemTime(dbProkis.getDbVeri),
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
                      Metotlar().getSystemDate(dbProkis.getDbVeri),
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
          SizedBox(
            height: 3 * oran,
          ),
          Expanded(
            flex: 40,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      //Kayıt türü
                      Expanded(
                        flex: 15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv754"),
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
                              flex: 3,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10 * oran),
                                      color: Colors.blue),
                                  margin: EdgeInsets.only(
                                      left: 3 * oran, right: 3 * oran),
                                  child: RawMaterialButton(
                                    constraints: BoxConstraints(
                                        minWidth: double.infinity),
                                    padding: EdgeInsets.all(0),
                                    child: SizedBox(
                                      child: Container(
                                        child: AutoSizeText(
                                          kayitTuru(kayitTuruIndex),
                                          style: TextStyle(
                                            //fontFamily: 'Kelly Slab',
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 50,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
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
                                                              "tv754"),
                                                          textScaleFactor: oran,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Kelly Slab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                      ),
                                                      //Kayıt türü seçim bölümü
                                                      Expanded(
                                                        flex: 10,
                                                        child: Container(
                                                          color: Colors.white,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Spacer(
                                                                flex: 1,
                                                              ),
                                                              //Elektrik Günlük hayv başına  ve toplam
                                                              Expanded(
                                                                flex: 3,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Spacer(),
                                                                    //Elektrik günlük toplam
                                                                    Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          margin:
                                                                              EdgeInsets.all(3 * oran),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10 * oran),
                                                                              color: Colors.blue),
                                                                          child:
                                                                              Column(
                                                                            children: <Widget>[
                                                                              Spacer(),
                                                                              Expanded(
                                                                                flex: 6,
                                                                                child: RawMaterialButton(
                                                                                  constraints: BoxConstraints(minWidth: double.infinity),
                                                                                  padding: EdgeInsets.all(0),
                                                                                  onPressed: () {
                                                                                    kayitTuruIndex = 1;
                                                                                    kayitAdet = 0;
                                                                                    gelenSaat = [];
                                                                                    gelenTarih = [];
                                                                                    gelenHayvanSayisi = [];
                                                                                    gelenDeger = [];
                                                                                    maxValue = -99999.0;
                                                                                    minValue = 99999.0;
                                                                                    totValue = 0.0;
                                                                                    ortValue = 0.0;
                                                                                    setState(() {
                                                                                      Navigator.pop(context);
                                                                                    });
                                                                                  },
                                                                                  child: SizedBox(
                                                                                    child: Container(
                                                                                      child: AutoSizeText(
                                                                                        Dil().sec(dilSecimi, "tv770"),
                                                                                        style: TextStyle(fontFamily: 'Kelly Slab', fontSize: 50, color: Colors.white),
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Spacer()
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Spacer(),
                                                                    //Elektrik günlük hayv baş
                                                                    Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          margin:
                                                                              EdgeInsets.all(3 * oran),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10 * oran),
                                                                              color: Colors.blue),
                                                                          child:
                                                                              Column(
                                                                            children: <Widget>[
                                                                              Spacer(),
                                                                              Expanded(
                                                                                flex: 6,
                                                                                child: RawMaterialButton(
                                                                                  constraints: BoxConstraints(minWidth: double.infinity),
                                                                                  padding: EdgeInsets.all(0),
                                                                                  onPressed: () {
                                                                                    kayitTuruIndex = 2;
                                                                                    kayitAdet = 0;
                                                                                    gelenSaat = [];
                                                                                    gelenTarih = [];
                                                                                    gelenHayvanSayisi = [];
                                                                                    gelenDeger = [];
                                                                                    maxValue = -99999.0;
                                                                                    minValue = 99999.0;
                                                                                    totValue = 0.0;
                                                                                    ortValue = 0.0;
                                                                                    setState(() {
                                                                                      Navigator.pop(context);
                                                                                    });
                                                                                  },
                                                                                  child: SizedBox(
                                                                                    child: Container(
                                                                                      child: AutoSizeText(
                                                                                        Dil().sec(dilSecimi, "tv771"),
                                                                                        style: TextStyle(fontFamily: 'Kelly Slab', fontSize: 50, color: Colors.white),
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Spacer()
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Spacer(),
                                                                  ],
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              //Yem Günlük hayv başına  ve toplam
                                                              Expanded(
                                                                flex: 3,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Spacer(),
                                                                    //Yem günlük toplam
                                                                    Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          margin:
                                                                              EdgeInsets.all(3 * oran),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10 * oran),
                                                                              color: Colors.blue),
                                                                          child:
                                                                              Column(
                                                                            children: <Widget>[
                                                                              Spacer(),
                                                                              Expanded(
                                                                                flex: 6,
                                                                                child: RawMaterialButton(
                                                                                  constraints: BoxConstraints(minWidth: double.infinity),
                                                                                  padding: EdgeInsets.all(0),
                                                                                  onPressed: () {
                                                                                    kayitTuruIndex = 3;
                                                                                    kayitAdet = 0;
                                                                                    gelenSaat = [];
                                                                                    gelenTarih = [];
                                                                                    gelenHayvanSayisi = [];
                                                                                    gelenDeger = [];
                                                                                    maxValue = -99999.0;
                                                                                    minValue = 99999.0;
                                                                                    totValue = 0.0;
                                                                                    ortValue = 0.0;
                                                                                    setState(() {
                                                                                      Navigator.pop(context);
                                                                                    });
                                                                                  },
                                                                                  child: SizedBox(
                                                                                    child: Container(
                                                                                      child: AutoSizeText(
                                                                                        Dil().sec(dilSecimi, "tv772"),
                                                                                        style: TextStyle(fontFamily: 'Kelly Slab', fontSize: 50, color: Colors.white),
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Spacer()
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Spacer(),
                                                                    //yem günlük hayv baş
                                                                    Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          margin:
                                                                              EdgeInsets.all(3 * oran),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10 * oran),
                                                                              color: Colors.blue),
                                                                          child:
                                                                              Column(
                                                                            children: <Widget>[
                                                                              Spacer(),
                                                                              Expanded(
                                                                                flex: 6,
                                                                                child: RawMaterialButton(
                                                                                  constraints: BoxConstraints(minWidth: double.infinity),
                                                                                  padding: EdgeInsets.all(0),
                                                                                  onPressed: () {
                                                                                    kayitTuruIndex = 4;
                                                                                    
                                                                                    kayitAdet = 0;
                                                                                    gelenSaat = [];
                                                                                    gelenTarih = [];
                                                                                    gelenHayvanSayisi = [];
                                                                                    gelenDeger = [];
                                                                                    maxValue = -99999.0;
                                                                                    minValue = 99999.0;
                                                                                    totValue = 0.0;
                                                                                    ortValue = 0.0;
                                                                                    setState(() {
                                                                                      Navigator.pop(context);
                                                                                    });
                                                                                  },
                                                                                  child: SizedBox(
                                                                                    child: Container(
                                                                                      child: AutoSizeText(
                                                                                        Dil().sec(dilSecimi, "tv773"),
                                                                                        style: TextStyle(fontFamily: 'Kelly Slab', fontSize: 50, color: Colors.white),
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Spacer()
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Spacer(),
                                                                  ],
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              //Su Günlük hayv başına ve toplam
                                                              Expanded(
                                                                flex: 3,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Spacer(),
                                                                    //Su günlük toplam
                                                                    Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          margin:
                                                                              EdgeInsets.all(3 * oran),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10 * oran),
                                                                              color: Colors.blue),
                                                                          child:
                                                                              Column(
                                                                            children: <Widget>[
                                                                              Spacer(),
                                                                              Expanded(
                                                                                flex: 6,
                                                                                child: RawMaterialButton(
                                                                                  constraints: BoxConstraints(minWidth: double.infinity),
                                                                                  padding: EdgeInsets.all(0),
                                                                                  onPressed: () {
                                                                                    kayitTuruIndex = 5;
                                                                                    kayitAdet = 0;
                                                                                    gelenSaat = [];
                                                                                    gelenTarih = [];
                                                                                    gelenHayvanSayisi = [];
                                                                                    gelenDeger = [];
                                                                                    maxValue = -99999.0;
                                                                                    minValue = 99999.0;
                                                                                    totValue = 0.0;
                                                                                    ortValue = 0.0;
                                                                                    setState(() {
                                                                                      Navigator.pop(context);
                                                                                    });
                                                                                  },
                                                                                  child: SizedBox(
                                                                                    child: Container(
                                                                                      child: AutoSizeText(
                                                                                        Dil().sec(dilSecimi, "tv774"),
                                                                                        style: TextStyle(fontFamily: 'Kelly Slab', fontSize: 50, color: Colors.white),
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Spacer()
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Spacer(),
                                                                    //Su günlük hayv başına
                                                                    Expanded(
                                                                        flex: 4,
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          margin:
                                                                              EdgeInsets.all(3 * oran),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10 * oran),
                                                                              color: Colors.blue),
                                                                          child:
                                                                              Column(
                                                                            children: <Widget>[
                                                                              Spacer(),
                                                                              Expanded(
                                                                                flex: 6,
                                                                                child: RawMaterialButton(
                                                                                  constraints: BoxConstraints(minWidth: double.infinity),
                                                                                  padding: EdgeInsets.all(0),
                                                                                  onPressed: () {
                                                                                    kayitTuruIndex = 6;
                                                                                    kayitAdet = 0;
                                                                                    gelenSaat = [];
                                                                                    gelenTarih = [];
                                                                                    gelenHayvanSayisi = [];
                                                                                    gelenDeger = [];
                                                                                    maxValue = -99999.0;
                                                                                    minValue = 99999.0;
                                                                                    totValue = 0.0;
                                                                                    ortValue = 0.0;
                                                                                    setState(() {
                                                                                      Navigator.pop(context);
                                                                                    });
                                                                                  },
                                                                                  child: SizedBox(
                                                                                    child: Container(
                                                                                      child: AutoSizeText(
                                                                                        Dil().sec(dilSecimi, "tv775"),
                                                                                        style: TextStyle(fontFamily: 'Kelly Slab', fontSize: 50, color: Colors.white),
                                                                                        maxLines: 1,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Spacer()
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Spacer(),
                                                                  ],
                                                                ),
                                                              ),
                                                              Spacer(
                                                                flex: 1,
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
                                          }).then((value) => () {
                                            print("KAPANIYOOOOOOOOOOOOOOR");
                                          });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Tarih ilk
                      Expanded(
                        flex: 11,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv756"),
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
                              flex: 3,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10 * oran),
                                      color: Colors.blue),
                                  margin: EdgeInsets.only(
                                      left: 3 * oran, right: 3 * oran),
                                  child: RawMaterialButton(
                                    constraints: BoxConstraints(
                                        minWidth: double.infinity),
                                    padding: EdgeInsets.all(0),
                                    child: SizedBox(
                                      child: Container(
                                        child: AutoSizeText(
                                          DateFormat('dd-MM-yyyy')
                                              .format(tarihIlk),
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 50,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _selectDate(context, 1, tarihIlk);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Tarih Son
                      Expanded(
                        flex: 11,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv757"),
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
                              flex: 3,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10 * oran),
                                      color: Colors.blue),
                                  margin: EdgeInsets.only(
                                      left: 3 * oran, right: 3 * oran),
                                  child: RawMaterialButton(
                                    constraints: BoxConstraints(
                                        minWidth: double.infinity),
                                    padding: EdgeInsets.all(0),
                                    child: SizedBox(
                                      child: Container(
                                        child: AutoSizeText(
                                          DateFormat('dd-MM-yyyy')
                                              .format(tarihSon),
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 50,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _selectDate(context, 2, tarihSon);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Veri getir
                      Expanded(
                        flex: 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Spacer(
                              flex: 2,
                            ),
                            Expanded(
                              flex: 3,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(10 * oran),
                                      color: Colors.green[700]),
                                  margin: EdgeInsets.only(
                                      left: 3 * oran, right: 3 * oran),
                                  child: RawMaterialButton(
                                    constraints: BoxConstraints(
                                        minWidth: double.infinity),
                                    padding: EdgeInsets.all(0),
                                    child: SizedBox(
                                      child: Container(
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "btn15"),
                                          style: TextStyle(
                                              fontFamily: 'Kelly Slab',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 50,
                                              color: Colors.white),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (tarihIlk.month != tarihSon.month ||
                                          tarihIlk.year != tarihSon.year) {
                                        Toast.show(
                                            Dil().sec(dilSecimi, "toast104"),
                                            context,
                                            duration: 3);
                                      } else {
                                        String gunIlk = tarihIlk.day.toString();
                                        String gunSon = tarihSon.day.toString();
                                        String ayy = tarihIlk.month.toString();
                                        String yil = tarihIlk.year.toString();
                                        String tabloAdi = "dlog4" +
                                            (ayy.length == 1
                                                ? ("0" + ayy)
                                                : ayy) +
                                            yil;
                                        print(tabloAdi);

                                        yazmaSonrasiGecikmeSayaci = 0;
                                        String komut =
                                            '3*$tabloAdi*$kayitTuruIndex*$gunIlk*$gunSon';
                                        Metotlar()
                                            .veriGonder(komut, 2234)
                                            .then((value) {
                                          if (value.split("*")[0] == "error") {
                                            Toast.show(
                                                Dil()
                                                    .sec(dilSecimi, "toast101"),
                                                context,
                                                duration: 3);
                                          } else {
                                            Toast.show(
                                                Dil().sec(dilSecimi, "toast8"),
                                                context,
                                                duration: 3);

                                            takipEtVeriIsleme(value);
                                            baglantiDurum = "";
                                          }
                                        });
                                      }
                                    },
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
                    flex: 7,
                    child: Container(
                      padding: EdgeInsets.all(5 * oran),
                      margin: EdgeInsets.all(5 * oran),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20 * oran),
                          color: Colors.grey[400]),
                      child: Row(
                        children: <Widget>[
                          //Log verileri
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: <Widget>[
                                //Liste başlıkları
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      //Kayıt no
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv760"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Tarih ilk
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv761"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Tarih Son
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv762"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Hayvan Sayısı
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv776"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //Değer
                                      Expanded(
                                        flex: 3,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv763"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Liste
                                Expanded(
                                  flex: 15,
                                  child: ListView.builder(
                                      itemCount: kayitAdet,
                                      itemBuilder:
                                          (BuildContext ctxt, int index) {
                                        return Container(
                                          color: index % 2 == 1
                                              ? Colors.grey[300]
                                              : Colors.grey[400],
                                          child: Row(
                                            children: <Widget>[
                                              //Kayıt No
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  height: 15 * oran,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      (index + 1).toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Saat
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  height: 15 * oran,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      gelenSaat[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Tarih
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  height: 15 * oran,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      gelenTarih[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Hayvan Sayısı
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  height: 15 * oran,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      gelenHayvanSayisi[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Değer
                                              Expanded(
                                                flex: 3,
                                                child: SizedBox(
                                                  height: 15 * oran,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      gelenDeger[index] +
                                                          " $birim",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                          //min-max ve toplam deger kısmı
                          Expanded(
                            flex: 1,
                            child: Visibility(
                              visible: kayitAdet == 0 ? false : true,
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Max değer
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv764"),
                                                  style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.white,
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                          maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  maxValue.toString() +
                                                      " $birim",
                                                  style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.red,
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                          maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Min Değer
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv765"),
                                                  style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.white,
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                          maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  minValue.toString() +
                                                      " $birim",
                                                  style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      fontSize: 50,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                          maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Toplam Değer
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv779"),
                                                  style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      fontSize: 50,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                          maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  totValue.toString() +
                                                      " $birim",
                                                  style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      fontSize: 50,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                          maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(
                                      flex: 1,
                                    ),
                                    //Ortalama Değer
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv782"),
                                                  style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.white,
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                          maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  ortValue.toString() +
                                                      " $birim",
                                                  style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      fontSize: 50,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                          maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
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
                          )
                        ],
                      ),
                    ))
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
                      Dil().sec(dilSecimi, "tv737"),
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
                            text: TextSpan(children: <TextSpan>[
                              //Giriş metni
                              TextSpan(
                                  text: Dil().sec(dilSecimi, "info61"),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13 * oran)),
/*
                                TextSpan(
                                  text: '\n\n'+Dil().sec(dilSecimi, "tv673"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran,
                                    fontWeight: FontWeight.bold
                                  )
                                ),

                                TextSpan(
                                  text:'\n'+ Dil().sec(dilSecimi, "ksltm20")+'\n'+
                                  Dil().sec(dilSecimi, "ksltm3")+'\n',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11*oran,
                                  )
                                ),
                                */
                            ]),
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
      drawer: Metotlar().navigatorMenu(dilSecimi, context, oran),
    );
  }

  Future<Null> _selectDate(
      BuildContext context, int index, DateTime selectedDate) async {
    final DateTime picked = await showDatePicker(
        helpText: Dil().sec(dilSecimi, "tv759"),
        cancelText: Dil().sec(dilSecimi, "btn3"),
        confirmText: Dil().sec(dilSecimi, "btn2"),
        locale: Locale('tr', 'TR'),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
                return Center(
                    child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: FittedBox(child: child),
                ));
              }
        );
        
    if (picked != null && picked != selectedDate) {
      if (picked.compareTo(DateTime.now()) <= 0) {
        if (index == 1) {
          setState(() {
            tarihIlk = picked;
          });
        }

        if (index == 2) {
          setState(() {
            tarihSon = picked;
          });
        }
      } else {
        Toast.show(Dil().sec(dilSecimi, "toast77"), context, duration: 3);
      }
    }
  }

  String kayitTuru(int index) {
    String sonuc = "";

    if (index == 1) {
      sonuc = Dil().sec(dilSecimi, "tv770");
    } else if (index == 2) {
      sonuc = Dil().sec(dilSecimi, "tv771");
    } else if (index == 3) {
      sonuc = Dil().sec(dilSecimi, "tv772");
    } else if (index == 4) {
      sonuc = Dil().sec(dilSecimi, "tv773");
    } else if (index == 5) {
      sonuc = Dil().sec(dilSecimi, "tv774");
    } else if (index == 6) {
      sonuc = Dil().sec(dilSecimi, "tv775");
    }

    return sonuc;
  }

  takipEtVeriIsleme(String gelenMesaj) {
    print(gelenMesaj);
    var degerler = gelenMesaj.split('#');
    kayitAdet = degerler.length - 1;
    gelenSaat = [];
    gelenTarih = [];
    gelenHayvanSayisi = [];
    gelenDeger = [];
    maxValue = -99999.0;
    minValue = 99999.0;
    totValue = 0.0;
    ortValue = 0.0;
    if (gelenMesaj.contains("yok1")) {
      Toast.show(Dil().sec(dilSecimi, "toast103"), context, duration: 3);
    } else if (gelenMesaj.contains("yok2")) {
      Toast.show(Dil().sec(dilSecimi, "toast102"), context, duration: 3);
    } else {
      for (var i = 1; i < degerler.length; i++) {
        String xx = degerler[i].split("*")[0];
        String saat = xx.length == 1 ? "0" + xx : xx;
        String yy = degerler[i].split("*")[1];
        String dk = yy.length == 1 ? "0" + yy : yy;
        String zz = degerler[i].split("*")[2];
        String gun = zz.length == 1 ? "0" + zz : zz;
        String tt = tarihIlk.month.toString();
        String ay = tt.length == 1 ? "0" + tt : tt;
        gelenSaat
            .add(saat + ":" + dk);

        gelenTarih.add(gun +
            "-" +
            ay +
            "-" +
            tarihIlk.year.toString());
        gelenHayvanSayisi.add(degerler[i].split("*")[3]);
        gelenDeger.add(degerler[i].split("*")[4]);

        double value = double.parse(degerler[i].split("*")[4]);
        if (value > maxValue) {
          maxValue = value;
        }
        if (value < minValue) {
          minValue = value;
        }

        totValue = totValue + value;
      }
      ortValue = (((totValue / kayitAdet) * 10).roundToDouble()) / 10;
    }

    baglanti = false;
    if (!timerCancel) {
      setState(() {});
    }
  }
}
