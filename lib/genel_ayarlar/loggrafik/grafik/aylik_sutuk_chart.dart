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

class AylikSuTukGrafigi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AylikSuTukGrafigiState();
  }
}

class AylikSuTukGrafigiState extends State<AylikSuTukGrafigi> {
  String dilSecimi = "EN";

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  String baglantiDurum = "";
  String alarmDurum =
      "00000000000000000000000000000000000000000000000000000000000000000000000000000000";

  DateTime tarih = DateTime.now();

  int kayitAdet1 = 0;
  int kayitAdet2 = 0;

  double maxValue1 = -100.0;
  double maxValue2 = -100.0;
  double minValue1 = 100.0;
  double minValue2 = 100.0;

  List<String> gelenTarih = [];
  List<String> gelenDegerSuTukTop = [];
  List<String> gelenDegerSuTukHayBas = [];

  bool suTukTopVisibility = true;
  bool suTukHayBasVisibility = false;

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
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv817a',
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
                        flex: 10,
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
                        flex: 10,
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
                                maxValue1 = -100.0;
                                maxValue2 = -100.0;
                                String gun = tarih.day.toString();
                                String ayy = tarih.month.toString();
                                String yil = tarih.year.toString();
                                String tabloAdi = "dlog4" +
                                    (ayy.length == 1 ? ("0" + ayy) : ayy) +
                                    yil;
                                print(tabloAdi);

