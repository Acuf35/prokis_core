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

class SicVeNemLog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SicVeNemLogState();
  }
}

class SicVeNemLogState extends State<SicVeNemLog> {
  String dilSecimi = "EN";
  String sifre = "0";

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

  String disNemVarMi = "0";
  int isiSenAdet = 0;
  int kayitAdet = 0;

  double maxValue = -100.0;
  double minValue = 100.0;

  List<String> gelenSaat = [];
  List<String> gelenTarih = [];
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
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv735',
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
                                                              Spacer(),
                                                              //ortalama sıcaklık - iç nem - dış nem
                                                              Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    //Ortalama Sıcaklık
                                                                    Expanded(
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
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                setState(() {
                                                                                  Navigator.pop(context);
                                                                                });
                                                                              },
                                                                              child: SizedBox(
                                                                                child: Container(
                                                                                  child: AutoSizeText(
                                                                                    Dil().sec(dilSecimi, "tv661"),
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
                                                                    //iç nem
                                                                    Expanded(
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
                                                                                kayitTuruIndex = 17;
                                                                                kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                setState(() {
                                                                                  Navigator.pop(context);
                                                                                });
                                                                              },
                                                                              child: SizedBox(
                                                                                child: Container(
                                                                                  child: AutoSizeText(
                                                                                    Dil().sec(dilSecimi, "tv441"),
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
                                                                    //Dış nem
                                                                    Visibility(
                                                                      visible: disNemVarMi ==
                                                                              "1"
                                                                          ? true
                                                                          : false,
                                                                      child: Expanded(
                                                                          child: Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(3 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 18;
                                                                                  kayitAdet = 0;
                                                                                  gelenSaat = [];
                                                                                  gelenTarih = [];
                                                                                  gelenDeger = [];
                                                                                  maxValue = -99999.0;
                                                                                  minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv442"),
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
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              //Sıc. sens 1-5
                                                              Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    //Sens 1
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              1,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 2;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv739"),
                                                                                      style: TextStyle(fontFamily: 'Kelly Slab', fontSize: 50, color: Colors.white),
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )),
                                                                    //Sens 2
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              2,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 3;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv740"),
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
                                                                      ),
                                                                    )),
                                                                    //Sens 3
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              3,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 4;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv741"),
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
                                                                      ),
                                                                    )),
                                                                    //Sens 4
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              4,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 5;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv742"),
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
                                                                      ),
                                                                    )),
                                                                    //Sens 5
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              5,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 6;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv743"),
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
                                                                      ),
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                              //Sıc. sens 6-10
                                                              Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    //Sens 6
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              6,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 7;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv744"),
                                                                                      style: TextStyle(fontFamily: 'Kelly Slab', fontSize: 50, color: Colors.white),
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )),
                                                                    //Sens 7
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              7,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 8;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv745"),
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
                                                                      ),
                                                                    )),
                                                                    //Sens 8
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              8,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 9;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv746"),
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
                                                                      ),
                                                                    )),
                                                                    //Sens 9
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              9,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 10;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv747"),
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
                                                                      ),
                                                                    )),
                                                                    //Sens 10
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              10,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 11;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv748"),
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
                                                                      ),
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                              //Sıc. sens 11-15
                                                              Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    //Sens. 11
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              11,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 12;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv749"),
                                                                                      style: TextStyle(fontFamily: 'Kelly Slab', fontSize: 50, color: Colors.white),
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )),
                                                                    //Sens. 12
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              12,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 13;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv750"),
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
                                                                      ),
                                                                    )),
                                                                    //Sens. 13
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              13,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 14;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv751"),
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
                                                                      ),
                                                                    )),
                                                                    //Sens. 14
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              14,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 15;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv752"),
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
                                                                      ),
                                                                    )),
                                                                    //Sens. 15
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              15,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  kayitTuruIndex = 16;
                                                                                  kayitAdet = 0;
                                                                                gelenSaat = [];
                                                                                gelenTarih = [];
                                                                                gelenDeger = [];
                                                                                maxValue = -99999.0;
                                                                                minValue = 99999.0;
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      Dil().sec(dilSecimi, "tv753"),
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
                                                                      ),
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                              Spacer(),
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
                      //Log periyot
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv755"),
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
                                          logDonguSuresi + " dk",
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
                                                              "tv755"),
                                                          textScaleFactor: oran,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Kelly Slab',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                      ),
                                                      //Log periyot
                                                      Expanded(
                                                        flex: 10,
                                                        child: Container(
                                                          color: Colors.white,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Spacer(
                                                                flex: 3,
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    //5 dk
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              1,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  logDonguSuresi = "5";
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      "5 " + Dil().sec(dilSecimi, "tv758"),
                                                                                      style: TextStyle(fontFamily: 'Kelly Slab', fontSize: 50, color: Colors.white),
                                                                                      maxLines: 1,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    )),
                                                                    //10 dk
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              2,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  logDonguSuresi = "10";
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      "10 " + Dil().sec(dilSecimi, "tv758"),
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
                                                                      ),
                                                                    )),
                                                                    //15 dk
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              3,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  logDonguSuresi = "15";
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      "15 " + Dil().sec(dilSecimi, "tv758"),
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
                                                                      ),
                                                                    )),
                                                                    //30 dk
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              4,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  logDonguSuresi = "30";
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      "30 " + Dil().sec(dilSecimi, "tv758"),
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
                                                                      ),
                                                                    )),
                                                                    //60 dk
                                                                    Expanded(
                                                                        child:
                                                                            Visibility(
                                                                      visible:
                                                                          isiSenAdet >=
                                                                              5,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        margin: EdgeInsets.all(5 *
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
                                                                              flex: 6,
                                                                              child: RawMaterialButton(
                                                                                constraints: BoxConstraints(minWidth: double.infinity),
                                                                                padding: EdgeInsets.all(0),
                                                                                onPressed: () {
                                                                                  logDonguSuresi = "60";
                                                                                  setState(() {
                                                                                    Navigator.pop(context);
                                                                                  });
                                                                                },
                                                                                child: SizedBox(
                                                                                  child: Container(
                                                                                    child: AutoSizeText(
                                                                                      "60 " + Dil().sec(dilSecimi, "tv758"),
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
                                                                      ),
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                              Spacer(
                                                                flex: 5,
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
                                        minValue = 100.0;
                                        maxValue = -100.0;
                                        String gunIlk = tarihIlk.day.toString();
                                        String gunSon = tarihSon.day.toString();
                                        String ayy = tarihIlk.month.toString();
                                        String yil = tarihIlk.year.toString();
                                        String tabloAdi = "dlog1" +
                                            (ayy.length == 1
                                                ? ("0" + ayy)
                                                : ayy) +
                                            yil;
                                        print(tabloAdi);

                                        yazmaSonrasiGecikmeSayaci = 0;
                                        String komut =
                                            '1*$tabloAdi*$kayitTuruIndex*$logDonguSuresi*$gunIlk*$gunSon';
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
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: <Widget>[
                                //Liste başlıkları
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
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
                                      Expanded(
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
                                        String birim = (kayitTuruIndex == 17 ||
                                                kayitTuruIndex == 18)
                                            ? "%"
                                            : "°C";
                                        return Container(
                                          color: index % 2 == 1
                                              ? Colors.grey[300]
                                              : Colors.grey[400],
                                          child: Row(
                                            children: <Widget>[
                                              //Kayıt No
                                              Expanded(
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
                                              //Değer
                                              Expanded(
                                                child: SizedBox(
                                                  height: 15 * oran,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      gelenDeger[index] +
                                                          " " +
                                                          birim,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        color: double.parse(
                                                                    gelenDeger[
                                                                        index]) ==
                                                                maxValue
                                                            ? Colors.red
                                                            : (double.parse(gelenDeger[
                                                                        index]) ==
                                                                    minValue
                                                                ? Colors.blue
                                                                : Colors.black),
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
                                    Expanded(
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  maxValue.toString() +
                                                      " " +
                                                      (kayitTuruIndex == 17 ||
                                                              kayitTuruIndex ==
                                                                  18
                                                          ? "%"
                                                          : "°C"),
                                                  style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                    Expanded(
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                child: AutoSizeText(
                                                  minValue.toString() +
                                                      " " +
                                                      (kayitTuruIndex == 17 ||
                                                              kayitTuruIndex ==
                                                                  18
                                                          ? "%"
                                                          : "°C"),
                                                  style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
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
        lastDate: DateTime(2101));
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
      sonuc = Dil().sec(dilSecimi, "tv661");
    } else if (index == 2) {
      sonuc = Dil().sec(dilSecimi, "tv739");
    } else if (index == 3) {
      sonuc = Dil().sec(dilSecimi, "tv740");
    } else if (index == 4) {
      sonuc = Dil().sec(dilSecimi, "tv741");
    } else if (index == 5) {
      sonuc = Dil().sec(dilSecimi, "tv742");
    } else if (index == 6) {
      sonuc = Dil().sec(dilSecimi, "tv743");
    } else if (index == 7) {
      sonuc = Dil().sec(dilSecimi, "tv744");
    } else if (index == 8) {
      sonuc = Dil().sec(dilSecimi, "tv745");
    } else if (index == 9) {
      sonuc = Dil().sec(dilSecimi, "tv746");
    } else if (index == 10) {
      sonuc = Dil().sec(dilSecimi, "tv747");
    } else if (index == 11) {
      sonuc = Dil().sec(dilSecimi, "tv748");
    } else if (index == 12) {
      sonuc = Dil().sec(dilSecimi, "tv749");
    } else if (index == 13) {
      sonuc = Dil().sec(dilSecimi, "tv750");
    } else if (index == 14) {
      sonuc = Dil().sec(dilSecimi, "tv751");
    } else if (index == 15) {
      sonuc = Dil().sec(dilSecimi, "tv752");
    } else if (index == 16) {
      sonuc = Dil().sec(dilSecimi, "tv753");
    } else if (index == 17) {
      sonuc = Dil().sec(dilSecimi, "tv441");
    } else if (index == 18) {
      sonuc = Dil().sec(dilSecimi, "tv442");
    }

    return sonuc;
  }

  takipEtVeriIsleme(String gelenMesaj) {
    print(gelenMesaj);
    var degerler = gelenMesaj.split('#');
    kayitAdet = degerler.length - 1;
    gelenSaat = [];
    gelenTarih = [];
    gelenDeger = [];

    if (gelenMesaj.contains("yok1")) {
      Toast.show(Dil().sec(dilSecimi, "toast103"), context, duration: 3);
    } else if (gelenMesaj.contains("yok2")) {
      Toast.show(Dil().sec(dilSecimi, "toast102"), context, duration: 3);
    } else {
      for (var i = 1; i < degerler.length; i++) {
        gelenSaat
            .add(degerler[i].split("*")[0] + ":" + degerler[i].split("*")[1]);

        gelenTarih.add(degerler[i].split("*")[2] +
            "-" +
            tarihIlk.month.toString() +
            "-" +
            tarihIlk.year.toString());
        gelenDeger.add(degerler[i].split("*")[3]);
        double value = double.parse(degerler[i].split("*")[3]);
        if (value > maxValue) {
          maxValue = value;
        }
        if (value < minValue) {
          minValue = value;
        }
      }
    }

    baglanti = false;
    if (!timerCancel) {
      setState(() {});
    }
  }
}
