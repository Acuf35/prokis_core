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

class ParametreLog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ParametreLogState();
  }
}

class ParametreLogState extends State<ParametreLog> {
  String dilSecimi = "EN";

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  String baglantiDurum = "";
  String alarmDurum =
      "00000000000000000000000000000000000000000000000000000000000000000000000000000000";

  DateTime tarihIlk = DateTime.now();
  DateTime tarihSon = DateTime.now();

  int kayitAdet = 0;

  List<String> gelenSaat = [];
  List<String> gelenTarih = [];
  List<String> gelenParametre = [];
  List<String> gelenYeniDeger = [];
  List<String> gelenUnsurNo = [];
  List<String> gelenUser = [];

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
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv738',
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
                                        String tabloAdi = "dlog5" +
                                            (ayy.length == 1
                                                ? ("0" + ayy)
                                                : ayy) +
                                            yil;
                                        print(tabloAdi);

                                        yazmaSonrasiGecikmeSayaci = 0;
                                        String komut =
                                            '4*$tabloAdi*$gunIlk*$gunSon';
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
                                Expanded(
                                  child: SizedBox(
                                    child: Container(
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv785"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Saat
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
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Tarih
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
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Parametre
                                Expanded(
                                  flex: 12,
                                  child: SizedBox(
                                    child: Container(
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv766"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Yeni Değer
                                Expanded(
                                  flex: 8,
                                  child: SizedBox(
                                    child: Container(
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv783"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //User
                                Expanded(
                                  flex: 4,
                                  child: SizedBox(
                                    child: Container(
                                      child: AutoSizeText(
                                        Dil().sec(dilSecimi, "tv784"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
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
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return Container(
                                    color: index % 2 == 1
                                        ? Colors.grey[300]
                                        : Colors.grey[400],
                                    child: Row(
                                      children: <Widget>[
                                        //Kayıt No
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            height: 15 * oran,
                                            child: Column(
                                              children: [
                                                Spacer(),
                                                Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      (index + 1).toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.black,
                                                      ),
                                                      minFontSize: 2,
                                                    ),
                                                  ),
                                                ),
                                                Spacer()
                                              ],
                                            ),
                                          ),
                                        ),
                                        //Saat
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            height: 15 * oran,
                                            child: Column(
                                              children: [
                                                Spacer(),
                                                Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      gelenSaat[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.black,
                                                      ),
                                                      minFontSize: 2,
                                                    ),
                                                  ),
                                                ),
                                                Spacer()
                                              ],
                                            ),
                                          ),
                                        ),
                                        //Tarih
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            height: 15 * oran,
                                            child: Column(
                                              children: [
                                                Spacer(),
                                                Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      gelenTarih[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.black,
                                                      ),
                                                      minFontSize: 2,
                                                    ),
                                                  ),
                                                ),
                                                Spacer()
                                              ],
                                            ),
                                          ),
                                        ),
                                        //Parametre
                                        Expanded(
                                          flex: 12,
                                          child: SizedBox(
                                            height: 15 * oran,
                                            child: Column(
                                              children: [
                                                Spacer(),
                                                Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      parametreMetin(
                                                          gelenParametre[index],
                                                          gelenUnsurNo[index]),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                      ),
                                                      minFontSize: 2,
                                                    ),
                                                  ),
                                                ),
                                                Spacer()
                                              ],
                                            ),
                                          ),
                                        ),
                                        //Yeni Değer
                                        Expanded(
                                          flex: 8,
                                          child: SizedBox(
                                            height: 15 * oran,
                                            child: Column(
                                              children: [
                                                Spacer(),
                                                Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      gelenYeniDeger[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                      ),
                                                      minFontSize: 2,
                                                    ),
                                                  ),
                                                ),
                                                Spacer()
                                              ],
                                            ),
                                          ),
                                        ),
                                        //User
                                        Expanded(
                                          flex: 4,
                                          child: SizedBox(
                                            height: 15 * oran,
                                            child: Column(
                                              children: [
                                                Spacer(),
                                                Expanded(
                                                  flex: 5,
                                                  child: Container(
                                                    child: AutoSizeText(
                                                      gelenUser[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 40,
                                                      ),
                                                      minFontSize: 2,
                                                    ),
                                                  ),
                                                ),
                                                Spacer()
                                              ],
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

  takipEtVeriIsleme(String gelenMesaj) {
    print(gelenMesaj);
    var degerler = gelenMesaj.split('#');
    kayitAdet = degerler.length - 1;
    gelenSaat = [];
    gelenTarih = [];
    gelenParametre = [];
    gelenUnsurNo = [];
    gelenYeniDeger = [];
    gelenUser = [];

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
        gelenSaat.add(saat + ":" + dk);

        gelenTarih.add(gun + "-" + ay + "-" + tarihIlk.year.toString());
        gelenParametre.add(degerler[i].split("*")[3]);
        gelenYeniDeger.add(degerler[i].split("*")[4]);
        gelenUnsurNo.add(degerler[i].split("*")[5]);
        gelenUser.add(degerler[i].split("*")[6]);
      }
    }

    baglanti = false;
    if (!timerCancel) {
      setState(() {});
    }
  }

  parametreMetin(String paramKodu, String unsurNo) {
    String sonuc = "";
    if (paramKodu == "ku1") {
      sonuc = Dil().sec(dilSecimi, "tv2");
    } else if (paramKodu == "ku2") {
      sonuc = Dil().sec(dilSecimi, "tv302") + "1";
    } else if (paramKodu == "ku3") {
      sonuc = Dil().sec(dilSecimi, "tv302") + "2";
    } else if (paramKodu == "ku4") {
      sonuc = Dil().sec(dilSecimi, "tv303");
    } else if (paramKodu == "ku5") {
      sonuc = Dil().sec(dilSecimi, "tv304");
    } else if (paramKodu == "ku6") {
      sonuc = Dil().sec(dilSecimi, "tv27");
    } else if (paramKodu == "ku7") {
      sonuc = Dil().sec(dilSecimi, "tv786") + " 1-2-3-4";
    } else if (paramKodu == "ku8") {
      sonuc = Dil().sec(dilSecimi, "tv786") + " 5-6-7-8";
    } else if (paramKodu == "ku9") {
      sonuc = Dil().sec(dilSecimi, "tv786") + " 9-10";
    } else if (paramKodu == "ku10") {
      sonuc = Dil().sec(dilSecimi, "tv787");
    } else if (paramKodu == "ku11") {
      sonuc = Dil().sec(dilSecimi, "tv788");
    } else if (paramKodu == "ku12") {
      sonuc = Dil().sec(dilSecimi, "tv31");
    } else if (paramKodu == "ku13") {
      sonuc =
          Dil().sec(dilSecimi, "tv34") + " & " + Dil().sec(dilSecimi, "tv35");
    } else if (paramKodu == "ku14") {
      sonuc = Dil().sec(dilSecimi, "tv789");
    } else if (paramKodu == "ku15") {
      sonuc = Dil().sec(dilSecimi, "tv38");
    } else if (paramKodu == "ku16") {
      sonuc =
          Dil().sec(dilSecimi, "tv40") + " & " + Dil().sec(dilSecimi, "tv35");
    } else if (paramKodu == "ku17") {
      sonuc = Dil().sec(dilSecimi, "tv790");
    } else if (paramKodu == "ku18") {
      sonuc = Dil().sec(dilSecimi, "tv47");
    } else if (paramKodu == "ku19") {
      sonuc =
          Dil().sec(dilSecimi, "tv46") + " & " + Dil().sec(dilSecimi, "tv35");
    } else if (paramKodu == "ku20") {
      sonuc = Dil().sec(dilSecimi, "tv791");
    } else if (paramKodu == "ku21") {
      sonuc = Dil().sec(dilSecimi, "tv48");
    } else if (paramKodu == "ku22") {
      sonuc = Dil().sec(dilSecimi, "tv49");
    } else if (paramKodu == "ku23") {
      sonuc = Dil().sec(dilSecimi, "tv792");
    } else if (paramKodu == "ku26") {
      sonuc = Dil().sec(dilSecimi, "tv68");
    } else if (paramKodu == "ku27") {
      sonuc =
          Dil().sec(dilSecimi, "tv64") + " & " + Dil().sec(dilSecimi, "tv35");
    } else if (paramKodu == "ku28") {
      sonuc = Dil().sec(dilSecimi, "tv793");
    } else if (paramKodu == "ku30") {
      sonuc = Dil().sec(dilSecimi, "tv71");
    } else if (paramKodu == "ku32") {
      sonuc = Dil().sec(dilSecimi, "tv76");
    } else if (paramKodu == "ku33") {
      sonuc =
          Dil().sec(dilSecimi, "tv80") + " & " + Dil().sec(dilSecimi, "tv35");
    } else if (paramKodu == "ku34") {
      sonuc = Dil().sec(dilSecimi, "tv794");
    } else if (paramKodu == "ku35") {
      sonuc = Dil().sec(dilSecimi, "tv84");
    } else if (paramKodu == "ku36") {
      sonuc = Dil().sec(dilSecimi, "tv83");
    } else if (paramKodu == "ku37") {
      sonuc = Dil().sec(dilSecimi, "tv795");
    } else if (paramKodu == "ku38") {
      sonuc = Dil().sec(dilSecimi, "tv85");
    } else if (paramKodu == "ku39") {
      sonuc = Dil().sec(dilSecimi, "tv349");
    } else if (paramKodu == "ko1-0") {
      sonuc = Dil().sec(dilSecimi, "tv126");
    } else if (paramKodu == "ko1-1") {
      sonuc = Dil().sec(dilSecimi, "tv125");
    } else if (paramKodu == "ko1-2") {
      sonuc = Dil().sec(dilSecimi, "tv128");
    } else if (paramKodu == "ko1-3") {
      sonuc = Dil().sec(dilSecimi, "tv130");
    } else if (paramKodu == "ko1-4") {
      sonuc =
          Dil().sec(dilSecimi, "tv173") + " " + Dil().sec(dilSecimi, "tv115");
    } else if (paramKodu == "ko1-5") {
      sonuc =
          Dil().sec(dilSecimi, "tv174") + " " + Dil().sec(dilSecimi, "tv115");
    } else if (paramKodu == "ko1-6") {
      sonuc =
          Dil().sec(dilSecimi, "tv175") + " " + Dil().sec(dilSecimi, "tv115");
    } else if (paramKodu == "ko1-7") {
      sonuc =
          Dil().sec(dilSecimi, "tv176") + " " + Dil().sec(dilSecimi, "tv115");
    } else if (paramKodu == "ko1-8") {
      sonuc =
          Dil().sec(dilSecimi, "tv177") + " " + Dil().sec(dilSecimi, "tv115");
    } else if (paramKodu == "ko1-9") {
      sonuc =
          Dil().sec(dilSecimi, "tv178") + " " + Dil().sec(dilSecimi, "tv115");
    } else if (paramKodu == "ko1-10") {
      sonuc =
          Dil().sec(dilSecimi, "tv179") + " " + Dil().sec(dilSecimi, "tv115");
    } else if (paramKodu == "ko1-11") {
      sonuc = Dil().sec(dilSecimi, "tv480a");
    } else if (paramKodu == "ko1-12") {
      sonuc = Dil().sec(dilSecimi, "tv182");
    } else if (paramKodu == "ko1-13") {
      sonuc = Dil().sec(dilSecimi, "tv324") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv125");
    } else if (paramKodu == "ko1-14") {
      sonuc = Dil().sec(dilSecimi, "tv191");
    } else if (paramKodu == "ko2-1") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv200");
    } else if (paramKodu == "ko2-2") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv201");
    } else if (paramKodu == "ko2-3") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv202");
    } else if (paramKodu == "ko2-4") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv203");
    } else if (paramKodu == "ko2-5") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv204");
    } else if (paramKodu == "ko2-6") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv205");
    } else if (paramKodu == "ko2-7") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv206");
    } else if (paramKodu == "ko2-8") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv207");
    } else if (paramKodu == "ko2-9") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv199");
    } else if (paramKodu == "ko2-10") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv217a");
    } else if (paramKodu == "ko2-11") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv215");
    } else if (paramKodu == "ko2-12") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv218");
    } else if (paramKodu == "ko2-13") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv219");
    } else if (paramKodu == "ko2-14") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv199");
    } else if (paramKodu == "ko2-15") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv214");
    } else if (paramKodu == "ko2-16") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv232a");
    } else if (paramKodu == "ko2-17") {
      sonuc = Dil().sec(dilSecimi, "tv108") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv796a");
    } else if (paramKodu == "ko3-$unsurNo") {
      sonuc =
          Dil().sec(dilSecimi, "tv459") + " $unsurNo " + int.parse(unsurNo) < 11
              ? Dil().sec(dilSecimi, "tv242")
              : Dil().sec(dilSecimi, "tv243");
    } else if (paramKodu == "ko3-21") {
      sonuc = Dil().sec(dilSecimi, "tv250");
    } else if (paramKodu == "ko3-22") {
      sonuc = Dil().sec(dilSecimi, "tv251");
    } else if (paramKodu == "ko3-23") {
      sonuc = Dil().sec(dilSecimi, "tv270");
    } else if (paramKodu == "ko3-24") {
      sonuc = Dil().sec(dilSecimi, "tv271");
    } else if (paramKodu == "ko3-25") {
      sonuc = Dil().sec(dilSecimi, "tv482");
    } else if (paramKodu == "ko3-26") {
      sonuc = Dil().sec(dilSecimi, "tv485a");
    } else if (paramKodu == "ko3-27") {
      sonuc = Dil().sec(dilSecimi, "tv486");
    } else if (paramKodu == "ko3-28") {
      sonuc = Dil().sec(dilSecimi, "tv487");
    } else if (paramKodu == "ko3-29") {
      sonuc = Dil().sec(dilSecimi, "tv488");
    } else if (paramKodu == "ko4-1") {
      sonuc =
          Dil().sec(dilSecimi, "tv592") + " 1 " + Dil().sec(dilSecimi, "tv254");
    } else if (paramKodu == "ko4-2") {
      sonuc =
          Dil().sec(dilSecimi, "tv592") + " 2 " + Dil().sec(dilSecimi, "tv254");
    } else if (paramKodu == "ko4-3") {
      sonuc =
          Dil().sec(dilSecimi, "tv592") + " 3 " + Dil().sec(dilSecimi, "tv254");
    } else if (paramKodu == "ko4-4") {
      sonuc =
          Dil().sec(dilSecimi, "tv592") + " 1 " + Dil().sec(dilSecimi, "tv255");
    } else if (paramKodu == "ko4-5") {
      sonuc =
          Dil().sec(dilSecimi, "tv592") + " 2 " + Dil().sec(dilSecimi, "tv255");
    } else if (paramKodu == "ko4-6") {
      sonuc =
          Dil().sec(dilSecimi, "tv592") + " 3 " + Dil().sec(dilSecimi, "tv255");
    } else if (paramKodu == "ko5-0") {
      sonuc = Dil().sec(dilSecimi, "tv294");
    } else if (paramKodu == "ko5-1") {
      sonuc = Dil().sec(dilSecimi, "tv272a");
    } else if (paramKodu == "ko5-2") {
      sonuc = Dil().sec(dilSecimi, "tv273a");
    } else if (paramKodu == "ko5-3") {
      sonuc = Dil().sec(dilSecimi, "tv274a");
    } else if (paramKodu == "ko5-4") {
      sonuc = Dil().sec(dilSecimi, "tv275");
    } else if (paramKodu == "ko5-5") {
      sonuc = Dil().sec(dilSecimi, "tv479a");
    } else if (paramKodu == "ko5-6") {
      sonuc = Dil().sec(dilSecimi, "tv478a");
    } else if (paramKodu == "ko6-0") {
      sonuc = Dil().sec(dilSecimi, "tv294");
    } else if (paramKodu == "ko6-1") {
      sonuc = Dil().sec(dilSecimi, "tv272a");
    } else if (paramKodu == "ko6-2") {
      sonuc = Dil().sec(dilSecimi, "tv273a");
    } else if (paramKodu == "ko6-3") {
      sonuc = Dil().sec(dilSecimi, "tv274a");
    } else if (paramKodu == "ko6-4") {
      sonuc = Dil().sec(dilSecimi, "tv275");
    } else if (paramKodu == "ko7-1") {
      sonuc = Dil().sec(dilSecimi, "tv309");
    } else if (paramKodu == "ko7-2") {
      sonuc = Dil().sec(dilSecimi, "tv310");
    } else if (paramKodu == "ko7-3") {
      sonuc = Dil().sec(dilSecimi, "tv311");
    } else if (paramKodu == "ko7-4") {
      sonuc = Dil().sec(dilSecimi, "tv312");
    } else if (paramKodu == "ko7-5") {
      sonuc = Dil().sec(dilSecimi, "tv313");
    } else if (paramKodu == "ko7-6") {
      sonuc = Dil().sec(dilSecimi, "tv314");
    } else if (paramKodu == "ko7-7") {
      sonuc = Dil().sec(dilSecimi, "tv315");
    } else if (paramKodu == "ko7-8") {
      sonuc = Dil().sec(dilSecimi, "tv316");
    } else if (paramKodu == "ko7-9") {
      sonuc = Dil().sec(dilSecimi, "tv317");
    } else if (paramKodu == "ko7-10") {
      sonuc = Dil().sec(dilSecimi, "tv318");
    } else if (paramKodu == "ko7-11") {
      sonuc = Dil().sec(dilSecimi, "tv319");
    } else if (paramKodu == "ko7-12") {
      sonuc = Dil().sec(dilSecimi, "tv325") +
          " " +
          Dil().sec(dilSecimi, "tv324") +
          "1";
    } else if (paramKodu == "ko7-13") {
      sonuc = Dil().sec(dilSecimi, "tv325") +
          " " +
          Dil().sec(dilSecimi, "tv324") +
          "2";
    } else if (paramKodu == "ko7-14") {
      sonuc = Dil().sec(dilSecimi, "tv325") +
          " " +
          Dil().sec(dilSecimi, "tv324") +
          "3";
    } else if (paramKodu == "ko7-15") {
      sonuc = Dil().sec(dilSecimi, "tv325") +
          " " +
          Dil().sec(dilSecimi, "tv324") +
          "4";
    } else if (paramKodu == "ko8-1") {
      sonuc = Dil().sec(dilSecimi, "tv343");
    } else if (paramKodu == "ko8-2") {
      sonuc = Dil().sec(dilSecimi, "tv345");
    } else if (paramKodu == "ko8-13") {
      sonuc = Dil().sec(dilSecimi, "tv344");
    } else if (paramKodu == "ko8-14") {
      sonuc = Dil().sec(dilSecimi, "tv346");
    } else if (paramKodu == "ko8-3") {
      sonuc = Dil().sec(dilSecimi, "tv337a");
    } else if (paramKodu == "ko8-4") {
      sonuc =
          Dil().sec(dilSecimi, "tv329") + " " + Dil().sec(dilSecimi, "tv338");
    } else if (paramKodu == "ko8-5") {
      sonuc =
          Dil().sec(dilSecimi, "tv329") + " " + Dil().sec(dilSecimi, "tv339");
    } else if (paramKodu == "ko8-6") {
      sonuc =
          Dil().sec(dilSecimi, "tv330") + " " + Dil().sec(dilSecimi, "tv338");
    } else if (paramKodu == "ko8-7") {
      sonuc =
          Dil().sec(dilSecimi, "tv330") + " " + Dil().sec(dilSecimi, "tv339");
    } else if (paramKodu == "ko8-8") {
      sonuc =
          Dil().sec(dilSecimi, "tv331") + " " + Dil().sec(dilSecimi, "tv338");
    } else if (paramKodu == "ko8-9") {
      sonuc =
          Dil().sec(dilSecimi, "tv331") + " " + Dil().sec(dilSecimi, "tv339");
    } else if (paramKodu == "ko8-10") {
      sonuc =
          Dil().sec(dilSecimi, "tv332") + " " + Dil().sec(dilSecimi, "tv338");
    } else if (paramKodu == "ko8-11") {
      sonuc =
          Dil().sec(dilSecimi, "tv332") + " " + Dil().sec(dilSecimi, "tv339");
    } else if (paramKodu == "ko8-12") {
      sonuc = Dil().sec(dilSecimi, "tv333a");
    } else if (paramKodu == "ko8-15") {
      sonuc = Dil().sec(dilSecimi, "tv470");
    } else if (paramKodu == "ko9-1") {
      sonuc = Dil().sec(dilSecimi, "tv417a");
    } else if (paramKodu == "ko9-2") {
      sonuc =
          Dil().sec(dilSecimi, "tv420") + " " + Dil().sec(dilSecimi, "tv418");
    } else if (paramKodu == "ko9-3") {
      sonuc =
          Dil().sec(dilSecimi, "tv421") + " " + Dil().sec(dilSecimi, "tv418");
    } else if (paramKodu == "ko9-4") {
      sonuc =
          Dil().sec(dilSecimi, "tv422") + " " + Dil().sec(dilSecimi, "tv418");
    } else if (paramKodu == "ko9-5") {
      sonuc =
          Dil().sec(dilSecimi, "tv423") + " " + Dil().sec(dilSecimi, "tv418");
    } else if (paramKodu == "ko9-6") {
      sonuc =
          Dil().sec(dilSecimi, "tv424") + " " + Dil().sec(dilSecimi, "tv418");
    } else if (paramKodu == "ko9-7") {
      sonuc =
          Dil().sec(dilSecimi, "tv425") + " " + Dil().sec(dilSecimi, "tv418");
    } else if (paramKodu == "ko9-8") {
      sonuc = Dil().sec(dilSecimi, "tv415a");
    } else if (paramKodu == "ko9-9") {
      sonuc = Dil().sec(dilSecimi, "tv416a");
    } else if (paramKodu == "ko9-10") {
      sonuc = Dil().sec(dilSecimi, "tv279");
    } else if (paramKodu == "ko10") {
      sonuc = Dil().sec(dilSecimi, "tv402");
    } else if (paramKodu == "ko11-1") {
      sonuc = Dil().sec(dilSecimi, "tv433") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          "(" +
          unsurNo +
          ")";
    } else if (paramKodu == "ko12-1") {
      sonuc = Dil().sec(dilSecimi, "tv443") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-2") {
      sonuc = Dil().sec(dilSecimi, "tv444") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-3") {
      sonuc = Dil().sec(dilSecimi, "tv445") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-4") {
      sonuc = Dil().sec(dilSecimi, "tv446") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-5") {
      sonuc = Dil().sec(dilSecimi, "tv447") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-6") {
      sonuc = Dil().sec(dilSecimi, "tv448") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-7") {
      sonuc = Dil().sec(dilSecimi, "tv449") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-8") {
      sonuc = Dil().sec(dilSecimi, "tv450") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-9") {
      sonuc = Dil().sec(dilSecimi, "tv451") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-10") {
      sonuc = Dil().sec(dilSecimi, "tv452") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-101") {
      sonuc = Dil().sec(dilSecimi, "tv443") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-102") {
      sonuc = Dil().sec(dilSecimi, "tv444") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-103") {
      sonuc = Dil().sec(dilSecimi, "tv445") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-104") {
      sonuc = Dil().sec(dilSecimi, "tv446") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-105") {
      sonuc = Dil().sec(dilSecimi, "tv447") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-106") {
      sonuc = Dil().sec(dilSecimi, "tv448") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-107") {
      sonuc = Dil().sec(dilSecimi, "tv449") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-108") {
      sonuc = Dil().sec(dilSecimi, "tv450") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-109") {
      sonuc = Dil().sec(dilSecimi, "tv451") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-110") {
      sonuc = Dil().sec(dilSecimi, "tv452") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-201") {
      sonuc = Dil().sec(dilSecimi, "tv441") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-202") {
      sonuc = Dil().sec(dilSecimi, "tv442") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv438");
    } else if (paramKodu == "ko12-301") {
      sonuc = Dil().sec(dilSecimi, "tv441") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko12-302") {
      sonuc = Dil().sec(dilSecimi, "tv442") +
          " " +
          Dil().sec(dilSecimi, "tv431") +
          " " +
          Dil().sec(dilSecimi, "tv439");
    } else if (paramKodu == "ko13-1") {
      sonuc =
          Dil().sec(dilSecimi, "tv458") + " " + Dil().sec(dilSecimi, "tv454");
    } else if (paramKodu == "ko13-3") {
      sonuc =
          Dil().sec(dilSecimi, "tv459") + " " + Dil().sec(dilSecimi, "tv454");
    } else if (paramKodu == "ko13-4") {
      sonuc =
          Dil().sec(dilSecimi, "tv112") + " " + Dil().sec(dilSecimi, "tv454");
    } else if (paramKodu == "ko13-6") {
      sonuc =
          Dil().sec(dilSecimi, "tv461") + " " + Dil().sec(dilSecimi, "tv454");
    } else if (paramKodu == "ko13-7") {
      sonuc =
          Dil().sec(dilSecimi, "tv462") + " " + Dil().sec(dilSecimi, "tv454");
    } else if (paramKodu == "ko13-8") {
      sonuc =
          Dil().sec(dilSecimi, "tv463") + " " + Dil().sec(dilSecimi, "tv454");
    } else if (paramKodu == "ko13-9") {
      sonuc =
          Dil().sec(dilSecimi, "tv581") + " " + Dil().sec(dilSecimi, "tv454");
    } else if (paramKodu == "ko14-$unsurNo") {
      sonuc = Dil().sec(dilSecimi, "tv324") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv221");
    } else if (paramKodu == "ko15-$unsurNo") {
      sonuc = Dil().sec(dilSecimi, "tv459") +
          " $unsurNo " +
          Dil().sec(dilSecimi, "tv221");
    } else if (paramKodu == "ko16-1") {
      sonuc = Dil().sec(dilSecimi, "tv466");
    } else if (paramKodu == "ko17-1") {
      sonuc = Dil().sec(dilSecimi, "tv467");
    } else if (paramKodu == "ko18-1") {
      sonuc =
          Dil().sec(dilSecimi, "tv468") + " " + Dil().sec(dilSecimi, "tv593");
    } else if (paramKodu == "ko18-2") {
      sonuc =
          Dil().sec(dilSecimi, "tv468") + " " + Dil().sec(dilSecimi, "tv594");
    } else if (paramKodu == "ko18-3") {
      sonuc =
          Dil().sec(dilSecimi, "tv468") + " " + Dil().sec(dilSecimi, "tv595");
    } else if (paramKodu == "ko19-1") {
      sonuc =
          Dil().sec(dilSecimi, "tv471") + " " + Dil().sec(dilSecimi, "tv89");
    } else if (paramKodu == "ko19-2") {
      sonuc =
          Dil().sec(dilSecimi, "tv471") + " " + Dil().sec(dilSecimi, "tv92");
    } else if (paramKodu == "ko19-3") {
      sonuc =
          Dil().sec(dilSecimi, "tv471") + " " + Dil().sec(dilSecimi, "tv90");
    } else if (paramKodu == "ko19-4") {
      sonuc =
          Dil().sec(dilSecimi, "tv471") + " " + Dil().sec(dilSecimi, "tv93");
    } else if (paramKodu == "ko19-5") {
      sonuc =
          Dil().sec(dilSecimi, "tv471") + " " + Dil().sec(dilSecimi, "tv91");
    } else if (paramKodu == "ko19-6") {
      sonuc =
          Dil().sec(dilSecimi, "tv471") + " " + Dil().sec(dilSecimi, "tv94");
    } else if (paramKodu == "ko20-1") {
      sonuc =
          Dil().sec(dilSecimi, "tv471") + " " + Dil().sec(dilSecimi, "tv581");
    } else if (paramKodu == "ko21-$unsurNo") {
      sonuc = Dil().sec(dilSecimi, "tv475") + " $unsurNo";
    } else if (paramKodu == "ko22-1") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 1 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko22-2") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 2 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko22-3") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 3 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko22-4") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 4 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko22-5") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 5 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko22-6") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 6 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko22-7") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 7 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko22-8") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 8 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko22-9") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 9 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko22-10") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 10 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko22-11") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 1 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko22-12") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 2 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko22-13") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 3 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko22-14") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 4 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko22-15") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 5 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko22-16") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 6 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko22-17") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 7 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko22-18") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 8 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko22-19") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 9 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko22-20") {
      sonuc = Dil().sec(dilSecimi, "tv192") +
          " 10 " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko23-1") {
      sonuc = Dil().sec(dilSecimi, "tv472");
    } else if (paramKodu == "ko24") {
      sonuc = Dil().sec(dilSecimi, "tv476");
    } else if (paramKodu == "ko25-1") {
      sonuc = Dil().sec(dilSecimi, "tv460") +
          " " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv473");
    } else if (paramKodu == "ko25-0") {
      sonuc = Dil().sec(dilSecimi, "tv460") +
          " " +
          Dil().sec(dilSecimi, "tv221") +
          " " +
          Dil().sec(dilSecimi, "tv474");
    } else if (paramKodu == "ko26-1") {
      sonuc = Dil().sec(dilSecimi, "tv489a");
    } else if (paramKodu == "ko26-2") {
      sonuc = Dil().sec(dilSecimi, "tv490a");
    } else if (paramKodu == "ko26-3") {
      sonuc = Dil().sec(dilSecimi, "tv491a");
    } else if (paramKodu == "ko26-4") {
      sonuc = Dil().sec(dilSecimi, "tv562a");
    } else if (paramKodu == "ko26-5") {
      sonuc = Dil().sec(dilSecimi, "tv566a");
    } else if (paramKodu == "ko26-6") {
      sonuc = Dil().sec(dilSecimi, "tv567a");
    } else if (paramKodu == "ko26-7") {
      sonuc = Dil().sec(dilSecimi, "tv568a");
    } else if (paramKodu == "ko26-11") {
      sonuc = Dil().sec(dilSecimi, "tv670b");
    } else if (paramKodu == "ko26-12") {
      sonuc = Dil().sec(dilSecimi, "tv670a");
    } else if (paramKodu == "ko26-13") {
      sonuc = Dil().sec(dilSecimi, "tv670b");
    } else if (paramKodu == "ko26-14") {
      sonuc = Dil().sec(dilSecimi, "tv672b");
    } else if (paramKodu == "ko26-15") {
      sonuc = Dil().sec(dilSecimi, "tv672a");
    } else if (paramKodu == "ko26-16") {
      sonuc = Dil().sec(dilSecimi, "tv672b");
    } else if (paramKodu == "ko27-1" && int.parse(unsurNo) <= 10) {
      sonuc = Dil().sec(dilSecimi, "tv500") +
          " " +
          Dil().sec(dilSecimi, "tv192") +
          unsurNo +
          " " +
          Dil().sec(dilSecimi, "tv236") +
          "-" +
          Dil().sec(dilSecimi, "tv237");
    } else if (paramKodu == "ko27-1" && int.parse(unsurNo) <= 20) {
      sonuc = Dil().sec(dilSecimi, "tv500") +
          " " +
          Dil().sec(dilSecimi, "tv192") +
          (int.parse(unsurNo) - 10).toString() +
          " " +
          Dil().sec(dilSecimi, "tv501");
    } else if (paramKodu == "ko27-1" && int.parse(unsurNo) <= 30) {
      sonuc = Dil().sec(dilSecimi, "tv500") +
          " " +
          Dil().sec(dilSecimi, "tv192") +
          (int.parse(unsurNo) - 20).toString() +
          " " +
          Dil().sec(dilSecimi, "tv502");
    } else if (paramKodu == "ko27-1" && int.parse(unsurNo) <= 40) {
      sonuc = Dil().sec(dilSecimi, "tv500") +
          " " +
          Dil().sec(dilSecimi, "tv192") +
          (int.parse(unsurNo) - 30).toString() +
          " " +
          Dil().sec(dilSecimi, "tv503");
    } else if (paramKodu == "ko28-1") {
      sonuc =
          Dil().sec(dilSecimi, "tv559") + " " + Dil().sec(dilSecimi, "tv89");
    } else if (paramKodu == "ko28-2") {
      sonuc =
          Dil().sec(dilSecimi, "tv559") + " " + Dil().sec(dilSecimi, "tv92");
    } else if (paramKodu == "ko28-3") {
      sonuc =
          Dil().sec(dilSecimi, "tv559") + " " + Dil().sec(dilSecimi, "tv90");
    } else if (paramKodu == "ko28-4") {
      sonuc =
          Dil().sec(dilSecimi, "tv559") + " " + Dil().sec(dilSecimi, "tv93");
    } else if (paramKodu == "ko28-5") {
      sonuc =
          Dil().sec(dilSecimi, "tv559") + " " + Dil().sec(dilSecimi, "tv91");
    } else if (paramKodu == "ko28-6") {
      sonuc =
          Dil().sec(dilSecimi, "tv559") + " " + Dil().sec(dilSecimi, "tv94");
    } else if (paramKodu == "ko29-1") {
      sonuc = Dil().sec(dilSecimi, "tv95");
    } else if (paramKodu == "ko29-2") {
      sonuc = Dil().sec(dilSecimi, "tv96");
    } else if (paramKodu == "ko29-3") {
      sonuc = Dil().sec(dilSecimi, "tv97");
    } else if (paramKodu == "ko29-4") {
      sonuc = Dil().sec(dilSecimi, "tv561");
    } else if (paramKodu == "ko30") {
      sonuc = Dil().sec(dilSecimi, "tv684");
    } else if (paramKodu == "ko31-1") {
      sonuc =
          Dil().sec(dilSecimi, "tv173") + " " + Dil().sec(dilSecimi, "tv706");
    } else if (paramKodu == "ko31-2") {
      sonuc =
          Dil().sec(dilSecimi, "tv173") + " " + Dil().sec(dilSecimi, "tv705");
    } else if (paramKodu == "ko31-3") {
      sonuc =
          Dil().sec(dilSecimi, "tv174") + " " + Dil().sec(dilSecimi, "tv706");
    } else if (paramKodu == "ko31-4") {
      sonuc =
          Dil().sec(dilSecimi, "tv174") + " " + Dil().sec(dilSecimi, "tv705");
    } else if (paramKodu == "ko31-5") {
      sonuc =
          Dil().sec(dilSecimi, "tv175") + " " + Dil().sec(dilSecimi, "tv706");
    } else if (paramKodu == "ko31-6") {
      sonuc =
          Dil().sec(dilSecimi, "tv175") + " " + Dil().sec(dilSecimi, "tv705");
    } else if (paramKodu == "ko31-7") {
      sonuc =
          Dil().sec(dilSecimi, "tv176") + " " + Dil().sec(dilSecimi, "tv706");
    } else if (paramKodu == "ko31-8") {
      sonuc =
          Dil().sec(dilSecimi, "tv176") + " " + Dil().sec(dilSecimi, "tv705");
    } else if (paramKodu == "ko31-9") {
      sonuc =
          Dil().sec(dilSecimi, "tv177") + " " + Dil().sec(dilSecimi, "tv706");
    } else if (paramKodu == "ko31-10") {
      sonuc =
          Dil().sec(dilSecimi, "tv177") + " " + Dil().sec(dilSecimi, "tv705");
    } else if (paramKodu == "ko31-11") {
      sonuc =
          Dil().sec(dilSecimi, "tv178") + " " + Dil().sec(dilSecimi, "tv706");
    } else if (paramKodu == "ko31-12") {
      sonuc =
          Dil().sec(dilSecimi, "tv178") + " " + Dil().sec(dilSecimi, "tv705");
    } else if (paramKodu == "ko31-13") {
      sonuc =
          Dil().sec(dilSecimi, "tv179") + " " + Dil().sec(dilSecimi, "tv706");
    } else if (paramKodu == "ko31-14") {
      sonuc =
          Dil().sec(dilSecimi, "tv179") + " " + Dil().sec(dilSecimi, "tv705");
    } else if (paramKodu == "ko31-15") {
      sonuc =
          Dil().sec(dilSecimi, "tv767") + " " + Dil().sec(dilSecimi, "tv482");
    } else if (paramKodu == "ko31-16") {
      sonuc =
          Dil().sec(dilSecimi, "tv767") + " " + Dil().sec(dilSecimi, "tv250");
    } else if (paramKodu == "ko31-17") {
      sonuc = Dil().sec(dilSecimi, "tv710a");
    } else if (paramKodu == "ko31-18") {
      sonuc = Dil().sec(dilSecimi, "tv711a");
    } else if (paramKodu == "ko31-19") {
      sonuc = Dil().sec(dilSecimi, "tv712a");
    } else if (paramKodu == "ko31-20") {
      sonuc = Dil().sec(dilSecimi, "tv713a");
    } else if (paramKodu == "ko31-21") {
      sonuc = Dil().sec(dilSecimi, "tv715");
    } else if (paramKodu == "ko31-22") {
      sonuc = Dil().sec(dilSecimi, "tv714");
    } else if (paramKodu == "ko32") {
      sonuc = Dil().sec(dilSecimi, "tv714");
    } else if (paramKodu == "ko33-$unsurNo") {
      sonuc = Dil().sec(dilSecimi, "tv716") +
          " " +
          Dil().sec(dilSecimi, "korna$unsurNo");
    }

    return sonuc;
  }
}
