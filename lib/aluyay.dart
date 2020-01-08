import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/kurulum_ozet.dart';
import 'package:prokis/kurulumu_tamamla.dart';
import 'package:prokis/silo_haritasi.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x0.dart';
import 'languages/select.dart';

class AluyayHaritasi extends StatefulWidget {
  List<Map> gelenDBveri;
  AluyayHaritasi(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }
  @override
  State<StatefulWidget> createState() {
    return AluyayHaritasiState(gelenDBveri);
  }
}

class AluyayHaritasiState extends State<AluyayHaritasi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";

  List<int> cikisAluyayNo = new List(4);
  List<int> cikisAluyayNoGecici = new List(4);
  List<int> cikisYem1No = new List(3);
  List<int> cikisYem1NoGecici = new List(3);
  List<int> cikisYem2No = new List(3);
  List<int> cikisYem2NoGecici = new List(3);
  List<int> cikisYem3No = new List(3);
  List<int> cikisYem3NoGecici = new List(3);

  int _onlarOut = 3;
  int _birlerOut = 3;
  int _degerNo = 0;

  bool veriGonderildi = false;
  bool cikisNoTekerrur = false;
  bool yem1Aktif = false;
  bool yem2Aktif = false;
  bool yem3Aktif = false;

  bool aluyayCikislarOK = false;

  List<int> tumCikislar = new List(111);

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  AluyayHaritasiState(List<Map> dbVeri) {
    bool tumCikislarVar = false;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 22) {
        if (dbVeri[i]["veri1"] == "ok") {
          tumCikislarVar = true;
          var tcikislar = dbVeri[i]["veri2"].split("#");

          for (int i = 1; i <= 110; i++) {
            tumCikislar[i] = int.parse(tcikislar[i - 1]);
          }
        }
      }

      if (dbVeri[i]["id"] == 31) {
        String xx;
        String yy;

        if (dbVeri[i]["veri1"] == "ok") {
          aluyayCikislarOK = true;
          veriGonderildi = true;
          xx = dbVeri[i]["veri2"];
          yy = dbVeri[i]["veri3"];
          var aluyayNolar = xx.split("#");
          var aktifYemCikislar = yy.split("#");
          cikisAluyayNo[1] = int.parse(aluyayNolar[0]);
          cikisAluyayNo[2] = int.parse(aluyayNolar[1]);
          cikisAluyayNo[3] = int.parse(aluyayNolar[2]);
          cikisYem1No[1] = int.parse(aluyayNolar[3]);
          cikisYem1No[2] = int.parse(aluyayNolar[4]);
          cikisYem2No[1] = int.parse(aluyayNolar[5]);
          cikisYem2No[2] = int.parse(aluyayNolar[6]);
          cikisYem3No[1] = int.parse(aluyayNolar[7]);
          cikisYem3No[2] = int.parse(aluyayNolar[8]);
          yem1Aktif = aktifYemCikislar[0] == "1" ? true : false;
          yem2Aktif = aktifYemCikislar[1] == "1" ? true : false;
          yem3Aktif = aktifYemCikislar[2] == "1" ? true : false;
        }
      }
    }

    if (!aluyayCikislarOK) {
      cikisAluyayNo[1] = 0;
      cikisAluyayNo[2] = 0;
      cikisAluyayNo[3] = 0;
      cikisYem1No[1] = 0;
      cikisYem1No[2] = 0;
      cikisYem2No[1] = 0;
      cikisYem2No[2] = 0;
      cikisYem3No[1] = 0;
      cikisYem3No[2] = 0;
      yem1Aktif = false;
      yem2Aktif = false;
      yem3Aktif = false;
    }

    if (!tumCikislarVar) {
      for (int i = 1; i <= 110; i++) {
        tumCikislar[i] = 0;
      }
    }

    for (int i = 1; i <= 3; i++) {
      cikisAluyayNoGecici[i] = cikisAluyayNo[i];
    }

    for (int i = 1; i <= 2; i++) {
      cikisYem1NoGecici[i] = cikisYem1No[i];
      cikisYem2NoGecici[i] = cikisYem2No[i];
      cikisYem3NoGecici[i] = cikisYem3No[i];
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
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
                      SelectLanguage().selectStrings(dilSecimi, "tv85"),
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
        //aluyay Harita Oluşturma Bölümü
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(
                  flex: 1,
                ),
                //Çıkışların olduğu bölüm
                Expanded(
                  flex: 12,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisAluyay(1, oran),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisAluyay(2, oran),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisAluyay(3, oran),
                                  ],
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv95"),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: oran,
                                    ),
                                    RawMaterialButton(
                                      onPressed: () {
                                        if (yem1Aktif) {
                                          yem1Aktif = false;
                                        } else {
                                          yem1Aktif = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Icon(
                                        yem1Aktif == true
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: yem1Aktif == true
                                            ? Colors.green[600]
                                            : Colors.black,
                                        size: 25 * oran,
                                      ),
                                      padding: EdgeInsets.all(0),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv96"),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: oran,
                                    ),
                                    RawMaterialButton(
                                      onPressed: () {
                                        if (yem2Aktif) {
                                          yem2Aktif = false;
                                        } else {
                                          yem2Aktif = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Icon(
                                        yem2Aktif == true
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: yem2Aktif == true
                                            ? Colors.green[600]
                                            : Colors.black,
                                        size: 25 * oran,
                                      ),
                                      padding: EdgeInsets.all(0),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv97"),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Kelly Slab',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textScaleFactor: oran,
                                    ),
                                    RawMaterialButton(
                                      onPressed: () {
                                        if (yem3Aktif) {
                                          yem3Aktif = false;
                                        } else {
                                          yem3Aktif = true;
                                        }
                                        setState(() {});
                                      },
                                      child: Icon(
                                        yem3Aktif == true
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        color: yem3Aktif == true
                                            ? Colors.green[600]
                                            : Colors.black,
                                        size: 25 * oran,
                                      ),
                                      padding: EdgeInsets.all(0),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      constraints: BoxConstraints(),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem1(1, oran, yem1Aktif),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem2(1, oran, yem2Aktif),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem3(1, oran, yem3Aktif),
                                  ],
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem1(2, oran, yem1Aktif),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem2(2, oran, yem2Aktif),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  children: <Widget>[
                                    _aluyayGrupCikisYem3(2, oran, yem3Aktif),
                                  ],
                                ),
                              ),
                              Spacer(),
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
                Expanded(
                  flex: 6,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              SelectLanguage().selectStrings(dilSecimi, "tv62"),
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
                        flex: 60,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(1, oran),
                                  _cikislarUnsur(2, oran),
                                  _cikislarUnsur(3, oran),
                                  _cikislarUnsur(4, oran),
                                  _cikislarUnsur(5, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(6, oran),
                                  _cikislarUnsur(7, oran),
                                  _cikislarUnsur(8, oran),
                                  _cikislarUnsur(9, oran),
                                  _cikislarUnsur(10, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(11, oran),
                                  _cikislarUnsur(12, oran),
                                  _cikislarUnsur(13, oran),
                                  _cikislarUnsur(14, oran),
                                  _cikislarUnsur(15, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(16, oran),
                                  _cikislarUnsur(17, oran),
                                  _cikislarUnsur(18, oran),
                                  _cikislarUnsur(19, oran),
                                  _cikislarUnsur(20, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(21, oran),
                                  _cikislarUnsur(22, oran),
                                  _cikislarUnsur(23, oran),
                                  _cikislarUnsur(24, oran),
                                  _cikislarUnsur(25, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(26, oran),
                                  _cikislarUnsur(27, oran),
                                  _cikislarUnsur(28, oran),
                                  _cikislarUnsur(29, oran),
                                  _cikislarUnsur(30, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(31, oran),
                                  _cikislarUnsur(32, oran),
                                  _cikislarUnsur(33, oran),
                                  _cikislarUnsur(34, oran),
                                  _cikislarUnsur(35, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(36, oran),
                                  _cikislarUnsur(37, oran),
                                  _cikislarUnsur(38, oran),
                                  _cikislarUnsur(39, oran),
                                  _cikislarUnsur(40, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(41, oran),
                                  _cikislarUnsur(42, oran),
                                  _cikislarUnsur(43, oran),
                                  _cikislarUnsur(44, oran),
                                  _cikislarUnsur(45, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(46, oran),
                                  _cikislarUnsur(47, oran),
                                  _cikislarUnsur(48, oran),
                                  _cikislarUnsur(49, oran),
                                  _cikislarUnsur(50, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(51, oran),
                                  _cikislarUnsur(52, oran),
                                  _cikislarUnsur(53, oran),
                                  _cikislarUnsur(54, oran),
                                  _cikislarUnsur(55, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(56, oran),
                                  _cikislarUnsur(57, oran),
                                  _cikislarUnsur(58, oran),
                                  _cikislarUnsur(59, oran),
                                  _cikislarUnsur(60, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(61, oran),
                                  _cikislarUnsur(62, oran),
                                  _cikislarUnsur(63, oran),
                                  _cikislarUnsur(64, oran),
                                  _cikislarUnsur(65, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(66, oran),
                                  _cikislarUnsur(67, oran),
                                  _cikislarUnsur(68, oran),
                                  _cikislarUnsur(69, oran),
                                  _cikislarUnsur(70, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(71, oran),
                                  _cikislarUnsur(72, oran),
                                  _cikislarUnsur(73, oran),
                                  _cikislarUnsur(74, oran),
                                  _cikislarUnsur(75, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(76, oran),
                                  _cikislarUnsur(77, oran),
                                  _cikislarUnsur(78, oran),
                                  _cikislarUnsur(79, oran),
                                  _cikislarUnsur(80, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(81, oran),
                                  _cikislarUnsur(82, oran),
                                  _cikislarUnsur(83, oran),
                                  _cikislarUnsur(84, oran),
                                  _cikislarUnsur(85, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(86, oran),
                                  _cikislarUnsur(87, oran),
                                  _cikislarUnsur(88, oran),
                                  _cikislarUnsur(89, oran),
                                  _cikislarUnsur(90, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(91, oran),
                                  _cikislarUnsur(92, oran),
                                  _cikislarUnsur(93, oran),
                                  _cikislarUnsur(94, oran),
                                  _cikislarUnsur(95, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(96, oran),
                                  _cikislarUnsur(97, oran),
                                  _cikislarUnsur(98, oran),
                                  _cikislarUnsur(99, oran),
                                  _cikislarUnsur(100, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(101, oran),
                                  _cikislarUnsur(102, oran),
                                  _cikislarUnsur(103, oran),
                                  _cikislarUnsur(104, oran),
                                  _cikislarUnsur(105, oran),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  _cikislarUnsur(106, oran),
                                  _cikislarUnsur(107, oran),
                                  _cikislarUnsur(108, oran),
                                  _cikislarUnsur(109, oran),
                                  _cikislarUnsur(110, oran),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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
                      //Verileri Gönder Butonu
                      FlatButton(
                        onPressed: () {
                          String cikisVeri1 = "";
                          String cikisVeri2 = "";
                          String cikisVeri3 = "";
                          String cikisVeri4 = "";
                          String cikisVeri5 = "";

                          String tumCikislarVeri = "";
                          bool noKontrol = false;
                          bool cikisKullanimda = false;
                          print(cikisYem1No);

                          for (int i = 1; i <= 3; i++) {
                            if (cikisAluyayNo[i] != 0) {
                              noKontrol = true;
                            }
                            cikisVeri1 =
                                cikisVeri1 + cikisAluyayNo[i].toString() + "#";
                          }

                          print(cikisYem1NoGecici);
                          print(cikisYem1No);

                          for (int i = 1; i <= 2; i++) {
                            if (cikisYem1No[i] == 0 && yem1Aktif) {
                              noKontrol = false;
                            }
                            if (cikisYem2No[i] == 0 && yem2Aktif) {
                              noKontrol = false;
                            }
                            if (cikisYem3No[i] == 0 && yem3Aktif) {
                              noKontrol = false;
                            }
                            cikisVeri2 =
                                cikisVeri2 + (yem1Aktif ? cikisYem1No[i].toString() : "0") + "#";
                            cikisVeri3 =
                                cikisVeri3 + (yem2Aktif ? cikisYem2No[i].toString() : "0") + "#";
                            cikisVeri4 =
                                cikisVeri4 + (yem3Aktif ? cikisYem3No[i].toString() : "0") + "#";
                          }

                          cikisVeri5 = (yem1Aktif ? "1" : "0") +
                              "#" +
                              (yem2Aktif ? "1" : "0") +
                              "#" +
                              (yem3Aktif ? "1" : "0");

                          for (int i = 1; i <= 3; i++) {
                            if (cikisAluyayNoGecici[i] != cikisAluyayNo[i]) {
                              if (tumCikislar[cikisAluyayNo[i]] == 0) {
                                tumCikislar[cikisAluyayNoGecici[i]] = 0;
                              } else {
                                cikisKullanimda = true;
                              }
                            }
                          }

                          for (int i = 1; i <= 2; i++) {
                            if (cikisYem1NoGecici[i] != cikisYem1No[i]) {
                              if (tumCikislar[cikisYem1No[i]] == 0) {
                                tumCikislar[cikisYem1NoGecici[i]] = 0;
                              } else {
                                cikisKullanimda = true;
                              }
                            }

                            if (cikisYem2NoGecici[i] != cikisYem2No[i]) {
                              if (tumCikislar[cikisYem2No[i]] == 0) {
                                tumCikislar[cikisYem2NoGecici[i]] = 0;
                              } else {
                                cikisKullanimda = true;
                              }
                            }

                            if (cikisYem3NoGecici[i] != cikisYem3No[i]) {
                              if (tumCikislar[cikisYem3No[i]] == 0) {
                                tumCikislar[cikisYem3NoGecici[i]] = 0;
                              } else {
                                cikisKullanimda = true;
                              }
                            }
                          }
                          

                          if (!noKontrol) {
                            Toast.show(
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "toast59"),
                                context,
                                duration: 3);
                          } else if (cikisNoTekerrur) {
                            Toast.show(
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "toast26"),
                                context,
                                duration: 3);
                          } else {


                            for (int i = 1; i <= 3; i++) {
                              if (cikisAluyayNo[i] != 0) {
                                tumCikislar[cikisAluyayNo[i]] = 1;
                              }
                            }

                            for (int i = 1; i <= 2; i++) {
                              if (cikisYem1No[i] != 0) {
                                tumCikislar[cikisYem1No[i]] = 1;
                              }
                              if (cikisYem2No[i] != 0) {
                                tumCikislar[cikisYem2No[i]] = 1;
                              }
                              if (cikisYem3No[i] != 0) {
                                tumCikislar[cikisYem3No[i]] = 1;
                              }
                            }


                            for (int i = 1; i <= 2; i++) {
                            if (!yem1Aktif) {
                              tumCikislar[cikisYem1NoGecici[i]] = 0;
                              cikisYem1No[i] = 0;
                            }
                            if (!yem2Aktif) {
                              tumCikislar[cikisYem2NoGecici[i]] = 0;
                              cikisYem2No[i] = 0;
                            }
                            if (!yem3Aktif) {
                              tumCikislar[cikisYem3NoGecici[i]] = 0;
                              cikisYem2No[i] = 0;
                            }
                          }

                            for (int i = 1; i <= 110; i++) {
                              tumCikislarVeri = tumCikislarVeri +
                                  tumCikislar[i].toString() +
                                  "#";
                            }
                            veriGonderildi = true;

                            _veriGonder(
                                "38",
                                "36",
                                cikisVeri1 +
                                    cikisVeri2 +
                                    cikisVeri3 +
                                    cikisVeri4,
                                cikisVeri5,
                                "0",
                                "0");
                            _veriGonder(
                                "25", "27", tumCikislarVeri, "0", "0", "0");
                            dbHelper
                                .veriYOKSAekleVARSAguncelle(
                                    31,
                                    "ok",
                                    cikisVeri1 +
                                        cikisVeri2 +
                                        cikisVeri3 +
                                        cikisVeri4,
                                    cikisVeri5,
                                    "0")
                                .then((deneme) {
                              dbHelper
                                  .veriYOKSAekleVARSAguncelle(
                                      22, "ok", tumCikislarVeri, "0", "0")
                                  .then((onValue) {
                                _dbVeriCekme();
                              });
                            });
                            for (int i = 1; i <= 3; i++) {
                              cikisAluyayNoGecici[i] = cikisAluyayNo[i];
                            }

                            for (int i = 1; i <= 2; i++) {
                              cikisYem1NoGecici[i] = cikisYem1No[i];
                              cikisYem2NoGecici[i] = cikisYem2No[i];
                              cikisYem3NoGecici[i] = cikisYem3No[i];
                            }
                          }
                        },
                        highlightColor: Colors.green,
                        splashColor: Colors.red,
                        color: veriGonderildi ? Colors.green[500] : Colors.blue,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.send,
                              size: 30 * oran,
                            ),
                            Text(
                              SelectLanguage().selectStrings(dilSecimi, "btn6"),
                              style: TextStyle(fontSize: 18),
                              textScaleFactor: oran,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //geri ok
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        Navigator.pop(context, tumCikislar);
                      },
                    )),
                Spacer(
                  flex: 1,
                ),
                //ileri ok
                Expanded(
                    flex: 2,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        if (!veriGonderildi) {
                          Toast.show(
                              SelectLanguage()
                                  .selectStrings(dilSecimi, "toast27"),
                              context,
                              duration: 3);
                        } else {

                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KurulumuTamamla(dbVeriler)),
                          );
                         
                        
                        }
                      },
                      color: Colors.black,
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

  
  Future _degergiris2X0(int onlarUnsur, int birlerUnsur, int indexNo,
      double oran, String dil, String baslik, int degerGirisKodu) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X0.Deger(
            onlarUnsur, birlerUnsur, indexNo, oran, dil, baslik);
      },
    ).then((val) {
      if (degerGirisKodu == 1) {
        degerGiris2X0Yrd1(val);
      }
      if (degerGirisKodu == 2) {
        degerGiris2X0Yrd2(val);
      }
      if (degerGirisKodu == 3) {
        degerGiris2X0Yrd3(val);
      }
      if (degerGirisKodu == 4) {
        degerGiris2X0Yrd4(val);
      }
    });
  }

  //Üst görünüşten haritadaki sensörlere numara atama işlemi
  degerGiris2X0Yrd1(var val) {
    if (_onlarOut != val[0] || _birlerOut != val[1]) {
      veriGonderildi = false;
    }

    _onlarOut = val[0];
    _birlerOut = val[1];
    _degerNo = val[2];

    cikisAluyayNo[_degerNo] =
        int.parse(_onlarOut.toString() + _birlerOut.toString());
    cikisNoTekerrur = false;

    for (int i = 1; i <= 3; i++) {
      for (int k = 1; k <= 3; k++) {
        if (i != k &&
            cikisAluyayNo[i] == cikisAluyayNo[k] &&
            cikisAluyayNo[i] != 0 &&
            cikisAluyayNo[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }

      for (int k = 1; k <= 2; k++) {
        if (i != k &&
            cikisAluyayNo[i] == cikisYem1No[k] &&
            cikisAluyayNo[i] != 0 &&
            cikisYem1No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
        if (i != k &&
            cikisAluyayNo[i] == cikisYem2No[k] &&
            cikisAluyayNo[i] != 0 &&
            cikisYem2No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
        if (i != k &&
            cikisAluyayNo[i] == cikisYem3No[k] &&
            cikisAluyayNo[i] != 0 &&
            cikisYem3No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
    }

    setState(() {});
  }

//Üst görünüşten haritadaki sensörlere numara atama işlemi
  degerGiris2X0Yrd2(var val) {
    if (_onlarOut != val[0] || _birlerOut != val[1]) {
      veriGonderildi = false;
    }

    _onlarOut = val[0];
    _birlerOut = val[1];
    _degerNo = val[2];

    cikisYem1No[_degerNo] =
        int.parse(_onlarOut.toString() + _birlerOut.toString());
    cikisNoTekerrur = false;

    for (int i = 1; i <= 2; i++) {
      for (int k = 1; k <= 2; k++) {
        if (i != k &&
            cikisYem1No[i] == cikisYem1No[k] &&
            cikisYem1No[i] != 0 &&
            cikisYem1No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
      for (int k = 1; k <= 2; k++) {
        if (i != k &&
            cikisYem1No[i] == cikisYem2No[k] &&
            cikisYem1No[i] != 0 &&
            cikisYem2No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
      for (int k = 1; k <= 2; k++) {
        if (i != k &&
            cikisYem1No[i] == cikisYem3No[k] &&
            cikisYem1No[i] != 0 &&
            cikisYem3No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
      for (int k = 1; k <= 3; k++) {
        if (i != k &&
            cikisYem1No[i] == cikisAluyayNo[k] &&
            cikisYem1No[i] != 0 &&
            cikisAluyayNo[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
    }

    setState(() {});
  }

//Üst görünüşten haritadaki sensörlere numara atama işlemi
  degerGiris2X0Yrd3(var val) {
    if (_onlarOut != val[0] || _birlerOut != val[1]) {
      veriGonderildi = false;
    }

    _onlarOut = val[0];
    _birlerOut = val[1];
    _degerNo = val[2];

    cikisYem2No[_degerNo] =
        int.parse(_onlarOut.toString() + _birlerOut.toString());
    cikisNoTekerrur = false;

    for (int i = 1; i <= 2; i++) {
      for (int k = 1; k <= 2; k++) {
        if (i != k &&
            cikisYem2No[i] == cikisYem2No[k] &&
            cikisYem2No[i] != 0 &&
            cikisYem2No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
      for (int k = 1; k <= 2; k++) {
        if (i != k &&
            cikisYem2No[i] == cikisYem1No[k] &&
            cikisYem2No[i] != 0 &&
            cikisYem1No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
      for (int k = 1; k <= 2; k++) {
        if (i != k &&
            cikisYem2No[i] == cikisYem3No[k] &&
            cikisYem2No[i] != 0 &&
            cikisYem3No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
      for (int k = 1; k <= 3; k++) {
        if (i != k &&
            cikisYem2No[i] == cikisAluyayNo[k] &&
            cikisYem2No[i] != 0 &&
            cikisAluyayNo[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
    }

    setState(() {});
  }

//Üst görünüşten haritadaki sensörlere numara atama işlemi
  degerGiris2X0Yrd4(var val) {
    if (_onlarOut != val[0] || _birlerOut != val[1]) {
      veriGonderildi = false;
    }

    _onlarOut = val[0];
    _birlerOut = val[1];
    _degerNo = val[2];

    cikisYem3No[_degerNo] =
        int.parse(_onlarOut.toString() + _birlerOut.toString());
    cikisNoTekerrur = false;

    for (int i = 1; i <= 2; i++) {
      for (int k = 1; k <= 2; k++) {
        if (i != k &&
            cikisYem3No[i] == cikisYem3No[k] &&
            cikisYem3No[i] != 0 &&
            cikisYem3No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
      for (int k = 1; k <= 2; k++) {
        if (i != k &&
            cikisYem3No[i] == cikisYem1No[k] &&
            cikisYem3No[i] != 0 &&
            cikisYem1No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
      for (int k = 1; k <= 2; k++) {
        if (i != k &&
            cikisYem3No[i] == cikisYem2No[k] &&
            cikisYem3No[i] != 0 &&
            cikisYem2No[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
      for (int k = 1; k <= 3; k++) {
        if (i != k &&
            cikisYem3No[i] == cikisAluyayNo[k] &&
            cikisYem3No[i] != 0 &&
            cikisAluyayNo[k] != 0) {
          cikisNoTekerrur = true;
          break;
        }
        if (cikisNoTekerrur) {
          break;
        }
      }
    }

    setState(() {});
  }

  _veriGonder(String dbKod, String id, String v1, String v2, String v3,
      String v4) async {
    Socket socket;

    try {
      socket = await Socket.connect('88.250.206.99', 2233);
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
              SelectLanguage().selectStrings(dilSecimi, "toast8"), context,
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
      Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast20"), context,
          duration: 3);
    }
  }

  Widget _aluyayGrupCikisAluyay(int index, double oran) {
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          Text(
            SelectLanguage().selectStrings(dilSecimi,
                index == 1 ? "tv86" : (index == 2 ? "tv87" : "tv88")),
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Kelly Slab',
                color: Colors.black,
                fontWeight: FontWeight.bold),
            textScaleFactor: oran,
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () {
                      _onlarOut = cikisAluyayNo[index] < 10
                          ? 0
                          : (cikisAluyayNo[index] ~/ 10).toInt();
                      _birlerOut = cikisAluyayNo[index] % 10;
                      _degerNo = index;

                      _degergiris2X0(
                          _onlarOut,
                          _birlerOut,
                          index,
                          oran,
                          dilSecimi,
                          index == 1 ? "tv86" : (index == 2 ? "tv87" : "tv88"),
                          1);
                      print(index);
                    },
                    fillColor: Colors.green[300],
                    child: Padding(
                      padding: EdgeInsets.all(3.0 * oran),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  cikisAluyayNo[index].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aluyayGrupCikisYem1(int index, double oran, bool aktif) {
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          Text(
            SelectLanguage()
                .selectStrings(dilSecimi, index == 1 ? "tv89" : "tv92"),
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Kelly Slab',
                color: Colors.black,
                fontWeight: FontWeight.bold),
            textScaleFactor: oran,
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () {
                      if (yem1Aktif) {
                        _onlarOut = cikisYem1No[index] < 10
                            ? 0
                            : (cikisYem1No[index] ~/ 10).toInt();
                        _birlerOut = cikisYem1No[index] % 10;
                        _degerNo = index;

                        _degergiris2X0(_onlarOut, _birlerOut, index, oran,
                            dilSecimi, index == 1 ? "tv89" : "tv92", 2);
                      }
                    },
                    fillColor: aktif ? Colors.green[300] : Colors.grey[600],
                    child: Padding(
                      padding: EdgeInsets.all(3.0 * oran),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  cikisYem1No[index].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aluyayGrupCikisYem2(int index, double oran, bool aktif) {
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          Text(
            SelectLanguage()
                .selectStrings(dilSecimi, index == 1 ? "tv90" : "tv93"),
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Kelly Slab',
                color: Colors.black,
                fontWeight: FontWeight.bold),
            textScaleFactor: oran,
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () {
                      if (yem2Aktif) {
                        _onlarOut = cikisYem2No[index] < 10
                            ? 0
                            : (cikisYem2No[index] ~/ 10).toInt();
                        _birlerOut = cikisYem2No[index] % 10;
                        _degerNo = index;

                        _degergiris2X0(_onlarOut, _birlerOut, index, oran,
                            dilSecimi, index == 1 ? "tv90" : "tv93", 3);
                      }
                    },
                    fillColor: aktif ? Colors.green[300] : Colors.grey[600],
                    child: Padding(
                      padding: EdgeInsets.all(3.0 * oran),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  cikisYem2No[index].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aluyayGrupCikisYem3(int index, double oran, bool aktif) {
    return Expanded(
      flex: 2,
      child: Column(
        children: <Widget>[
          Text(
            SelectLanguage()
                .selectStrings(dilSecimi, index == 1 ? "tv91" : "tv94"),
            style: TextStyle(
                fontSize: 14,
                fontFamily: 'Kelly Slab',
                color: Colors.black,
                fontWeight: FontWeight.bold),
            textScaleFactor: oran,
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 4,
                  child: RawMaterialButton(
                    onPressed: () {
                      if (yem3Aktif) {
                        _onlarOut = cikisYem3No[index] < 10
                            ? 0
                            : (cikisYem3No[index] ~/ 10).toInt();
                        _birlerOut = cikisYem3No[index] % 10;
                        _degerNo = index;

                        _degergiris2X0(_onlarOut, _birlerOut, index, oran,
                            dilSecimi, index == 1 ? "tv91" : "tv94", 4);
                      }
                    },
                    fillColor: aktif ? Colors.green[300] : Colors.grey[600],
                    child: Padding(
                      padding: EdgeInsets.all(3.0 * oran),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                child: AutoSizeText(
                                  cikisYem3No[index].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
                Spacer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cikislarUnsur(int index, double oran) {
    return Expanded(
      child: SizedBox(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(2 * oran),
              child: Container(
                color: tumCikislar[index] == 0
                    ? Colors.grey[300]
                    : (tumCikislar[index] == 1
                        ? Colors.blue[200]
                        : Colors.grey[300]),
                alignment: Alignment.center,
                child: AutoSizeText(
                  index.toString() + ": " + outConv(index),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25 * oran,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  minFontSize: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String outConv(int deger) {
    String sonuc = "";

    if (deger == 1)
      sonuc = "Q0.0";
    else if (deger == 2)
      sonuc = "Q0.1";
    else if (deger == 3)
      sonuc = "Q0.2";
    else if (deger == 4)
      sonuc = "Q0.3";
    else if (deger == 5)
      sonuc = "Q0.4";
    else if (deger == 6)
      sonuc = "Q0.5";
    else if (deger == 7)
      sonuc = "Q0.6";
    else if (deger == 8)
      sonuc = "Q0.7";
    else if (deger == 9)
      sonuc = "Q1.0";
    else if (deger == 10)
      sonuc = "Q1.1";
    else if (deger == 11)
      sonuc = "Q2.0";
    else if (deger == 12)
      sonuc = "Q2.1";
    else if (deger == 13)
      sonuc = "Q2.2";
    else if (deger == 14)
      sonuc = "Q2.3";
    else if (deger == 15)
      sonuc = "Q2.4";
    else if (deger == 16)
      sonuc = "Q2.5";
    else if (deger == 17)
      sonuc = "Q2.6";
    else if (deger == 18)
      sonuc = "Q2.7";
    else if (deger == 19)
      sonuc = "Q3.0";
    else if (deger == 20)
      sonuc = "Q3.1";
    else if (deger == 21)
      sonuc = "Q3.2";
    else if (deger == 22)
      sonuc = "Q3.3";
    else if (deger == 23)
      sonuc = "Q3.4";
    else if (deger == 24)
      sonuc = "Q3.5";
    else if (deger == 25)
      sonuc = "Q3.6";
    else if (deger == 26)
      sonuc = "Q3.7";
    else if (deger == 27)
      sonuc = "Q4.0";
    else if (deger == 28)
      sonuc = "Q4.1";
    else if (deger == 29)
      sonuc = "Q4.2";
    else if (deger == 30)
      sonuc = "Q4.3";
    else if (deger == 31)
      sonuc = "Q4.4";
    else if (deger == 32)
      sonuc = "Q4.5";
    else if (deger == 33)
      sonuc = "Q4.6";
    else if (deger == 34)
      sonuc = "Q4.7";
    else if (deger == 35)
      sonuc = "Q5.0";
    else if (deger == 36)
      sonuc = "Q5.1";
    else if (deger == 37)
      sonuc = "Q5.2";
    else if (deger == 38)
      sonuc = "Q5.3";
    else if (deger == 39)
      sonuc = "Q5.4";
    else if (deger == 40)
      sonuc = "Q5.5";
    else if (deger == 41)
      sonuc = "Q5.6";
    else if (deger == 42)
      sonuc = "Q5.7";
    else if (deger == 43)
      sonuc = "Q6.0";
    else if (deger == 44)
      sonuc = "Q6.1";
    else if (deger == 45)
      sonuc = "Q6.2";
    else if (deger == 46)
      sonuc = "Q6.3";
    else if (deger == 47)
      sonuc = "Q6.4";
    else if (deger == 48)
      sonuc = "Q6.5";
    else if (deger == 49)
      sonuc = "Q6.6";
    else if (deger == 50)
      sonuc = "Q6.7";
    else if (deger == 51)
      sonuc = "Q7.0";
    else if (deger == 52)
      sonuc = "Q7.1";
    else if (deger == 53)
      sonuc = "Q7.2";
    else if (deger == 54)
      sonuc = "Q7.3";
    else if (deger == 55)
      sonuc = "Q7.4";
    else if (deger == 56)
      sonuc = "Q7.5";
    else if (deger == 57)
      sonuc = "Q7.6";
    else if (deger == 58)
      sonuc = "Q7.7";
    else if (deger == 59)
      sonuc = "Q8.0";
    else if (deger == 60)
      sonuc = "Q8.1";
    else if (deger == 61)
      sonuc = "Q8.2";
    else if (deger == 62)
      sonuc = "Q8.3";
    else if (deger == 63)
      sonuc = "Q8.4";
    else if (deger == 64)
      sonuc = "Q8.5";
    else if (deger == 65)
      sonuc = "Q8.6";
    else if (deger == 66)
      sonuc = "Q8.7";
    else if (deger == 67)
      sonuc = "Q9.0";
    else if (deger == 68)
      sonuc = "Q9.1";
    else if (deger == 69)
      sonuc = "Q9.2";
    else if (deger == 70)
      sonuc = "Q9.3";
    else if (deger == 71)
      sonuc = "Q9.4";
    else if (deger == 72)
      sonuc = "Q9.5";
    else if (deger == 73)
      sonuc = "Q9.6";
    else if (deger == 74)
      sonuc = "Q9.7";
    else if (deger == 75)
      sonuc = "Q10.0";
    else if (deger == 76)
      sonuc = "Q10.1";
    else if (deger == 77)
      sonuc = "Q10.2";
    else if (deger == 78)
      sonuc = "Q10.3";
    else if (deger == 79)
      sonuc = "Q10.4";
    else if (deger == 80)
      sonuc = "Q10.5";
    else if (deger == 81)
      sonuc = "Q10.6";
    else if (deger == 82)
      sonuc = "Q10.7";
    else if (deger == 83)
      sonuc = "Q11.0";
    else if (deger == 84)
      sonuc = "Q11.1";
    else if (deger == 85)
      sonuc = "Q11.2";
    else if (deger == 86)
      sonuc = "Q11.3";
    else if (deger == 87)
      sonuc = "Q11.4";
    else if (deger == 88)
      sonuc = "Q11.5";
    else if (deger == 89)
      sonuc = "Q11.6";
    else if (deger == 90)
      sonuc = "Q11.7";
    else if (deger == 91)
      sonuc = "Q12.0";
    else if (deger == 92)
      sonuc = "Q12.1";
    else if (deger == 93)
      sonuc = "Q12.2";
    else if (deger == 94)
      sonuc = "Q12.3";
    else if (deger == 95)
      sonuc = "Q12.4";
    else if (deger == 96)
      sonuc = "Q12.5";
    else if (deger == 97)
      sonuc = "Q12.6";
    else if (deger == 98)
      sonuc = "Q12.7";
    else if (deger == 99)
      sonuc = "Q13.0";
    else if (deger == 100)
      sonuc = "Q13.1";
    else if (deger == 101)
      sonuc = "Q13.2";
    else if (deger == 102)
      sonuc = "Q13.3";
    else if (deger == 103)
      sonuc = "Q13.4";
    else if (deger == 104)
      sonuc = "Q13.5";
    else if (deger == 105)
      sonuc = "Q13.6";
    else if (deger == 106)
      sonuc = "Q13.7";
    else if (deger == 107)
      sonuc = "Q14.0";
    else if (deger == 108)
      sonuc = "Q14.1";
    else if (deger == 109)
      sonuc = "Q14.2";
    else if (deger == 110)
      sonuc = "Q14.3";
    else if (deger == 111)
      sonuc = "Q14.4";
    else if (deger == 112)
      sonuc = "Q14.5";
    else if (deger == 113)
      sonuc = "Q14.6";
    else if (deger == 114)
      sonuc = "114.7";
    else if (deger == 115)
      sonuc = "Q15.0";
    else if (deger == 116)
      sonuc = "Q15.1";
    else if (deger == 117)
      sonuc = "Q15.2";
    else if (deger == 118)
      sonuc = "Q15.3";
    else if (deger == 119)
      sonuc = "Q15.4";
    else if (deger == 120)
      sonuc = "Q15.5";
    else if (deger == 121)
      sonuc = "Q15.6";
    else if (deger == 122)
      sonuc = "Q15.7";
    else if (deger == 123)
      sonuc = "Q16.0";
    else {
      sonuc = "";
    }

    return sonuc;
  }


//--------------------------METOTLAR--------------------------------

}
