import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/isisensor_haritasi.dart';
import 'package:toast/toast.dart';
import 'genel/alert_reset.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x2x0.dart';
import 'languages/select.dart';

class PedHaritasi extends StatefulWidget {
  List<Map> gelenDBveri;
  PedHaritasi(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }
  @override
  State<StatefulWidget> createState() {
    return PedHaritasiState(gelenDBveri);
  }
}

class PedHaritasiState extends State<PedHaritasi> {
//++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  List<Map> dbVeriler;
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "TR";
  String kurulumDurum = "0";
  List<int> pedHarita = new List(25);
  List<bool> pedVisibility = new List(25);
  List<int> pedNo = new List(25);
  List<int> cikisNo = new List(25);
  List<int> cikisNoGecici = new List(25);
  bool haritaOnay = false;
  int pedAdet = 0;

  int _onlarped = 1;
  int _birlerped = 0;
  int _onlarOut = 3;
  int _birlerOut = 3;
  int _degerNo = 0;

  double _oran1;
  bool veriGonderildi = false;
  bool pedNoTekerrur = false;
  bool cikisNoTekerrur = false;

  List<int> tumCikislar = new List(111);

//--------------------------DATABASE DEĞİŞKENLER--------------------------------


//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  PedHaritasiState(List<Map> dbVeri) {
    bool pedHaritaOK=false;
    bool pedCikisOK=false;
    bool tumCikislarVar = false;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if(dbVeri[i]["id"]==4){
        pedAdet = int.parse(dbVeri[i]["veri3"]);
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

      if(dbVeri[i]["id"]==18){
        if(dbVeri[i]["veri1"]=="ok"){
          pedHaritaOK=true;
        String xx=dbVeri[i]["veri2"];
        var fHaritalar = xx.split("#");
        for(int i=1;i<=24;i++ ){
          pedHarita[i]=int.parse(fHaritalar[i-1]);
          if(fHaritalar[i-1]!="0"){
          haritaOnay=true;
      }
      
    }

    for (int i = 1; i <= 24; i++) {
      if (pedHarita[i] != 0) {
        pedVisibility[i] = true;
      } else {
        pedVisibility[i] = false;
      }
    }

      }


    }

    if(dbVeri[i]["id"]==19){
        String xx;
        String yy;

        if(dbVeri[i]["veri1"]=="ok"){
          pedCikisOK=true;
          veriGonderildi=true;
          xx=dbVeri[i]["veri2"];
          yy=dbVeri[i]["veri3"];
          var pedNolar=xx.split("#");
          var cikisNolar=yy.split("#");
          for(int i=1;i<=24;i++){
            pedNo[i]=int.parse(pedNolar[i-1]);
            cikisNo[i]=int.parse(cikisNolar[i-1]);
          }

        }
      
      }

      
    }

    if(!pedHaritaOK){
      for(int i=1;i<=24;i++){
        pedHarita[i]=0;
        pedVisibility[i]=true;
      }
      
    }

    if(!pedCikisOK){
      for(int i=1;i<=24;i++){
        pedNo[i]=0;
        cikisNo[i]=0;
      }
    }


    if (!tumCikislarVar) {
      for (int i = 1; i <= 110; i++) {
        tumCikislar[i] = 0;
      }
    }

    for (int i = 1; i <= 24; i++) {
        cikisNoGecici[i]=cikisNo[i];
      }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------


