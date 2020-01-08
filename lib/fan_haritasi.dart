import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'genel/alert_reset.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x2x0.dart';
import 'genel/deger_giris_3x0.dart';
import 'klepe_haritasi.dart';
import 'languages/select.dart';

class FanHaritasi extends StatefulWidget {
  List<Map> gelenDBveri;
  FanHaritasi(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }
  @override
  State<StatefulWidget> createState() {
    return FanHaritasiState(gelenDBveri);
  }
}

class FanHaritasiState extends State<FanHaritasi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  List<int> fanHarita = new List(121);
  List<bool> fanVisibility = new List(121);
  List<int> fanNo = new List(121);
  List<int> cikisNo = new List(121);
  List<int> cikisNoGecici = new List(121);
  List<bool> sutun = new List(13);
  bool haritaOnay = false;
  int fanAdet = 0;

  int _onlarFan = 1;
  int _birlerFan = 0;
  int _onlarOut = 3;
  int _birlerOut = 3;
  int _degerNo = 0;

  double _oran1;
  bool veriGonderildi = false;
  bool fanNoTekerrur = false;
  bool cikisNoTekerrur = false;

  List<int> tumCikislar = new List(111);

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  FanHaritasiState(List<Map> dbVeri) {
    bool fanHaritaOK = false;
    bool fanCikisOK = false;
    bool tumCikislarVar = false;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 4) {
        fanAdet = int.parse(dbVeri[i]["veri1"]);
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

      if (dbVeri[i]["id"] == 14) {
        if (dbVeri[i]["veri1"] == "ok") {
          fanHaritaOK = true;
          String xx = dbVeri[i]["veri2"];
          var fHaritalar = xx.split("#");
          for (int i = 1; i <= 120; i++) {
            fanHarita[i] = int.parse(fHaritalar[i - 1]);
            if (fHaritalar[i - 1] != "0") {
              haritaOnay = true;
            }
          }

          for (int i = 1; i <= 12; i++) {
            sutun[i] = false;
          }

          for (int i = 1; i <= 120; i++) {
            if (fanHarita[i] != 0) {
              fanVisibility[i] = true;
              if (i % 12 == 1) {
                sutun[1] = true;
              } else if (i % 12 == 2) {
                sutun[2] = true;
              } else if (i % 12 == 3) {
                sutun[3] = true;
              } else if (i % 12 == 4) {
                sutun[4] = true;
              } else if (i % 12 == 5) {
                sutun[5] = true;
              } else if (i % 12 == 6) {
                sutun[6] = true;
              } else if (i % 12 == 7) {
                sutun[7] = true;
              } else if (i % 12 == 8) {
                sutun[8] = true;
              } else if (i % 12 == 9) {
                sutun[9] = true;
              } else if (i % 12 == 10) {
                sutun[10] = true;
              } else if (i % 12 == 11) {
                sutun[11] = true;
              } else if (i % 12 == 0) {
                sutun[12] = true;
              }
            } else {
              fanVisibility[i] = false;
            }
          }
        }
      }

      if (dbVeri[i]["id"] == 15) {
        String xx;
        String yy;

        if (dbVeri[i]["veri1"] == "ok") {
          fanCikisOK = true;
          veriGonderildi = true;
          xx = dbVeri[i]["veri2"];
          yy = dbVeri[i]["veri3"];
          var fanNolar = xx.split("#");
          var cikisNolar = yy.split("#");
          for (int i = 1; i <= 120; i++) {
            fanNo[i] = int.parse(fanNolar[i - 1]);
            cikisNo[i] = int.parse(cikisNolar[i - 1]);
          }
        }
      }
    }

    if (!fanHaritaOK) {
      for (int i = 1; i <= 120; i++) {
        fanHarita[i] = 0;
        fanVisibility[i] = true;
      }

      for (int i = 1; i <= 12; i++) {
        sutun[i] = true;
      }
    }

    if (!fanCikisOK) {
      for (int i = 1; i <= 120; i++) {
        fanNo[i] = 0;
        cikisNo[i] = 0;
      }
    }

    if (!tumCikislarVar) {
      for (int i = 1; i <= 110; i++) {
        tumCikislar[i] = 0;
      }
    }

    for (int i = 1; i <= 120; i++) {
      cikisNoGecici[i] = cikisNo[i];
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
    _oran1 = oran;
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
                      SelectLanguage().selectStrings(dilSecimi, "tv31"),
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
        //Fan Harita Oluşturma Bölümü
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Spacer(flex: 1),
                //Harita Satır ve sütunlar
                Expanded(
                  flex: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //Sütun 1
                      Visibility(
                        visible: sutun[1],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*1
                              Visibility(
                                child: _fanHaritaUnsur(1, oran),
                                visible: fanVisibility[1] ? true : false,
                              ),
                              //2*1
                              Visibility(
                                child: _fanHaritaUnsur(13, oran),
                                visible: fanVisibility[13] ? true : false,
                              ),
                              //3*1
                              Visibility(
                                child: _fanHaritaUnsur(25, oran),
                                visible: fanVisibility[25] ? true : false,
                              ),
                              //4*1
                              Visibility(
                                child: _fanHaritaUnsur(37, oran),
                                visible: fanVisibility[37] ? true : false,
                              ),
                              //5*1
                              Visibility(
                                child: _fanHaritaUnsur(49, oran),
                                visible: fanVisibility[49] ? true : false,
                              ),
                              //6*1
                              Visibility(
                                child: _fanHaritaUnsur(61, oran),
                                visible: fanVisibility[61] ? true : false,
                              ),
                              //7*1
                              Visibility(
                                child: _fanHaritaUnsur(73, oran),
                                visible: fanVisibility[73] ? true : false,
                              ),
                              //8*1
                              Visibility(
                                child: _fanHaritaUnsur(85, oran),
                                visible: fanVisibility[85] ? true : false,
                              ),
                              //9*1
                              Visibility(
                                child: _fanHaritaUnsur(97, oran),
                                visible: fanVisibility[97] ? true : false,
                              ),
                              //10*1
                              Visibility(
                                child: _fanHaritaUnsur(109, oran),
                                visible: fanVisibility[109] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 2
                      Visibility(
                        visible: sutun[2],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*2
                              Visibility(
                                child: _fanHaritaUnsur(2, oran),
                                visible: fanVisibility[2] ? true : false,
                              ),
                              //2*2
                              Visibility(
                                child: _fanHaritaUnsur(14, oran),
                                visible: fanVisibility[14] ? true : false,
                              ),
                              //3*2
                              Visibility(
                                child: _fanHaritaUnsur(26, oran),
                                visible: fanVisibility[26] ? true : false,
                              ),
                              //4*2
                              Visibility(
                                child: _fanHaritaUnsur(38, oran),
                                visible: fanVisibility[38] ? true : false,
                              ),
                              //5*2
                              Visibility(
                                child: _fanHaritaUnsur(50, oran),
                                visible: fanVisibility[50] ? true : false,
                              ),
                              //6*2
                              Visibility(
                                child: _fanHaritaUnsur(62, oran),
                                visible: fanVisibility[62] ? true : false,
                              ),
                              //7*2
                              Visibility(
                                child: _fanHaritaUnsur(74, oran),
                                visible: fanVisibility[74] ? true : false,
                              ),
                              //8*2
                              Visibility(
                                child: _fanHaritaUnsur(86, oran),
                                visible: fanVisibility[86] ? true : false,
                              ),
                              //9*2
                              Visibility(
                                child: _fanHaritaUnsur(98, oran),
                                visible: fanVisibility[98] ? true : false,
                              ),
                              //10*2
                              Visibility(
                                child: _fanHaritaUnsur(110, oran),
                                visible: fanVisibility[110] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 3
                      Visibility(
                        visible: sutun[3],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*3
                              Visibility(
                                child: _fanHaritaUnsur(3, oran),
                                visible: fanVisibility[3] ? true : false,
                              ),
                              //2*3
                              Visibility(
                                child: _fanHaritaUnsur(15, oran),
                                visible: fanVisibility[15] ? true : false,
                              ),
                              //3*3
                              Visibility(
                                child: _fanHaritaUnsur(27, oran),
                                visible: fanVisibility[27] ? true : false,
                              ),
                              //4*3
                              Visibility(
                                child: _fanHaritaUnsur(39, oran),
                                visible: fanVisibility[39] ? true : false,
                              ),
                              //5*3
                              Visibility(
                                child: _fanHaritaUnsur(51, oran),
                                visible: fanVisibility[51] ? true : false,
                              ),
                              //6*3
                              Visibility(
                                child: _fanHaritaUnsur(63, oran),
                                visible: fanVisibility[63] ? true : false,
                              ),
                              //7*3
                              Visibility(
                                child: _fanHaritaUnsur(75, oran),
                                visible: fanVisibility[75] ? true : false,
                              ),
                              //8*3
                              Visibility(
                                child: _fanHaritaUnsur(87, oran),
                                visible: fanVisibility[87] ? true : false,
                              ),
                              //9*3
                              Visibility(
                                child: _fanHaritaUnsur(99, oran),
                                visible: fanVisibility[99] ? true : false,
                              ),
                              //10*3
                              Visibility(
                                child: _fanHaritaUnsur(111, oran),
                                visible: fanVisibility[111] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 4
                      Visibility(
                        visible: sutun[4],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*4
                              Visibility(
                                child: _fanHaritaUnsur(4, oran),
                                visible: fanVisibility[4] ? true : false,
                              ),
                              //2*4
                              Visibility(
                                child: _fanHaritaUnsur(16, oran),
                                visible: fanVisibility[16] ? true : false,
                              ),
                              //3*4
                              Visibility(
                                child: _fanHaritaUnsur(28, oran),
                                visible: fanVisibility[28] ? true : false,
                              ),
                              //4*4
                              Visibility(
                                child: _fanHaritaUnsur(40, oran),
                                visible: fanVisibility[40] ? true : false,
                              ),
                              //5*4
                              Visibility(
                                child: _fanHaritaUnsur(52, oran),
                                visible: fanVisibility[52] ? true : false,
                              ),
                              //6*4
                              Visibility(
                                child: _fanHaritaUnsur(64, oran),
                                visible: fanVisibility[64] ? true : false,
                              ),
                              //7*4
                              Visibility(
                                child: _fanHaritaUnsur(76, oran),
                                visible: fanVisibility[76] ? true : false,
                              ),
                              //8*4
                              Visibility(
                                child: _fanHaritaUnsur(88, oran),
                                visible: fanVisibility[88] ? true : false,
                              ),
                              //9*4
                              Visibility(
                                child: _fanHaritaUnsur(100, oran),
                                visible: fanVisibility[100] ? true : false,
                              ),
                              //10*4
                              Visibility(
                                child: _fanHaritaUnsur(112, oran),
                                visible: fanVisibility[112] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 5
                      Visibility(
                        visible: sutun[5],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*5
                              Visibility(
                                child: _fanHaritaUnsur(5, oran),
                                visible: fanVisibility[5] ? true : false,
                              ),
                              //2*5
                              Visibility(
                                child: _fanHaritaUnsur(17, oran),
                                visible: fanVisibility[17] ? true : false,
                              ),
                              //3*5
                              Visibility(
                                child: _fanHaritaUnsur(29, oran),
                                visible: fanVisibility[29] ? true : false,
                              ),
                              //4*5
                              Visibility(
                                child: _fanHaritaUnsur(41, oran),
                                visible: fanVisibility[41] ? true : false,
                              ),
                              //5*5
                              Visibility(
                                child: _fanHaritaUnsur(53, oran),
                                visible: fanVisibility[53] ? true : false,
                              ),
                              //6*5
                              Visibility(
                                child: _fanHaritaUnsur(65, oran),
                                visible: fanVisibility[65] ? true : false,
                              ),
                              //7*5
                              Visibility(
                                child: _fanHaritaUnsur(77, oran),
                                visible: fanVisibility[77] ? true : false,
                              ),
                              //8*5
                              Visibility(
                                child: _fanHaritaUnsur(89, oran),
                                visible: fanVisibility[89] ? true : false,
                              ),
                              //9*5
                              Visibility(
                                child: _fanHaritaUnsur(101, oran),
                                visible: fanVisibility[101] ? true : false,
                              ),
                              //10*5
                              Visibility(
                                child: _fanHaritaUnsur(113, oran),
                                visible: fanVisibility[113] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 6
                      Visibility(
                        visible: sutun[6],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*6
                              Visibility(
                                child: _fanHaritaUnsur(6, oran),
                                visible: fanVisibility[6] ? true : false,
                              ),
                              //2*6
                              Visibility(
                                child: _fanHaritaUnsur(18, oran),
                                visible: fanVisibility[18] ? true : false,
                              ),
                              //3*6
                              Visibility(
                                child: _fanHaritaUnsur(30, oran),
                                visible: fanVisibility[30] ? true : false,
                              ),
                              //4*6
                              Visibility(
                                child: _fanHaritaUnsur(42, oran),
                                visible: fanVisibility[42] ? true : false,
                              ),
                              //5*6
                              Visibility(
                                child: _fanHaritaUnsur(54, oran),
                                visible: fanVisibility[54] ? true : false,
                              ),
                              //6*6
                              Visibility(
                                child: _fanHaritaUnsur(66, oran),
                                visible: fanVisibility[66] ? true : false,
                              ),
                              //7*6
                              Visibility(
                                child: _fanHaritaUnsur(78, oran),
                                visible: fanVisibility[78] ? true : false,
                              ),
                              //8*6
                              Visibility(
                                child: _fanHaritaUnsur(90, oran),
                                visible: fanVisibility[90] ? true : false,
                              ),
                              //9*6
                              Visibility(
                                child: _fanHaritaUnsur(102, oran),
                                visible: fanVisibility[102] ? true : false,
                              ),
                              //10*6
                              Visibility(
                                child: _fanHaritaUnsur(114, oran),
                                visible: fanVisibility[114] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 7
                      Visibility(
                        visible: sutun[7],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*7
                              Visibility(
                                child: _fanHaritaUnsur(7, oran),
                                visible: fanVisibility[7] ? true : false,
                              ),
                              //2*7
                              Visibility(
                                child: _fanHaritaUnsur(19, oran),
                                visible: fanVisibility[19] ? true : false,
                              ),
                              //3*7
                              Visibility(
                                child: _fanHaritaUnsur(31, oran),
                                visible: fanVisibility[31] ? true : false,
                              ),
                              //4*7
                              Visibility(
                                child: _fanHaritaUnsur(43, oran),
                                visible: fanVisibility[43] ? true : false,
                              ),
                              //5*7
                              Visibility(
                                child: _fanHaritaUnsur(55, oran),
                                visible: fanVisibility[55] ? true : false,
                              ),
                              //6*7
                              Visibility(
                                child: _fanHaritaUnsur(67, oran),
                                visible: fanVisibility[67] ? true : false,
                              ),
                              //7*7
                              Visibility(
                                child: _fanHaritaUnsur(79, oran),
                                visible: fanVisibility[79] ? true : false,
                              ),
                              //8*7
                              Visibility(
                                child: _fanHaritaUnsur(91, oran),
                                visible: fanVisibility[91] ? true : false,
                              ),
                              //9*7
                              Visibility(
                                child: _fanHaritaUnsur(103, oran),
                                visible: fanVisibility[103] ? true : false,
                              ),
                              //10*7
                              Visibility(
                                child: _fanHaritaUnsur(115, oran),
                                visible: fanVisibility[115] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 8
                      Visibility(
                        visible: sutun[8],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*8
                              Visibility(
                                child: _fanHaritaUnsur(8, oran),
                                visible: fanVisibility[8] ? true : false,
                              ),
                              //2*8
                              Visibility(
                                child: _fanHaritaUnsur(20, oran),
                                visible: fanVisibility[20] ? true : false,
                              ),
                              //3*8
                              Visibility(
                                child: _fanHaritaUnsur(32, oran),
                                visible: fanVisibility[32] ? true : false,
                              ),
                              //4*8
                              Visibility(
                                child: _fanHaritaUnsur(44, oran),
                                visible: fanVisibility[44] ? true : false,
                              ),
                              //5*8
                              Visibility(
                                child: _fanHaritaUnsur(56, oran),
                                visible: fanVisibility[56] ? true : false,
                              ),
                              //6*8
                              Visibility(
                                child: _fanHaritaUnsur(68, oran),
                                visible: fanVisibility[68] ? true : false,
                              ),
                              //7*8
                              Visibility(
                                child: _fanHaritaUnsur(80, oran),
                                visible: fanVisibility[80] ? true : false,
                              ),
                              //8*8
                              Visibility(
                                child: _fanHaritaUnsur(92, oran),
                                visible: fanVisibility[92] ? true : false,
                              ),
                              //9*8
                              Visibility(
                                child: _fanHaritaUnsur(104, oran),
                                visible: fanVisibility[104] ? true : false,
                              ),
                              //10*8
                              Visibility(
                                child: _fanHaritaUnsur(116, oran),
                                visible: fanVisibility[116] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 9
                      Visibility(
                        visible: sutun[9],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*9
                              Visibility(
                                child: _fanHaritaUnsur(9, oran),
                                visible: fanVisibility[9] ? true : false,
                              ),
                              //2*9
                              Visibility(
                                child: _fanHaritaUnsur(21, oran),
                                visible: fanVisibility[21] ? true : false,
                              ),
                              //3*9
                              Visibility(
                                child: _fanHaritaUnsur(33, oran),
                                visible: fanVisibility[33] ? true : false,
                              ),
                              //4*9
                              Visibility(
                                child: _fanHaritaUnsur(45, oran),
                                visible: fanVisibility[45] ? true : false,
                              ),
                              //5*9
                              Visibility(
                                child: _fanHaritaUnsur(57, oran),
                                visible: fanVisibility[57] ? true : false,
                              ),
                              //6*9
                              Visibility(
                                child: _fanHaritaUnsur(69, oran),
                                visible: fanVisibility[69] ? true : false,
                              ),
                              //7*9
                              Visibility(
                                child: _fanHaritaUnsur(81, oran),
                                visible: fanVisibility[81] ? true : false,
                              ),
                              //8*9
                              Visibility(
                                child: _fanHaritaUnsur(93, oran),
                                visible: fanVisibility[93] ? true : false,
                              ),
                              //9*9
                              Visibility(
                                child: _fanHaritaUnsur(105, oran),
                                visible: fanVisibility[105] ? true : false,
                              ),
                              //10*9
                              Visibility(
                                child: _fanHaritaUnsur(117, oran),
                                visible: fanVisibility[117] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 10
                      Visibility(
                        visible: sutun[10],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*10
                              Visibility(
                                child: _fanHaritaUnsur(10, oran),
                                visible: fanVisibility[10] ? true : false,
                              ),
                              //2*10
                              Visibility(
                                child: _fanHaritaUnsur(22, oran),
                                visible: fanVisibility[22] ? true : false,
                              ),
                              //3*10
                              Visibility(
                                child: _fanHaritaUnsur(34, oran),
                                visible: fanVisibility[34] ? true : false,
                              ),
                              //4*10
                              Visibility(
                                child: _fanHaritaUnsur(46, oran),
                                visible: fanVisibility[46] ? true : false,
                              ),
                              //5*10
                              Visibility(
                                child: _fanHaritaUnsur(58, oran),
                                visible: fanVisibility[58] ? true : false,
                              ),
                              //6*10
                              Visibility(
                                child: _fanHaritaUnsur(70, oran),
                                visible: fanVisibility[70] ? true : false,
                              ),
                              //7*10
                              Visibility(
                                child: _fanHaritaUnsur(82, oran),
                                visible: fanVisibility[82] ? true : false,
                              ),
                              //8*10
                              Visibility(
                                child: _fanHaritaUnsur(94, oran),
                                visible: fanVisibility[94] ? true : false,
                              ),
                              //9*10
                              Visibility(
                                child: _fanHaritaUnsur(106, oran),
                                visible: fanVisibility[106] ? true : false,
                              ),
                              //10*10
                              Visibility(
                                child: _fanHaritaUnsur(118, oran),
                                visible: fanVisibility[118] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 11
                      Visibility(
                        visible: sutun[11],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*11
                              Visibility(
                                child: _fanHaritaUnsur(11, oran),
                                visible: fanVisibility[11] ? true : false,
                              ),
                              //2*11
                              Visibility(
                                child: _fanHaritaUnsur(23, oran),
                                visible: fanVisibility[23] ? true : false,
                              ),
                              //3*11
                              Visibility(
                                child: _fanHaritaUnsur(35, oran),
                                visible: fanVisibility[35] ? true : false,
                              ),
                              //4*11
                              Visibility(
                                child: _fanHaritaUnsur(47, oran),
                                visible: fanVisibility[47] ? true : false,
                              ),
                              //5*11
                              Visibility(
                                child: _fanHaritaUnsur(59, oran),
                                visible: fanVisibility[59] ? true : false,
                              ),
                              //6*11
                              Visibility(
                                child: _fanHaritaUnsur(71, oran),
                                visible: fanVisibility[71] ? true : false,
                              ),
                              //7*11
                              Visibility(
                                child: _fanHaritaUnsur(83, oran),
                                visible: fanVisibility[83] ? true : false,
                              ),
                              //8*11
                              Visibility(
                                child: _fanHaritaUnsur(95, oran),
                                visible: fanVisibility[95] ? true : false,
                              ),
                              //9*11
                              Visibility(
                                child: _fanHaritaUnsur(107, oran),
                                visible: fanVisibility[107] ? true : false,
                              ),
                              //10*11
                              Visibility(
                                child: _fanHaritaUnsur(119, oran),
                                visible: fanVisibility[119] ? true : false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Sütun 12
                      Visibility(
                        visible: sutun[12],
                        child: Expanded(
                          child: Column(
                            children: <Widget>[
                              //1*12
                              Visibility(
                                child: _fanHaritaUnsur(12, oran),
                                visible: fanVisibility[12] ? true : false,
                              ),
                              //2*12
                              Visibility(
                                child: _fanHaritaUnsur(24, oran),
                                visible: fanVisibility[24] ? true : false,
                              ),
                              //3*12
                              Visibility(
                                child: _fanHaritaUnsur(36, oran),
                                visible: fanVisibility[36] ? true : false,
                              ),
                              //4*12
                              Visibility(
                                child: _fanHaritaUnsur(48, oran),
                                visible: fanVisibility[48] ? true : false,
                              ),
                              //5*12
                              Visibility(
                                child: _fanHaritaUnsur(60, oran),
                                visible: fanVisibility[60] ? true : false,
                              ),
                              //6*12
                              Visibility(
                                child: _fanHaritaUnsur(72, oran),
                                visible: fanVisibility[72] ? true : false,
                              ),
                              //7*12
                              Visibility(
                                child: _fanHaritaUnsur(84, oran),
                                visible: fanVisibility[84] ? true : false,
                              ),
                              //8*12
                              Visibility(
                                child: _fanHaritaUnsur(96, oran),
                                visible: fanVisibility[96] ? true : false,
                              ),
                              //9*12
                              Visibility(
                                child: _fanHaritaUnsur(108, oran),
                                visible: fanVisibility[108] ? true : false,
                              ),
                              //10*12
                              Visibility(
                                child: _fanHaritaUnsur(120, oran),
                                visible: fanVisibility[120] ? true : false,
                              ),
                            ],
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
                  flex: 6,
                  child: Visibility(
                    visible: haritaOnay,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: Container(
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "tv62"),
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
                          flex: 20,
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
                      //Haritayı Onayla Butonu
                      Visibility(
                        visible: !haritaOnay,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: FlatButton(
                          onPressed: () {
                            int sayac = 0;
                            List<int> satir = new List(11);
                            bool dikdortgenHata = false;

                            for (int i = 1; i <= 10; i++) {
                              satir[i] = 0;
                            }

                            for (int i = 1; i <= 12; i++) {
                              if (fanHarita[i] != 0) {
                                satir[1]++;
                              }
                              if (fanHarita[i + 12] != 0) {
                                satir[2]++;
                              }
                              if (fanHarita[i + 24] != 0) {
                                satir[3]++;
                              }
                              if (fanHarita[i + 36] != 0) {
                                satir[4]++;
                              }
                              if (fanHarita[i + 48] != 0) {
                                satir[5]++;
                              }
                              if (fanHarita[i + 60] != 0) {
                                satir[6]++;
                              }
                              if (fanHarita[i + 72] != 0) {
                                satir[7]++;
                              }
                              if (fanHarita[i + 84] != 0) {
                                satir[8]++;
                              }
                              if (fanHarita[i + 96] != 0) {
                                satir[9]++;
                              }
                              if (fanHarita[i + 108] != 0) {
                                satir[10]++;
                              }
                            }

                            for (int i = 1; i <= 10; i++) {
                              for (int k = 1; k <= 10; k++) {
                                if (satir[i] != satir[k] &&
                                    satir[i] != 0 &&
                                    satir[k] != 0) {
                                  dikdortgenHata = true;
                                }
                              }
                            }

                            for (int i = 1; i <= 120; i++) {
                              if (fanHarita[i] == 2) {
                                sayac++;
                              }
                            }

                            if (sayac < fanAdet) {
                              //Haritada seçilen fan sayısı eksik
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast16"),
                                  context,
                                  duration: 3);
                            } else if (sayac > fanAdet) {
                              //Haritada seçilen fan sayısı yüksek
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast17"),
                                  context,
                                  duration: 3);
                            } else if (dikdortgenHata) {
                              //Dikdörtgen seçim hatası
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast18"),
                                  context,
                                  duration: 3);
                            } else {
                              //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast8"),
                                  context,
                                  duration: 3);
                              haritaOnay = true;

                              for (int i = 1; i <= 12; i++) {
                                sutun[i] = false;
                              }

                              for (int i = 1; i <= 120; i++) {
                                if (fanHarita[i] != 0) {
                                  fanVisibility[i] = true;
                                  if (i % 12 == 1) {
                                    sutun[1] = true;
                                  } else if (i % 12 == 2) {
                                    sutun[2] = true;
                                  } else if (i % 12 == 3) {
                                    sutun[3] = true;
                                  } else if (i % 12 == 4) {
                                    sutun[4] = true;
                                  } else if (i % 12 == 5) {
                                    sutun[5] = true;
                                  } else if (i % 12 == 6) {
                                    sutun[6] = true;
                                  } else if (i % 12 == 7) {
                                    sutun[7] = true;
                                  } else if (i % 12 == 8) {
                                    sutun[8] = true;
                                  } else if (i % 12 == 9) {
                                    sutun[9] = true;
                                  } else if (i % 12 == 10) {
                                    sutun[10] = true;
                                  } else if (i % 12 == 11) {
                                    sutun[11] = true;
                                  } else if (i % 12 == 0) {
                                    sutun[12] = true;
                                  }
                                } else {
                                  fanVisibility[i] = false;
                                }
                              }

                              String veri = "";

                              for (int i = 1; i <= 120; i++) {
                                veri = veri + fanHarita[i].toString() + "#";
                              }
                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  14, "ok", veri, "0", "0");

                              _veriGonder("12", "19", veri, "0", "0", "0");

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
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "btn4"),
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
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "btn5"),
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
                            bool cikisKullanimda = false;
                            bool fanNOyuksek = false;
                            String cikisVeri = "";
                            String noVeri = "";
                            String tumCikislarVeri = "";
                            for (int i = 1; i <= 120; i++) {
                              if (fanHarita[i] == 2) {
                                if (fanNo[i] == 0 || cikisNo[i] == 0) {
                                  noKontrol = true;
                                }
                                if (fanNo[i] > fanAdet) {
                                  fanNOyuksek = true;
                                }
                              }
                              cikisVeri =
                                  cikisVeri + cikisNo[i].toString() + "#";
                              noVeri = noVeri + fanNo[i].toString() + "#";
                            }

                            for (int i = 1; i <= 120; i++) {
                              if (cikisNoGecici[i] != cikisNo[i]) {
                                if (tumCikislar[cikisNo[i]] == 0) {
                                  tumCikislar[cikisNoGecici[i]] = 0;
                                } else {
                                  cikisKullanimda = true;
                                }
                              }
                            }

                            if (noKontrol) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast24"),
                                  context,
                                  duration: 3);
                            } else if (fanNOyuksek) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast47"),
                                  context,
                                  duration: 3);
                            } else if (fanNoTekerrur) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast25"),
                                  context,
                                  duration: 3);
                            } else if (cikisNoTekerrur) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast26"),
                                  context,
                                  duration: 3);
                            } else if (cikisKullanimda) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast38"),
                                  context,
                                  duration: 3);
                            } else {

                              for (int i = 1; i <= 120; i++) {
                                if (cikisNo[i] != 0) {
                                  tumCikislar[cikisNo[i]] = 1;
                                }
                              }

                              for(int i=1;i<=110;i++){
                                  tumCikislarVeri = tumCikislarVeri + tumCikislar[i].toString() + "#";
                              }
                              
                              veriGonderildi = true;
                              _veriGonder(
                                  "13", "20", noVeri, cikisVeri, "0", "0");
                              _veriGonder(
                                  "25", "27", tumCikislarVeri, "0", "0", "0");
                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  15, "ok", noVeri, cikisVeri, "0");

                              dbHelper
                                  .veriYOKSAekleVARSAguncelle(
                                      22, "ok", tumCikislarVeri, "0", "0")
                                  .then((onValue) {
                                _dbVeriCekme();
                              });

                              for (int i = 1; i <= 120; i++) {
                                cikisNoGecici[i] = cikisNo[i];
                              }
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
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "btn6"),
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
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      iconSize: 50 * oran,
                      onPressed: () {
                        Navigator.pop(context);
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
                        if (!haritaOnay) {
                          Toast.show(
                              SelectLanguage()
                                  .selectStrings(dilSecimi, "toast62"),
                              context,
                              duration: 3);
                        } else if (!veriGonderildi) {
                          print(haritaOnay);
                          Toast.show(
                              SelectLanguage()
                                  .selectStrings(dilSecimi, "toast27"),
                              context,
                              duration: 3);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KlepeHaritasi(dbVeriler)),
                          ).then((onValue) {
                            _dbVeriCekme();
                            for (int i = 1; i <= 110; i++) {
                              tumCikislar[i] = onValue[i];
                            }
                          });
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

  String imageGetir(int deger) {
    String imagePath;
    if (deger == 0) {
      imagePath = 'assets/images/soru_isareti.png';
    } else if (deger == 1) {
      imagePath = 'assets/images/duvar_icon.png';
    } else if (deger == 2) {
      imagePath = 'assets/images/fan_on_gorunuz_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Future _degergiris2X2X0(int onlarX, birlerX, onlarY, birlerY, index,
      double oran, String dil, baslik1, baslik2) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X2X0.Deger(onlarX, birlerX, onlarY, birlerY, index,
            oran, dil, baslik1, baslik2);
      },
    ).then((val) {
      if (_onlarFan != val[0] ||
          _birlerFan != val[1] ||
          _onlarOut != val[2] ||
          _birlerOut != val[3]) {
        veriGonderildi = false;
      }
      _onlarFan = val[0];
      _birlerFan = val[1];
      _onlarOut = val[2];
      _birlerOut = val[3];
      _degerNo = val[4];

      fanNo[_degerNo] = int.parse(_onlarFan.toString() + _birlerFan.toString());
      cikisNo[_degerNo] =
          int.parse(_onlarOut.toString() + _birlerOut.toString());
      fanNoTekerrur = false;
      cikisNoTekerrur = false;

      for (int i = 1; i <= 120; i++) {
        for (int k = 1; k <= 120; k++) {
          if (i != k &&
              fanNo[i] == fanNo[k] &&
              fanNo[i] != 0 &&
              fanNo[k] != 0) {
            fanNoTekerrur = true;
            break;
          }
          if (fanNoTekerrur) {
            break;
          }
          if (i != k &&
              cikisNo[i] == cikisNo[k] &&
              cikisNo[i] != 0 &&
              cikisNo[k] != 0) {
            cikisNoTekerrur = true;
            break;
          }
          if (cikisNoTekerrur) {
            break;
          }
        }
      }
      setState(() {});
    });
  }

  Widget _fanHaritaUnsur(int indexNo, double oran) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: RawMaterialButton(
                onPressed: () {
                  if (haritaOnay) {
                    if (fanHarita[indexNo] == 2) {
                      _onlarFan = fanNo[indexNo] < 10
                          ? 0
                          : (fanNo[indexNo] ~/ 10).toInt();
                      _birlerFan = fanNo[indexNo] % 10;
                      _onlarOut = cikisNo[indexNo] < 10
                          ? 0
                          : (cikisNo[indexNo] ~/ 10).toInt();
                      _birlerOut = cikisNo[indexNo] % 10;
                      _degerNo = indexNo;
                      _degergiris2X2X0(_onlarFan, _birlerFan, _onlarOut,
                          _birlerOut, indexNo, oran, dilSecimi, "tv34", "tv35");
                    }
                  } else {
                    if (fanHarita[indexNo] == 0 || fanHarita[indexNo] == null) {
                      fanHarita[indexNo] = 1;
                    } else if (fanHarita[indexNo] == 1) {
                      fanHarita[indexNo] = 2;
                    } else if (fanHarita[indexNo] == 2) {
                      fanHarita[indexNo] = 0;
                    }

                    setState(() {});
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Opacity(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage(imageGetir(fanHarita[indexNo])),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      opacity: fanVisibility[indexNo] &&
                              haritaOnay &&
                              fanHarita[indexNo] == 2
                          ? 0.6
                          : 1,
                    ),
                    Visibility(
                      visible:
                          haritaOnay && fanHarita[indexNo] != 0 ? true : false,
                      child: Visibility(
                        visible: haritaOnay && fanHarita[indexNo] == 2
                            ? true
                            : false,
                        child: Column(
                          children: <Widget>[
                            Spacer(),
                            //Fan No
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                                  dilSecimi, "tv32") +
                                              fanNo[indexNo].toString(),
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
                            //Çıkış No
                            Expanded(
                              flex: 2,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                                  dilSecimi, "tv33") +
                                              cikisNo[indexNo].toString(),
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
                            Spacer()
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
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
        String tumCikislarVeri = "";

        for (int i = 1; i <= 120; i++) {
          if (cikisNo[i] != 0) {
            tumCikislar[cikisNo[i]] = 0;
          }
        }

        for (int i = 1; i <= 110; i++) {
          tumCikislarVeri = tumCikislarVeri + tumCikislar[i].toString() + "#";
        }

        for (int i = 1; i <= 120; i++) {
          fanHarita[i] = 0;
          fanNo[i] = 0;
          cikisNo[i] = 0;
          fanVisibility[i] = true;
        }
        for (int i = 1; i <= 12; i++) {
          sutun[i] = true;
        }
        haritaOnay = false;

        dbHelper.veriYOKSAekleVARSAguncelle(14, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(15, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(
            22, "ok", tumCikislarVeri, "0", "0");
        _veriGonder("14", "0", "0", "0", "0", "0");
        _veriGonder("25", "27", tumCikislarVeri, "0", "0", "0");

        setState(() {});
      }
    });
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
