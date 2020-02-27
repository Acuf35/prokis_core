import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel/metotlar.dart';
import 'package:prokis/kontrol.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_1x2.dart';
import 'genel/deger_giris_2x1.dart';
import 'genel/deger_giris_3x0.dart';
import 'languages/select.dart';

class MinHavAgirlik extends StatefulWidget {
  List<Map> gelenDBveri;
  MinHavAgirlik(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return MinHavAgirlikState(gelenDBveri);
  }
}

class MinHavAgirlikState extends State<MinHavAgirlik> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String kumesTuru = "1";
  String airInletAdet = "1";
  String info = "info12";
  List<Map> dbVeriler;

  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _ondalikOnlar = 0;
  int _ondalikBirler = 0;
  int _index = 0;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  String calismaSuresiUstSinir = "150";
  String airInletOncelikSuresi = "20";
  String havaGirisKatsayisi = "80";
  bool fasilaOffdaAirInletKapansinMi = false;
  String fasilaDonguSuresi='5';

  String gunluk_1_7 = "0.16";
  String gunluk_8_14 = "0.42";
  String gunluk_15_21 = "0.59";
  String gunluk_22_28 = "0.84";
  String gunluk_29_35 = "0.93";
  String gunluk_36_42 = "1.18";
  String gunluk_43_49 = "1.35";
  String gunluk_50veSonrasi = "1.52";

  String haftalik_7_20 = "0.16";
  String haftalik_21_52 = "0.42";
  String haftalik_53veSonrasi = "0.59";

  String calismaSure = "120";
  String durmaSure = "240";
  String minHavFanSayisi = "2";
  String hayvanBasinaIhtiyac = "700";

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  MinHavAgirlikState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 3) {
        kumesTuru = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 3) {
        airInletAdet = dbVeri[i]["veri2"];
        airInletAdet = "0";
      }
    }

    if(kumesTuru!="1"){
      info=airInletAdet!="0" ? "info12" : "info13";
    }else{
      info=airInletAdet!="0" ? "info14" : "info15";
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    if (timerSayac == 0) {
      _takipEt();

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          _takipEt();
        }
      });
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv276'),
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
                                  color: Colors.grey[700],
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
                                  color: Colors.grey[700],
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
                            height: 10 * oran,
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv272"),
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
                                              int sayi = int.parse(
                                                  calismaSuresiUstSinir);
                                              _index = 1;
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
                                                  "tv272",
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
                                                  calismaSuresiUstSinir,
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
                                Visibility(visible: airInletAdet!="0" ? true : false,
                                                                  child: Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: SizedBox(
                                              child: Container(
                                                alignment: Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, "tv273"),
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
                                                int sayi = int.parse(
                                                    airInletOncelikSuresi);
                                                _index = 2;
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
                                                    "tv273",
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
                                                    airInletOncelikSuresi,
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
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv274"),
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
                                                  int.parse(havaGirisKatsayisi);
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
                                                  "tv274",
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
                                                  havaGirisKatsayisi,
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
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Visibility(visible: airInletAdet!="0" ? true : false,
                                                                      child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv275"),
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
                                          flex: 4,
                                          child: IconButton(
                                            padding: EdgeInsets.all(0),
                                            onPressed: () {
                                              if(fasilaDonguSuresi=='10'){
                                              _index = 4;
                                              if (!fasilaOffdaAirInletKapansinMi) {
                                                fasilaOffdaAirInletKapansinMi = true;
                                              } else {
                                                fasilaOffdaAirInletKapansinMi = false;
                                              }
                                              String veri=fasilaOffdaAirInletKapansinMi==true ? '1' : '0';
                                              yazmaSonrasiGecikmeSayaci=0;
                                              _veriGonder(
                                                  "12*$_index*$veri");
                                              setState(() {});
                                              }else{
                                                Toast.show(Dil().sec(dilSecimi,"toast72"), context,duration: 3);

                                              }

                                            },
                                            icon: Icon(
                                                fasilaOffdaAirInletKapansinMi == true
                                                    ? Icons.check_box
                                                    : Icons.check_box_outline_blank),
                                            color: fasilaOffdaAirInletKapansinMi == true
                                                ? Colors.green.shade500
                                                : Colors.blue.shade600,
                                            iconSize: 30 * oran,
                                          ),
                                        ),
                                        Spacer(
                                          flex: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: AutoSizeText(
                                              Dil().sec(dilSecimi, "tv294"),
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
                                        flex: 4,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(flex: 2,
                                                                                          child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Text('5',textScaleFactor: oran,),
                                                  IconButton(
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      fasilaOffdaAirInletKapansinMi=false;
                                                      _index = 0;
                                                      if (fasilaDonguSuresi!='5') {
                                                        fasilaDonguSuresi = '5';
                                                      }
                                                      String veri=(int.parse(fasilaDonguSuresi)*60000).toString();
                                                      yazmaSonrasiGecikmeSayaci=0;
                                                      _veriGonder(
                                                          "12*$_index*$veri");
                                                      setState(() {});
                                                    },
                                                    icon: Icon(
                                                        fasilaDonguSuresi == '5'
                                                            ? Icons.check_box
                                                            : Icons.check_box_outline_blank),
                                                    color: fasilaDonguSuresi == '5'
                                                        ? Colors.green.shade500
                                                        : Colors.blue.shade600,
                                                    iconSize: 30 * oran,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Expanded(flex: 2,
                                                                                          child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text("10",textScaleFactor: oran,),
                                                  IconButton(
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      _index = 0;
                                                      if (fasilaDonguSuresi!="10") {
                                                        fasilaDonguSuresi = "10";
                                                      }
                                                      String veri=(int.parse(fasilaDonguSuresi)*60000).toString();
                                                      yazmaSonrasiGecikmeSayaci=0;
                                                      _veriGonder(
                                                          "12*$_index*$veri");
                                                      setState(() {});
                                                    },
                                                    icon: Icon(
                                                        fasilaDonguSuresi == '10'
                                                            ? Icons.check_box
                                                            : Icons.check_box_outline_blank),
                                                    color: fasilaDonguSuresi == '10'
                                                        ? Colors.green.shade500
                                                        : Colors.blue.shade600,
                                                    iconSize: 30 * oran,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          
                                          ],
                                        ),
                                      ),
                                      Spacer(
                                        flex: 2,
                                      )
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
                                Expanded(
                                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv270"),
                                      style: TextStyle(fontFamily: 'Kelly Slab',color: Colors.grey[600]),textScaleFactor: oran,
                                      ),
                                      Text(calismaSure,style: TextStyle(fontFamily: 'Kelly Slab',fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue[200]),textScaleFactor: oran,)
                                    ],
                                  ),
                                ),
                                Expanded(
                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv271"),
                                      style: TextStyle(fontFamily: 'Kelly Slab',color: Colors.grey[600]),textScaleFactor: oran,
                                      ),
                                      Text(durmaSure,style: TextStyle(fontFamily: 'Kelly Slab',fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue[200]),textScaleFactor: oran,)
                                    ],
                                  ),
                                ),
                                Expanded(
                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv278"),textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'Kelly Slab',color: Colors.grey[600]),textScaleFactor: oran,
                                      ),
                                      Text(hayvanBasinaIhtiyac,style: TextStyle(fontFamily: 'Kelly Slab',fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue[200]),textScaleFactor: oran,)
                                    ],
                                  ),
                                ),
                              
                                Visibility(visible: airInletAdet!="0" ? false : true,
                                                                  child: Expanded(
                                                                    child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(Dil().sec(dilSecimi, "tv277"),
                                        style: TextStyle(fontFamily: 'Kelly Slab',color: Colors.grey[600]),textScaleFactor: oran,
                                        ),
                                        Text(minHavFanSayisi,style: TextStyle(fontFamily: 'Kelly Slab',fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue[200]),textScaleFactor: oran,)
                                      ],
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(width: 1*oran,color: Colors.black,),
                    _minHavDefaultUnsur(kumesTuru, oran),
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
                            subtitle: Text(
                              Dil().sec(dilSecimi, info),
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

      if (_index == 1) {
        calismaSuresiUstSinir = (_yuzler * 100 + _onlar * 10 + _birler).toString();
        veri = calismaSuresiUstSinir;
      }
      if (_index == 2) {
        airInletOncelikSuresi = (_yuzler * 100 + _onlar * 10 + _birler).toString();
        veri = (int.parse(airInletOncelikSuresi)*1000).toString();
      }

      if (_index == 3) {
        havaGirisKatsayisi = (_yuzler * 100 + _onlar * 10 + _birler).toString();
        veri = havaGirisKatsayisi;
      }

      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        _veriGonder("12*$index*$veri");
      }

      setState(() {});
    });
  }

  Future _degergiris1X2(
      int birler,
      int ondalikOnlar,
      int ondalikBirler,
      int index,
      double oran,
      String dil,
      String baslik,
      String onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris1X2.Deger(birler, ondalikOnlar, ondalikBirler,
            index, oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_birler != val[0] ||
          _ondalikOnlar != val[1] ||
          _ondalikBirler != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }

      
      _birler = val[0];
      _ondalikOnlar = val[1];
      _ondalikBirler = val[2];
      _index = val[3];

      
      if (index == 5) {
        gunluk_1_7 = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri1 = gunluk_1_7;

      if (index == 6) {
        gunluk_8_14 = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri2 = gunluk_8_14;

      if (index == 7) {
        gunluk_15_21 = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri3 = gunluk_15_21;

      if (index == 8) {
        gunluk_22_28 = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri4 = gunluk_22_28;

      if (index == 9) {
        gunluk_29_35 = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri5 = gunluk_29_35;

      if (index == 10) {
        gunluk_36_42 = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri6 = gunluk_36_42;

      if (index == 11) {
        gunluk_43_49 = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri7 = gunluk_43_49;

      if (index == 12) {
        gunluk_50veSonrasi = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri8 = gunluk_50veSonrasi;

      if (index == 14) {
        haftalik_7_20 = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri9 = haftalik_7_20;

      if (index == 15) {
        haftalik_21_52 = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri10 = haftalik_21_52;

      if (index == 16) {
        haftalik_53veSonrasi = _birler.toString() +
            "." +
            _ondalikOnlar.toString()+_ondalikBirler.toString();
      }
      String veri11 = haftalik_53veSonrasi;

      String veriX="$veri1*$veri2*$veri3*$veri4*$veri5*$veri6*$veri7*$veri8";
      String veriY="$veri9*$veri10*$veri11";

      String veri=kumesTuru=='1' ? veriY : veriX;




      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        _veriGonder("12*$_index*$kumesTuru*$veri");
      }
    });
  }

  

  _veriGonder(String emir) async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2235).then((socket) {
        String gelen_mesaj = "";

        socket.add(utf8.encode(emir));

        socket.listen(
          (List<int> event) {
            print(utf8.decode(event));
            gelen_mesaj = utf8.decode(event);
            var gelen_mesaj_parcali = gelen_mesaj.split("*");

            if (gelen_mesaj_parcali[0] == 'ok') {
              Toast.show(Dil().sec(dilSecimi, "toast8"), context, duration: 2);
            } else {
              Toast.show(gelen_mesaj_parcali[0], context, duration: 2);
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            _takipEt();
            setState(() {});
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context, duration: 3);
      baglanti = false;
    }
  }

  _takipEt() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2236).then((socket) {
        socket.add(utf8.encode('11*$kumesTuru'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);
            if (gelenMesaj != "") {
              var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              calismaSuresiUstSinir=degerler[0];
              airInletOncelikSuresi=degerler[1];
              havaGirisKatsayisi=degerler[2];
              fasilaOffdaAirInletKapansinMi=degerler[3]=='True' ? true : false;
              calismaSure=degerler[4];
              durmaSure=degerler[5];
              minHavFanSayisi=degerler[6];
              hayvanBasinaIhtiyac=degerler[7];
              fasilaDonguSuresi=degerler[8];

              if(kumesTuru=='1'){
                haftalik_7_20 =degerler[9];
                haftalik_21_52 =degerler[10];
                haftalik_53veSonrasi =degerler[11];
              }else{
                gunluk_1_7 =degerler[9];
                gunluk_8_14 =degerler[10];
                gunluk_15_21 =degerler[11];
                gunluk_22_28 =degerler[12];
                gunluk_29_35 =degerler[13];
                gunluk_36_42 =degerler[14];
                gunluk_43_49 =degerler[15];
                gunluk_50veSonrasi=degerler[16];
              }



              



              //socket.add(utf8.encode('ok'));
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            if (!timerCancel) {
              setState(() {});
            }
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context, duration: 3);
      baglanti = false;
    }
  }

  Widget _minHavDefaultUnsur(String kTuru,double oran){

    Widget widget;

    if(kTuru=="1"){
      widget=Expanded(
                        flex: 2 ,
                        child: Container(
                          color: Colors.grey[400],
                          child: Column(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 3*oran),
                              child: Text(Dil().sec(dilSecimi, "tv289"),textScaleFactor: oran,
                              style: TextStyle(fontFamily: 'Kelly Slab',color: Colors.white),),
                            ),
                          Padding(
                              padding: EdgeInsets.only(bottom:3*oran,top: 3*oran),
                              child: Container(height: 1,color:Colors.black,),
                            ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv290"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index = 14;

                                        _birler = int.parse(haftalik_7_20.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(haftalik_7_20.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(haftalik_7_20.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv290","");
                                      
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
                                                  haftalik_7_20,
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
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv291"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index =15;

                                        _birler = int.parse(haftalik_21_52.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(haftalik_21_52.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(haftalik_21_52.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv291","");
                                      
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
                                                  haftalik_21_52,
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
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv292"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index = 16;

                                        _birler = int.parse(haftalik_53veSonrasi.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(haftalik_53veSonrasi.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(haftalik_53veSonrasi.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv292","");
                                      
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
                                                  haftalik_53veSonrasi,
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
                          
                          Expanded(child: Row(children: <Widget>[
                            Spacer(flex: 2,),
                            Expanded(flex:8,child: RaisedButton(onPressed: (){
                              _veriGonder("12*13*$kumesTuru*0.95*1.10*1.20");
                            },child: Text(Dil().sec(dilSecimi, "tv288"),
                            textScaleFactor: oran,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            ), color: Colors.cyan,),),
                            Spacer(flex: 2,)
                          ],),),
                          Spacer(flex: 2,),



                          ],),
                        ));
               

    }else{
      widget=Expanded(
                        flex: 2 ,
                        child: Container(
                          color: Colors.grey[400],
                          child: Column(children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 3*oran),
                              child: Text(Dil().sec(dilSecimi, "tv279"),textScaleFactor: oran,
                              style: TextStyle(fontFamily: 'Kelly Slab',color: Colors.white),),
                            ),
                          Padding(
                              padding: EdgeInsets.only(bottom:3*oran,top: 3*oran),
                              child: Container(height: 1,color:Colors.black,),
                            ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv280"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index = 5;

                                        _birler = int.parse(gunluk_1_7.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(gunluk_1_7.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(gunluk_1_7.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv280","");
                                      
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
                                                  gunluk_1_7,
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
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv281"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index = 6;

                                        _birler = int.parse(gunluk_8_14.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(gunluk_8_14.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(gunluk_8_14.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv281","");
                                      
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
                                                  gunluk_8_14,
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
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv282"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index = 7;

                                        _birler = int.parse(gunluk_15_21.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(gunluk_15_21.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(gunluk_15_21.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv282","");
                                      
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
                                                  gunluk_15_21,
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
                          Padding(
                              padding: EdgeInsets.only(bottom:3*oran,top: 3*oran),
                              child: Container(height: 1),
                            ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv283"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index = 8;

                                        _birler = int.parse(gunluk_22_28.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(gunluk_22_28.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(gunluk_22_28.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv283","");
                                      
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
                                                  gunluk_22_28,
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
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv284"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index = 9;

                                        _birler = int.parse(gunluk_29_35.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(gunluk_29_35.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(gunluk_29_35.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv284","");
                                      
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
                                                  gunluk_29_35,
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
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv285"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index = 10;

                                        _birler = int.parse(gunluk_36_42.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(gunluk_36_42.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(gunluk_36_42.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv285","");
                                      
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
                                                  gunluk_36_42,
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
                          Padding(
                              padding: EdgeInsets.only(bottom:3*oran,top: 3*oran),
                              child: Container(height: 1),
                            ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv286"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index = 11;

                                        _birler = int.parse(gunluk_43_49.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(gunluk_43_49.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(gunluk_43_49.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv286","");
                                      
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
                                                  gunluk_43_49,
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
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv287"),
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
                                          flex: 4,
                                          child: RawMaterialButton(
                                            onPressed: () {
                                               _index = 12;

                                        _birler = int.parse(gunluk_50veSonrasi.split(".")[0]) % 10;
                                        _ondalikOnlar = int.parse(gunluk_50veSonrasi.split(".")[1])~/10;
                                        _ondalikBirler = int.parse(gunluk_50veSonrasi.split(".")[1])%10;

                                        _degergiris1X2(
                                            _birler,
                                            _ondalikOnlar,
                                            _ondalikBirler,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv287","");
                                      
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
                                                  gunluk_50veSonrasi,
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
                                Spacer()
                                ],
                            ),
                          ),
                          Expanded(child: Row(children: <Widget>[
                            Spacer(),
                            Expanded(flex:8,child: RaisedButton(onPressed: (){
                              _veriGonder("12*13*$kumesTuru*0.16*0.42*0.59*0.84*0.93*1.18*1.35*1.52");
                            },child: Text(Dil().sec(dilSecimi, "tv288"),
                            textScaleFactor: oran,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            ), color: Colors.cyan,),),
                            Spacer(flex: 4,)
                          ],),),
                          



                          ],),
                        ));
                  
    }

    return widget;



  }

  //--------------------------METOTLAR--------------------------------

}
