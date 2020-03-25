import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/airinlet_haritasi.dart';
import 'package:prokis/silo_haritasi.dart';
import 'package:toast/toast.dart';
import 'diger_cikislar.dart';
import 'genel/alert_reset.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x0.dart';
import 'genel/deger_giris_2x2x0.dart';
import 'genel/sayfa_geri_alert.dart';
import 'isisensor_haritasi.dart';
import 'isitici_haritasi.dart';
import 'kurulum_ayarlari.dart';
import 'languages/select.dart';

class BacafanHaritasi extends StatefulWidget {
  List<Map> gelenDBveri;
  bool gelenDurum;
  BacafanHaritasi(List<Map> dbVeriler,bool durum) {
    gelenDBveri = dbVeriler;
    gelenDurum=durum;
  }
  @override
  State<StatefulWidget> createState() {
    return BacafanHaritasiState(gelenDBveri,gelenDurum);
  }
}

class BacafanHaritasiState extends State<BacafanHaritasi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  List<int> bacafanHarita = new List(27);
  List<bool> bacafanVisibility = new List(27);
  List<int> bacafanNo = new List(27);
  List<int> cikisNo = new List(4);
  List<int> cikisNoGecici = new List(4);
  bool haritaOnay = false;
  int bacafanVarMi = 0;
  String airinletAdet = '0';
  String isiticiAdet = '0';
  String siloAdet = '0';
  
  bool dijitalCikis=true;
  bool analogCikis=false;
  String cikisTur="1";    //1:0-10V   2:4-20mA

  int _onlarbacafan = 0;
  int _birlerbacafan = 0;
  int _onlarOut = 3;
  int _birlerOut = 3;
  int _degerNo = 0;

  double oran1;
  bool veriGonderildi = false;
  bool cikisNoTekerrur = false;

  bool baglanti = false;
  bool timerCancel = false;

  List<int> tumCikislar = new List(111);

  bool durum;

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  BacafanHaritasiState(List<Map> dbVeri,bool drm) {
    bool bacafanHaritaOK = false;
    bool bacafanNoOK = false;
    bool tumCikislarVar = false;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 5) {
        bacafanVarMi = int.parse(dbVeri[i]["veri1"]);
        airinletAdet=dbVeri[i]["veri2"];
        isiticiAdet=dbVeri[i]["veri3"];
        siloAdet=dbVeri[i]["veri4"];
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

      if (dbVeri[i]["id"] == 23) {
        if (dbVeri[i]["veri1"] == "ok") {
          bacafanHaritaOK = true;
          String xx = dbVeri[i]["veri2"];
          var fHaritalar = xx.split("#");
          for (int i = 1; i <= 26; i++) {
            bacafanHarita[i] = int.parse(fHaritalar[i - 1]);
            if (fHaritalar[i - 1] != "0") {
              haritaOnay = true;
            }
          }

          for (int i = 1; i <= 26; i++) {
            if (bacafanHarita[i] != 0) {
              bacafanVisibility[i] = true;
            } else {
              bacafanVisibility[i] = false;
            }
          }
        }
      }

      if (dbVeri[i]["id"] == 24) {
        String xx;
        String yy;
        String zz;

        if (dbVeri[i]["veri1"] == "ok") {
          bacafanNoOK = true;
          veriGonderildi = true;
          xx = dbVeri[i]["veri2"];
          yy = dbVeri[i]["veri3"];
          zz = dbVeri[i]["veri4"];
          var bacafanNolar = xx.split("#");
          var bacafanCikis = yy.split("#");
          var bacafanCikisVeri = zz.split("*");
          for (int i = 1; i <= 26; i++) {
            bacafanNo[i] = int.parse(bacafanNolar[i - 1]);
          }
          for (int i = 1; i <= 3; i++) {
            cikisNo[i] = int.parse(bacafanCikis[i - 1]);
          }
          dijitalCikis=bacafanCikisVeri[0]=="1" ? true :false;
          analogCikis=bacafanCikisVeri[1]=="1" ? true :false;
          cikisTur=bacafanCikisVeri[2];

        }
      }



    }

    if (!bacafanHaritaOK) {
      for (int i = 1; i <= 26; i++) {
        bacafanHarita[i] = 0;
        bacafanVisibility[i] = true;
      }
    }

    if (!bacafanNoOK) {
      for (int i = 1; i <= 26; i++) {
        if (bacafanVarMi == 1) {
          bacafanNo[i] = 1;
        } else {
          bacafanNo[i] = 0;
        }
      }
      for (int i = 1; i <= 3; i++) {
        cikisNo[i] = 0;
      }
    }

    if (!tumCikislarVar) {
      for (int i = 1; i <= 110; i++) {
        tumCikislar[i] = 0;
      }
    }

    for (int i = 1; i <= 3; i++) {
      cikisNoGecici[i] = cikisNo[i];
    }

    durum=drm;

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++EKRAN BÜYÜKLÜĞÜ ORANI+++++++++++++++++++++++++++++++
    var oran = MediaQuery.of(context).size.width / 731.4;
    oran1 = oran;