                                yazmaSonrasiGecikmeSayaci = 0;
                                String komut = '7*$tabloAdi*5*6*$ayy';
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
                        flex: 3,
                        child: Row(
                          children: [
                            //Su Tüketimi Toplam
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
                                          Dil().sec(dilSecimi, "tv820"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 60,
                                            //fontWeight: FontWeight.bold
                                          ),
                                          maxLines: 1,
                                          minFontSize: 5,
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
                                        if (!suTukTopVisibility) {
                                          suTukTopVisibility = true;
                                          suTukHayBasVisibility = false;
                                        } else {
                                          suTukTopVisibility = false;
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(suTukTopVisibility == true
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank),
                                      color: suTukTopVisibility == true
                                          ? Colors.green.shade500
                                          : Colors.blue.shade600,
                                      iconSize: 20 * oran,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Su Tüketimi hayvan başına
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
                                          Dil().sec(dilSecimi, "tv821"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            color: Colors.red[800],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 60,
                                            //fontWeight: FontWeight.bold
                                          ),
                                          maxLines: 1,
                                          minFontSize: 2,
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
                                        if (!suTukHayBasVisibility) {
                                          suTukHayBasVisibility = true;
                                          suTukTopVisibility = false;
                                        } else {
                                          suTukHayBasVisibility = false;
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(suTukHayBasVisibility == true
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank),
                                      color: suTukHayBasVisibility == true
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
                                      //Tarih
                                      Expanded(
                                        flex: 8,
                                        child: SizedBox(
                                          child: Container(
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv762")+"\n"+Dil().sec(dilSecimi, "tv822"),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              maxLines: 2,
                                              minFontSize: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                          visible: suTukTopVisibility,
                                          child: Spacer()),
                                      //Su tüketimi toplam
                                      Visibility(
                                        visible: suTukTopVisibility,
                                        child: Expanded(
                                          flex: 8,
                                          child: SizedBox(
                                            child: Container(
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv820")+"\n(Lt)",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                maxLines: 2,
                                                minFontSize: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                          visible: suTukHayBasVisibility,
                                          child: Spacer()),
                                      //Su tüketimi Hayvan başına
                                      Visibility(
                                        visible: suTukHayBasVisibility,
                                        child: Expanded(
                                          flex: 8,
                                          child: SizedBox(
                                            child: Container(
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv821")+"\n(Lt)",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                                maxLines: 2,
                                                minFontSize: 2,
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
                                        flex: 8,
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
                                                            gelenTarih[index],
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 40,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            maxLines: 1,
                                                            minFontSize: 2,
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
                                          visible: suTukTopVisibility,
                                          child: Spacer()),
                                      //Su Tüketimi toplam
                                      Visibility(
                                        visible: suTukTopVisibility,
                                        child: Expanded(
                                          flex: 8,
                                          child: ListView.builder(
                                              itemCount: kayitAdet1,
                                              itemBuilder: (BuildContext ctxt,
                                                  int index) {
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
                                                              gelenDegerSuTukTop[
                                                                      index],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 40,
                                                                color: double.parse(gelenDegerSuTukTop[
                                                                            index]) ==
                                                                        maxValue1
                                                                    ? Colors.red
                                                                    : (double.parse(gelenDegerSuTukTop[index]) ==
                                                                            minValue1
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .black),
                                                              ),
                                                              maxLines: 1,
                                                            minFontSize: 2,
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
                                          visible: suTukHayBasVisibility,
                                          child: Spacer()),
                                      //Su Tüketimi hayvan başına
                                      Visibility(
                                        visible: suTukHayBasVisibility,
                                        child: Expanded(
                                          flex: 8,
                                          child: ListView.builder(
                                              itemCount: kayitAdet1,
                                              itemBuilder: (BuildContext ctxt,
                                                  int index) {
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
                                                              gelenDegerSuTukHayBas[
                                                                      index],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 40,
                                                                color: double.parse(gelenDegerSuTukHayBas[
                                                                            index]) ==
                                                                        maxValue2
                                                                    ? Colors.red
                                                                    : (double.parse(gelenDegerSuTukHayBas[index]) ==
                                                                            minValue2
                                                                        ? Colors
                                                                            .blue
                                                                        : Colors
                                                                            .black),
                                                              ),
                                                              maxLines: 1,
                                                            minFontSize: 2,
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
                      Dil().sec(dilSecimi, "tv817a"),
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
                                  text: Dil().sec(dilSecimi, "info67"),
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
    var parametre;
    var degerler1;
    var degerler2;

    if (!gelenMesaj.contains("yok1") && !gelenMesaj.contains("yok2")) {
      parametre = gelenMesaj.split('+');
      gelenTarih = [];

      degerler1 = parametre[0].split('#');
      kayitAdet1 = degerler1.length - 1;
      gelenDegerSuTukTop = [];

      degerler2 = parametre[1].split('#');
      kayitAdet2 = degerler1.length - 1;
      gelenDegerSuTukHayBas = [];
    }

    if (gelenMesaj.contains("yok1")) {
      Toast.show(Dil().sec(dilSecimi, "toast103"), context, duration: 3);
    } else if (gelenMesaj.contains("yok2")) {
      Toast.show(Dil().sec(dilSecimi, "toast102"), context, duration: 3);
    } else {
      for (var i = 1; i < degerler1.length; i++) {
        String xx = degerler1[i].split("*")[0];
        String ay = xx.length == 1 ? "0" + xx : xx;
        String yy = degerler1[i].split("*")[1];
        String gun = yy.length == 1 ? "0" + yy : yy;
        gelenTarih.add(gun + "." + ay);

        gelenDegerSuTukTop.add(degerler1[i].split("*")[2]);
        double value1 = double.parse(degerler1[i].split("*")[2]);
        if (value1 > maxValue1) {
          maxValue1 = value1;
        }
        if (value1 < minValue1) {
          minValue1 = value1;
        }
      }

      for (var i = 1; i < degerler2.length; i++) {
        gelenDegerSuTukHayBas.add(degerler2[i].split("*")[2]);
        double value2 = double.parse(degerler2[i].split("*")[2]);
        if (value2 > maxValue2) {
          maxValue2 = value2;
        }
        if (value2 < minValue2) {
          minValue2 = value2;
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
      defaultRenderer: charts.LineRendererConfig(strokeWidthPx: 1.5 * oran),
      animate: false,
      domainAxis: charts.DateTimeAxisSpec(
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: 'dd',
            transitionFormat: 'dd',
          ),
        ),
        tickProviderSpec:
            charts.StaticDateTimeTickProviderSpec(<charts.TickSpec<DateTime>>[
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 1)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 2)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 3)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 4)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 5)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 6)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 7)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 8)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 9)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 10)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 11)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 12)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 13)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 14)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 15)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 16)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 17)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 18)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 19)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 20)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 21)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 22)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 23)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 24)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 25)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 26)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 27)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 28)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 29)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 30)),
          charts.TickSpec<DateTime>(DateTime(tarih.year, tarih.month, 31)),
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
                color: charts.MaterialPalette.gray.shade300)),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        showAxisLine: true,
        viewport: charts.NumericExtents(-1000, 10000),
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            charts.TickSpec<num>(0),
            charts.TickSpec<num>(500),
            charts.TickSpec<num>(1000),
            charts.TickSpec<num>(1500),
            charts.TickSpec<num>(2000),
            charts.TickSpec<num>(2500),
            charts.TickSpec<num>(3000),
            charts.TickSpec<num>(3500),
            charts.TickSpec<num>(4000),
            charts.TickSpec<num>(4500),
            charts.TickSpec<num>(5000),
            charts.TickSpec<num>(5500),
            charts.TickSpec<num>(6000),
            charts.TickSpec<num>(6500),
            charts.TickSpec<num>(7000),
            charts.TickSpec<num>(7500),
            charts.TickSpec<num>(8000),
            charts.TickSpec<num>(8500),
            charts.TickSpec<num>(9000),
            charts.TickSpec<num>(9500),
            charts.TickSpec<num>(10000),
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
                color: charts.MaterialPalette.gray.shade300)),
      ),
      secondaryMeasureAxis: charts.NumericAxisSpec(
        showAxisLine: true,
        viewport: charts.NumericExtents(-0.0125, 0.125),
        tickProviderSpec: charts.StaticNumericTickProviderSpec(
          <charts.TickSpec<num>>[
            charts.TickSpec<num>(0      ),
            charts.TickSpec<num>(0.00625),
            charts.TickSpec<num>(0.0125),
            charts.TickSpec<num>(0.01875),
            charts.TickSpec<num>(0.025),
            charts.TickSpec<num>(0.03125),
            charts.TickSpec<num>(0.0375),
            charts.TickSpec<num>(0.04375),
            charts.TickSpec<num>(0.05),
            charts.TickSpec<num>(0.05625),
            charts.TickSpec<num>(0.0625),
            charts.TickSpec<num>(0.06875),
            charts.TickSpec<num>(0.075),
            charts.TickSpec<num>(0.08125),
            charts.TickSpec<num>(0.0875),
            charts.TickSpec<num>(0.09375),
            charts.TickSpec<num>(0.1),
            charts.TickSpec<num>(0.10625),
            charts.TickSpec<num>(0.1125),
            charts.TickSpec<num>(0.11875),
            charts.TickSpec<num>(0.125),
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
                color: charts.MaterialPalette.gray.shade300)),
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
    List<TimeSeriesSales> losAngelesSalesData = [];
    List<TimeSeriesSales> mobileSalesData = [];

    for (int i = 0; i <= gelenTarih.length - 1; i++) {
      desktopSalesData.add(new TimeSeriesSales(
          DateTime(tarih.year, ayGetir(gelenTarih, i), gunGetir(gelenTarih, i)),
          veriGetir(gelenDegerSuTukTop, i)));
      losAngelesSalesData.add(new TimeSeriesSales(
          DateTime(tarih.year, ayGetir(gelenTarih, i), gunGetir(gelenTarih, i)),
          veriGetir(gelenDegerSuTukHayBas, i)));
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
        id: 'ortsic',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.red[800]),
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: losAngelesSalesData,
      )..setAttribute(charts.measureAxisIdKey, 'secondaryMeasureAxisId'),
    ];
  }

  double veriGetir(List<String> liste, int index) {
    return liste.length > index ? double.parse(liste[index]) : 0;
  }

  int ayGetir(List<String> liste, int index) {
    return liste.length > index ? int.parse(liste[index].split(".")[1]) : 0;
  }

  int gunGetir(List<String> liste, int index) {
    return liste.length > index ? int.parse(liste[index].split(".")[0]) : 0;
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final double sales;

  TimeSeriesSales(this.time, this.sales);
}
