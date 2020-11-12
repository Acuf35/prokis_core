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

class AlarmVeUyariLog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AlarmVeUyariLogState();
  }
}

class AlarmVeUyariLogState extends State<AlarmVeUyariLog> {
  String dilSecimi = "EN";

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  String baglantiDurum = "";
  String alarmDurum =
      "00000000000000000000000000000000000000000000000000000000000000000000000000000000";

  int kayitTuruIndex = 1;

  DateTime tarihIlk = DateTime.now();
  DateTime tarihSon = DateTime.now();

  int kayitAdet = 0;

  List<String> aktifZaman = [];
  List<String> pasifZaman = [];
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv736',
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
                                                              Spacer(flex: 1,),
                                                              //Alarm ve Uyarı
                                                              Expanded(
                                                                flex: 1,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Spacer(),
                                                                    //Alarm
                                                                    Expanded(flex: 2,
                                                                        child:
                                                                            Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: EdgeInsets
                                                                          .all(3 *
                                                                              oran),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10 *
                                                                              oran),
                                                                          color:
                                                                              Colors.blue),
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Spacer(),
                                                                          Expanded(
                                                                            flex:
                                                                                6,
                                                                            child:
                                                                                RawMaterialButton(
                                                                              constraints: BoxConstraints(minWidth: double.infinity),
                                                                              padding: EdgeInsets.all(0),
                                                                              onPressed: () {
                                                                                kayitTuruIndex = 1;
                                                                                kayitAdet = 0;
                                                                                aktifZaman = [];
                                                                                pasifZaman = [];
                                                                                gelenDeger = [];
                                                                                setState(() {
                                                                                  Navigator.pop(context);
                                                                                });
                                                                              },
                                                                              child: SizedBox(
                                                                                child: Container(
                                                                                  child: AutoSizeText(
                                                                                    Dil().sec(dilSecimi, "tv767"),
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
                                                                    //Uyarı
                                                                    Expanded(flex: 2,
                                                                        child:
                                                                            Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      margin: EdgeInsets
                                                                          .all(3 *
                                                                              oran),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(10 *
                                                                              oran),
                                                                          color:
                                                                              Colors.blue),
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Spacer(),
                                                                          Expanded(
                                                                            flex:
                                                                                6,
                                                                            child:
                                                                                RawMaterialButton(
                                                                              constraints: BoxConstraints(minWidth: double.infinity),
                                                                              padding: EdgeInsets.all(0),
                                                                              onPressed: () {
                                                                                kayitTuruIndex = 2;
                                                                                kayitAdet = 0;
                                                                                aktifZaman = [];
                                                                                pasifZaman = [];
                                                                                gelenDeger = [];
                                                                                setState(() {
                                                                                  Navigator.pop(context);
                                                                                });
                                                                              },
                                                                              child: SizedBox(
                                                                                child: Container(
                                                                                  child: AutoSizeText(
                                                                                    Dil().sec(dilSecimi, "tv768"),
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
                                                              Spacer(flex: 3,),
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
                                        String tabloAdi = (kayitTuruIndex==1 ? "dlog2" : "dlog3") +
                                            (ayy.length == 1
                                                ? ("0" + ayy)
                                                : ayy) +
                                            yil;
                                        print(tabloAdi);

                                        yazmaSonrasiGecikmeSayaci = 0;
                                        String komut =
                                            '2*$tabloAdi*$kayitTuruIndex*$gunIlk*$gunSon';
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
                      child: Column(
                        children: <Widget>[
                          //Liste başlıkları
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                //Kayıt no
                                Expanded(flex: 2,
                                  child: SizedBox(
                                    child: Container(
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv785"),
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
                                  flex: 7,
                                  child: SizedBox(
                                    child: Container(
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "btn16"),
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
                                  flex: 7,
                                  child: SizedBox(
                                    child: Container(
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "btn17"),
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
                                Expanded(flex: 20,
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
                                        Expanded(flex: 2,
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
                                        //Alarm Giriş Zamanı
                                        Expanded(
                                          flex: 7,
                                          child: SizedBox(
                                            height: 15 * oran,
                                            child: Container(
                                              child: AutoSizeText(
                                                aktifZaman[index],
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
                                        //Alarm çıkış Zamanı
                                        Expanded(
                                          flex: 7,
                                          child: SizedBox(
                                            height: 15 * oran,
                                            child: Container(
                                              child: AutoSizeText(
                                                pasifZaman[index],
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
                                        //Alarm Tanımı
                                        Expanded(flex: 20,
                                          child: SizedBox(
                                            height: 15 * oran,
                                            child: Container(
                                              child: AutoSizeText(
                                                kayitTuruIndex==1 ? Dil().sec(dilSecimi, "alarm${gelenDeger[index]}") :
                                                Dil().sec(dilSecimi, "uyari${int.parse(gelenDeger[index])+60}"),
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
                      Dil().sec(dilSecimi, "tv735"),
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
                                  text: Dil().sec(dilSecimi, "info55"),
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
      sonuc = Dil().sec(dilSecimi, "tv767");
    } else if (index == 2) {
      sonuc = Dil().sec(dilSecimi, "tv768");
    }

    return sonuc;
  }

  takipEtVeriIsleme(String gelenMesaj) {
    print(gelenMesaj);
    var degerler = gelenMesaj.split('#');
    kayitAdet = degerler.length - 1;
    aktifZaman = [];
    pasifZaman = [];
    gelenDeger = [];

    if (gelenMesaj.contains("yok1")) {
      Toast.show(Dil().sec(dilSecimi, "toast103"), context, duration: 3);
    } else if (gelenMesaj.contains("yok2")) {
      Toast.show(Dil().sec(dilSecimi, "toast102"), context, duration: 3);
    } else {
      for (var i = 1; i < degerler.length; i++) {
        String xxG = degerler[i].split("*")[0];
        String saatG = xxG.length == 1 ? "0" + xxG : xxG;
        String yyG = degerler[i].split("*")[1];
        String dkG = yyG.length == 1 ? "0" + yyG : yyG;
        String zzG = degerler[i].split("*")[2];
        String gunG = zzG.length == 1 ? "0" + zzG : zzG;
        String xxC = degerler[i].split("*")[3];
        String saatC = xxC.length == 1 ? "0" + xxC : xxC;
        String yyC = degerler[i].split("*")[4];
        String dkC = yyC.length == 1 ? "0" + yyC : yyC;
        String zzC = degerler[i].split("*")[5];
        String gunC = zzC.length == 1 ? "0" + zzC : zzC;
        String tt = tarihIlk.month.toString();
        String ay = tt.length == 1 ? "0" + tt : tt;
        String ww = tarihIlk.year.toString();
        String yil = ww.length == 1 ? "0" + ww : ww;

        aktifZaman.add(saatG + ":" + dkG + "   " + gunG + "." + ay + "." + yil);

        pasifZaman.add(saatC + ":" + dkC + "   " + gunC + "." + ay + "." + yil);

        gelenDeger.add(degerler[i].split("*")[6]);
      }
    }

    baglanti = false;
    if (!timerCancel) {
      setState(() {});
    }
  }
}