  @override
  Widget build(BuildContext context) {
//++++++++++++++++++++++++++DATABASE'den SATIRLARI ÇEKME+++++++++++++++++++++++++++++++
    dbSatirlar = dbHelper.satirlariCek();
    final satirSayisi = dbHelper.satirSayisi();
    satirSayisi.then((int satirSayisi) => dbSatirSayisi = satirSayisi);
    satirSayisi.whenComplete(() {
      if (dbSayac == 0) {
        dbSatirlar.then((List<Map> satir) => _satirlar(satir));
        dbSayac++;
      }
    });
//--------------------------DATABASE'den SATIRLARI ÇEKME--------------------------------

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
                      SelectLanguage().selectStrings(dilSecimi, "tv47"),
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
        //ped Harita Oluşturma Bölümü
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
                //Tüm duvarlar Ped görünümü
                Expanded(
                  flex: 6,
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      //Ön ve Sağ Duvar
                      Expanded(flex: 20,
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
                            Expanded(flex: 8,
                              child: Stack(children: <Widget>[
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
                                  Row(
                                    children: <Widget>[
                                      Spacer(),
                                      Expanded(flex: 4,
                                                                              child: Column(children: <Widget>[
                                          Visibility(child: _pedHaritaUnsur(1),visible: pedVisibility[1] ? true : false,),
                                          Visibility(child: _pedHaritaUnsur(2),visible: pedVisibility[2] ? true : false,),
                                          Visibility(child: _pedHaritaUnsur(3),visible: pedVisibility[3] ? true : false,),
                                        ],),
                                      ),
                                      Spacer()
                                    ],
                                  )
                                ],)
                            ),
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
                            Expanded(flex: 16,
                              child: Stack(children: <Widget>[
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
                                Row(children: <Widget>[
                                  Expanded(
                                                                      child: Column(children: <Widget>[
                                    Visibility(child: _pedHaritaUnsur(4),visible: pedVisibility[4] ? true : false,),
                                    Visibility(child: _pedHaritaUnsur(5),visible: pedVisibility[5] ? true : false,),
                                    Visibility(child: _pedHaritaUnsur(6),visible: pedVisibility[6] ? true : false,),
                                ],),
                                  ),
                                Expanded(
                                                                  child: Column(children: <Widget>[
                                    Visibility(child: _pedHaritaUnsur(7),visible: pedVisibility[7] ? true : false,),
                                    Visibility(child: _pedHaritaUnsur(8),visible: pedVisibility[8] ? true : false,),
                                    Visibility(child: _pedHaritaUnsur(9),visible: pedVisibility[9] ? true : false,),
                                  ],),
                                ),
                                Expanded(
                                                                  child: Column(children: <Widget>[
                                    Visibility(child: _pedHaritaUnsur(10),visible: pedVisibility[10] ? true : false,),
                                    Visibility(child: _pedHaritaUnsur(11),visible: pedVisibility[11] ? true : false,),
                                    Visibility(child: _pedHaritaUnsur(12),visible: pedVisibility[12] ? true : false,),
                                  ],),
                                )

                                ],)
                              ],)
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      //Arka ve Sol Duvar
                      Expanded(flex: 20,
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
                            Expanded(flex: 8,
                              child: Stack(children: <Widget>[
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
                                Row(
                                  children: <Widget>[
                                    Spacer(),
                                    Expanded(
                                                                          child: Column(children: <Widget>[
                                        Visibility(child: _pedHaritaUnsur(22),visible: pedVisibility[22] ? true : false,),
                                        Visibility(child: _pedHaritaUnsur(23),visible: pedVisibility[23] ? true : false,),
                                        Visibility(child: _pedHaritaUnsur(24),visible: pedVisibility[24] ? true : false,),
                                      ],),
                                    ),
                                    Spacer()
                                  ],
                                )
                              ],)
                            ),
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
                            Expanded(flex: 16,
                              child: Stack(children: <Widget>[
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
                                                                          child: Column(children: <Widget>[
                                        Visibility(child: _pedHaritaUnsur(13),visible: pedVisibility[13] ? true : false,),
                                        Visibility(child: _pedHaritaUnsur(14),visible: pedVisibility[14] ? true : false,),
                                        Visibility(child: _pedHaritaUnsur(15),visible: pedVisibility[15] ? true : false,),
                                      ],),
                                    ),
                                    Expanded(
                                                                          child: Column(children: <Widget>[
                                        Visibility(child: _pedHaritaUnsur(16),visible: pedVisibility[16] ? true : false,),
                                        Visibility(child: _pedHaritaUnsur(17),visible: pedVisibility[17] ? true : false,),
                                        Visibility(child: _pedHaritaUnsur(18),visible: pedVisibility[18] ? true : false,),
                                      ],),
                                    ),
                                    Expanded(
                                                                          child: Column(children: <Widget>[
                                        Visibility(child: _pedHaritaUnsur(19),visible: pedVisibility[19] ? true : false,),
                                        Visibility(child: _pedHaritaUnsur(20),visible: pedVisibility[20] ? true : false,),
                                        Visibility(child: _pedHaritaUnsur(21),visible: pedVisibility[21] ? true : false,),
                                      ],),
                                    ),
                                  ],
                                )
                              ],)
                            ),
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

                            for (int i = 1; i <= 24; i++) {
                              if (pedHarita[i] == 1) {
                                sayac++;
                              }
                            }

                            if (sayac < pedAdet) {
                              //Haritada seçilen ped sayısı eksik
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast29"),
                                  context,
                                  duration: 3);
                            } else if (sayac > pedAdet) {
                              //Haritada seçilen ped sayısı yüksek
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast30"),
                                  context,
                                  duration: 3);
                            }  else {
                              //++++++++++++++++++++++++ONAY BÖLÜMÜ+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast8"),
                                  context,
                                  duration: 3);
                              haritaOnay = true;

