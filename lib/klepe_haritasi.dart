import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/ped_haritasi.dart';
import 'package:toast/toast.dart';
import 'genel/alert_reset.dart';
import 'genel/cikis_alert.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x2x0.dart';
import 'genel/deger_giris_2x2x2x0.dart';
import 'genel/deger_giris_3x0.dart';
import 'languages/select.dart';

class KlepeHaritasi extends StatefulWidget {
  List<Map> gelenDBveri;
  KlepeHaritasi(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }
  @override
  State<StatefulWidget> createState() {
    return KlepeHaritasiState(gelenDBveri);
  }
}

class KlepeHaritasiState extends State<KlepeHaritasi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  List<int> klepeHarita = new List(19);
  List<bool> klepeVisibility = new List(19);
  List<int> klepeNo = new List(19);
  List<int> cikisNoAc = new List(19);
  List<int> cikisNoGeciciAc = new List(19);
  List<int> cikisNoKapa = new List(19);
  List<int> cikisNoGeciciKapa = new List(19);
  bool haritaOnay = false;
  int klepeAdet = 0;

  int _onlarklepe = 1;
  int _birlerklepe = 0;
  int _onlarOutAc = 3;
  int _onlarOutKapa = 3;
  int _birlerOutAc = 3;
  int _birlerOutKapa = 3;
  int _degerNo = 0;

  double _oran1;
  bool veriGonderildi = false;
  bool klepeNoTekerrur = false;
  bool cikisNoTekerrur = false;

  List<int> tumCikislar = new List(111);

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  KlepeHaritasiState(List<Map> dbVeri) {
    bool klepeHaritaOK = false;
    bool klepeCikisOK = false;
    bool tumCikislarVar = false;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {
        klepeAdet = int.parse(dbVeri[i]["veri2"]);
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

      if (dbVeri[i]["id"] == 16) {
        if (dbVeri[i]["veri1"] == "ok") {
          klepeHaritaOK = true;
          String xx = dbVeri[i]["veri2"];
          var fHaritalar = xx.split("#");
          for (int i = 1; i <= 18; i++) {
            klepeHarita[i] = int.parse(fHaritalar[i - 1]);
            if (fHaritalar[i - 1] != "0") {
              haritaOnay = true;
            }
          }

          for (int i = 1; i <= 18; i++) {
            if (klepeHarita[i] != 0) {
              klepeVisibility[i] = true;
            } else {
              klepeVisibility[i] = false;
            }
          }
        }
      }

      if (dbVeri[i]["id"] == 17) {
        String xx;
        String yy;
        String zz;

        if (dbVeri[i]["veri1"] == "ok") {
          klepeCikisOK = true;
          veriGonderildi = true;
          xx = dbVeri[i]["veri2"];
          yy = dbVeri[i]["veri3"];
          zz = dbVeri[i]["veri4"];
          var klepeNolar = xx.split("#");
          var cikisNolarAc = yy.split("#");
          var cikisNolarKapa = zz.split("#");
          for (int i = 1; i <= 18; i++) {
            klepeNo[i] = int.parse(klepeNolar[i - 1]);
            cikisNoAc[i] = int.parse(cikisNolarAc[i - 1]);
            cikisNoKapa[i] = int.parse(cikisNolarKapa[i - 1]);
          }
        }
      }
    }

    if (!klepeHaritaOK) {
      for (int i = 1; i <= 18; i++) {
        klepeHarita[i] = 0;
        klepeVisibility[i] = true;
      }
    }

    if (!klepeCikisOK) {
      for (int i = 1; i <= 18; i++) {
        klepeNo[i] = 0;
        cikisNoAc[i] = 0;
        cikisNoKapa[i] = 0;
      }
    }

    if (!tumCikislarVar) {
      for (int i = 1; i <= 110; i++) {
        tumCikislar[i] = 0;
      }
    }

    for (int i = 1; i <= 18; i++) {
        cikisNoGeciciAc[i]=cikisNoAc[i];
        cikisNoGeciciKapa[i]=cikisNoKapa[i];
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
                      SelectLanguage().selectStrings(dilSecimi, "tv38"),
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
        //klepe Harita Oluşturma Bölümü
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
                //Tüm duvarlar Klepe görünümü
                Expanded(
                  flex: 6,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      //Ön ve Sağ Duvar
                      Expanded(
                        flex: 20,
                        child: Row(
                          children: <Widget>[
                            //Ön Duvar
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv53"),
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
                                flex: 8,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.pink,
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/onarka_duvar_gri_icon.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Visibility(
                                          child: _klepeHaritaUnsur(1),
                                          visible:
                                              klepeVisibility[1] ? true : false,
                                        ),
                                        Visibility(
                                          child: _klepeHaritaUnsur(2),
                                          visible:
                                              klepeVisibility[2] ? true : false,
                                        ),
                                        Visibility(
                                          child: _klepeHaritaUnsur(3),
                                          visible:
                                              klepeVisibility[3] ? true : false,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                            Spacer(),
                            //Sağ Duvar
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv54"),
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
                                flex: 16,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.pink,
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/sagsol_duvar_gri_icon.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Visibility(
                                                child: _klepeHaritaUnsur(4),
                                                visible: klepeVisibility[4]
                                                    ? true
                                                    : false,
                                              ),
                                              Visibility(
                                                child: _klepeHaritaUnsur(5),
                                                visible: klepeVisibility[5]
                                                    ? true
                                                    : false,
                                              ),
                                              Visibility(
                                                child: _klepeHaritaUnsur(6),
                                                visible: klepeVisibility[6]
                                                    ? true
                                                    : false,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Visibility(
                                                child: _klepeHaritaUnsur(7),
                                                visible: klepeVisibility[7]
                                                    ? true
                                                    : false,
                                              ),
                                              Visibility(
                                                child: _klepeHaritaUnsur(8),
                                                visible: klepeVisibility[8]
                                                    ? true
                                                    : false,
                                              ),
                                              Visibility(
                                                child: _klepeHaritaUnsur(9),
                                                visible: klepeVisibility[9]
                                                    ? true
                                                    : false,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Spacer(),
                      //Arka ve Sol Duvar
                      Expanded(
                        flex: 20,
                        child: Row(
                          children: <Widget>[
                            //Arka Duvar
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv55"),
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
                                flex: 8,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.pink,
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/onarka_duvar_gri_icon.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Visibility(
                                          child: _klepeHaritaUnsur(16),
                                          visible: klepeVisibility[16]
                                              ? true
                                              : false,
                                        ),
                                        Visibility(
                                          child: _klepeHaritaUnsur(17),
                                          visible: klepeVisibility[17]
                                              ? true
                                              : false,
                                        ),
                                        Visibility(
                                          child: _klepeHaritaUnsur(18),
                                          visible: klepeVisibility[18]
                                              ? true
                                              : false,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                            Spacer(),
                            //Sol Duvar
                            Expanded(
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: SizedBox(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      SelectLanguage()
                                          .selectStrings(dilSecimi, "tv56"),
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
                                flex: 16,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.pink,
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/sagsol_duvar_gri_icon.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Visibility(
                                                child: _klepeHaritaUnsur(10),
                                                visible: klepeVisibility[10]
                                                    ? true
                                                    : false,
                                              ),
                                              Visibility(
                                                child: _klepeHaritaUnsur(11),
                                                visible: klepeVisibility[11]
                                                    ? true
                                                    : false,
                                              ),
                                              Visibility(
                                                child: _klepeHaritaUnsur(12),
                                                visible: klepeVisibility[12]
                                                    ? true
                                                    : false,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Visibility(
                                                child: _klepeHaritaUnsur(13),
                                                visible: klepeVisibility[13]
                                                    ? true
                                                    : false,
                                              ),
                                              Visibility(
                                                child: _klepeHaritaUnsur(14),
                                                visible: klepeVisibility[14]
                                                    ? true
                                                    : false,
                                              ),
                                              Visibility(
                                                child: _klepeHaritaUnsur(15),
                                                visible: klepeVisibility[15]
                                                    ? true
                                                    : false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Visibility(visible: haritaOnay,
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

                            for (int i = 1; i <= 18; i++) {
                              if (klepeHarita[i] == 1) {
                                sayac++;
                              }
                            }

                            if (sayac < klepeAdet) {
                              //Haritada seçilen klepe sayısı eksik
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast29"),
                                  context,
                                  duration: 3);
                            } else if (sayac > klepeAdet) {
                              //Haritada seçilen klepe sayısı yüksek
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast30"),
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

                              for (int i = 1; i <= 18; i++) {
                                if (klepeHarita[i] != 0) {
                                  klepeVisibility[i] = true;
                                } else {
                                  klepeVisibility[i] = false;
                                }
                              }

                              String veri = "";

                              for (int i = 1; i <= 18; i++) {
                                veri = veri + klepeHarita[i].toString() + "#";
                              }

                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  16, "ok", veri, "0", "0");

                              _veriGonder("15", "21", veri, "0", "0", "0");

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
                                size: 30*oran,
                              ),
                              Text(
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "btn4"),
                                style: TextStyle(fontSize: 18),textScaleFactor: oran,
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
                                size: 30*oran,
                              ),
                              Text(
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "btn5"),
                                style: TextStyle(fontSize: 18),textScaleFactor: oran,
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
                            bool cikisKullanimda=false;
                            String cikisVeriAc = "";
                            String cikisVeriKapa = "";
                            String noVeri = "";
                            String tumCikislarVeri = "";
                            for (int i = 1; i <= 18; i++) {
                              if (klepeHarita[i] == 1) {
                                if (klepeNo[i] == 0 ||
                                    cikisNoAc[i] == 0 ||
                                    cikisNoKapa[i] == 0) {
                                  noKontrol = true;
                                }
                              }
                              cikisVeriAc =
                                  cikisVeriAc + cikisNoAc[i].toString() + "#";
                              cikisVeriKapa = cikisVeriKapa +
                                  cikisNoKapa[i].toString() +
                                  "#";
                              noVeri = noVeri + klepeNo[i].toString() + "#";
                            }




                            for(int i=1;i<=18;i++){
                                  if(cikisNoGeciciAc[i]!=cikisNoAc[i]){
                                  
                                  if(tumCikislar[cikisNoAc[i]]==0){
                                      tumCikislar[cikisNoGeciciAc[i]]=0;
                                  }else{
                                    cikisKullanimda=true;
                                  }
                                    
                                  }

                                  if(cikisNoGeciciKapa[i]!=cikisNoKapa[i]){
                                  
                                  if(tumCikislar[cikisNoKapa[i]]==0){
                                      tumCikislar[cikisNoGeciciKapa[i]]=0;
                                  }else{
                                    cikisKullanimda=true;
                                  }
                                    
                                  }
                              }

                              if(!cikisKullanimda){
                              for(int i=1;i<=18;i++){
                                if(cikisNoAc[i]!=0){
                                  tumCikislar[cikisNoAc[i]]=1;
                                }
                                if(cikisNoKapa[i]!=0){
                                  tumCikislar[cikisNoKapa[i]]=1;
                                }
                              }
                              }
                              for(int i=1;i<=110;i++){
                                  tumCikislarVeri = tumCikislarVeri + tumCikislar[i].toString() + "#";
                              }






                            if (noKontrol) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast37"),
                                  context,
                                  duration: 3);
                            } else if (klepeNoTekerrur) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast28"),
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
                            }else {
                              veriGonderildi = true;

                              _veriGonder("16", "22", noVeri, cikisVeriAc,
                                  cikisVeriKapa, "0");
                                  _veriGonder(
                                  "25", "27", tumCikislarVeri, "0", "0", "0");
                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  17, "ok", noVeri, cikisVeriAc, cikisVeriKapa).then((deneme){
                                    dbHelper.veriYOKSAekleVARSAguncelle(
                                  22, "ok", tumCikislarVeri, "0", "0");
                                  });


                                  for (int i = 1; i <= 18; i++) {
                                  cikisNoGeciciAc[i]=cikisNoAc[i];
                                  cikisNoGeciciKapa[i]=cikisNoKapa[i];
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
                                size: 30*oran,
                              ),
                              Text(
                                SelectLanguage()
                                    .selectStrings(dilSecimi, "btn6"),
                                style: TextStyle(fontSize: 18),textScaleFactor: oran,
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
                        Navigator.pop(context,tumCikislar);
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
                                builder: (context) => PedHaritasi(dbVeriler)),
                          ).then((onValue) {
                            _dbVeriCekme();
                            for(int i=1;i<=110;i++){
                              tumCikislar[i]= onValue[i];
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
      imagePath = 'assets/images/klepe_harita_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Future _degergiris2X2X2X0() async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X2X2X0.Deger(
            _onlarklepe,
            _birlerklepe,
            _onlarOutAc,
            _birlerOutAc,
            _onlarOutKapa,
            _birlerOutKapa,
            _degerNo,
            _oran1,
            dilSecimi,
            "tv40");
      },
    ).then((val) {
      if (_onlarklepe != val[0] ||
          _birlerklepe != val[1] ||
          _onlarOutAc != val[2] ||
          _birlerOutAc != val[3] ||
          _onlarOutKapa != val[4] ||
          _birlerOutKapa != val[5]) {
        veriGonderildi = false;
      }
      _onlarklepe = val[0];
      _birlerklepe = val[1];
      _onlarOutAc = val[2];
      _birlerOutAc = val[3];
      _onlarOutKapa = val[4];
      _birlerOutKapa = val[5];
      _degerNo = val[6];

      klepeNo[_degerNo] =
          int.parse(_onlarklepe.toString() + _birlerklepe.toString());
      cikisNoAc[_degerNo] =
          int.parse(_onlarOutAc.toString() + _birlerOutAc.toString());
      cikisNoKapa[_degerNo] =
          int.parse(_onlarOutKapa.toString() + _birlerOutKapa.toString());
      klepeNoTekerrur = false;
      cikisNoTekerrur = false;

      for (int i = 1; i <= 18; i++) {
        for (int k = 1; k <= 18; k++) {
          if (i != k &&
              klepeNo[i] == klepeNo[k] &&
              klepeNo[i] != 0 &&
              klepeNo[k] != 0) {
            klepeNoTekerrur = true;
            break;
          }
          if (klepeNoTekerrur) {
            break;
          }
          if (i != k &&
              cikisNoAc[i] == cikisNoAc[k] &&
              cikisNoAc[i] != 0 &&
              cikisNoAc[k] != 0) {
            cikisNoTekerrur = true;
            break;
          }

          if (i != k &&
              cikisNoKapa[i] == cikisNoKapa[k] &&
              cikisNoKapa[i] != 0 &&
              cikisNoKapa[k] != 0) {
            cikisNoTekerrur = true;
            break;
          }
          if (cikisNoAc[i] == cikisNoKapa[k] &&
              cikisNoAc[i] != 0 &&
              cikisNoKapa[k] != 0) {
            cikisNoTekerrur = true;
            break;
          }
        }
        if (cikisNoTekerrur) {
          break;
        }
      }

      setState(() {});
    });
  }

  Widget _klepeHaritaUnsur(int indexNo) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: RawMaterialButton(
                onPressed: () {
                  if (haritaOnay) {
                    _onlarklepe = klepeNo[indexNo] < 10
                        ? 0
                        : (klepeNo[indexNo] ~/ 10).toInt();
                    _birlerklepe = klepeNo[indexNo] % 10;
                    _onlarOutAc = cikisNoAc[indexNo] < 10
                        ? 0
                        : (cikisNoAc[indexNo] ~/ 10).toInt();
                    _birlerOutAc = cikisNoAc[indexNo] % 10;
                    _onlarOutKapa = cikisNoKapa[indexNo] < 10
                        ? 0
                        : (cikisNoKapa[indexNo] ~/ 10).toInt();
                    _birlerOutKapa = cikisNoKapa[indexNo] % 10;
                    _degerNo = indexNo;
                    _degergiris2X2X2X0();
                  } else {
                    if (klepeHarita[indexNo] == 0 ||
                        klepeHarita[indexNo] == null) {
                      klepeHarita[indexNo] = 1;
                    } else if (klepeHarita[indexNo] == 1) {
                      klepeHarita[indexNo] = 0;
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
                            image: AssetImage(imageGetir(klepeHarita[indexNo])),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      opacity: klepeVisibility[indexNo] &&
                              haritaOnay &&
                              klepeHarita[indexNo] == 1
                          ? 1
                          : 1,
                    ),
                    Visibility(
                      visible: haritaOnay && klepeHarita[indexNo] != 0
                          ? true
                          : false,
                      child: Visibility(
                        visible: haritaOnay && klepeHarita[indexNo] == 1
                            ? true
                            : false,
                        child: Row(
                          children: <Widget>[
                            Spacer(),
                            //klepe No
                            Expanded(
                              flex: 4,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                                  dilSecimi, "tv39") +
                                              klepeNo[indexNo].toString(),
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
                            //Çıkış NoAc
                            Expanded(
                              flex: 6,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                                  dilSecimi, "tv43") +
                                              cikisNoAc[indexNo].toString(),
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
                            //Çıkış NoKapa
                            Expanded(
                              flex: 6,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                                  dilSecimi, "tv44") +
                                              cikisNoKapa[indexNo].toString(),
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
      socket = await Socket.connect('192.168.2.110', 2233);
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
        String tumCikislarVeri="";

        for (int i = 1; i <= 18; i++) {
          if(cikisNoAc[i] != 0){
            tumCikislar[cikisNoAc[i]]=0;
          }
          if(cikisNoKapa[i] != 0){
            tumCikislar[cikisNoKapa[i]]=0;
          }
        }

        for(int i=1;i<=110;i++){
            tumCikislarVeri = tumCikislarVeri + tumCikislar[i].toString() + "#";
        }

        
        for (int i = 1; i <= 18; i++) {
          klepeHarita[i] = 0;
          klepeNo[i] = 0;
          cikisNoAc[i] = 0;
          cikisNoKapa[i] = 0;
          klepeVisibility[i] = true;
        }
        haritaOnay = false;

        dbHelper.veriYOKSAekleVARSAguncelle(16, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(17, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(22, "ok", tumCikislarVeri, "0", "0");
        _veriGonder("17", "0", "0", "0", "0", "0");
        _veriGonder("25", "27", tumCikislarVeri, "0", "0", "0");

        setState(() {});
      }
    });
  }


Widget _cikislarUnsur(int index, double oran) {
    return Expanded(
                                  child: SizedBox(
                                    child: Stack(alignment: Alignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(2*oran),
                                          child: Container(color: tumCikislar[index]==0 ? Colors.grey[300] : (tumCikislar[index]==1 ? Colors.blue[200] : Colors.grey[300]),
                                            alignment: Alignment.center,
                                            child: AutoSizeText(
                                              index.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25*oran,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              minFontSize: 8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
  }


//--------------------------METOTLAR--------------------------------

}
