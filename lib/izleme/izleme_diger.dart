import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_2x0.dart';
import 'package:prokis/yardimci/deger_giris_3x0.dart';
import 'package:prokis/genel_ayarlar/izleme.dart';
import 'package:prokis/languages/select.dart';

class IzlemeDiger extends StatefulWidget {
  List<Map> gelenDBveri;
  IzlemeDiger(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return IzlemeDigerState(gelenDBveri);
  }
}

class IzlemeDigerState extends State<IzlemeDiger> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String siloAdet = "4";
  String bacafanAdet = "0";
  String disNemVarMi = "0";

  String info = "info12";
  List<Map> dbVeriler;

  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _index = 0;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  List<int> siloHarita = new List.filled(31,0);
  List<int> siloAktuelAgirlik = new List.filled(5,0);
  List<bool> siloVisibility = new List.filled(31,false);
  List<int> siloNo = new List.filled(31,0);

  String toplamYemTuketim="0";
  String hayvanBasinaYemTuketim="0";

  bool otoYEM=false;
  String cks1ileriSaat="20";
  String cks1geriSaat="25";
  String cks2ileriSaat="20";
  String cks2geriSaat="25";
  String cks3ileriSaat="20";
  String cks3geriSaat="25";

  bool otoAYD=false;
  String acSaati1="07:30";
  String kpSaati1="22:30";
  String acSaati2="07:30";
  String kpSaati2="22:30";
  String anlikAydinlikYuzdesi="70.0";

  List<String> sayacDeger=new List.filled(13,"0");
  String sayacGunlukToplamTuketim="0";
  String sayacGunlukHayBasTuketim="0";

  String setSicakligi="23.0";
  String ortSicaklik="25.6";
  String dogBolgeBitis="24.0";
  String capBolgeBitis="26.0";
  String olculenMakSic="29.0";
  String olculenMinSic="19.0";
  String olculenMakZmn="14:40";
  String olculenMinZmn="03:20";
  String icNem="50.0";
  String disNem="65.0";
  String ortHissedilirSicaklik="24.9";

  String olumOrani = "1.35";
  String guncelOluHayvanSayisi = "126";
  String guncelHayvanSayisi = "120000";
  String suruYasiGunluk = "140";
  String suruYasiHaftalik = "20.0";

  bool yemlemeCKS1aktif=false;
  bool yemlemeCKS2aktif=false;
  bool yemlemeCKS3aktif=false;

  String sayacSayisi="0";

  bool acKapaSaat2Aktiflik=false;
  bool dimmerVarMi=false;
  

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  IzlemeDigerState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 5) {
        var xx=dbVeri[i]["veri1"].split('#'); 
        bacafanAdet = xx[0];
        siloAdet = dbVeri[i]["veri4"];
      }

      if (dbVeri[i]["id"] == 13) {
        disNemVarMi = dbVeri[i]["veri4"];
      }

      if (dbVeri[i]["id"] == 29) {
        if (dbVeri[i]["veri1"] == "ok") {
          String xx = dbVeri[i]["veri2"];
          var fHaritalar = xx.split("#");
          for (int i = 1; i <=30; i++) {
            siloHarita[i] = int.parse(fHaritalar[i - 1]);
            if (siloHarita[i] != 0) {
              siloVisibility[i] = true;
            } else {
              siloVisibility[i] = false;
            }
          }
        }
      }

      if (dbVeri[i]["id"] == 30) {
        String xx;

        if (dbVeri[i]["veri1"] == "ok") {
          xx = dbVeri[i]["veri2"];
          var siloNolar = xx.split("#");
          for (int i = 1; i <=30; i++) {
            siloNo[i] = int.parse(siloNolar[i - 1]);
          }
        }
      }
      
    }

    print(siloHarita);
    print(siloVisibility);

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
          print("_takipEt tetikleniyor!");
        }
      });
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv599'),
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
                                  color: Colors.blue[800],
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
                                  color: Colors.blue[800],
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
                padding: EdgeInsets.only(top: 3 * oran,right: 3 * oran,left:  3 * oran),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Expanded(flex: 2,
                      child: Row(
                        children: <Widget>[
                          //YEMLEME , AYDINLATMA ve SU SAYAÇLARI
                          Expanded(flex: 15,

                            child: Container(
                              decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(20*oran),
                                 //color: Colors.yellow[400],
                                 border: Border.all(width: 1*oran)
                               ),
                              child: Row(
                                children: <Widget>[
                                  Spacer(),
                                  //Yem Arabaları
                                  Expanded(flex: 10,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv113"),
                                                textAlign:
                                                    TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 50.0,
                                                    fontFamily:
                                                        'Kelly Slab',
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                minFontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 4,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              //color: Colors.pink,
                                              image: DecorationImage(
                                                alignment: Alignment.center,
                                                image: AssetImage(
                                                    "assets/images/kurulum_yemleme_icon.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 8,
                                          child: Stack(fit: StackFit.expand,
                                            children: <Widget>[
                                              Visibility(visible: !yemlemeCKS1aktif && !yemlemeCKS2aktif && !yemlemeCKS3aktif ? false: true,
                                                child: Column(
                                                  children: <Widget>[

                                                    //Yemleme resmi altı başlık
                                                    Expanded(flex: 5,
                                                      child: SizedBox(
                                                        child: Container(
                                                          margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                          color: Colors.black,
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            Dil().sec(dilSecimi, "tv607"),
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 50.0,
                                                                fontFamily:'Kelly Slab',
                                                                fontWeight:FontWeight.bold,
                                                                color: Colors.white
                                                                ),
                                                            maxLines: 2,
                                                            minFontSize: 8,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //ileri geri metni
                                                    Expanded(flex: 4,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(),
                                                          Expanded(flex: 2,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: AutoSizeText(
                                                                  Dil().sec(dilSecimi, "tv557"),
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 50.0,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                  ),
                                                                  maxLines: 2,
                                                                  minFontSize: 8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(flex: 2,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: AutoSizeText(
                                                                  Dil().sec(dilSecimi, "tv558"),
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 50.0,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                  ),
                                                                  maxLines: 2,
                                                                  minFontSize: 8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          
                                                        ],
                                                      ),
                                                    ),
                                                    //çıkış 1 ileri geri bir sonraki yemleme zamanı
                                                    Expanded(flex: 4,
                                                      child: Visibility(visible: yemlemeCKS1aktif,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(flex: 1,
                                                              child: SizedBox(
                                                                child: Container(
                                                                  alignment: Alignment.center,
                                                                  child: AutoSizeText(
                                                                    Dil().sec(dilSecimi, "tv33")+"1",
                                                                    textAlign:
                                                                        TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 50.0,
                                                                        fontFamily:
                                                                            'Kelly Slab',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 1,
                                                                    minFontSize: 8,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(flex: 2,
                                                              child: SizedBox(
                                                                child: Container(
                                                                  margin: EdgeInsets.all(1*oran),
                                                                  color: Colors.blue[200],
                                                                  alignment: Alignment.center,
                                                                  child: AutoSizeText(
                                                                    Dil().sec(dilSecimi, saatGetir(int.parse(cks1ileriSaat))),
                                                                    textAlign:
                                                                        TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 50.0,
                                                                        fontFamily:
                                                                            'Kelly Slab',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 2,
                                                                    minFontSize: 8,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(flex: 2,
                                                              child: SizedBox(
                                                                child: Container(
                                                                  margin: EdgeInsets.all(1*oran),
                                                                  color: Colors.red[300],
                                                                  alignment: Alignment.center,
                                                                  child: AutoSizeText(
                                                                    Dil().sec(dilSecimi, saatGetir(int.parse(cks1geriSaat))),
                                                                    textAlign:
                                                                        TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 50.0,
                                                                        fontFamily:
                                                                            'Kelly Slab',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 2,
                                                                    minFontSize: 8,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    //çıkış 2 ileri geri bir sonraki yemleme zamanı
                                                    Expanded(flex: 4,
                                                      child: Visibility(visible: yemlemeCKS2aktif,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(flex: 1,
                                                              child: SizedBox(
                                                                child: Container(
                                                                  alignment: Alignment.center,
                                                                  child: AutoSizeText(
                                                                    Dil().sec(dilSecimi, "tv33")+"2",
                                                                    textAlign:
                                                                        TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 50.0,
                                                                        fontFamily:
                                                                            'Kelly Slab',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 1,
                                                                    minFontSize: 8,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(flex: 2,
                                                              child: SizedBox(
                                                                child: Container(
                                                                  margin: EdgeInsets.all(1*oran),
                                                                  color: Colors.blue[200],
                                                                  alignment: Alignment.center,
                                                                  child: AutoSizeText(
                                                                    Dil().sec(dilSecimi, saatGetir(int.parse(cks2ileriSaat))),
                                                                    textAlign:
                                                                        TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 50.0,
                                                                        fontFamily:
                                                                            'Kelly Slab',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 2,
                                                                    minFontSize: 8,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(flex: 2,
                                                              child: SizedBox(
                                                                child: Container(
                                                                  margin: EdgeInsets.all(1*oran),
                                                                  color: Colors.red[300],
                                                                  alignment: Alignment.center,
                                                                  child: AutoSizeText(
                                                                    Dil().sec(dilSecimi, saatGetir(int.parse(cks2geriSaat))),
                                                                    textAlign:
                                                                        TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 50.0,
                                                                        fontFamily:
                                                                            'Kelly Slab',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 2,
                                                                    minFontSize: 8,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    //çıkış 3 ileri geri bir sonraki yemleme zamanı
                                                    Expanded(flex: 4,
                                                      child: Visibility(visible: yemlemeCKS3aktif,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(flex: 1,
                                                              child: SizedBox(
                                                                child: Container(
                                                                  alignment: Alignment.center,
                                                                  child: AutoSizeText(
                                                                    Dil().sec(dilSecimi, "tv33")+"3",
                                                                    textAlign:
                                                                        TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 50.0,
                                                                        fontFamily:
                                                                            'Kelly Slab',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 1,
                                                                    minFontSize: 8,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(flex: 2,
                                                              child: SizedBox(
                                                                child: Container(
                                                                  margin: EdgeInsets.all(1*oran),
                                                                  color: Colors.blue[200],
                                                                  alignment: Alignment.center,
                                                                  child: AutoSizeText(
                                                                    Dil().sec(dilSecimi, saatGetir(int.parse(cks3ileriSaat))),
                                                                    textAlign:
                                                                        TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 50.0,
                                                                        fontFamily:
                                                                            'Kelly Slab',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 2,
                                                                    minFontSize: 8,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(flex: 2,
                                                              child: SizedBox(
                                                                child: Container(
                                                                  margin: EdgeInsets.all(1*oran),
                                                                  color: Colors.red[300],
                                                                  alignment: Alignment.center,
                                                                  child: AutoSizeText(
                                                                    Dil().sec(dilSecimi, saatGetir(int.parse(cks3geriSaat))),
                                                                    textAlign:
                                                                        TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 50.0,
                                                                        fontFamily:
                                                                            'Kelly Slab',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 2,
                                                                    minFontSize: 8,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    //Yem araba oto-man durum
                                                    Expanded(flex: 4,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 2,),
                                                          Expanded(flex: 2,
                                                            child: autoManGosterge(otoYEM, oran, dilSecimi)
                                                          ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),

                                                    ),

                                                  ],
                                                ),
                                              ),

                                              Visibility(visible: yemlemeCKS1aktif || yemlemeCKS2aktif || yemlemeCKS3aktif ? false: true,
                                                child: SizedBox(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      Dil().sec(dilSecimi, "tv621"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          fontWeight:FontWeight.bold,
                                                          color: Colors.grey[500],
                                                          ),
                                                      maxLines: 4,
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
                                  Spacer(),
                                  //Su sayacı
                                  Expanded(flex: 10,
                                    child: Stack(fit: StackFit.expand,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, "tv609"),
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(flex: 4,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  //color: Colors.pink,
                                                  image: DecorationImage(
                                                    alignment: Alignment.center,
                                                    image: AssetImage(
                                                        "assets/images/kurulum_sayac_icon.png"),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(flex: 8,
                                              child: Stack(fit: StackFit.expand,
                                                children: <Widget>[


                                                  Visibility(visible: sayacSayisi=="0" ? false: true,
                                                    child: Column(
                                                      children: <Widget>[
                                                        //Yemleme resmi altı başlık
                                                        Expanded(flex: 10,
                                                          child: SizedBox(
                                                            child: Container(
                                                              margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                              padding : EdgeInsets.only(left: 5*oran,right: 5*oran),
                                                              color: Colors.black,
                                                              alignment: Alignment.center,
                                                              child: AutoSizeText(
                                                                Dil().sec(dilSecimi, "tv610"),
                                                                textAlign:
                                                                    TextAlign.center,
                                                                style: TextStyle(
                                                                    fontSize: 50.0,
                                                                    fontFamily:'Kelly Slab',
                                                                    fontWeight:FontWeight.bold,
                                                                    color: Colors.white
                                                                    ),
                                                                maxLines: 1,
                                                                minFontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        //Sayac 1-2
                                                        Expanded(flex: 8,
                                                          child: Row(
                                                            children: <Widget>[
                                                              
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(1, oran)
                                                              ),
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(2, oran)
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        //Sayac 3-4
                                                        Expanded(flex: 8,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(3, oran)
                                                              ),
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(4, oran)
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        //Sayac 5-6
                                                        Expanded(flex: 8,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(5, oran)
                                                              ),
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(6, oran)
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        //Sayac 7-8
                                                        Expanded(flex: 8,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(7, oran)
                                                              ),
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(8, oran)
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        //Sayac 9-10
                                                        Expanded(flex: 8,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(9, oran)
                                                              ),
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(10, oran)
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        //Sayac 11-12
                                                        Expanded(flex: 8,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(11, oran)
                                                              ),
                                                              Expanded(flex: 1,
                                                                child: suSayacUnsur(12, oran)
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        //Günlük Toplam Tüketim
                                                        Expanded(flex: 8,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(flex: 4,
                                                                child: SizedBox(
                                                                  child: Container(
                                                                    alignment: Alignment.centerRight,
                                                                    child: AutoSizeText(
                                                                      Dil().sec(dilSecimi, "tv611"),
                                                                      textAlign:
                                                                          TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: 50.0,
                                                                          fontFamily:
                                                                              'Kelly Slab',
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      maxLines: 2,
                                                                      minFontSize: 8,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(flex: 2,
                                                                child: SizedBox(
                                                                  child: Container(
                                                                    margin: EdgeInsets.all(1*oran),
                                                                    color: Colors.red[300],
                                                                    alignment: Alignment.center,
                                                                    child: AutoSizeText(
                                                                      sayacGunlukToplamTuketim,
                                                                      textAlign:
                                                                          TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: 50.0,
                                                                          fontFamily:
                                                                              'Kelly Slab',
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      maxLines: 2,
                                                                      minFontSize: 8,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              
                                                            ],
                                                          ),
                                                        ),
                                                        //Günlük hayvan başına tüketim
                                                        Expanded(flex: 8,
                                                          child: Row(
                                                            children: <Widget>[
                                                              Expanded(flex: 4,
                                                                child: SizedBox(
                                                                  child: Container(
                                                                    alignment: Alignment.centerRight,
                                                                    child: AutoSizeText(
                                                                      Dil().sec(dilSecimi, "tv612"),
                                                                      textAlign:
                                                                          TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: 50.0,
                                                                          fontFamily:
                                                                              'Kelly Slab',
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      maxLines: 2,
                                                                      minFontSize: 8,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              
                                                              Expanded(flex: 2,
                                                                child: SizedBox(
                                                                  child: Container(
                                                                    margin: EdgeInsets.all(1*oran),
                                                                    color: Colors.red[300],
                                                                    alignment: Alignment.center,
                                                                    child: AutoSizeText(
                                                                      sayacGunlukHayBasTuketim,
                                                                      textAlign:
                                                                          TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: 50.0,
                                                                          fontFamily:
                                                                              'Kelly Slab',
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      maxLines: 2,
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
                                                
                                                  Visibility(visible: sayacSayisi=="0" ? true: false,
                                                child: SizedBox(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      Dil().sec(dilSecimi, "tv622"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          fontWeight:FontWeight.bold,
                                                          color: Colors.grey[500],
                                                          ),
                                                      maxLines: 4,
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
                                      ],
                                    ),
                                  ),                                  
                                  Spacer(),
                                  //Aydınlatma 
                                  Expanded(flex: 10,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: AutoSizeText(
                                                Dil().sec(dilSecimi, "tv112"),
                                                textAlign:
                                                    TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 50.0,
                                                    fontFamily:
                                                        'Kelly Slab',
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                                minFontSize: 8,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 4,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              //color: Colors.pink,
                                              image: DecorationImage(
                                                alignment: Alignment.center,
                                                image: AssetImage(
                                                    "assets/images/kurulum_aydinlatma_icon.png"),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(flex: 8,
                                          child: Column(
                                            children: <Widget>[

                                              //Aydınlatma Resmi altı başlık
                                              Expanded(flex: 5,
                                                child: SizedBox(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                    color: Colors.black,
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      Dil().sec(dilSecimi, "tv608"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          fontWeight:FontWeight.bold,
                                                          color: Colors.white
                                                          ),
                                                      maxLines: 2,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Aç kapa metni
                                              Expanded(flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(),
                                                    Expanded(flex: 2,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Spacer(flex: 2,),
                                                          Expanded(flex: 5,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: AutoSizeText(
                                                                  Dil().sec(dilSecimi, "tv473"),
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 50.0,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                  ),
                                                                  maxLines: 2,
                                                                  minFontSize: 8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(flex: 2,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Spacer(flex: 2,),
                                                          Expanded(flex: 5,
                                                            child: SizedBox(
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                child: AutoSizeText(
                                                                  Dil().sec(dilSecimi, "tv474"),
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 50.0,
                                                                      fontFamily:
                                                                          'Kelly Slab',
                                                                  ),
                                                                  maxLines: 2,
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
                                              //çıkış 1 aydınlatma aç-kapa saati
                                              Expanded(flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(flex: 1,
                                                      child: SizedBox(
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            "1:",
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 50.0,
                                                                fontFamily:
                                                                    'Kelly Slab',
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                            maxLines: 2,
                                                            minFontSize: 8,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(flex: 2,
                                                      child: SizedBox(
                                                        child: Container(
                                                          margin: EdgeInsets.all(1*oran),
                                                          color: Colors.blue[200],
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            acSaati1,
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 50.0,
                                                                fontFamily:
                                                                    'Kelly Slab',
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                            maxLines: 2,
                                                            minFontSize: 8,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(flex: 2,
                                                      child: SizedBox(
                                                        child: Container(
                                                          margin: EdgeInsets.all(1*oran),
                                                          color: Colors.red[300],
                                                          alignment: Alignment.center,
                                                          child: AutoSizeText(
                                                            kpSaati1,
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 50.0,
                                                                fontFamily:
                                                                    'Kelly Slab',
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                            maxLines: 2,
                                                            minFontSize: 8,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    
                                                  ],
                                                ),
                                              ),
                                              //çıkış 2 aydınlatma aç-kapa saati
                                              Expanded(flex: 4,
                                                child: Visibility(visible: acKapaSaat2Aktiflik,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(flex: 1,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            child: AutoSizeText(
                                                              "2:",
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                              maxLines: 2,
                                                              minFontSize: 8,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(flex: 2,
                                                        child: SizedBox(
                                                          child: Container(
                                                            margin: EdgeInsets.all(1*oran),
                                                            color: Colors.blue[200],
                                                            alignment: Alignment.center,
                                                            child: AutoSizeText(
                                                              acSaati2,
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                              maxLines: 2,
                                                              minFontSize: 8,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(flex: 2,
                                                        child: SizedBox(
                                                          child: Container(
                                                            margin: EdgeInsets.all(1*oran),
                                                            color: Colors.red[300],
                                                            alignment: Alignment.center,
                                                            child: AutoSizeText(
                                                              kpSaati2,
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                              maxLines: 2,
                                                              minFontSize: 8,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              
                                              //Aydınlık Yüzdesi
                                              Expanded(flex:4,
                                                child: Visibility(visible: dimmerVarMi,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(flex: 3,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Spacer(),
                                                            Expanded(flex: 5,
                                                              child: SizedBox(
                                                                child: Container(
                                                                  alignment: Alignment.centerRight,
                                                                  child: AutoSizeText(
                                                                    Dil().sec(dilSecimi, "tv613"),
                                                                    textAlign:
                                                                        TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: 50.0,
                                                                        fontFamily:
                                                                            'Kelly Slab',
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    maxLines: 1,
                                                                    minFontSize: 6,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(flex: 2,
                                                        child: SizedBox(
                                                          child: Container(
                                                            margin: EdgeInsets.all(1*oran),
                                                            color: Colors.red[300],
                                                            alignment: Alignment.center,
                                                            child: AutoSizeText(
                                                              anlikAydinlikYuzdesi,
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                              maxLines: 2,
                                                              minFontSize: 8,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              //Aydınlatma Oto-Man Durumu
                                              Expanded(flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(flex: 2,),
                                                    Expanded(flex: 2,
                                                      child: autoManGosterge(otoAYD, oran, dilSecimi)
                                                    ),
                                                    Spacer(flex: 1,)
                                                  ],
                                                ),
 
                                              ),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),

                          //Sıcaklıklar
                          Expanded(flex: 7,
                              child: Row(
                                children: <Widget>[
                                  Spacer(flex: 2,),
                                  Expanded(flex:24,
                                    child: Column(
                                      children: <Widget>[
                                        Spacer(),
                                        //Set Sıcaklığı
                                        Expanded(flex: 6,
                                          child: 
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Spacer(flex: 2,),
                                              Expanded(flex: 2,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  padding: EdgeInsets.only(left: 1*oran),
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, "tv582"),
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:'Kelly Slab',
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.red[800]
                                                        ),
                                                    maxLines: 2,
                                                    minFontSize: 5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                              Expanded(flex: 6,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    setSicakligi,
                                                    textAlign:TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:'Kelly Slab',
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold
                                                        ),
                                                    maxLines: 1,
                                                    minFontSize: 5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                              Expanded(flex: 2,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  padding: EdgeInsets.only(right: 2*oran),
                                                  child: AutoSizeText(
                                                    "°C",
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily:'Kelly Slab',
                                                        color: Colors.red[800]
                                                        ),
                                                    maxLines: 1,
                                                    minFontSize: 5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                              Spacer(flex: 2,)
                                            ],
                                          ),
                                        ),
                                        //Ortalama Sıcaklık Bölümü
                                        Expanded(flex: 8,
                                          child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[600],
                                            borderRadius: BorderRadius.circular(5*oran)
                                          ),
                                          
                                          child:Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(flex: 1,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.centerRight,
                                                    padding: EdgeInsets.only(left: 1*oran),
                                                    child: AutoSizeText(
                                                      Dil().sec(dilSecimi, "tv583"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.grey[200]
                                                          ),
                                                      maxLines: 2,
                                                      minFontSize: 5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(flex: 3,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      ortSicaklik,
                                                      textAlign:TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold
                                                          ),
                                                      maxLines: 1,
                                                      minFontSize: 5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.centerLeft,
                                                    padding: EdgeInsets.only(right: 2*oran),
                                                    child: AutoSizeText(
                                                      "°C",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 50.0,
                                                          fontFamily:'Kelly Slab',
                                                          color: Colors.grey[200]
                                                          ),
                                                      maxLines: 1,
                                                      minFontSize: 5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        )
                                        )),
                                        //Doğal Bölge Çapraz Bölge
                                        Expanded(flex: 6,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Spacer(flex: 2,),
                                                    Expanded(flex: 7,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.center,
                                                         padding: EdgeInsets.only(left: 1*oran),
                                                         child: AutoSizeText(
                                                           Dil().sec(dilSecimi, "tv584"),
                                                           textAlign:
                                                               TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.red[800]
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                 ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerRight,
                                                               child: AutoSizeText(
                                                                 dogBolgeBitis,
                                                                 textAlign:TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.black,
                                                                     fontWeight: FontWeight.bold
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Expanded(flex: 2,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerLeft,
                                                               padding: EdgeInsets.only(right: 2*oran),
                                                               child: AutoSizeText(
                                                                 "°C",
                                                                 textAlign:
                                                                     TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.red[800]
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Spacer(flex: 2,),
                                                    Expanded(flex: 7,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.center,
                                                         padding: EdgeInsets.only(left: 1*oran),
                                                         child: AutoSizeText(
                                                           Dil().sec(dilSecimi, "tv585"),
                                                           textAlign:
                                                               TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.red[800]
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                 ),
                                                    Expanded(flex: 11,
                                                      child: Stack(fit: StackFit.expand,
                                                        children: <Widget>[
                                                          Visibility(visible: bacafanAdet=="0"? false : true,
                                                            child: Row(
                                                              children: <Widget>[
                                                                Spacer(flex: 1,),
                                                                Expanded(flex: 4,
                                                                 child: SizedBox(
                                                                   child: Container(
                                                                     alignment: Alignment.centerRight,
                                                                     child: AutoSizeText(
                                                                       capBolgeBitis,
                                                                       textAlign:TextAlign.center,
                                                                       style: TextStyle(
                                                                           fontSize: 50.0,
                                                                           fontFamily:'Kelly Slab',
                                                                           color: Colors.black,
                                                                           fontWeight: FontWeight.bold
                                                                           ),
                                                                       maxLines: 1,
                                                                       minFontSize: 5,
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ),
                                                                Expanded(flex: 2,
                                                                 child: SizedBox(
                                                                   child: Container(
                                                                     alignment: Alignment.centerLeft,
                                                                     padding: EdgeInsets.only(right: 2*oran),
                                                                     child: AutoSizeText(
                                                                       "°C",
                                                                       textAlign:
                                                                           TextAlign.center,
                                                                       style: TextStyle(
                                                                           fontSize: 50.0,
                                                                           fontFamily:'Kelly Slab',
                                                                           color: Colors.red[800]
                                                                           ),
                                                                       maxLines: 1,
                                                                       minFontSize: 5,
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ),
                                                                Spacer(flex: 1,)
                                                              ],
                                                            ),
                                                          ),
                                                          Visibility(visible: bacafanAdet=="0"? true : false,
                                                            child: SizedBox(
                                                              child: Container(
                                                                margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                                alignment: Alignment.center,
                                                                child: AutoSizeText(
                                                                  Dil().sec(dilSecimi, "tv237"),
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 50.0,
                                                                      fontFamily:'Kelly Slab',
                                                                      fontWeight:FontWeight.bold,
                                                                      color: Colors.grey[500],
                                                                      ),
                                                                  maxLines: 4,
                                                                  minFontSize: 8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              
                                          ],
                                        )),
                                        //Maks ve Min sıcaklıklar
                                        Expanded(flex: 6,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Spacer(flex: 2,),
                                                    Expanded(flex: 7,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.center,
                                                         padding: EdgeInsets.only(left: 1*oran),
                                                         child: AutoSizeText(
                                                           Dil().sec(dilSecimi, "tv614"),
                                                           textAlign:
                                                               TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.red[800]
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                 ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerRight,
                                                               child: AutoSizeText(
                                                                 olculenMakSic,
                                                                 textAlign:TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.black,
                                                                     fontWeight: FontWeight.bold
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Expanded(flex: 2,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerLeft,
                                                               padding: EdgeInsets.only(right: 2*oran),
                                                               child: AutoSizeText(
                                                                 "°C",
                                                                 textAlign:
                                                                     TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.red[800]
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Spacer(flex: 2,),
                                                    Expanded(flex: 7,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.center,
                                                         padding: EdgeInsets.only(left: 1*oran),
                                                         child: AutoSizeText(
                                                           Dil().sec(dilSecimi, "tv615"),
                                                           textAlign:
                                                               TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.red[800]
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                 ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerRight,
                                                               child: AutoSizeText(
                                                                 olculenMinSic,
                                                                 textAlign:TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.black,
                                                                     fontWeight: FontWeight.bold
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Expanded(flex: 2,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerLeft,
                                                               padding: EdgeInsets.only(right: 2*oran),
                                                               child: AutoSizeText(
                                                                 "°C",
                                                                 textAlign:
                                                                     TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.red[800]
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              
                                          ],
                                        )),
                                        //Maks ve Min sicaklık saatleri
                                        Expanded(flex: 6,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Spacer(flex: 2,),
                                                    Expanded(flex: 7,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.center,
                                                         padding: EdgeInsets.only(left: 1*oran),
                                                         child: AutoSizeText(
                                                           Dil().sec(dilSecimi, "tv616"),
                                                           textAlign:
                                                               TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.red[800]
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                 ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.center,
                                                               child: AutoSizeText(
                                                                 olculenMakZmn,
                                                                 textAlign:TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.black,
                                                                     fontWeight: FontWeight.bold
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Spacer(flex: 2,),
                                                    Expanded(flex: 7,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.center,
                                                         padding: EdgeInsets.only(left: 1*oran),
                                                         child: AutoSizeText(
                                                           Dil().sec(dilSecimi, "tv617"),
                                                           textAlign:
                                                               TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.red[800]
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                 ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.center,
                                                               child: AutoSizeText(
                                                                 olculenMinZmn,
                                                                 textAlign:TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.black,
                                                                     fontWeight: FontWeight.bold
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              
                                          ],
                                        )),
                                        //İç nem Dış Nem
                                        Expanded(flex: 6,
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Spacer(flex: 2,),
                                                    Expanded(flex: 7,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.center,
                                                         padding: EdgeInsets.only(left: 1*oran),
                                                         child: AutoSizeText(
                                                           Dil().sec(dilSecimi, "tv618"),
                                                           textAlign:
                                                               TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.red[800]
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                 ),
                                                    Expanded(flex: 11,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Spacer(flex: 1,),
                                                          Expanded(flex: 4,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerRight,
                                                               child: AutoSizeText(
                                                                 icNem,
                                                                 textAlign:TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.black,
                                                                     fontWeight: FontWeight.bold
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Expanded(flex: 2,
                                                           child: SizedBox(
                                                             child: Container(
                                                               alignment: Alignment.centerLeft,
                                                               padding: EdgeInsets.only(right: 2*oran),
                                                               child: AutoSizeText(
                                                                 "%",
                                                                 textAlign:
                                                                     TextAlign.center,
                                                                 style: TextStyle(
                                                                     fontSize: 50.0,
                                                                     fontFamily:'Kelly Slab',
                                                                     color: Colors.red[800]
                                                                     ),
                                                                 maxLines: 1,
                                                                 minFontSize: 5,
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                          Spacer(flex: 1,)
                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,)
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: <Widget>[
                                                    Spacer(flex: 2,),
                                                    Expanded(flex: 7,
                                                     child: SizedBox(
                                                       child: Container(
                                                         alignment: Alignment.center,
                                                         padding: EdgeInsets.only(left: 1*oran),
                                                         child: AutoSizeText(
                                                           Dil().sec(dilSecimi, "tv619"),
                                                           textAlign:
                                                               TextAlign.center,
                                                           style: TextStyle(
                                                               fontSize: 50.0,
                                                               fontFamily:'Kelly Slab',
                                                               color: Colors.red[800]
                                                               ),
                                                           maxLines: 1,
                                                           minFontSize: 5,
                                                         ),
                                                       ),
                                                     ),
                                                 ),
                                                    Expanded(flex: 11,
                                                      child: Stack(fit: StackFit.expand,
                                                        children: <Widget>[
                                                          Visibility(visible: disNemVarMi=="0" ? false: true,
                                                                                                                      child: Row(
                                                              children: <Widget>[
                                                                Spacer(flex: 1,),
                                                                Expanded(flex: 4,
                                                                 child: SizedBox(
                                                                   child: Container(
                                                                     alignment: Alignment.centerRight,
                                                                     child: AutoSizeText(
                                                                       disNem,
                                                                       textAlign:TextAlign.center,
                                                                       style: TextStyle(
                                                                           fontSize: 50.0,
                                                                           fontFamily:'Kelly Slab',
                                                                           color: Colors.black,
                                                                           fontWeight: FontWeight.bold
                                                                           ),
                                                                       maxLines: 1,
                                                                       minFontSize: 5,
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ),
                                                                Expanded(flex: 2,
                                                                 child: SizedBox(
                                                                   child: Container(
                                                                     alignment: Alignment.centerLeft,
                                                                     padding: EdgeInsets.only(right: 2*oran),
                                                                     child: AutoSizeText(
                                                                       "%",
                                                                       textAlign:
                                                                           TextAlign.center,
                                                                       style: TextStyle(
                                                                           fontSize: 50.0,
                                                                           fontFamily:'Kelly Slab',
                                                                           color: Colors.red[800]
                                                                           ),
                                                                       maxLines: 1,
                                                                       minFontSize: 5,
                                                                     ),
                                                                   ),
                                                                 ),
                                                               ),
                                                                Spacer(flex: 1,)
                                                              ],
                                                            ),
                                                          ),
                                                          Visibility(visible: disNemVarMi=="0"? true : false,
                                                            child: SizedBox(
                                                              child: Container(
                                                                margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                                                alignment: Alignment.center,
                                                                child: AutoSizeText(
                                                                  Dil().sec(dilSecimi, "tv237"),
                                                                  textAlign:
                                                                      TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontSize: 50.0,
                                                                      fontFamily:'Kelly Slab',
                                                                      fontWeight:FontWeight.bold,
                                                                      color: Colors.grey[500],
                                                                      ),
                                                                  maxLines: 4,
                                                                  minFontSize: 8,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              
                                          ],
                                        )),
                                        
                                      ],
                                    ),
                                  ),
                                  Spacer(flex: 2,),
                                ],
                              )
                            ),
  
                         //Silo ve yem
                          Expanded(flex: 15,
                            child: Container(
                              decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(20*oran),
                                 //color: Colors.yellow[400],
                                 border: Border.all(width: 1*oran)
                               ),
                              alignment: Alignment.center,
                              child: Stack(fit: StackFit.expand,
                                children: <Widget>[
                                  //Bina ve siloların resimleri
                                  Visibility(visible: siloAdet=="0" ? false: true,
                                                                      child: Column(
                                       children: <Widget>[
                                         Expanded(
                                          flex: 7,
                                          child: Row(
                                            children: <Widget>[
                                              Spacer(
                              flex: 6,
                            ),
                                              Expanded(
                              flex: 3,
                              child: Column(
                                     children: <Widget>[
                                       _siloHaritaUnsur(7, oran, "tv83", 1),
                                       _siloHaritaUnsur(6, oran, "tv83", 1),
                                     ],
                              ),
                            ),
                                              Expanded(
                              flex: 3,
                              child: Column(
                                     children: <Widget>[
                                       Spacer(),
                                       _siloHaritaUnsur(8, oran, "tv83", 1),
                                     ],
                              ),
                            ),
                                              Spacer(
                              flex: 3,
                            ),
                                              Expanded(
                              flex: 3,
                              child: Column(
                                     children: <Widget>[
                                       Spacer(),
                                       _siloHaritaUnsur(9, oran, "tv83", 1),
                                     ],
                              ),
                            ),
                                              Expanded(
                              flex: 3,
                              child: Column(
                                     children: <Widget>[
                                       _siloHaritaUnsur(11, oran, "tv83", 1),
                                       _siloHaritaUnsur(10, oran, "tv83", 1),
                                     ],
                              ),
                            ),
                                              Expanded(
                              flex: 3,
                              child: Column(
                                     children: <Widget>[
                                       Spacer(),
                                       _siloHaritaUnsur(12, oran, "tv83", 1),
                                     ],
                              ),
                            ),
                                              Spacer(
                              flex: 3,
                            ),
                                              Expanded(
                              flex: 3,
                              child: Column(
                                     children: <Widget>[
                                       Spacer(),
                                       _siloHaritaUnsur(13, oran, "tv83", 1),
                                     ],
                              ),
                            ),
                                              Expanded(
                              flex: 3,
                              child: Column(
                                     children: <Widget>[
                                       _siloHaritaUnsur(15, oran, "tv83", 1),
                                       _siloHaritaUnsur(14, oran, "tv83", 1),
                                     ],
                              ),
                            ),
                                              Spacer(
                              flex: 6,
                            ),
                                            ],
                                          ),
                                        ),
                                         Expanded(
                                           flex: 10,
                                           child: Row(
                                             children: <Widget>[
                                               Expanded(
                                                 flex: 6,
                                                 child: Column(
                                                   children: <Widget>[
                                                     Expanded(
                                                       child: Row(
                                                         children: <Widget>[
                                                           _siloHaritaUnsur(4, oran, "tv83", 1),
                                                           _siloHaritaUnsur(3, oran, "tv83", 1),
                                                         ],
                                                       ),
                                                     ),
                                                     Expanded(
                                                       child: Row(
                                                         children: <Widget>[
                                                           Spacer(),
                                                           _siloHaritaUnsur(3, oran, "tv83", 1),
                                                         ],
                                                       ),
                                                     ),
                                                     Expanded(
                                                       child: Row(
                                                         children: <Widget>[
                                                           _siloHaritaUnsur(2, oran, "tv83", 1),
                                                           _siloHaritaUnsur(1, oran, "tv83", 1),
                                                         ],
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                               ),
                                               Expanded(
                                                   flex: 27,
                                                   child: Stack(fit: StackFit.expand,
                                                     children: <Widget>[
                                                       //Çatı Resmi
                                                       Container(
                                                         decoration: BoxDecoration(
                                                           //color: Colors.pink,
                                                           image: DecorationImage(
                                                             alignment: Alignment.center,
                                                             image: AssetImage(
                                                                 "assets/images/bina_catili_ust_gorunum.png"),
                                                             fit: BoxFit.fill,
                                                           ),
                                                         ),
                                                       ),
                                                       //Bina üst görünüş metni
                                                       Column(
                                                         children: <Widget>[
                                                           Spacer(
                                                             flex: 6,
                                                           ),
                                                           Expanded(
                                                             flex: 2,
                                                             child: Row(
                                                               children: <Widget>[
                                                                 Spacer(),
                                                                 Expanded(
                                                                   flex: 2,
                                                                   child: SizedBox(
                                                                     child: Container(
                                                                       alignment: Alignment.center,
                                                                       child: AutoSizeText(
                                                                         Dil()
                                                                             .sec(
                                                                                 dilSecimi,
                                                                                 "tv57"),
                                                                         textAlign:
                                                                             TextAlign.center,
                                                                         style: TextStyle(
                                                                           color: Colors.white,
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
                                                             ),
                                                           ),
                                                           Spacer(
                                                             flex: 6,
                                                           )
                                                         ],
                                                       ),
                                                       //Ön ve Arka metin
                                                       Row(
                                                         children: <Widget>[
                                                           Expanded(
                                                             child: Column(
                                                               children: <Widget>[
                                                                 Spacer(flex: 2,),
                                                                 Expanded(
                                                                   child: RotatedBox(
                                                                     quarterTurns: 0,
                                                                     child: SizedBox(
                                                                       child: Container(
                                                                         padding: EdgeInsets.only(left: 3*oran),
                                                                         alignment: Alignment.centerLeft,
                                                                         child: AutoSizeText(
                                                                           Dil()
                                                                               .sec(dilSecimi, "tv58"),
                                                                           textAlign: TextAlign.center,
                                                                           style: TextStyle(
                                                                             color: Colors.white,
                                                                             fontSize: 40,
                                                                             fontFamily: 'Kelly Slab'
                                                                           ),
                                                                           maxLines: 1,
                                                                           minFontSize: 8,
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                 ),
                                                                 Spacer(flex: 2,),
                                                               ],
                                                             ),
                                                           ),
                                                           Spacer(flex: 2,),
                                                           Expanded(
                                                             child: Column(
                                                               children: <Widget>[
                                                                 Spacer(flex: 2,),
                                                                 Expanded(
                                                                   child: RotatedBox(
                                                                     quarterTurns: 0,
                                                                     child: SizedBox(
                                                                       child: Container(
                                                                         padding: EdgeInsets.only(right: 3*oran),
                                                                         alignment: Alignment.centerRight,
                                                                         child: AutoSizeText(
                                                                           Dil()
                                                                               .sec(dilSecimi, "tv59"),
                                                                           textAlign: TextAlign.center,
                                                                           style: TextStyle(
                                                                             color: Colors.white,
                                                                             fontSize: 40,
                                                                             fontFamily: 'Kelly Slab'
                                                                           ),
                                                                           maxLines: 1,
                                                                           minFontSize: 8,
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                 ),
                                                                 Spacer(flex: 2,),
                                                               ],
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                     ],
                                                   )),
                                               Expanded(
                                                 flex: 6,
                                                 child: Column(
                                                   children: <Widget>[
                                                     Expanded(
                                                       child: Row(
                                                         children: <Widget>[
                                                           _siloHaritaUnsur(16, oran, "tv83", 1),
                                                           _siloHaritaUnsur(17, oran, "tv83", 1),
                                                         ],
                                                       ),
                                                     ),
                                                     Expanded(
                                                       child: Row(
                                                         children: <Widget>[
                                                           _siloHaritaUnsur(18, oran, "tv83", 1),
                                                           Spacer()
                                                         ],
                                                       ),
                                                     ),
                                                     Expanded(
                                                       child: Row(
                                                         children: <Widget>[
                                                           _siloHaritaUnsur(19, oran, "tv83", 1),
                                                           _siloHaritaUnsur(20, oran, "tv83", 1),
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
                                         flex: 7,
                                         child: Row(
                                           children: <Widget>[
                                             Spacer(
                                               flex: 6,
                                             ),
                                             Expanded(
                                               flex: 3,
                                               child: Column(
                                                 children: <Widget>[
                                                   _siloHaritaUnsur(29, oran, "tv83", 1),
                                                   _siloHaritaUnsur(30, oran, "tv83", 1),
                                                 ],
                                               ),
                                             ),
                                             Expanded(
                                               flex: 3,
                                               child: Column(
                                                 children: <Widget>[
                                                   _siloHaritaUnsur(28, oran, "tv83", 1),
                                                   Spacer()
                                                 ],
                                               ),
                                             ),
                                             Spacer(
                                               flex: 3,
                                             ),
                                             Expanded(
                                               flex: 3,
                                               child: Column(
                                                 children: <Widget>[
                                                   _siloHaritaUnsur(27, oran, "tv83", 1),
                                                   Spacer()
                                                 ],
                                               ),
                                             ),
                                             Expanded(
                                               flex: 3,
                                               child: Column(
                                                 children: <Widget>[
                                                   _siloHaritaUnsur(25, oran, "tv83", 1),
                                                   _siloHaritaUnsur(26, oran, "tv83", 1),
                                                 ],
                                               ),
                                             ),
                                             Expanded(
                                               flex: 3,
                                               child: Column(
                                                 children: <Widget>[
                                                   _siloHaritaUnsur(24, oran, "tv83", 1),
                                                   Spacer()
                                                 ],
                                               ),
                                             ),
                                             Spacer(
                                               flex: 3,
                                             ),
                                             Expanded(
                                               flex: 3,
                                               child: Column(
                                                 children: <Widget>[
                                                   _siloHaritaUnsur(23, oran, "tv83", 1),
                                                   Spacer()
                                                 ],
                                               ),
                                             ),
                                             Expanded(
                                               flex: 3,
                                               child: Column(
                                                 children: <Widget>[
                                                   _siloHaritaUnsur(21, oran, "tv83", 1),
                                                   _siloHaritaUnsur(22, oran, "tv83", 1),
                                                 ],
                                               ),
                                             ),
                                             Spacer(
                                               flex: 6,
                                             ),
                                           ],
                                         ),
                                       ),
                                         
                                       ],
                                     ),
                                  ),
                                  //Silo anlık değerler
                                  Visibility(visible: siloAdet=="0" ? false: true,
                                                                      child: Row(
                                      children: <Widget>[
                                        Spacer(flex: 3,),
                                        //Silo 1-2
                                        Expanded(flex: 3,
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(flex: 6,
                                                child: _siloDegerUnsur(oran, 1)
                                              ),
                                              Spacer(flex: 38,),
                                              
                                              Expanded(flex: 6,
                                                child: _siloDegerUnsur(oran, 2)
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        //Silo 3-4
                                        Expanded(flex: 3,
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(flex: 6,
                                                child: _siloDegerUnsur(oran, 3)
                                              ),
                                              Spacer(flex: 38,),
                                              
                                              Expanded(flex: 6,
                                                child: _siloDegerUnsur(oran, 4)
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                        Spacer(flex: 3,)   
                                      ],
                                    ),
                                  ),
                                  //Günlük tüketimler
                                  Visibility(visible: siloAdet=="0" ? false: true,
                                                                      child: Row(
                                      children: <Widget>[
                                        Spacer(flex: 16,),
                                        Expanded(flex: 3,
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(flex: 4,
                                                child: Container(
                                                  margin: EdgeInsets.only(top: 3*oran,right: 3*oran),
                                                  decoration: BoxDecoration(
                                                    color: Colors.yellow[200],
                                                    border: Border.all(width: 1,color:Color.fromRGBO(115, 87, 3, 1),),
                                                    borderRadius: BorderRadius.circular(10*oran),
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Spacer(),

                                                      Expanded(flex: 8,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            padding: EdgeInsets.only(left: 1*oran),
                                                            child: AutoSizeText(
                                                              Dil().sec(dilSecimi, "tv605"),
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black
                                                                  ),
                                                              maxLines: 2,
                                                              minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        Expanded(flex: 10,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.topCenter,
                                                            padding: EdgeInsets.only(left: 1*oran),
                                                            child: AutoSizeText(
                                                              toplamYemTuketim,
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black
                                                                  ),
                                                              maxLines: 2,
                                                              minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),


                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Spacer(flex: 6,),
                                              Expanded(flex: 4,
                                                child: Container(
                                                  margin: EdgeInsets.only(bottom: 3*oran,right: 3*oran),
                                                  decoration: BoxDecoration(
                                                    color: Colors.yellow[200],
                                                    border: Border.all(width: 1,color: Color.fromRGBO(115, 87, 3, 1),),
                                                    borderRadius: BorderRadius.circular(10*oran),
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      //Spacer(),

                                                      Expanded(flex: 14,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            padding: EdgeInsets.only(left: 1*oran),
                                                            child: AutoSizeText(
                                                              Dil().sec(dilSecimi, "tv606"),
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold,
                                                                  ),
                                                              maxLines: 3,
                                                              minFontSize: 5,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        Expanded(flex: 10,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.topCenter,
                                                            padding: EdgeInsets.only(left: 1*oran),
                                                            child: AutoSizeText(
                                                              hayvanBasinaYemTuketim,
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold,
                                                                  ),
                                                              maxLines: 2,
                                                              minFontSize: 5,
                                                              ),
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
                                      ],
                                    ),
                                  ),
                                  //Silo yoksa görünecek metin
                                  Visibility(visible: siloAdet=="0" ? true: false,
                                    child: SizedBox(
                                      child: Container(
                                        margin: EdgeInsets.only(left: 2*oran,right: 2*oran),
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          Dil().sec(dilSecimi, "tv623"),
                                          textAlign:
                                              TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontFamily:'Kelly Slab',
                                              fontWeight:FontWeight.bold,
                                              color: Colors.grey[500],
                                              ),
                                          maxLines: 4,
                                          minFontSize: 8,
                                        ),
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
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Spacer(flex: 5,),
                                    Expanded(flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10*oran),
                                          color: Colors.grey[300],
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(flex: 7,
                                             child: SizedBox(
                                               child: Container(
                                                 alignment: Alignment.center,
                                                 padding: EdgeInsets.only(left: 1*oran),
                                                 child: AutoSizeText(
                                                   Dil().sec(dilSecimi, "tv620"),
                                                   textAlign:
                                                       TextAlign.center,
                                                   style: TextStyle(
                                                       fontSize: 50.0,
                                                       fontFamily:'Kelly Slab',
                                                       color: Colors.red[800]
                                                       ),
                                                   maxLines: 1,
                                                   minFontSize: 5,
                                                 ),
                                               ),
                                             ),
                                         ),
                                            Expanded(flex: 11,
                                              child: Row(
                                                children: <Widget>[
                                                  Spacer(flex: 1,),
                                                  Expanded(flex: 4,
                                                   child: SizedBox(
                                                     child: Container(
                                                       alignment: Alignment.centerRight,
                                                       child: AutoSizeText(
                                                         ortHissedilirSicaklik,
                                                         textAlign:TextAlign.center,
                                                         style: TextStyle(
                                                             fontSize: 50.0,
                                                             fontFamily:'Kelly Slab',
                                                             color: Colors.black,
                                                             fontWeight: FontWeight.bold
                                                             ),
                                                         maxLines: 1,
                                                         minFontSize: 5,
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                                  Expanded(flex: 2,
                                                   child: SizedBox(
                                                     child: Container(
                                                       alignment: Alignment.centerLeft,
                                                       padding: EdgeInsets.only(right: 2*oran),
                                                       child: AutoSizeText(
                                                         "°C",
                                                         textAlign:
                                                             TextAlign.center,
                                                         style: TextStyle(
                                                             fontSize: 50.0,
                                                             fontFamily:'Kelly Slab',
                                                             color: Colors.red[800]
                                                             ),
                                                         maxLines: 1,
                                                         minFontSize: 5,
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                                  Spacer(flex: 2,)
                                                ],
                                              ),
                                            ),
                                            
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(flex: 5,)
                                  ],
                                ),
                              ),
                                              
                              Expanded(flex: 2,
                                                              child: Row(
                                  children: <Widget>[
                                    Spacer(),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(dilSecimi, "tv426"),
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                color: Colors.grey[600]),
                                            textScaleFactor: oran, textAlign:TextAlign.center,
                                          ),
                                          Text(
                                            olumOrani,
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.blue[200]),
                                            textScaleFactor: oran,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(dilSecimi, "tv418"),
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                color: Colors.grey[600]),
                                            textScaleFactor: oran, textAlign:TextAlign.center,
                                          ),
                                          Text(
                                            guncelOluHayvanSayisi,
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.blue[200]),
                                            textScaleFactor: oran,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(dilSecimi, "tv427"),
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                color: Colors.grey[600]),
                                            textScaleFactor: oran,textAlign:TextAlign.center,
                                          ),
                                          Text(
                                            guncelHayvanSayisi,
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.blue[200]),
                                            textScaleFactor: oran,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(dilSecimi, "tv428"),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                color: Colors.grey[600]),
                                            textScaleFactor: oran,
                                          ),
                                          Text(
                                            suruYasiGunluk,
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.blue[200]),
                                            textScaleFactor: oran,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            Dil().sec(dilSecimi, "tv429"),
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                color: Colors.grey[600]),
                                            textScaleFactor: oran,textAlign:TextAlign.center,
                                          ),
                                          Text(
                                            suruYasiHaftalik,
                                            style: TextStyle(
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 30,
                                                color: Colors.blue[200]),
                                            textScaleFactor: oran,
                                          )
                                        ],
                                      ),
                                    ),
                                    Spacer()
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
        floatingActionButton: Container(width: 56*oran,height: 56*oran,
          child: FittedBox(
                      child: FloatingActionButton(
              onPressed: () {
                timerCancel = true;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Izleme(dbVeriler)),
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

      
      

      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        _veriGonder("32*$index*$veri");
      }

      setState(() {});
    });
  }

Future _degergiris2X0(int onlarUnsur, int birlerUnsur, int klepeIndex, int paramIndex,
      double oran, String dil, String baslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X0.Deger(
            onlarUnsur, birlerUnsur, klepeIndex, oran, dil, baslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (
          _onlar != val[0] ||
          _birler != val[1] ||
          _index != val[2]) {
          veriGonderilsinMi = true;
      }

      _onlar = val[0];
      _birler = val[1];
      _index = val[2];

      


      if (veriGonderilsinMi) {
        yazmaSonrasiGecikmeSayaci = 0;
        _veriGonder("32*");
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
      await Socket.connect('192.168.1.110', 2237).then((socket) {
        socket.add(utf8.encode('2*'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);
            if (gelenMesaj != "") {
              var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              siloAktuelAgirlik[1]=int.parse(degerler[0]);
              siloAktuelAgirlik[2]=int.parse(degerler[1]);
              siloAktuelAgirlik[3]=int.parse(degerler[2]);
              siloAktuelAgirlik[4]=int.parse(degerler[3]);
              toplamYemTuketim=degerler[4];
              hayvanBasinaYemTuketim=degerler[5];

              otoYEM=degerler[6]=="1" ? true : false;
              cks1ileriSaat=degerler[7];
              cks2ileriSaat=degerler[8];
              cks3ileriSaat=degerler[9];
              cks1geriSaat=degerler[10];
              cks2geriSaat=degerler[11];
              cks3geriSaat=degerler[12];

              otoAYD=degerler[13]=="1" ? true : false;
              acSaati1=degerler[14];
              kpSaati1=degerler[15];
              acSaati2=degerler[16];
              kpSaati2=degerler[17];

              for (var i = 18; i <= 29; i++) {
                sayacDeger[i-17]=degerler[i];
              }

              sayacGunlukToplamTuketim=degerler[30];
              sayacGunlukHayBasTuketim=degerler[31];

              setSicakligi=degerler[32];
              ortSicaklik=degerler[33];
              dogBolgeBitis=degerler[34];
              capBolgeBitis=degerler[35];

              olculenMakSic=degerler[36];
              olculenMinSic=degerler[37];
              olculenMakZmn=degerler[38];
              olculenMinZmn=degerler[39];
              
              icNem=degerler[40];
              disNem=degerler[41];
              
              ortHissedilirSicaklik=degerler[42];
              
              olumOrani=degerler[43];
              guncelOluHayvanSayisi=degerler[44];
              guncelHayvanSayisi=degerler[45];
              suruYasiGunluk=degerler[46];
              suruYasiHaftalik=degerler[47];
              
              yemlemeCKS1aktif=degerler[48]=="1" ? true : false;
              yemlemeCKS2aktif=degerler[49]=="1" ? true : false;
              yemlemeCKS3aktif=degerler[50]=="1" ? true : false;

              sayacSayisi=degerler[51];

              acKapaSaat2Aktiflik=degerler[49]=="1" ? true : false;
              dimmerVarMi=degerler[50]!="0" ? true : false;


              



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

  Widget _siloHaritaUnsur(int indexNo, double oran, String baslik, int degerGirisKodu) {
    return Expanded(
      child: Visibility(
        visible: siloVisibility[indexNo] ? true : false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: RawMaterialButton(
                  onPressed: () {

                  },
                  child: Stack(fit: StackFit.expand,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Spacer(),
                          Expanded(flex: 5,
                                                      child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image:
                                      AssetImage('assets/images/silo_izleme_icon.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(
                            flex: 2,
                          ),
                          //silo No
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: <Widget>[
                                Spacer(flex: 1),
                                Expanded(
                                  flex: 6,
                                  child: SizedBox(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: AutoSizeText(
                                            siloNo[indexNo].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 50.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Kelly Slab'),
                                        maxLines: 1,
                                        minFontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(flex: 2,)
                              ],
                            ),
                          ),
                          Spacer(flex: 2,),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _siloDegerUnsur(double oran, int index){
    String baslik="";
    if(index==1){
      baslik=Dil().sec(dilSecimi, "tv600");
    }else if(index==2){
      baslik=Dil().sec(dilSecimi, "tv601");
    }else if(index==3){
      baslik=Dil().sec(dilSecimi, "tv602");
    }else if(index==4){
      baslik=Dil().sec(dilSecimi, "tv603");
    }
    return Container(
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(115, 87, 3, 1),
                                                  borderRadius: BorderRadius.circular(5*oran)
                                                ),
                                                
                                                child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
  
                                                    Expanded(flex: 1,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.centerRight,
                                                            padding: EdgeInsets.only(left: 1*oran),
                                                            child: AutoSizeText(
                                                              baslik,
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.grey[200]
                                                                  ),
                                                              maxLines: 1,
                                                              minFontSize: 5,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    Expanded(flex: 3,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.center,
                                                            child: AutoSizeText(
                                                              siloAktuelAgirlik[index].toString(),
                                                              textAlign:TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold
                                                                  ),
                                                              maxLines:1,
                                                              minFontSize: 5,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    Expanded(
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.centerLeft,
                                                            padding: EdgeInsets.only(right: 2*oran),
                                                            child: AutoSizeText(
                                                              Dil().sec(dilSecimi, "tv604"),
                                                              textAlign:
                                                                  TextAlign.center,
                                                              style: TextStyle(
                                                                  fontSize: 50.0,
                                                                  fontFamily:'Kelly Slab',
                                                                  color: Colors.grey[200]
                                                                  ),
                                                              maxLines: 1,
                                                              minFontSize: 5,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                 ],
                                                )
                                              );
  }


  Widget autoManGosterge(bool deger, double oran, String dilSecimi){
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4*oran),
          color:deger ? Colors.green : Colors.yellow,
        ),
        alignment: Alignment.center,
        child: AutoSizeText(
          deger ? Dil().sec(dilSecimi, "tv455") : Dil().sec(dilSecimi, "tv456"),
          style: TextStyle(
              fontSize: 50.0,
              fontFamily:
                  'Kelly Slab',
                  color: deger ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold
              ),
          maxLines: 1,
          minFontSize: 8,
        ),
      ),
    );
  }


  Widget suSayacUnsur(int index, double oran){
    
    return Visibility( visible: int.parse(sayacSayisi)>=index ? true : false,
          child: Row(
        
                children: <Widget>[

                  Expanded(flex: 1,
                    child: SizedBox(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: AutoSizeText(
                          "$index:",
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                              fontSize: 50.0,
                              fontFamily:
                                  'Kelly Slab',
                              fontWeight:
                                  FontWeight.bold),
                          maxLines: 2,
                          minFontSize: 8,
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 2,
                    child: SizedBox(
                      child: Container(
                        margin: EdgeInsets.all(1*oran),
                        color: Colors.blue[200],
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          sayacDeger[index],
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                              fontSize: 50.0,
                              fontFamily:
                                  'Kelly Slab',
                              fontWeight:
                                  FontWeight.bold),
                          maxLines: 2,
                          minFontSize: 8,
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
    );
  }

  String saatGetir(int saatNo) {
    String veri = "";

    if (saatNo == 1) {
      veri = 'tv506';
    }
    if (saatNo == 2) {
      veri = 'tv507';
    }
    if (saatNo == 3) {
      veri = 'tv508';
    }
    if (saatNo == 4) {
      veri = 'tv509';
    }
    if (saatNo == 5) {
      veri = 'tv510';
    }
    if (saatNo == 6) {
      veri = 'tv511';
    }
    if (saatNo == 7) {
      veri = 'tv512';
    }
    if (saatNo == 8) {
      veri = 'tv513';
    }
    if (saatNo == 9) {
      veri = 'tv514';
    }
    if (saatNo == 10) {
      veri = 'tv515';
    }
    if (saatNo == 11) {
      veri = 'tv516';
    }
    if (saatNo == 12) {
      veri = 'tv517';
    }
    if (saatNo == 13) {
      veri = 'tv518';
    }
    if (saatNo == 14) {
      veri = 'tv519';
    }
    if (saatNo == 15) {
      veri = 'tv520';
    }
    if (saatNo == 16) {
      veri = 'tv521';
    }
    if (saatNo == 17) {
      veri = 'tv522';
    }
    if (saatNo == 18) {
      veri = 'tv523';
    }
    if (saatNo == 19) {
      veri = 'tv524';
    }
    if (saatNo == 20) {
      veri = 'tv525';
    }
    if (saatNo == 21) {
      veri = 'tv526';
    }
    if (saatNo == 22) {
      veri = 'tv527';
    }
    if (saatNo == 23) {
      veri = 'tv528';
    }
    if (saatNo == 24) {
      veri = 'tv529';
    }
    if (saatNo == 25) {
      veri = 'tv530';
    }
    if (saatNo == 26) {
      veri = 'tv531';
    }
    if (saatNo == 27) {
      veri = 'tv532';
    }
    if (saatNo == 28) {
      veri = 'tv533';
    }
    if (saatNo == 29) {
      veri = 'tv534';
    }
    if (saatNo == 30) {
      veri = 'tv535';
    }
    if (saatNo == 31) {
      veri = 'tv536';
    }
    if (saatNo == 32) {
      veri = 'tv537';
    }
    if (saatNo == 33) {
      veri = 'tv538';
    }
    if (saatNo == 34) {
      veri = 'tv539';
    }
    if (saatNo == 35) {
      veri = 'tv540';
    }
    if (saatNo == 36) {
      veri = 'tv541';
    }
    if (saatNo == 37) {
      veri = 'tv542';
    }
    if (saatNo == 38) {
      veri = 'tv543';
    }
    if (saatNo == 39) {
      veri = 'tv544';
    }
    if (saatNo == 40) {
      veri = 'tv545';
    }
    if (saatNo == 41) {
      veri = 'tv546';
    }
    if (saatNo == 42) {
      veri = 'tv547';
    }
    if (saatNo == 43) {
      veri = 'tv548';
    }
    if (saatNo == 44) {
      veri = 'tv549';
    }
    if (saatNo == 45) {
      veri = 'tv550';
    }
    if (saatNo == 46) {
      veri = 'tv551';
    }
    if (saatNo == 47) {
      veri = 'tv552';
    }
    if (saatNo == 48) {
      veri = 'tv553';
    }

    return veri;
  }

  
  //--------------------------METOTLAR--------------------------------

}
