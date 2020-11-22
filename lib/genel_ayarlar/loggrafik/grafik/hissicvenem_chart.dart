import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:prokis/genel_ayarlar/loggrafik/grafik.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';
import 'package:toast/toast.dart';

class HisSicVeNemChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HisSicVeNemChartState();
  }
}

class HisSicVeNemChartState extends State<HisSicVeNemChart> {
  String dilSecimi = "EN";
  String sifre = "0";

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  String baglantiDurum = "";
  String alarmDurum =
      "00000000000000000000000000000000000000000000000000000000000000000000000000000000";

  DateTime tarih = DateTime.now();

  String disNemVarMi = "0";
  int isiSenAdet = 0;
  int kayitAdet1 = 0;
  int kayitAdet2 = 0;
  int kayitAdet3 = 0;

  double maxValue1 = -100.0;
  double maxValue2 = -100.0;
  double maxValue3 = -100.0;
  double minValue1 = 100.0;
  double minValue2 = 100.0;
  double minValue3 = 100.0;

  List<String> gelenSaat = [];
  List<String> gelenDegerOrtSic = [];
  List<String> gelenDegerIcNem = [];
  List<String> gelenDegerDisNem = [];

  bool ortSicVisibility = false;
  bool icNemVisibility = false;
  bool disNemVisibility = false;

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
    sifre = dbProkis.dbVeriGetir(3, 4, "0");
    disNemVarMi = dbProkis.dbVeriGetir(13, 4, "0");
    isiSenAdet = int.parse(dbProkis.dbVeriGetir(4, 4, "0").split("#")[0]);

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
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv807a',
          Colors.blue, baglantiDurum, alarmDurum),
      floatingActionButton: Container(
        width: 56 * oran,
        height: 56 * oran,
        child: FittedBox(
          child: Opacity(
            opacity: 0.5,
            child: FloatingActionButton(
              onPressed: () {
                timerCancel = true;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Grafik()),
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
                      //Tarih
                      Expanded(
                        flex: 5,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10 * oran),
                                color: Colors.blue),
                            margin: EdgeInsets.only(
                                left: 3 * oran, right: 3 * oran),
                            child: RawMaterialButton(
                              constraints:
                                  BoxConstraints(minWidth: double.infinity),
                              padding: EdgeInsets.all(0),
                              child: SizedBox(
                                child: Container(
                                  child: AutoSizeText(
                                    DateFormat('dd-MM-yyyy').format(tarih),
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
                                _selectDate(context, 1, tarih);
                              },
                            ),
                          ),
                        ),
                      ),
                      //Veri getir
                      Expanded(
                        flex: 5,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10 * oran),
                                color: Colors.green[700]),
                            margin: EdgeInsets.only(
                                left: 3 * oran, right: 3 * oran),
                            child: RawMaterialButton(
                              constraints:
                                  BoxConstraints(minWidth: double.infinity),
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
                                minValue1 = 100.0;
                                minValue2 = 100.0;
                                minValue3 = 100.0;
                                maxValue1 = -100.0;
                                maxValue2 = -100.0;
                                maxValue3 = -100.0;
                                String gun = tarih.day.toString();
                                String ayy = tarih.month.toString();
                                String yil = tarih.year.toString();
                                String tabloAdi = "dlog1" +
                                    (ayy.length == 1 ? ("0" + ayy) : ayy) +
                                    yil;
                                print(tabloAdi);

                                yazmaSonrasiGecikmeSayaci = 0;
                                String komut = '5*$tabloAdi*1*17*18*15*$gun';
                                Metotlar()
                                    .veriGonder(komut, 2234)
                                    .then((value) {
                                  if (value.split("*")[0] == "error") {
                                    Toast.show(Dil().sec(dilSecimi, "toast101"),
                                        context,
                                        duration: 3);
                                  } else {
                                    Toast.show(
                                        Dil().sec(dilSecimi, "toast8"), context,
                                        duration: 3);

                                    takipEtVeriIsleme(value);
                                    baglantiDurum = "";
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      //Görünecek veri seçimi
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
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
                                          Dil().sec(dilSecimi, "tv808"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 60,
                                            //fontWeight: FontWeight.bold
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
                                      alignment: Alignment.topCenter,
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        yazmaSonrasiGecikmeSayaci = 0;
                                        if (!ortSicVisibility) {
                                          ortSicVisibility = true;
                                          icNemVisibility = false;
                                          disNemVisibility = false;
                                        } else {
                                          ortSicVisibility = false;
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(ortSicVisibility == true
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank),
                                      color: ortSicVisibility == true
                                          ? Colors.green.shade500
                                          : Colors.blue.shade600,
                                      iconSize: 20 * oran,
                                    ),
                                  ),
                                ],
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
                                          Dil().sec(dilSecimi, "tv809"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 60,
                                            //fontWeight: FontWeight.bold
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
                                      alignment: Alignment.topCenter,
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        yazmaSonrasiGecikmeSayaci = 0;
                                        if (!icNemVisibility) {
                                          icNemVisibility = true;
                                          ortSicVisibility = false;
                                          disNemVisibility = false;
                                        } else {
                                          icNemVisibility = false;
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(icNemVisibility == true
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank),
                                      color: icNemVisibility == true
                                          ? Colors.green.shade500
                                          : Colors.blue.shade600,
                                      iconSize: 20 * oran,
                                    ),
                                  ),
                                ],
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
                                          Dil().sec(dilSecimi, "tv810"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.blue[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 60,
                                            //fontWeight: FontWeight.bold
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
                                      alignment: Alignment.topCenter,
                                      padding: EdgeInsets.all(0),
                                      onPressed: () {
                                        yazmaSonrasiGecikmeSayaci = 0;
                                        if (!disNemVisibility) {
                                          disNemVisibility = true;
                                          icNemVisibility = false;
                                          ortSicVisibility = false;
                                        } else {
                                          disNemVisibility = false;
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(disNemVisibility == true
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank),
                                      color: disNemVisibility == true
                                          ? Colors.green.shade500
                                          : Colors.blue.shade600,
                                      iconSize: 20 * oran,
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
                Expanded(
                    flex: 10,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            color: Colors.white,
                            child: _chart3(oran),
                          ),
                        ),
                        Expanded(
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
                                      //Saat
                                      Expanded(
                                        flex: 6,
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
                                      Visibility(
                                          visible: ortSicVisibility,
                                          child: Spacer()),
                                      //Ort Sıc
                                      Visibility(
                                        visible: ortSicVisibility,
                                        child: Expanded(
                                          flex: 9,
                                          child: SizedBox(
                                            child: Container(
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv808"),
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
                                      ),
                                      Visibility(
                                          visible: icNemVisibility,
                                          child: Spacer()),
                                      //İç Nem
                                      Visibility(
                                        visible: icNemVisibility,
                                        child: Expanded(
                                          flex: 9,
                                          child: SizedBox(
                                            child: Container(
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv809"),
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
                                      ),
                                      Visibility(
                                          visible: disNemVisibility,
                                          child: Spacer()),
                                      //Dış Nem
                                      Visibility(
                                        visible: disNemVisibility,
                                        child: Expanded(
                                          flex: 9,
                                          child: SizedBox(
                                            child: Container(
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv810"),
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
                                      ),
                                    ],
                                  ),
                                ),
                                //Liste
                                Expanded(
                                  flex: 15,
                                  child: Row(
                                    children: [
                                      //Saat
                                      Expanded(
                                        flex: 6,
                                        child: ListView.builder(
                                            itemCount: kayitAdet1,
                                            itemBuilder:
                                                (BuildContext ctxt, int index) {
                                              return Container(
                                                color: index % 2 == 1
                                                    ? Colors.grey[300]
                                                    : Colors.grey[400],
                                                child: Row(
                                                  children: <Widget>[
                                                    //Değer
                                                    Expanded(
                                                      child: SizedBox(
                                                        height: 12 * oran,
                                                        child: Container(
                                                          child: AutoSizeText(
                                                            gelenSaat[index],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 40,
                                                              color:
                                                                  Colors.black,
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
                                      Visibility(
                                          visible: ortSicVisibility,
                                          child: Spacer()),
                                      //Ort Sic
                                      Visibility(
                                        visible: ortSicVisibility,
                                        child: Expanded(
                                          flex: 9,
                                          child: ListView.builder(
                                              itemCount: kayitAdet1,
                                              itemBuilder: (BuildContext ctxt,
                                                  int index) {
                                                String birim = "°C";
                                                return Container(
                                                  color: index % 2 == 1
                                                      ? Colors.grey[300]
                                                      : Colors.grey[400],
                                                  child: Row(
                                                    children: <Widget>[
                                                      //Değer
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 12 * oran,
                                                          child: Container(
                                                            child: AutoSizeText(
                                                              gelenDegerOrtSic[
                                                                      index] +
                                                                  " " +
                                                                  birim,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 40,
                                                                color: double.parse(gelenDegerOrtSic[
                                                                            index]) ==
                                                                        maxValue1
                                                                    ? Colors.red
                                                                    : (double.parse(gelenDegerOrtSic[index]) ==
                                                                            minValue1
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .black),
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
                                      ),
                                      Visibility(
                                          visible: icNemVisibility,
                                          child: Spacer()),
                                      //İç Nem
                                      Visibility(
                                        visible: icNemVisibility,
                                        child: Expanded(
                                          flex: 9,
                                          child: ListView.builder(
                                              itemCount: kayitAdet2,
                                              itemBuilder: (BuildContext ctxt,
                                                  int index) {
                                                String birim = "%";
                                                return Container(
                                                  color: index % 2 == 1
                                                      ? Colors.grey[300]
                                                      : Colors.grey[400],
                                                  child: Row(
                                                    children: <Widget>[
                                                      //Değer
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 12 * oran,
                                                          child: Container(
                                                            child: AutoSizeText(
                                                              gelenDegerIcNem[
                                                                      index] +
                                                                  " " +
                                                                  birim,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 40,
                                                                color: double.parse(gelenDegerIcNem[
                                                                            index]) ==
                                                                        maxValue2
                                                                    ? Colors.red
                                                                    : (double.parse(gelenDegerIcNem[index]) ==
                                                                            minValue2
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .black),
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
                                      ),
                                      Visibility(
                                          visible: disNemVisibility,
                                          child: Spacer()),
                                      //Dış Nem
                                      Visibility(
                                        visible: disNemVisibility,
                                        child: Expanded(
                                          flex: 9,
                                          child: ListView.builder(
                                              itemCount: kayitAdet3,
                                              itemBuilder: (BuildContext ctxt,
                                                  int index) {
                                                String birim = "%";
                                                return Container(
                                                  color: index % 2 == 1
                                                      ? Colors.grey[300]
                                                      : Colors.grey[400],
                                                  child: Row(
                                                    children: <Widget>[
                                                      //Değer
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 12 * oran,
                                                          child: Container(
                                                            child: AutoSizeText(
                                                              gelenDegerDisNem[
                                                                      index] +
                                                                  " " +
                                                                  birim,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 40,
                                                                color: double.parse(gelenDegerDisNem[
                                                                            index]) ==
                                                                        maxValue3
                                                                    ? Colors.red
                                                                    : (double.parse(gelenDegerDisNem[index]) ==
                                                                            minValue3
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .black),
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
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                                  text: Dil().sec(dilSecimi, "info54"),
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

        /* RENK DEĞİŞTİRİR
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.yellow,
                
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child,
          );
        }

        */
        );

    if (picked != null && picked != selectedDate) {
      if (picked.compareTo(DateTime.now()) <= 0) {
        if (index == 1) {
          setState(() {
            tarih = picked;
          });
        }
      } else {
        Toast.show(Dil().sec(dilSecimi, "toast77"), context, duration: 3);
      }
    }
  }

  takipEtVeriIsleme(String gelenMesaj) {
    print(gelenMesaj);
    var parametre = gelenMesaj.split('+');
    gelenSaat = [];

    var degerler1 = parametre[0].split('#');
    kayitAdet1 = degerler1.length - 1;
    gelenDegerOrtSic = [];

    var degerler2 = parametre[1].split('#');
    kayitAdet2 = degerler1.length - 1;
    gelenDegerIcNem = [];

    var degerler3 = parametre[2].split('#');
    kayitAdet3 = degerler1.length - 1;
    gelenDegerDisNem = [];

    if (gelenMesaj.contains("yok1")) {
      Toast.show(Dil().sec(dilSecimi, "toast103"), context, duration: 3);
    } else if (gelenMesaj.contains("yok2")) {
      Toast.show(Dil().sec(dilSecimi, "toast102"), context, duration: 3);
    } else {
      for (var i = 1; i < degerler1.length; i++) {
        String xx = degerler1[i].split("*")[0];
        String saat = xx.length == 1 ? "0" + xx : xx;
        String yy = degerler1[i].split("*")[1];
        String dk = yy.length == 1 ? "0" + yy : yy;
        gelenSaat.add(saat + ":" + dk);

        gelenDegerOrtSic.add(degerler1[i].split("*")[2]);
        double value1 = double.parse(degerler1[i].split("*")[2]);
        if (value1 > maxValue1) {
          maxValue1 = value1;
        }
        if (value1 < minValue1) {
          minValue1 = value1;
        }
      }

      for (var i = 1; i < degerler2.length; i++) {
        gelenDegerIcNem.add(degerler2[i].split("*")[2]);
        double value2 = double.parse(degerler2[i].split("*")[2]);
        if (value2 > maxValue2) {
          maxValue2 = value2;
        }
        if (value2 < minValue2) {
          minValue2 = value2;
        }
      }

      for (var i = 1; i < degerler3.length; i++) {
        gelenDegerDisNem.add(degerler3[i].split("*")[2]);
        double value3 = double.parse(degerler3[i].split("*")[2]);
        if (value3 > maxValue3) {
          maxValue3 = value3;
        }
        if (value3 < minValue3) {
          minValue3 = value3;
        }
      }
    }

    baglanti = false;
    if (!timerCancel) {
      setState(() {});
    }
  }

  Widget _chart3(double oran) {
    
    return charts.TimeSeriesChart(
      _createSampleData3(),
      defaultRenderer: charts.LineRendererConfig(strokeWidthPx: 3),
      animate: false,
      domainAxis: charts.DateTimeAxisSpec(
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          minute: charts.TimeFormatterSpec(
            format: 'HH:mm',
            transitionFormat: 'HH:mm',
          ),
        ),
        tickProviderSpec:
            charts.StaticDateTimeTickProviderSpec(<charts.TickSpec<DateTime>>[
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 07, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 07, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 08, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 08, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 09, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 09, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 10, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 10, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 11, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 11, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 12, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 12, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 13, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 13, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 14, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 14, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 15, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 15, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 16, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 16, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 17, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 17, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 18, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 18, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 19, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 19, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 20, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 20, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 21, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 21, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 22, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 22, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 23, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 23, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 00, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 00, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 01, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 01, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 02, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 02, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 03, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 03, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 04, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 04, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 05, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 05, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 06, 00)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, tarih.day, 06, 30)),
        ]),
        renderSpec: charts.GridlineRendererSpec(
            labelRotation: -90,
            //labelAnchor: charts.TickLabelAnchor.before,
            labelOffsetFromAxisPx: (4 * oran).round(),

            // Tick and Label styling here.
            labelStyle: charts.TextStyleSpec(
                fontSize: (10 * oran).round(), // size in Pts.
                color: charts.MaterialPalette.black),

            // Change the line colors to match text color.
            lineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.gray.shade500)),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        showAxisLine: true,
        viewport: charts.NumericExtents(-20, 100),
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            //charts.TickSpec<num>(-20),
            //charts.TickSpec<num>(-10),
            charts.TickSpec<num>(0),
            charts.TickSpec<num>(5),
            charts.TickSpec<num>(10),
            charts.TickSpec<num>(15),
            charts.TickSpec<num>(20),
            charts.TickSpec<num>(25),
            charts.TickSpec<num>(30),
            charts.TickSpec<num>(35),
            charts.TickSpec<num>(40),
            charts.TickSpec<num>(45),
            charts.TickSpec<num>(50),
            charts.TickSpec<num>(55),
            charts.TickSpec<num>(60),
            charts.TickSpec<num>(65),
            charts.TickSpec<num>(70),
            charts.TickSpec<num>(75),
            charts.TickSpec<num>(80),
            charts.TickSpec<num>(85),
            charts.TickSpec<num>(90),
            charts.TickSpec<num>(95),
            charts.TickSpec<num>(100),
          ],
        ),
        renderSpec: charts.GridlineRendererSpec(
            //labelRotation: 50,
            labelOffsetFromAxisPx: (4 * oran).round(),

            // Tick and Label styling here.
            labelStyle: charts.TextStyleSpec(
                fontSize: (10 * oran).round(), // size in Pts.
                color: charts.MaterialPalette.blue.shadeDefault),

            // Change the line colors to match text color.
            lineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.gray.shade500)),
      ),
      secondaryMeasureAxis: charts.NumericAxisSpec(
        showAxisLine: true,
        viewport: charts.NumericExtents(-10, 50),
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            //charts.TickSpec<num>(-10),
            //charts.TickSpec<num>(-7.5),
            //charts.TickSpec<num>(-5),
            //charts.TickSpec<num>(-2.5),
            charts.TickSpec<num>(0),
            charts.TickSpec<num>(2.5),
            charts.TickSpec<num>(5),
            charts.TickSpec<num>(7.5),
            charts.TickSpec<num>(10),
            charts.TickSpec<num>(12.5),
            charts.TickSpec<num>(15),
            charts.TickSpec<num>(17.5),
            charts.TickSpec<num>(20),
            charts.TickSpec<num>(22.5),
            charts.TickSpec<num>(25),
            charts.TickSpec<num>(27.5),
            charts.TickSpec<num>(30),
            charts.TickSpec<num>(32.5),
            charts.TickSpec<num>(35),
            charts.TickSpec<num>(37.5),
            charts.TickSpec<num>(40),
            charts.TickSpec<num>(42.5),
            charts.TickSpec<num>(45),
            charts.TickSpec<num>(47.5),
            charts.TickSpec<num>(50),
          ],
        ),
        renderSpec: charts.GridlineRendererSpec(
            //labelRotation: 50,
            labelOffsetFromAxisPx: (4 * oran).round(),

            // Tick and Label styling here.
            labelStyle: charts.TextStyleSpec(
                fontSize: (10 * oran).round(), // size in Pts.

                color: charts.MaterialPalette.red.shadeDefault),

            // Change the line colors to match text color.
            lineStyle: charts.LineStyleSpec(
                color: charts.MaterialPalette.gray.shade500)),
      ),
      customSeriesRenderers: [
        charts.PointRendererConfig(
            // ID used to link series to this renderer.
            customRendererId: 'customPoint')
      ],
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData3() {
    List<TimeSeriesSales> desktopSalesData = [];
    List<TimeSeriesSales> tableSalesData = [];
    List<TimeSeriesSales> mobileSalesData = [];
    List<TimeSeriesSales> losAngelesSalesData = [];

    for (int i = 0; i <= gelenSaat.length - 1; i++) {
      desktopSalesData.add(new TimeSeriesSales(
          DateTime(tarih.year, tarih.month, tarih.day, saatGetir(gelenSaat, i),
              dakikaGetir(gelenSaat, i)),
          veriGetir(gelenDegerIcNem, i)));
      tableSalesData.add(new TimeSeriesSales(
          DateTime(tarih.year, tarih.month, tarih.day, saatGetir(gelenSaat, i),
              dakikaGetir(gelenSaat, i)),
          veriGetir(gelenDegerDisNem, i)));
      losAngelesSalesData.add(new TimeSeriesSales(
          DateTime(tarih.year, tarih.month, tarih.day, saatGetir(gelenSaat, i),
              dakikaGetir(gelenSaat, i)),
          veriGetir(gelenDegerOrtSic, i)));
    }

    //print(desktopSalesData[9].sales);
    //print(desktopSalesData[9].time);

/*    final desktopSalesData = [
      TimeSeriesSales(DateTime(2017, 9, 19, 10, 30), 10),
    ];


    final tableSalesData = [
      TimeSeriesSales(DateTime(2017, 9, 19, 10, 30), 10),
      TimeSeriesSales(DateTime(2017, 9, 19, 13, 30), 50),
      TimeSeriesSales(DateTime(2017, 9, 19, 18, 30), 200),
      TimeSeriesSales(DateTime(2017, 9, 19, 22, 00), 150),
    ];

    final mobileSalesData = [
      TimeSeriesSales(DateTime(2017, 9, 19, 10, 30), 10),
      TimeSeriesSales(DateTime(2017, 9, 19, 13, 30), 50),
      TimeSeriesSales(DateTime(2017, 9, 19, 18, 30), 200),
      TimeSeriesSales(DateTime(2017, 9, 19, 22, 00), 150),
    ];

    final losAngelesSalesData = [
      TimeSeriesSales(DateTime(2017, 9, 19, 10, 30), 25),
      TimeSeriesSales(DateTime(2017, 9, 19, 13, 30), 50),
      TimeSeriesSales(DateTime(2017, 9, 19, 18, 30), 10),
      TimeSeriesSales(DateTime(2017, 9, 19, 22, 00), 20),
    ];
*/
    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'icnem',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'disnem',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blue[800]),
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: tableSalesData,
      ),
/*
      charts.Series<TimeSeriesSales, DateTime>(
          id: 'maxmindeger',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: mobileSalesData)
        // Configure our custom point renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
        */
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'ortsic',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: losAngelesSalesData,
      )..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId')
    ];
  }

  double veriGetir(List<String> liste, int index) {
    return liste.length > index ? double.parse(liste[index]) : 0;
  }

  int saatGetir(List<String> liste, int index) {
    return liste.length > index ? int.parse(liste[index].split(":")[0]) : 0;
  }

  int dakikaGetir(List<String> liste, int index) {
    return liste.length > index ? int.parse(liste[index].split(":")[1]) : 0;
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}
