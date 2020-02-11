import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/bacafan_haritasi.dart';
import 'package:prokis/ped_haritasi.dart';
import 'package:toast/toast.dart';
import 'genel/alert_reset.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x0.dart';
import 'genel/deger_giris_2x2x0.dart';
import 'kurulum_ayarlari.dart';
import 'languages/select.dart';

class IsiSensorHaritasi extends StatefulWidget {
  List<Map> gelenDBveri;
  bool gelenDurum;
  IsiSensorHaritasi(List<Map> dbVeriler,bool durum) {
    gelenDBveri = dbVeriler;
    gelenDurum=durum;
  }
  @override
  State<StatefulWidget> createState() {
    return IsiSensorHaritasiState(gelenDBveri,gelenDurum);
  }
}

class IsiSensorHaritasiState extends State<IsiSensorHaritasi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  List<int> isisensorHarita = new List(23);
  List<bool> isisensorVisibility = new List(23);
  List<int> isisensorNo = new List(23);
  bool haritaOnay = false;
  int isisensorAdet = 0;
  int isisensorBaglanti = 1;

  int _onlarisisensor = 0;
  int _birlerisisensor = 0;
  int _onlarAktifSensor = 0;
  int _birlerAktifSensor = 0;
  int _degerNo = 0;

  double _oran1;
  bool veriGonderildi = false;
  bool isisensorNoTekerrur = false;

  int sayacAktifSensor = 0;
  bool baglanti = false;
  bool timerCancel = false;

  List<bool> aktifSensorVisibility = new List(16);
  List<int> aktifSensorNo = new List(16);
  List<String> aktifSensorID = new List(16);
  List<String> aktifSensorValue = new List(16);
  List<bool> aktifSensorDurum = new List(16);
  int aktifSenSay = 0;
  bool aktifSensorNoTekerrur = false;
  bool atanacakSensorVarmi = true;

  List<int> tumCikislar = new List(111);

  bool durum;

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  IsiSensorHaritasiState(List<Map> dbVeri,bool drm) {
    bool isisensorHaritaOK = false;
    bool isisensorNoOK = false;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {
        var xx=dbVeri[i]["veri4"].split('#');
        isisensorAdet = int.parse(xx[0]);
        isisensorBaglanti=int.parse(xx[1]);
      }

      if (dbVeri[i]["id"] == 20) {
        if (dbVeri[i]["veri1"] == "ok") {
          isisensorHaritaOK = true;
          String xx = dbVeri[i]["veri2"];
          var fHaritalar = xx.split("#");
          for (int i = 1; i <= 22; i++) {
            isisensorHarita[i] = int.parse(fHaritalar[i - 1]);
            if (fHaritalar[i - 1] != "0") {
              haritaOnay = true;
            }
          }

          for (int i = 1; i <= 22; i++) {
            if (isisensorHarita[i] != 0) {
              isisensorVisibility[i] = true;
            } else {
              isisensorVisibility[i] = false;
            }
          }
        }
      }

      if (dbVeri[i]["id"] == 21) {
        String xx;
        String yy;
        String zz;

        if (dbVeri[i]["veri1"] == "ok") {
          isisensorNoOK = true;
          veriGonderildi = true;
          xx = dbVeri[i]["veri2"];
          yy = dbVeri[i]["veri3"];
          zz = dbVeri[i]["veri4"];
          var isisensorNolar = xx.split("#");
          var aktifIsisensorNolar = yy.split("#");
          var aktifIsisensorIDler = zz.split("#");
          for (int i = 1; i <= 22; i++) {
            isisensorNo[i] = int.parse(isisensorNolar[i - 1]);
          }

          if (aktifIsisensorNolar.length > 2 && aktifIsisensorIDler.length > 2) {
            for (int i = 1; i <= 15; i++) {
              aktifSensorNo[i] = int.parse(aktifIsisensorNolar[i - 1]);
              aktifSensorID[i] = aktifIsisensorIDler[i - 1];
            }
          } else {
            for (int i = 1; i <= 15; i++) {
              aktifSensorNo[i] = 0;
            }
          }

        }
      }
    }

    if (!isisensorHaritaOK) {
      for (int i = 1; i <= 22; i++) {
        isisensorHarita[i] = 0;
        isisensorVisibility[i] = true;
      }
    }

    if (!isisensorNoOK) {
      for (int i = 1; i <= 22; i++) {
        isisensorNo[i] = 0;
      }

      for (int i = 1; i <= 15; i++) {
        aktifSensorNo[i] = 0;
        aktifSensorID[i] = "";
      }
    }

    for (int i = 1; i <= 15; i++) {
      aktifSensorValue[i] = "0.0";
      aktifSensorVisibility[i] = false;
      aktifSensorDurum[i] = false;
    }
    durum=drm;
    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {


    if (sayacAktifSensor == 0) {
      print("İlk Takip Et çalıştırıldı!!!");
      if(isisensorBaglanti==1){
        _takipEtWifi();
      }else{
        _takipEtAnalog();
      }
      

      Timer.periodic(Duration(seconds: 5), (timer) {


        if (timerCancel) {
          timer.cancel();
        }

        if (!baglanti) {
          baglanti = true;

          if(isisensorBaglanti==1){
            _takipEtWifi();
          }else{
            _takipEtAnalog();
          }
        }

      });
    }

    sayacAktifSensor++;

//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
    _oran1 = oran;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
      floatingActionButton: Visibility(visible: !durum,
          child: Container(width: 40*oran,height: 40*oran,
            child: FittedBox(
                        child: FloatingActionButton(
                onPressed: () {
                  timerCancel=true;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
                  );
                },
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ),
    ),
   
        body: Column(
      children: <Widget>[
        //Başlık bölümü
        Expanded(
            child: Container(
          color: Colors.grey.shade600,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: SizedBox(
                  child: Container(
                    alignment: Alignment.center,
                    child: AutoSizeText(
                      Dil().sec(dilSecimi, "tv48"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Kelly Slab',
                          color: Colors.white,
                          fontSize: 60,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
          alignment: Alignment.center,
        )),
        //isisensor Harita Oluşturma Bölümü
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    children: <Widget>[
                      Spacer(flex: 5,),
                      Expanded(child: 
                      Row(
                        children: <Widget>[
                          Spacer(),
                          Expanded(flex: 4,
                                                      child: SizedBox(
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: AutoSizeText(
                                    Dil().sec(dilSecimi, "tv70"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 8,
                                  ),
                                ),
                              ),
                          ),
                          Spacer()
                        ],
                      )
                      ,),
                      _isisensorHaritaUnsur(22, oran, "tv49", 1),
                      Container(height: 5*oran,)
                    ],
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Column(
                    children: <Widget>[
                      //Aktif Sensörler Bölümü
                      Expanded(
                          flex: 13,
                          child: Stack(
                            children: <Widget>[
                              Visibility(
                                visible: isisensorBaglanti==2  ? false : (aktifSenSay==0 ? true : false),
                                child: Center(
                                    child: Text(
                                  Dil()
                                      .sec(dilSecimi, "tv60"),
                                  style: TextStyle(
                                      fontSize: 20 * oran,
                                      fontFamily: "Kelly Slab",
                                      color: Colors.grey[300],
                                      fontWeight: FontWeight.bold),
                                  textScaleFactor: oran,
                                )),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        //Aktif sensörler başlık
                                        Expanded(
                                          flex: 2,
                                          child: RotatedBox(
                                            quarterTurns: -45,
                                            child: SizedBox(
                                              child: Container(
                                                alignment: Alignment.center,
                                                child: AutoSizeText(
                                                  Dil()
                                                      .sec(
                                                          dilSecimi, "tv51"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 40,
                                                  ),
                                                  maxLines: 1,
                                                  minFontSize: 8,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Aktif Sensorler 1-2-3
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 1
                                              _aktifSensor(1, oran),
                                              //Aktif sensör 2
                                              _aktifSensor(2, oran),
                                              //Aktif sensör 3
                                              _aktifSensor(3, oran),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 4-5-6
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 4
                                              _aktifSensor(4, oran),
                                              //Aktif sensör 5
                                              _aktifSensor(5, oran),
                                              //Aktif sensör 6
                                              _aktifSensor(6, oran),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 7-8-9
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 7
                                              _aktifSensor(7, oran),
                                              //Aktif sensör 8
                                              _aktifSensor(8, oran),
                                              //Aktif sensör 9
                                              _aktifSensor(9, oran),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 10-11-12
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 10
                                              _aktifSensor(10, oran),
                                              //Aktif sensör 11
                                              _aktifSensor(11, oran),
                                              //Aktif sensör 12
                                              _aktifSensor(12, oran),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Aktif Sensorler 13-14-15
                                        Expanded(
                                          flex: 10,
                                          child: Column(
                                            children: <Widget>[
                                              //Aktif sensör 13
                                              _aktifSensor(13, oran),
                                              //Aktif sensör 14
                                              _aktifSensor(14, oran),
                                              //Aktif sensör 15
                                              _aktifSensor(15, oran),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Spacer(),
                      //Sensor Konumları Bölümü
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              Dil().sec(dilSecimi, "tv57"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 40,
                              ),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 20,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil()
                                          .sec(dilSecimi, "tv58"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 27,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.pink,
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/bina_catisiz_ust_gorunum.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Spacer(),
                                        Expanded(
                                          flex: 10,
                                          child: Row(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        1, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        2, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        3, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        4, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        5, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        6, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        7, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        8, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        9, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        10, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        11, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        12, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        13, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        14, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        15, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        16, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        17, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        18, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _isisensorHaritaUnsur(
                                                        19, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        20, oran, "tv49", 1),
                                                    _isisensorHaritaUnsur(
                                                        21, oran, "tv49", 1),
                                                  ],
                                                ),
                                              ),
                                              Spacer()
                                            ],
                                          ),
                                        ),
                                        Spacer()
                                      ],
                                    )
                                  ],
                                )),
                            Expanded(
                              flex: 1,
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      Dil()
                                          .sec(dilSecimi, "tv59"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 40,
                                      ),
                                      maxLines: 1,
                                      minFontSize: 8,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(
                  flex: 1,
                )
              ],
            ),
          ),
        ),

        //ileri geri ok bölümü
        Expanded(
          child: Container(
            color: Colors.grey.shade600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //Spacer(),
                Expanded(
                  flex: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Haritayı Onayla Butonu
                      Visibility(
                        visible: !haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            int sayac = 0;

                            for (int i = 1; i <= 22; i++) {
                              if (isisensorHarita[i] == 1) {
                                sayac++;
                              }
                            }

                            if (sayac < isisensorAdet) {
                              //Haritada seçilen isisensor sayısı eksik
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast51"),
                                  context,
                                  duration: 3);
                            } else if (sayac > isisensorAdet) {
                              //Haritada seçilen isisensor sayısı yüksek
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast52"),
                                  context,
                                  duration: 3);
                            } else {
                              //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast8"),
                                  context,
                                  duration: 3);
                              haritaOnay = true;

                              for (int i = 1; i <= 22; i++) {
                                if (isisensorHarita[i] != 0) {
                                  isisensorVisibility[i] = true;
                                } else {
                                  isisensorVisibility[i] = false;
                                }
                              }

                              String veri = "";

                              for (int i = 1; i <= 22; i++) {
                                veri =
                                    veri + isisensorHarita[i].toString() + "#";
                              }

                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  20, "ok", veri, "0", "0");

                              _veriGonder("21", "25", veri, "0", "0", "0");

                              setState(() {});
                            }

                            //-------------------------ONAY BÖLÜMÜ--------------------------------------------------
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.map,
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn4"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Haritayı Sıfırla Butonu
                      Visibility(
                        visible: haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            _resetAlert(dilSecimi);
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.refresh,
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn5"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Verileri Gönder Butonu
                      Visibility(
                        visible: haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            bool noKontrol = false;
                            bool enAzBirAtama = false;
                            bool sensSayYukNo = false;
                            String noVeri = "";
                            String noVeriAktif = "";
                            String idVeriAktif = "";
                            for (int i = 1; i <= 22; i++) {
                              if (isisensorHarita[i] == 1) {
                                if (isisensorNo[i] == 0) {
                                  noKontrol = true;
                                }
                                if (isisensorNo[i] > isisensorAdet) {
                                  sensSayYukNo = true;
                                }
                              }
                              noVeri = noVeri + isisensorNo[i].toString() + "#";
                            }
                            for (int i = 1; i <= 15; i++) {
                              noVeriAktif = noVeriAktif +
                                  aktifSensorNo[i].toString() +
                                  "#";
                              idVeriAktif = idVeriAktif +
                                  aktifSensorID[i].toString() +
                                  "#";
                              if (aktifSensorNo[i] != 0) {
                                enAzBirAtama = true;
                              }
                            }
                            if (noKontrol) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast35"),
                                  context,
                                  duration: 3);
                            } else if (sensSayYukNo) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast40"),
                                  context,
                                  duration: 3);
                            } else if (isisensorNoTekerrur) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast31"),
                                  context,
                                  duration: 3);
                            } else if (!enAzBirAtama) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast34"),
                                  context,
                                  duration: 3);
                            } else if (!atanacakSensorVarmi) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast41"),//Aktif sensorlere numara verirken harita üzerindeki numaralar içinde var mı yok mu kontrol  eder. 
                                  context,
                                  duration: 3);
                            } else if (aktifSensorNoTekerrur) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast33"),
                                  context,
                                  duration: 3);
                            } else {
                              veriGonderildi = true;

                              _veriGonder("22", "26", noVeri, noVeriAktif,
                                  idVeriAktif, "0");
                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  21, "ok", noVeri, noVeriAktif, idVeriAktif);
                            }
                          },
                          highlightColor: Colors.green,
                          splashColor: Colors.red,
                          color:
                              veriGonderildi ? Colors.green[500] : Colors.blue,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.send,
                                size: 30 * oran,
                              ),
                              Text(
                                Dil()
                                    .sec(dilSecimi, "btn6"),
                                style: TextStyle(fontSize: 18),
                                textScaleFactor: oran,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //geri ok
                Expanded(
                    flex: 2,
                    child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        iconSize: 50 * oran,
                        onPressed: () {
                          timerCancel = true;
                          
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PedHaritasi(dbVeriler,true)),
                            );
                          
                          
                          //Navigator.pop(context, tumCikislar);
                        },
                      ),
                    )),
                Spacer(
                  flex: 1,
                ),
                //ileri ok
                Expanded(
                    flex: 2,
                    child: Visibility(visible: durum,maintainState: true,maintainSize: true,maintainAnimation: true,
                                          child: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        iconSize: 50 * oran,
                        onPressed: () {
                          if (!veriGonderildi) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);
                          } else {
                            timerCancel = true;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BacafanHaritasi(dbVeriler,true)),
                            );

                            
                          }
                        },
                        color: Colors.black,
                      ),
                    )),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    ));