//--------------------------EKRAN BÜYÜKLÜĞÜ ORANI--------------------------------

//++++++++++++++++++++++++++SCAFFOLD+++++++++++++++++++++++++++++++
    return Scaffold(
      floatingActionButton: Visibility(visible: !durum,
          child: Container(width: 40*oran,height: 40*oran,
            child: FittedBox(
                        child: FloatingActionButton(
                onPressed: () {
                  if(veriGonderildi){
                    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
                  );
                  }else{
                    _sayfaGeriAlert(dilSecimi, "tv564");
                  }
                  
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
                      Dil().sec(dilSecimi, "tv68"),
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
        //bacafan Harita Oluşturma Bölümü
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
                Expanded(
                  flex: 12,
                  child: Column(
                    children: <Widget>[
                      //Bacafan çıkış tercihleri bölümü
                      Expanded(
                        flex: 10,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(),
                              Expanded(flex: 2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Spacer(),
                                                Expanded(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    child: Container(
                                                      alignment: Alignment.bottomCenter,
                                                      child: AutoSizeText(
                                                        Dil().sec(dilSecimi, "tv66"),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Kelly Slab',
                                                          color: Colors.black,
                                                          fontSize: 60,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                        maxLines: 3,
                                                        minFontSize: 8,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(alignment: Alignment.topCenter,
                                                    child: RawMaterialButton(
                                                      
                                          onPressed: () {

                                            if (!dijitalCikis) {
                                              dijitalCikis=true;
                                              analogCikis=false;
                                              veriGonderildi=false;
                                            }

                                            setState(() {});
                                          },
                                          child: Icon(
                                            dijitalCikis
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: dijitalCikis
                                                ? Colors.green[600]
                                                : Colors.blue[700],
                                            size: 30 * oran,
                                          ),
                                          padding: EdgeInsets.all(0),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                        ),
                                                  ),
                                                ),
                                                //Spacer(flex: 1,)
                                              ],
                                            ),
                                          ),
                              Spacer(),
                              Expanded(flex: 2,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Spacer(),
                                                Expanded(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    child: Container(
                                                      alignment: Alignment.bottomCenter,
                                                      child: AutoSizeText(
                                                        Dil().sec(dilSecimi, "tv67"),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Kelly Slab',
                                                          color: Colors.black,
                                                          fontSize: 60,
                                                          fontWeight: FontWeight.bold
                                                        ),
                                                        maxLines: 3,
                                                        minFontSize: 8,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(alignment: Alignment.topCenter,
                                                    child: RawMaterialButton(
                                                      
                                          onPressed: () {

                                            if (!analogCikis) {
                                              dijitalCikis=false;
                                              analogCikis=true;
                                              veriGonderildi=false;
                                            }
                                            setState(() {});
                                          },
                                          child: Icon(
                                            analogCikis
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: analogCikis
                                                ? Colors.green[600]
                                                : Colors.blue[700],
                                            size: 30 * oran,
                                          ),
                                          padding: EdgeInsets.all(0),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                        ),
                                                  ),
                                                ),
                                                //Spacer(flex: 1,)
                                              ],
                                            ),
                                          ),
                              Spacer(),
                              Expanded(flex: 2,
                                            child: Visibility(visible: analogCikis,
                                                                                          child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Spacer(),
                                                  Expanded(
                                                    flex: 2,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.bottomCenter,
                                                        child: AutoSizeText(
                                                          Dil().sec(dilSecimi, "tv492"),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily: 'Kelly Slab',
                                                            color: Colors.grey[600],
                                                            fontSize: 60,
                                                            fontWeight: FontWeight.bold
                                                          ),
                                                          maxLines: 3,
                                                          minFontSize: 8,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(alignment: Alignment.topCenter,
                                                      child: RawMaterialButton(
                                                        
                                          onPressed: () {

                                              if (cikisTur!="1") {
                                                cikisTur="1";
                                                veriGonderildi=false;
                                              }

                                              setState(() {});
                                          },
                                          child: Icon(
                                              cikisTur=="1"
                                                  ? Icons.check_box
                                                  : Icons.check_box_outline_blank,
                                              color: cikisTur=="1"
                                                  ? Colors.green[600]
                                                  : Colors.black,
                                              size: 25 * oran,
                                          ),
                                          padding: EdgeInsets.all(0),
                                          materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                        ),
                                                    ),
                                                  ),
                                                  //Spacer(flex: 1,)
                                                ],
                                              ),
                                            ),
                                          ),
                              Spacer(),
                              Expanded(flex: 2,
                                            child: Visibility(visible: analogCikis,
                                                                                          child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Spacer(),
                                                  Expanded(
                                                    flex: 2,
                                                    child: SizedBox(
                                                      child: Container(
                                                        alignment: Alignment.bottomCenter,
                                                        child: AutoSizeText(
                                                          Dil().sec(dilSecimi, "tv493"),
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily: 'Kelly Slab',
                                                            color: Colors.grey[600],
                                                            fontSize: 60,
                                                            fontWeight: FontWeight.bold
                                                          ),
                                                          maxLines: 3,
                                                          minFontSize: 8,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(alignment: Alignment.topCenter,
                                                      child: RawMaterialButton(
                                                        
                                          onPressed: () {

                                              if (cikisTur!="2") {
                                                cikisTur="2";
                                                veriGonderildi=false;
                                              }
                                              setState(() {});
                                          },
                                          child: Icon(
                                              cikisTur=="2"
                                                  ? Icons.check_box
                                                  : Icons.check_box_outline_blank,
                                              color: cikisTur=="2"
                                                  ? Colors.green[600]
                                                  : Colors.black,
                                              size: 25 * oran,
                                          ),
                                          padding: EdgeInsets.all(0),
                                          materialTapTargetSize:
                                                MaterialTapTargetSize.shrinkWrap,
                                          constraints: BoxConstraints(),
                                        ),
                                                    ),
                                                  ),
                                                  //Spacer(flex: 1,)
                                                ],
                                              ),
                                            ),
                                          ),
                              Spacer(),
                              Expanded(
                                flex: 5,
                                child: Column(
                                    children: <Widget>[
                                      Spacer(),
                                      _bacaFanGrupCikis(1, oran),
                                      Spacer(),
                                    ],
                                  ),
                              ),
                              Spacer(),
                              
                            ],
                          ),
                        ),
                      ),

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
                                        image: DecorationImage(
                                          alignment: Alignment.center,
                                          image: AssetImage(
                                              "assets/images/bina_catili_ust_gorunum.png"),
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
                                                    _bacafanHaritaUnsur(
                                                        1, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        2, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        3, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        4, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        5, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        6, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        7, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        8, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        9, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        10, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        11, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        12, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        13, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        14, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        15, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        16, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        17, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        18, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        19, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        20, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        21, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        22, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        23, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        24, oran, "tv64", 1),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    _bacafanHaritaUnsur(
                                                        25, oran, "tv64", 1),
                                                    Spacer(),
                                                    _bacafanHaritaUnsur(
                                                        26, oran, "tv64", 1),
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
                ),
                Expanded(
                  flex: 6,
                  child: Visibility(
                    visible: haritaOnay,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            child: Container(
                              alignment: Alignment.center,
                              child: AutoSizeText(
                                Dil()
                                    .sec(dilSecimi, "tv62"),
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
                            //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                            bool seciliHeaterVarmi = false;
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast8"),
                                context,
                                duration: 3);
                            haritaOnay = true;
                            int no=0;
                            for (int i = 1; i <= 26; i++) {
                              if (bacafanHarita[i] != 0) {
                                bacafanVisibility[i] = true;
                                seciliHeaterVarmi = true;
                                no++;
                                bacafanNo[i]=no;
                              } else {
                                bacafanVisibility[i] = false;
                              }
                            }

                            String veri = "";

                            for (int i = 1; i <= 26; i++) {
                              veri = veri + bacafanHarita[i].toString() + "#";
                            }

                            if (!seciliHeaterVarmi) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast53"),
                                  context,
                                  duration: 3);
                            } else {
                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  23, "ok", veri, "0", "0");

                              _veriGonder("26", "28", veri, "0", "0", "0");

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
                            bool noKontrol1 = false;
                            bool noKontrol2 = false;
                            bool cikisKullanimda = false;
                            String noVeri = "";
                            String cikisNolar = "";
                            String cikisTurSecimi = "";
                            String tumCikislarVeri = "";
                            for (int i = 1; i <= 26; i++) {
                              if (bacafanHarita[i] == 1) {
                                if (bacafanNo[i] == 0) {
                                  noKontrol1 = true;
                                }
                              }
                              noVeri = noVeri + bacafanNo[i].toString() + "#";
                            }
                            for (int i = 1; i <= 3; i++) {
                              if (cikisNo[i] == 0 && bacafanVarMi >= i) {
                                noKontrol2 = true;
                              }

                              cikisNolar =
                                  cikisNolar + cikisNo[i].toString() + "#";
                            }

                            cikisTurSecimi=(dijitalCikis ? "1" : "0") + "*" + (analogCikis ? "1" : "0")+"*"+cikisTur;

                            for (int i = 1; i <= 3; i++) {
                              if (cikisNoGecici[i] != cikisNo[i]) {
                                if (tumCikislar[cikisNo[i]] == 0) {
                                  tumCikislar[cikisNoGecici[i]] = 0;
                                } else {
                                  cikisKullanimda = true;
                                }
                              }
                            }

                            if (noKontrol1) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast39"),
                                  context,
                                  duration: 3);
                            }
                            else if (noKontrol2) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast63"),
                                  context,
                                  duration: 3);
                            } else if (cikisNoTekerrur) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast26"),
                                  context,
                                  duration: 3);
                            } else if (cikisKullanimda) {
                              Toast.show(
                                  Dil()
                                      .sec(dilSecimi, "toast38"),
                                  context,
                                  duration: 3);
                            } else {

                              for (int i = 1; i <= 3; i++) {
                                if (cikisNo[i] != 0) {
                                  tumCikislar[cikisNo[i]] = 1;
                                }
                              }

                              for (int i = 1; i <= 110; i++) {
                                tumCikislarVeri = tumCikislarVeri +
                                    tumCikislar[i].toString() +
                                    "#";
                              }
                              veriGonderildi = true;

                              _veriGonder(
                                  "27", "29", noVeri, cikisNolar, cikisTurSecimi, "0");
                              _veriGonder(
                                  "25", "27", tumCikislarVeri, "0", "0", "0");
                              dbHelper
                                  .veriYOKSAekleVARSAguncelle(
                                      24, "ok", noVeri, cikisNolar, cikisTurSecimi)
                                  .then((deneme) {
                                dbHelper
                                    .veriYOKSAekleVARSAguncelle(
                                        22, "ok", tumCikislarVeri, "0", "0")
                                    .then((onValue) {
                                  _dbVeriCekme();
                                });
                              });

                              for (int i = 1; i <= 3; i++) {
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
                                  builder: (context) =>
                                      IsiSensorHaritasi(dbVeriler,true)),
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
                          if (!haritaOnay) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast62"),
                                context,
                                duration: 3);
                          } else if (!veriGonderildi) {
                            Toast.show(
                                Dil()
                                    .sec(dilSecimi, "toast27"),
                                context,
                                duration: 3);
                          } else {

                            if(airinletAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AirInletHaritasi(dbVeriler,true)),
                              );
                            }else if(isiticiAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IsiticiHaritasi(dbVeriler,true)),
                              );
                            }else if(siloAdet!='0'){

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SiloHaritasi(dbVeriler,true)),
                              );
                            }else{

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DigerCikislar(dbVeriler,true)),
                              );
                            }

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
      imagePath = 'assets/images/harita_bacafan_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
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
      if (degerGirisKodu == 1) degerGiris2X0Yrd1(val);
      if (degerGirisKodu == 2) degerGiris2X0Yrd2(val);
    });
  }

  //Üst görünüşten haritadaki sensörlere numara atama işlemi
  degerGiris2X0Yrd1(var val) {
    if (_onlarbacafan != val[0] || _birlerbacafan != val[1]) {
      veriGonderildi = false;
    }

    _onlarbacafan = val[0];
    _birlerbacafan = val[1];
    _degerNo = val[2];

    bacafanNo[_degerNo] =
        int.parse(_onlarbacafan.toString() + _birlerbacafan.toString());

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

    cikisNo[_degerNo] = int.parse(_onlarOut.toString() + _birlerOut.toString());
    cikisNoTekerrur = false;

    for (int i = 1; i <= 3; i++) {
      for (int k = 1; k <= 3; k++) {
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
  }

  Widget _bacafanHaritaUnsur(
      int indexNo, double oran, String baslik, int degerGirisKodu) {
    return Expanded(
      child: Visibility(
        visible: bacafanVisibility[indexNo] ? true : false,
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
                      _onlarbacafan = bacafanNo[indexNo] < 10
                          ? 0
                          : (bacafanNo[indexNo] ~/ 10).toInt();
                      _birlerbacafan = bacafanNo[indexNo] % 10;
                      _degerNo = indexNo;
                      _degergiris2X0(_onlarbacafan, _birlerbacafan, indexNo,
                          oran, dilSecimi, baslik, degerGirisKodu);
                    } else {
                      if (bacafanHarita[indexNo] == 0 ||
                          bacafanHarita[indexNo] == null) {
                        bacafanHarita[indexNo] = 1;
                      } else if (bacafanHarita[indexNo] == 1) {
                        bacafanHarita[indexNo] = 0;
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
                              image: AssetImage(
                                  imageGetir(bacafanHarita[indexNo])),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        opacity: bacafanVisibility[indexNo] &&
                                haritaOnay &&
                                bacafanHarita[indexNo] == 1
                            ? 1
                            : 1,
                      ),
                      Visibility(
                        visible: haritaOnay && bacafanHarita[indexNo] != 0
                            ? true
                            : false,
                        maintainState: true,
                        maintainSize: true,
                        maintainAnimation: true,
                        child: Row(
                          children: <Widget>[
                            //bacafan No
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
                                                  dilSecimi, "tv72") +
                                              bacafanNo[indexNo].toString(),
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
                                ],
                              ),
                            ),
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
        String tumCikislarVeri = "";

        for (int i = 1; i <= 3; i++) {
          if (cikisNo[i] != 0) {
            tumCikislar[cikisNo[i]] = 0;
          }
        }

        for (int i = 1; i <= 110; i++) {
          tumCikislarVeri = tumCikislarVeri + tumCikislar[i].toString() + "#";
        }
        for (int i = 1; i <= 26; i++) {
          bacafanHarita[i] = 0;
          bacafanNo[i] = 0;
          bacafanVisibility[i] = true;
        }

        for (int i = 1; i <= 3; i++) {
          cikisNo[i] = 0;
        }
        haritaOnay = false;

        dijitalCikis=true;
        analogCikis=false;
        cikisTur="1";

        dbHelper.veriYOKSAekleVARSAguncelle(23, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(24, "0", "0", "0", "0");
        _veriGonder("28", "0", "0", "0", "0", "0");

        setState(() {});
      }
    });
  }

  Widget _bacaFanGrupCikis(int index, double oran) {
    return Expanded(
      flex: 2,
      child: Visibility(
        visible: bacafanVarMi >= index,
        maintainAnimation: true,
        maintainSize: true,
        maintainState: true,
        child: Column(
          children: <Widget>[
            Text(
              Dil().sec(dilSecimi,
                  index == 1 ? "tv65" : (index == 2 ? "tv66" : "tv67")),
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kelly Slab',
                  color: Colors.grey[600],
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
                        _onlarOut = cikisNo[index] < 10
                            ? 0
                            : (cikisNo[index] ~/ 10).toInt();
                        _birlerOut = cikisNo[index] % 10;
                        _degerNo = index;

                        _degergiris2X0(_onlarOut, _birlerOut, index, oran,
                            dilSecimi, "tv69", 2);
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
                                    cikisNo[index].toString(),
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


 Future _sayfaGeriAlert(String dilSecimi, String uyariMetni) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return SayfaGeriAlert.deger(dilSecimi,uyariMetni);
      },
    ).then((val) {
      if (val) {

        if(val){

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => KurulumAyarlari(dbVeriler)),
          );

        }


      }
    });
  }

//--------------------------METOTLAR--------------------------------

}