                              for (int i = 1; i <= 24; i++) {
                                if (pedHarita[i] != 0) {
                                  pedVisibility[i] = true;
                                } else {
                                  pedVisibility[i] = false;
                                }
                              }

                              String veri = "";

                              for (int i = 1; i <= 24; i++) {
                                veri = veri + pedHarita[i].toString() + "#";
                              }
                              
                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  18, "ok", veri, "0", "0");

                              _veriGonder("18", "23", veri, "0", "0", "0");
                              

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
                            String cikisVeri = "";
                            String noVeri = "";
                            String tumCikislarVeri = "";
                            for (int i = 1; i <= 24; i++) {
                              if (pedHarita[i] == 1) {
                                if (pedNo[i] == 0 || cikisNo[i] == 0) {
                                  noKontrol = true;
                                }
                              }
                              cikisVeri =
                                  cikisVeri + cikisNo[i].toString() + "#";
                              noVeri = noVeri + pedNo[i].toString() + "#";
                            }

                            for(int i=1;i<=24;i++){
                                  if(cikisNoGecici[i]!=cikisNo[i]){
                                  
                                  if(tumCikislar[cikisNo[i]]==0){
                                      tumCikislar[cikisNoGecici[i]]=0;
                                  }else{
                                    cikisKullanimda=true;
                                  }
                                    
                                  }
                              }

                              if(!cikisKullanimda){
                              for(int i=1;i<=24;i++){
                                if(cikisNo[i]!=0){
                                  tumCikislar[cikisNo[i]]=1;
                                }
                              }
                              }
                              for(int i=1;i<=110;i++){
                                  tumCikislarVeri = tumCikislarVeri + tumCikislar[i].toString() + "#";
                              }




                            if (noKontrol) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast36"),
                                  context,
                                  duration: 3);
                            } else if (pedNoTekerrur) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast32"),
                                  context,
                                  duration: 3);
                            } else if (cikisNoTekerrur) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast26"),
                                  context,
                                  duration: 3);
                            }else if (cikisKullanimda) {
                              Toast.show(
                                  SelectLanguage()
                                      .selectStrings(dilSecimi, "toast38"),
                                  context,
                                  duration: 3);
                            } else {
                              veriGonderildi = true;
                              
                              _veriGonder(
                                  "19", "24", noVeri, cikisVeri, "0", "0");
                                  _veriGonder(
                                  "25", "27", tumCikislarVeri, "0", "0", "0");
                              dbHelper.veriYOKSAekleVARSAguncelle(
                                  19, "ok", noVeri, cikisVeri, "0").then((deneme){
                                    dbHelper.veriYOKSAekleVARSAguncelle(
                                  22, "ok", tumCikislarVeri, "0", "0");
                                  });

                                  for (int i = 1; i <= 24; i++) {
                                    cikisNoGecici[i]=cikisNo[i];
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
                              builder: (context) => IsiSensorHaritasi(dbVeriler)),
                        ).then((onValue) {
                            _dbVeriCekme();
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

    dbVeriler=satirlar;
  }

_dbVeriCekme(){
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
      imagePath = 'assets/images/ped_harita_icon.png';
    } else {
      imagePath = 'assets/images/soru_isareti.png';
    }
    return imagePath;
  }

  Future _degergiris2X2X0() async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X2X0.Deger(_onlarped, _birlerped, _onlarOut,
            _birlerOut, _degerNo, _oran1, dilSecimi,"tv46");
      },
    ).then((val) {
      if (_onlarped != val[0] ||
          _birlerped != val[1] ||
          _onlarOut != val[2] ||
          _birlerOut != val[3]) {
        veriGonderildi = false;
      }
      _onlarped = val[0];
      _birlerped = val[1];
      _onlarOut = val[2];
      _birlerOut = val[3];
      _degerNo = val[4];

      pedNo[_degerNo] =
          int.parse(_onlarped.toString() + _birlerped.toString());
      cikisNo[_degerNo] =
          int.parse(_onlarOut.toString() + _birlerOut.toString());
      pedNoTekerrur = false;
      cikisNoTekerrur = false;

      for (int i = 1; i <= 24; i++) {
        for (int k = 1; k <= 24; k++) {
          if (i != k &&
              pedNo[i] == pedNo[k] &&
              pedNo[i] != 0 &&
              pedNo[k] != 0) {
            pedNoTekerrur = true;
            break;
          }
          if (pedNoTekerrur) {
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

  Widget _pedHaritaUnsur(int indexNo) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: RawMaterialButton(
                onPressed: () {
                  if (haritaOnay) {

                    _onlarped = pedNo[indexNo] < 10
                        ? 0
                        : (pedNo[indexNo] ~/ 10).toInt();
                    _birlerped = pedNo[indexNo] % 10;
                    _onlarOut = cikisNo[indexNo] < 10
                        ? 0
                        : (cikisNo[indexNo] ~/ 10).toInt();
                    _birlerOut = cikisNo[indexNo] % 10;
                    _degerNo = indexNo;
                    _degergiris2X2X0();
                  } else {

                    if (pedHarita[indexNo] == 0 ||
                        pedHarita[indexNo] == null) {
                      pedHarita[indexNo] = 1;
                    }  else if (pedHarita[indexNo] == 1) {
                      pedHarita[indexNo] = 0;
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
                            image: AssetImage(imageGetir(pedHarita[indexNo])),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      opacity: pedVisibility[indexNo] &&
                              haritaOnay &&
                              pedHarita[indexNo] == 1
                          ? 1
                          : 1,
                    ),
                    Visibility(
                      visible: haritaOnay && pedHarita[indexNo] != 0
                          ? true
                          : false,
                      child: Visibility(
                        visible: haritaOnay && pedHarita[indexNo] == 1
                            ? true
                            : false,
                        child: Row(
                          children: <Widget>[
                            Spacer(flex: 5,),
                            //ped No
                            Expanded(flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                                  dilSecimi, "tv45") +
                                              pedNo[indexNo].toString(),
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
                            //Çıkış No
                            Expanded(flex: 5,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
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

  _veriGonder(String dbKod, String id, String v1, String v2, String v3,String v4) async {
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

        

        for (int i = 1; i <= 24; i++) {
          if(cikisNo[i] != 0){
            tumCikislar[cikisNo[i]]=0;
          }
        }

        for(int i=1;i<=110;i++){
            tumCikislarVeri = tumCikislarVeri + tumCikislar[i].toString() + "#";
        }

        for (int i = 1; i <= 24; i++) {
          pedHarita[i] = 0;
          pedNo[i] = 0;
          cikisNo[i] = 0;
          pedVisibility[i] = true;
        }
        haritaOnay = false;

        dbHelper.veriYOKSAekleVARSAguncelle(18, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(19, "0", "0", "0", "0");
        dbHelper.veriYOKSAekleVARSAguncelle(22, "ok", tumCikislarVeri, "0", "0");
        _veriGonder("20", "0", "0", "0", "0", "0");
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