//--------------------------SCAFFOLD--------------------------------
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

  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/harita_isi_sensor_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Future _degergiris2X0(int onlarX, birlerX, index, double oran, String dil,
      baslik, int degerGirisKodu) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X0.Deger(onlarX, birlerX, index, oran, dil, baslik);
      },
    ).then((val) {
      if (degerGirisKodu == 1) degerGiris2X0Yrd1(val);
      if (degerGirisKodu == 2) degerGiris2X0Yrd2(val);
    });
  }

  //Üst görünüşten haritadaki sensörlere numara atama işlemi
  degerGiris2X0Yrd1(var val) {
    
    if (_onlarisisensor != val[0] || _birlerisisensor != val[1]) {
      veriGonderildi = false;
    }

    _onlarisisensor = val[0];
    _birlerisisensor = val[1];
    _degerNo = val[2];

    isisensorNo[_degerNo] =
        int.parse(_onlarisisensor.toString() + _birlerisisensor.toString());
    isisensorNoTekerrur = false;

    for (int i = 1; i <= 22; i++) {
      for (int k = 1; k <= 22; k++) {
        if (i != k &&
            isisensorNo[i] == isisensorNo[k] &&
            isisensorNo[i] != 0 &&
            isisensorNo[k] != 0) {
          isisensorNoTekerrur = true;
          break;
        }
        if (isisensorNoTekerrur) {
          break;
        }
      }
    }

    setState(() {});
  }

  //Üst görünüşten haritadaki sensörlere numara atama işlemi
  degerGiris2X0Yrd2(var val) {
    if (_onlarAktifSensor != val[0] || _birlerAktifSensor != val[1]) {
      veriGonderildi = false;
    }

    _onlarAktifSensor = val[0];
    _birlerAktifSensor = val[1];
    _degerNo = val[2];

    aktifSensorNo[_degerNo] =
        int.parse(_onlarAktifSensor.toString() + _birlerAktifSensor.toString());
    aktifSensorNoTekerrur = false;

    for (int i = 1; i <= 15; i++) {
      for (int k = 1; k <= 15; k++) {
        if (i != k &&
            aktifSensorNo[i] == aktifSensorNo[k] &&
            aktifSensorNo[i] != 0 &&
            aktifSensorNo[k] != 0) {
          aktifSensorNoTekerrur = true;
          break;
        }
        if (aktifSensorNoTekerrur) {
          break;
        }
      }
    }

    atanacakSensorVarmi = false;
    for (int i = 1; i <= 22; i++) {
      if (isisensorNo[i] != 0 && aktifSensorNo[_degerNo] == isisensorNo[i]) {
        atanacakSensorVarmi = true;
        break;
      }
    }

    setState(() {});
  }

  Widget _isisensorHaritaUnsur(
      int indexNo, double oran, String baslik, int degerGirisKodu) {
    return Expanded(
      child: Visibility(
        visible: isisensorVisibility[indexNo] ? true : false,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: RawMaterialButton(
                  onPressed: () {
                    if (haritaOnay) {
                      _onlarisisensor = isisensorNo[indexNo] < 10
                          ? 0
                          : (isisensorNo[indexNo] ~/ 10).toInt();
                      _birlerisisensor = isisensorNo[indexNo] % 10;
                      _degerNo = indexNo;
                      _degergiris2X0(_onlarisisensor, _birlerisisensor, indexNo,
                          oran, dilSecimi, baslik, degerGirisKodu);
                    } else {
                      if (isisensorHarita[indexNo] == 0 ||
                          isisensorHarita[indexNo] == null) {
                        isisensorHarita[indexNo] = 1;
                      } else if (isisensorHarita[indexNo] == 1) {
                        isisensorHarita[indexNo] = 0;
                      }

                      setState(() {});
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        child: Container(
                          decoration: BoxDecoration(
                            //color: Colors.pink,
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: AssetImage(
                                  imageGetir(isisensorHarita[indexNo])),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        opacity: isisensorVisibility[indexNo] &&
                                haritaOnay &&
                                isisensorHarita[indexNo] == 1
                            ? 1
                            : 1,
                      ),
                      Visibility(
                        visible: haritaOnay && isisensorHarita[indexNo] != 0
                            ? true
                            : false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Row(
                          children: <Widget>[
                            Spacer(
                              flex: 5,
                            ),
                            //isisensor No
                            Expanded(
                              flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: AutoSizeText(
                                          Dil().sec(
                                                  dilSecimi, "tv50") +
                                              isisensorNo[indexNo].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontFamily: 'Kelly Slab'),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _veriGonder(String dbKod, String id, String v1, String v2, String v3,
      String v4) async {
    Socket socket;

    try {
      socket = await Socket.connect('192.168.1.110', 2233);
      String gelen_mesaj = "";

      print('connected');

      // listen to the received data event stream
      socket.listen((List<int> event) {
        //socket.add(utf8.encode('ok'));
        print(utf8.decode(event));
        gelen_mesaj = utf8.decode(event);
        var gelen_mesaj_parcali = gelen_mesaj.split("*");

        if (gelen_mesaj_parcali[0] == 'ok') {
          Toast.show(
              Dil().sec(dilSecimi, "toast8"), context,
              duration: 2);
        } else {
          Toast.show(gelen_mesaj_parcali[0], context, duration: 2);
        }

        setState(() {});
      });

      socket.add(utf8.encode('$dbKod*$id*$v1*$v2*$v3*$v4'));

      // wait 5 seconds
      await Future.delayed(Duration(seconds: 5));

      // .. and close the socket
      socket.close();
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast20"), context,
          duration: 3);
    }
  }

  Future _resetAlert(String x) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return ResetAlert.deger(x);
      },
    ).then((val) {
      if (val) {
        veriGonderildi = false;
        for (int i = 1; i <= 22; i++) {
          isisensorHarita[i] = 0;
          isisensorNo[i] = 0;
          isisensorVisibility[i] = true;
        }
        for(int i=1 ; i<=15;i++){
          aktifSensorNo[i]=0;
        }
        haritaOnay = false;

        dbHelper.veriYOKSAekleVARSAguncelle(20, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(21, "0", "0", "0", "0");
        _veriGonder("23", "0", "0", "0", "0", "0");

        setState(() {});
      }
    });
  }

  _takipEtWifi() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2233).then((socket) {
        /*
        socket.timeout(ReceiveTimeout,onTimeout: (deneme){
            Toast.show("Bağlantı zaman aşımına uğradı", context,duration: 3);
        });
        */

        socket.add(utf8.encode('24a*'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);

            if (gelenMesaj != "") {
              var sensorler = gelenMesaj.split('*');
              print(sensorler);
              aktifSenSay = ((sensorler.length - 1) ~/ 3).toInt();

              for (int i = 1; i <= 15; i++) {
                if (i <= aktifSenSay) {
                  aktifSensorVisibility[i] = true;
                }
              }
              int sayac = 0;
              for (int i = 0; i <= sensorler.length - 2; i++) {
                if (i % 3 == 0) {
                  sayac++;
                  aktifSensorID[sayac] = sensorler[i];
                  aktifSensorValue[sayac] = sensorler[i + 1];
                  aktifSensorDurum[sayac] =
                      sensorler[i + 2] == 'ok' ? true : false;
                }
              }

              socket.add(utf8.encode('ok'));
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
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  _takipEtAnalog() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2233).then((socket) {

        socket.add(utf8.encode('24b'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);

            if (gelenMesaj != "") {
              var sensorler = gelenMesaj.split('#');
              print(sensorler);

              for (int i = 1; i <= 15; i++) {
                if (i%3 != 0) {
                  aktifSensorVisibility[i] = true;
                }
              }

              aktifSensorVisibility[1] =  isisensorAdet>=1 ? true :false;
              aktifSensorVisibility[4] =  isisensorAdet>=2 ? true :false;
              aktifSensorVisibility[7] =  isisensorAdet>=3 ? true :false;
              aktifSensorVisibility[10] = isisensorAdet>=4 ? true :false;
              aktifSensorVisibility[13] = isisensorAdet>=5 ? true :false;
              aktifSensorVisibility[2] =  isisensorAdet>=6 ? true :false;
              aktifSensorVisibility[5] =  isisensorAdet>=7 ? true :false;
              aktifSensorVisibility[8] =  isisensorAdet>=8 ? true :false;
              aktifSensorVisibility[11] = isisensorAdet>=9 ? true :false;
              aktifSensorVisibility[14] = isisensorAdet>=10 ? true :false;

              aktifSensorID[1] = 'Analog1';
              aktifSensorID[4] = 'Analog2';
              aktifSensorID[7] = 'Analog3';
              aktifSensorID[10] = 'Analog4';
              aktifSensorID[13] = 'Analog5';
              aktifSensorID[2] = 'Analog6';
              aktifSensorID[5] = 'Analog7';
              aktifSensorID[8] = 'Analog8';
              aktifSensorID[11] = 'Analog9';
              aktifSensorID[14] = 'Analog10';
              aktifSensorValue[1]   = sensorler[0] ;
              aktifSensorValue[4]   = sensorler[1] ;
              aktifSensorValue[7]   = sensorler[2] ;
              aktifSensorValue[10]  = sensorler[3] ;
              aktifSensorValue[13]  = sensorler[4] ;
              aktifSensorValue[2]   = sensorler[5] ;
              aktifSensorValue[5]   = sensorler[6];
              aktifSensorValue[8]   = sensorler[7];
              aktifSensorValue[11]  = sensorler[8];
              aktifSensorValue[14]  = sensorler[9];
              aktifSensorDurum[1]   = sensorler[0]=="0.0" ? false : true ;
              aktifSensorDurum[4]   = sensorler[1]=="0.0" ? false : true ;
              aktifSensorDurum[7]   = sensorler[2]=="0.0" ? false : true ;
              aktifSensorDurum[10]  = sensorler[3]=="0.0" ? false : true ;
              aktifSensorDurum[13]  = sensorler[4]=="0.0" ? false : true ;
              aktifSensorDurum[2]   = sensorler[5]=="0.0" ? false : true ;
              aktifSensorDurum[5]   = sensorler[6]=="0.0" ? false : true;
              aktifSensorDurum[8]   = sensorler[7]=="0.0" ? false : true;
              aktifSensorDurum[11]  = sensorler[8]=="0.0" ? false : true;
              aktifSensorDurum[14]  = sensorler[9]=="0.0" ? false : true;

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
        if(!timerCancel)
          Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      if(!timerCancel)
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  Widget _aktifSensor(int index, double oran) {
    return Expanded(
      child: Visibility(
        visible: aktifSensorVisibility[index],
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Column(
          children: <Widget>[
            Text(
              Dil().sec(dilSecimi, "tv50") +
                  aktifSensorNo[index].toString(),
              style: TextStyle(
                  fontSize: 14,
                  color: aktifSensorNo[index] == 0
                      ? Colors.black
                      : Colors.blue[700],
                  fontWeight: aktifSensorNo[index] == 0
                      ? FontWeight.normal
                      : FontWeight.bold),
              textScaleFactor: oran,
            ),
            Expanded(
              child: RawMaterialButton(
                onPressed: () {
                  _onlarAktifSensor = aktifSensorNo[index] < 10
                      ? 0
                      : (aktifSensorNo[index] ~/ 10).toInt();
                  _birlerAktifSensor = aktifSensorNo[index] % 10;
                  _degerNo = index;

                  _degergiris2X0(_onlarAktifSensor, _birlerAktifSensor, index,
                      oran, dilSecimi, "tv61", 2);
                  print(index);
                },
                fillColor:
                    aktifSensorDurum[index] ? Colors.green[300] : Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(3.0 * oran),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: AutoSizeText(
                              aktifSensorID[index] + " :",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 50.0,
                                  fontFamily: 'Kelly Slab'),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: AutoSizeText(
                              aktifSensorValue[index] + "°C",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 50.0,
                                  fontFamily: 'Kelly Slab'),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                constraints: BoxConstraints(minWidth: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }

//--------------------------METOTLAR--------------------------------

}
