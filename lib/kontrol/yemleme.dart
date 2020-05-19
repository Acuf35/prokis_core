import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/genel_ayarlar/kontrol.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_4x0.dart';
import 'package:prokis/languages/select.dart';

class Yemleme extends StatefulWidget {
  List<Map> gelenDBveri;
  Yemleme(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return YemlemeState(gelenDBveri);
  }
}

class YemlemeState extends State<Yemleme> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String disNemAktif = "1";
  bool format24saatlik=true;

  
  List<Map> dbVeriler;

  int _binler = 0;
  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _index = 0;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  List<bool> yemIleri1 = new List(49);
  List<bool> yemGeri1 = new List(49);
  List<bool> yemIleri2 = new List(49);
  List<bool> yemGeri2 = new List(49);
  List<bool> yemIleri3 = new List(49);
  List<bool> yemGeri3 = new List(49);

  bool yemCikis1Aktif=false;
  bool yemCikis2Aktif=false;
  bool yemCikis3Aktif=false;

  bool yem1AktifKurulumdan = false;
  bool yem2AktifKurulumdan = false;
  bool yem3AktifKurulumdan = false;

  String sinyalSuresi="900";

  bool veriGonderildi = false;

  String baglantiDurum="";


  

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  YemlemeState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 13) {
        disNemAktif = dbVeri[i]["veri4"];
      }

      if (dbVeri[i]["id"] == 34) {
        format24saatlik = dbVeri[i]["veri1"] =="1" ? true: false;
      }

      if (dbVeri[i]["id"] == 31) {
        String xx;
        xx = dbVeri[i]["veri3"];
        var aktifYemCikislar = xx.split("#");
        yem1AktifKurulumdan = aktifYemCikislar[0] == "1" ? true : false;
        yem2AktifKurulumdan = aktifYemCikislar[1] == "1" ? true : false;
        yem3AktifKurulumdan = aktifYemCikislar[2] == "1" ? true : false;

        
      }
    }

    for (var i = 1; i < 49; i++) {
      yemIleri1[i] = false;
      yemIleri2[i] = false;
      yemIleri3[i] = false;
      yemGeri1[i] = false;
      yemGeri2[i] = false;
      yemGeri3[i] = false;
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {



    if (timerSayac == 0) {
      
      Metotlar().takipEt('29*', 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
              setState(() {});
            }else{
              takipEtVeriIsleme(veri);
              baglantiDurum="";
            }
        });

    }

    timerSayac++;





    var oran = MediaQuery.of(context).size.width / 731.4;


    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv113',baglantiDurum),
        body: Column(
          children: <Widget>[
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
                        Metotlar().getSystemTime(dbVeriler),
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
                        Metotlar().getSystemDate(dbVeriler),
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
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 10 * oran),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          Dil().sec(dilSecimi, "tv561"),
                          textScaleFactor: oran,
                          style: TextStyle(
                            fontFamily: 'Kelly Slab',
                          ),
                          ),
                        RawMaterialButton(
                          onPressed: (){

                            int sayi=int.parse(sinyalSuresi);
                            _binler = sayi < 1000 ? 0 : (sayi ~/ 1000).toInt();
                            _yuzler = sayi < 100 ? 0 : ((sayi % 1000) ~/ 100).toInt();
                            _onlar = sayi < 10 ? 0 : ((sayi % 100) ~/ 10).toInt();
                            _birler = sayi % 10;
                            _index = 4;

                            _degergiris4X0(
                              _binler,
                              _yuzler,
                                _onlar,
                                _birler,
                                _index,
                                oran,
                                dilSecimi,
                                "tv561",
                                "");

                        },
                        child: Text(
                          sinyalSuresi,textScaleFactor: oran,
                          style: TextStyle(
                            fontFamily: 'Kelly Slab',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                          ),
                          fillColor: Colors.orange[700],
                        
                        
                        ),
                      ],
                    ),
                    Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Visibility(visible: yemCikis1Aktif,
                                                              child: Column(
                                          children: <Widget>[
                                            Expanded(flex: 33,
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                              Spacer(),
                                              Expanded(flex: 5,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: 5*oran),
                                                child: ileriGeriButon("tv557", "tv554", oran,1),
                                              
                                              
                                              ),
                                                ),
                                              Spacer(),
                                              Expanded(flex: 5,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: 5*oran),
                                                child: ileriGeriButon("tv558", "tv554", oran,2),
                                              ),
                                                ),
                                              Spacer(),



                                              ],
                                            ),
                                            ),
                                            Spacer(),
                                            Expanded(flex: 6,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.centerRight,
                                                            child: AutoSizeText(
                                                              Dil().sec(
                                                                  dilSecimi, "tv557"),
                                                              textAlign:
                                                                  TextAlign.right,
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
                                            Spacer(),
                                            Expanded(flex: 6,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.centerRight,
                                                            child: AutoSizeText(
                                                              Dil().sec(
                                                                  dilSecimi, "tv558"),
                                                              textAlign:
                                                                  TextAlign.right,
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
                                            Spacer(),
                                            
                                          ],
                                        ),
                              )),
                                      

                            Expanded(flex: 12,
                                                          child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        
                                        Text(
                                          Dil().sec(dilSecimi, "tv554"),
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        RawMaterialButton(
                                                              
                                                  onPressed: () {

                                                    if(yem1AktifKurulumdan){


                                                    if (yemCikis1Aktif) {
                                                      yemCikis1Aktif = false;
                                                    } else {
                                                      yemCikis1Aktif = true;
                                                    }

                                                    String veri=yemCikis1Aktif==true ? '1' : '0';
                                                              
                                                              yazmaSonrasiGecikmeSayaci = 0;
                                                              String komut="35*1*$veri";
                                                              Metotlar().veriGonder(komut, 2235).then((value){
                                                                if(value.split("*")[0]=="error"){
                                                                  Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                }else{
                                                                  Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                  
                                                                  baglanti = false;
                                                                  Metotlar().takipEt('29*', 2236).then((veri){
                                                                      if(veri.split("*")[0]=="error"){
                                                                        baglanti=false;
                                                                        baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                                                        setState(() {});
                                                                      }else{
                                                                        takipEtVeriIsleme(veri);
                                                                        baglantiDurum="";
                                                                      }
                                                                  });
                                                                }
                                                              });

                                                    setState(() {});

                                                    }else{
                                                      Toast.show(Dil().sec(dilSecimi, "toast85"), context,duration: 3);
                                                    }



                                                  },
                                                  child: Icon(
                                                    yemCikis1Aktif == true
                                                        ? Icons.check_box
                                                        : Icons.check_box_outline_blank,
                                                    color: yemCikis1Aktif == true
                                                        ? Colors.green[600]
                                                        : Colors.black,
                                                    size: 25 * oran,
                                                  ),
                                                  padding: EdgeInsets.all(0),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize.shrinkWrap,
                                                  constraints: BoxConstraints(),
                                                ),
                                         Container(width: 15*oran),                 
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 3,
                                    child: Visibility(visible: yemCikis1Aktif,
                                      child: yemSaatGostergeUnsurCOK(oran,yemIleri1,yemGeri1,format24saatlik)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        
                        ),

                    Expanded(
                        child: Container(color: Colors.grey[100],
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Visibility(visible: yemCikis2Aktif,
                                                                child: Column(
                                            children: <Widget>[
                                              Expanded(flex: 33,
                                                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                  Spacer(),
                                                  Expanded(flex: 5,
                                                child: Padding(
                                                  padding:  EdgeInsets.only(left: 5*oran),
                                                  child: ileriGeriButon("tv557", "tv555", oran,3),
                                                ),
                                                  ),
                                                  Spacer(),
                                                  Expanded(flex: 5,
                                                child: Padding(
                                                  padding:  EdgeInsets.only(left: 5*oran),
                                                  child: ileriGeriButon("tv558", "tv555", oran,4),
                                                ),
                                                  ),
                                                  Spacer(),



                                                ],
                                              ),
                                              ),
                                              Spacer(),
                                              Expanded(flex: 6,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.centerRight,
                                                              child: AutoSizeText(
                                                                Dil().sec(
                                                                    dilSecimi, "tv557"),
                                                                textAlign:
                                                                    TextAlign.right,
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
                                              Spacer(),
                                              Expanded(flex: 6,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment.centerRight,
                                                              child: AutoSizeText(
                                                                Dil().sec(
                                                                    dilSecimi, "tv558"),
                                                                textAlign:
                                                                    TextAlign.right,
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
                                              Spacer(),
                                              
                                            ],
                                          ),
                                )),
                                        

                              Expanded(flex: 12,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          
                                          Text(
                                            Dil().sec(dilSecimi, "tv555"),
                                            textScaleFactor: oran,
                                            style: TextStyle(
                                              fontFamily: 'Kelly Slab',
                                              fontWeight: FontWeight.bold
                                            ),
                                            ),
                                          RawMaterialButton(
                                                                
                                                    onPressed: () {

                                                      if (yem2AktifKurulumdan){

                                                      if (yemCikis2Aktif) {
                                                        yemCikis2Aktif = false;
                                                      } else {
                                                        yemCikis2Aktif = true;
                                                      }

                                                      String veri=yemCikis2Aktif==true ? '1' : '0';
                                                              
                                                              yazmaSonrasiGecikmeSayaci = 0;
                                                              String komut="35*2*$veri";
                                                              Metotlar().veriGonder(komut, 2235).then((value){
                                                                if(value.split("*")[0]=="error"){
                                                                  Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                }else{
                                                                  Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                  
                                                                  baglanti = false;
                                                                  Metotlar().takipEt('29*', 2236).then((veri){
                                                                      if(veri.split("*")[0]=="error"){
                                                                        baglanti=false;
                                                                        baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                                                        setState(() {});
                                                                      }else{
                                                                        takipEtVeriIsleme(veri);
                                                                        baglantiDurum="";
                                                                      }
                                                                  });
                                                                }
                                                              });

                                                      setState(() {});
                                                      }else{
                                                      Toast.show(Dil().sec(dilSecimi, "toast86"), context,duration: 3);
                                                    }
                                                    },
                                                    child: Icon(
                                                      yemCikis2Aktif == true
                                                          ? Icons.check_box
                                                          : Icons.check_box_outline_blank,
                                                      color: yemCikis2Aktif == true
                                                          ? Colors.green[600]
                                                          : Colors.black,
                                                      size: 25 * oran,
                                                    ),
                                                    padding: EdgeInsets.all(0),
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize.shrinkWrap,
                                                    constraints: BoxConstraints(),
                                                  ),
                                          Container(width: 15*oran),            
                                        ],
                                      ),
                                    ),
                                    Expanded(flex: 3,
                                      child: Visibility(visible: yemCikis2Aktif,
                                        child: yemSaatGostergeUnsurCOK(oran,yemIleri2,yemGeri2,format24saatlik)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        
                        ),

                    Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Visibility(visible: yemCikis3Aktif,
                                                              child: Column(
                                          children: <Widget>[
                                            Expanded(flex: 33,
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                              Spacer(),
                                              Expanded(flex: 5,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: 5*oran),
                                                child: ileriGeriButon("tv557", "tv556", oran,5),
                                              ),
                                                ),
                                              Spacer(),
                                              Expanded(flex: 5,
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: 5*oran),
                                                child: ileriGeriButon("tv558", "tv556", oran,6),
                                              ),
                                                ),
                                              Spacer(),



                                              ],
                                            ),
                                            ),
                                            Spacer(),
                                            Expanded(flex: 6,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.centerRight,
                                                            child: AutoSizeText(
                                                              Dil().sec(
                                                                  dilSecimi, "tv557"),
                                                              textAlign:
                                                                  TextAlign.right,
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
                                            Spacer(),
                                            Expanded(flex: 6,
                                                        child: SizedBox(
                                                          child: Container(
                                                            alignment: Alignment.centerRight,
                                                            child: AutoSizeText(
                                                              Dil().sec(
                                                                  dilSecimi, "tv558"),
                                                              textAlign:
                                                                  TextAlign.right,
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
                                            Spacer(),
                                            
                                          ],
                                        ),
                              )),
                                      

                            Expanded(flex: 12,
                                                          child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        
                                        Text(
                                          Dil().sec(dilSecimi, "tv556"),
                                          textScaleFactor: oran,
                                          style: TextStyle(
                                            fontFamily: 'Kelly Slab',
                                            fontWeight: FontWeight.bold
                                          ),
                                          ),
                                        RawMaterialButton(
                                                              
                                                  onPressed: () {
                                                    if(yem3AktifKurulumdan){
                                                    if (yemCikis3Aktif) {
                                                      yemCikis3Aktif = false;
                                                    } else {
                                                      yemCikis3Aktif = true;
                                                    }
                                                              String veri=yemCikis3Aktif==true ? '1' : '0';
                                                              

                                                              yazmaSonrasiGecikmeSayaci = 0;
                                                              String komut="35*3*$veri";
                                                              Metotlar().veriGonder(komut, 2235).then((value){
                                                                if(value.split("*")[0]=="error"){
                                                                  Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                                }else{
                                                                  Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                                  
                                                                  baglanti = false;
                                                                  Metotlar().takipEt('29*', 2236).then((veri){
                                                                      if(veri.split("*")[0]=="error"){
                                                                        baglanti=false;
                                                                        baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                                                        setState(() {});
                                                                      }else{
                                                                        takipEtVeriIsleme(veri);
                                                                        baglantiDurum="";
                                                                      }
                                                                  });
                                                                }
                                                              });

                                                    setState(() {});
                                                    }else{
                                                      Toast.show(Dil().sec(dilSecimi, "toast87"), context,duration: 3);
                                                    }
                                                  },
                                                  child: Icon(
                                                    yemCikis3Aktif == true
                                                        ? Icons.check_box
                                                        : Icons.check_box_outline_blank,
                                                    color: yemCikis3Aktif == true
                                                        ? Colors.green[600]
                                                        : Colors.black,
                                                    size: 25 * oran,
                                                  ),
                                                  padding: EdgeInsets.all(0),
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize.shrinkWrap,
                                                  constraints: BoxConstraints(),
                                                ),
                                          Container(width: 15*oran),                
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 3,
                                    child: Visibility(visible: yemCikis3Aktif,
                                      child: yemSaatGostergeUnsurCOK(oran,yemIleri3,yemGeri3,format24saatlik)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        
                        ),

                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: Opacity(opacity: 0.4,
                  child: Container(
            width: 56 * oran,
            height: 56 * oran,
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
        ),
        drawer: Metotlar().navigatorMenu(dilSecimi, context, oran),
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
                        Dil().sec(dilSecimi, "tv560"), //Sıcaklık diyagramı
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
                              Dil().sec(dilSecimi, "info22"),
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
        )
        );
  
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

  Future _degergiris4X0(int binlerUnsur,int yuzlerUnsur,int onlarUnsur, int birlerUnsur, int indexNo,
      double oran, String dil, String baslik, String onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris4X0.Deger(
            binlerUnsur, yuzlerUnsur,onlarUnsur,birlerUnsur, indexNo, oran, dil, baslik,onBaslik);
      },
    ).then((val) {
      veriGonderildi = false;
      if (_binler != val[0] || _yuzler != val[1] || _onlar != val[2] || _birler != val[3]) {
      veriGonderildi = true;
    }

    _binler = val[0];
    _yuzler = val[1];
    _onlar = val[2];
    _birler = val[3];
    _index = val[4];

    if(_binler*1000+_yuzler*100+_onlar*10+_birler > 1500){
      Toast.show(Dil().sec(dilSecimi, "toast88"), context,duration: 3);
    }else{

      sinyalSuresi=(_binler*1000+_yuzler*100+_onlar*10+_birler).toString();
      
      if(veriGonderildi){

          

          yazmaSonrasiGecikmeSayaci = 0;
          String komut="35*4*$sinyalSuresi";
          Metotlar().veriGonder(komut, 2235).then((value){
            if(value.split("*")[0]=="error"){
              Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
            }else{
              Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
              
              baglanti = false;
              Metotlar().takipEt('29*', 2236).then((veri){
                  if(veri.split("*")[0]=="error"){
                    baglanti=false;
                    baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                    setState(() {});
                  }else{
                    takipEtVeriIsleme(veri);
                    baglantiDurum="";
                  }
              });
            }
          });


          setState(() {});
      }

      
    }

    });
  }
  
  takipEtVeriIsleme(String gelenMesaj){
    
    var degerler = gelenMesaj.split('#');
              print(degerler);
              var ileriYem1;
              var geriYem1;
              var ileriYem2;
              var geriYem2;
              var ileriYem3;
              var geriYem3;

              if(degerler[0]!=''){
                ileriYem1=degerler[0].split("*");
              }

              if(degerler[1]!=''){
                geriYem1=degerler[1].split("*");
              }



              if(degerler[2]!=''){
                ileriYem2=degerler[2].split("*");
              }

              if(degerler[3]!=''){
                geriYem2=degerler[3].split("*");
              }



              if(degerler[4]!=''){
                ileriYem3=degerler[4].split("*");
              }

              if(degerler[5]!=''){
                geriYem3=degerler[5].split("*");
              }


              for (var i = 1; i < 49; i++) {

                if(degerler[0]!=''){
                  yemIleri1[i]=ileriYem1[i-1]=="True" ? true :false;
                }

                if(degerler[1]!=''){
                  yemGeri1[i]=geriYem1[i-1]=="True" ? true :false;
                }


                if(degerler[2]!=''){
                  yemIleri2[i]=ileriYem2[i-1]=="True" ? true :false;
                }

                if(degerler[3]!=''){
                  yemGeri2[i]=geriYem2[i-1]=="True" ? true :false;
                }


                if(degerler[4]!=''){
                  yemIleri3[i]=ileriYem3[i-1]=="True" ? true :false;
                }

                if(degerler[5]!=''){
                  yemGeri3[i]=geriYem3[i-1]=="True" ? true :false;
                }


             }

              var aktifler=degerler[6].split("*");
              yemCikis1Aktif=aktifler[0]=="True" ? true :false;
              yemCikis2Aktif=aktifler[1]=="True" ? true :false;
              yemCikis3Aktif=aktifler[2]=="True" ? true :false;

              sinyalSuresi=degerler[7];


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 

  Widget yemSaatGostergeUnsurTEK(List<bool> yemArabaIleri,List<bool> yemArabaGeri, double oran, int saatNo) {
    
    return Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(flex: 21,
            child: SizedBox(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: RotatedBox(quarterTurns: -1,
                                child: AutoSizeText(
                    Dil().sec(format24saatlik ? 'TR' : 'EN', Metotlar().saatGetir(saatNo)),
                    textAlign:
                        TextAlign.center,
                    style: TextStyle(
                        fontSize: 50.0,
                        fontFamily:
                            'Kelly Slab',),
                    maxLines: 1,
                    minFontSize: 8,
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          Expanded(flex: 6,
                    child: Container(
              width: 10 * oran,
              height: 10 * oran,
              color: yemArabaIleri[saatNo] ? Colors.green : Colors.black,
            ),
          ),
          Spacer(),
          Expanded(flex: 6,
                    child: Container(
              width: 10 * oran,
              height: 10 * oran,
              color: yemArabaGeri[saatNo] ? Colors.green : Colors.black,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget yemSaatGostergeUnsurCOK(double oran, List<bool> yemArabaIleri, List<bool> yemArabaGeri, bool format) {

    if(format){
      return Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                         
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 1),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 2),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 3),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 4),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 5),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 6),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 7),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 8),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 9),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 10),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 11),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 12),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 13),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 14),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 15),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 16),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 17),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 18),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 19),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 20),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 21),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 22),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 23),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 24),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 25),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 26),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 27),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 28),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 29),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 30),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 31),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 32),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 33),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 34),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 35),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 36),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 37),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 38),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 39),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 40),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 41),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 42),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 43),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 44),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 45),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 46),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 47),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 48),

                        ],
                      );
     
    }else{

      return Row(mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                         
                          
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 3),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 4),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 5),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 6),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 7),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 8),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 9),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 10),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 11),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 12),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 13),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 14),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 15),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 16),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 17),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 18),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 19),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 20),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 21),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 22),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 23),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 24),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 1),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 2),

                          
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 27),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 28),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 29),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 30),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 31),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 32),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 33),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 34),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 35),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 36),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 37),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 38),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 39),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 40),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 41),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 42),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 43),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 44),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 45),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 46),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 47),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 48),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 25),
                          yemSaatGostergeUnsurTEK(yemArabaIleri,yemArabaGeri, oran, 26),

                        ],
                      );

    }
    
                   
  
  }




  

 Widget ileriGeriButon (String butonIsim,String baslik,double oran, int yemArabaTur){

   return RawMaterialButton(
                                                fillColor: Colors.cyan[700],
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                constraints: BoxConstraints(),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5*oran)),
                                                        onPressed: (){

                                                          showModalBottomSheet<void>(
                                          
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                  builder: (context, state) {
                                                    return Container(
                                                      color: Colors.orange,
                                                      height: double.infinity,
                                                      child: Column(
                                                        children: <Widget>[
                                                          //Başlık bölümü
                                                          Expanded(
                                                            flex: 1,
                                                            child: Center(
                                                                child: Text(
                                                              Dil().sec(dilSecimi,"tv559")+" - "+Dil().sec(dilSecimi,baslik)+" - "+Dil().sec(dilSecimi,butonIsim),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                          textScaleFactor: oran,
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,alignment: Alignment.center,
                                                            child:checkBoxUnsorCOKLU(format24saatlik, oran, yemArabaTur, state)
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              });
                                        

                                                                    },
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: <Widget>[
                                                                        Expanded(flex: 5,
                                                                    child: SizedBox(
                                                                      child: Container(
                                                                        padding: EdgeInsets.only(left: 3*oran,right: 3*oran),
                                                                        alignment: Alignment.center,
                                                                        child: AutoSizeText(
                                                                          Dil().sec(
                                                                              dilSecimi, butonIsim),
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style: TextStyle(
                                                                              fontSize: 50.0,
                                                                              fontFamily:
                                                                                  'Kelly Slab',
                                                                                  color: Colors.white,
                                                                              fontWeight:
                                                                                  FontWeight.bold),
                                                                          maxLines: 1,
                                                                          minFontSize: 8,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    ),
                                                              
                                                            ],
                                                          ),
                                                      );

 }

 Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }


 Widget checBoxUnsur(double oran,int index,int yemArabaTur,StateSetter updateState){

   bool checkBoxGeciciDurum=false;

   if (yemArabaTur==1) {
     if(yemIleri1[index]){
       checkBoxGeciciDurum=true;
     } else {
       checkBoxGeciciDurum=false;
     }
   }else if (yemArabaTur==2) {
     if(yemGeri1[index]){
       checkBoxGeciciDurum=true;
     } else {
       checkBoxGeciciDurum=false;
     }
   }else if (yemArabaTur==3) {
     if(yemIleri2[index]){
       checkBoxGeciciDurum=true;
     } else {
       checkBoxGeciciDurum=false;
     }
   }else if (yemArabaTur==4) {
     if(yemGeri2[index]){
       checkBoxGeciciDurum=true;
     } else {
       checkBoxGeciciDurum=false;
     }
   }else if (yemArabaTur==5) {
     if(yemIleri3[index]){
       checkBoxGeciciDurum=true;
     } else {
       checkBoxGeciciDurum=false;
     }
   }else if (yemArabaTur==6) {
     if(yemGeri3[index]){
       checkBoxGeciciDurum=true;
     } else {
       checkBoxGeciciDurum=false;
     }
   }

   

   return Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.end,
       children: <Widget>[
         RotatedBox(quarterTurns: -1,
                    child: Text(
             Dil().sec(format24saatlik ? 'TR' : 'EN', Metotlar().saatGetir(index)),
             style: TextStyle(
               fontFamily: 'Kelly Slab',
               fontSize: 12,
             ),
             textScaleFactor: oran,
             ),
         ),
         RawMaterialButton(
                                                                    
                    onPressed: () {


                      if (yemArabaTur==1) {
                        if(yemIleri1[index]){
                          yemIleri1[index] = false;
                          checkBoxGeciciDurum=false;
                        } else {
                          yemIleri1[index] = true;
                          checkBoxGeciciDurum=true;
                        }
                      }


                      if (yemArabaTur==2) {
                        if(yemGeri1[index]){
                          yemGeri1[index] = false;
                          checkBoxGeciciDurum=false;
                        } else {
                          yemGeri1[index] = true;
                          checkBoxGeciciDurum=true;
                        }
                      }



                      if (yemArabaTur==3) {
                        if(yemIleri2[index]){
                          yemIleri2[index] = false;
                          checkBoxGeciciDurum=false;
                        } else {
                          yemIleri2[index] = true;
                          checkBoxGeciciDurum=true;
                        }
                      }


                      if (yemArabaTur==4) {
                        if(yemGeri2[index]){
                          yemGeri2[index] = false;
                          checkBoxGeciciDurum=false;
                        } else {
                          yemGeri2[index] = true;
                          checkBoxGeciciDurum=true;
                        }
                      }




                      if (yemArabaTur==5) {
                        if(yemIleri3[index]){
                          yemIleri3[index] = false;
                          checkBoxGeciciDurum=false;
                        } else {
                          yemIleri3[index] = true;
                          checkBoxGeciciDurum=true;
                        }
                      }


                      if (yemArabaTur==6) {
                        if(yemGeri3[index]){
                          yemGeri3[index] = false;
                          checkBoxGeciciDurum=false;
                        } else {
                          yemGeri3[index] = true;
                          checkBoxGeciciDurum=true;
                        }
                      }

                      bottomDrawerIcindeGuncelle(updateState);

                                
                      String veri=checkBoxGeciciDurum==true ? '1' : '0';

                      yazmaSonrasiGecikmeSayaci = 0;
                      String komut="34*$index*$yemArabaTur*$veri";
                      Metotlar().veriGonder(komut, 2235).then((value){
                        if(value.split("*")[0]=="error"){
                          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                        }else{
                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                          
                          baglanti = false;
                          Metotlar().takipEt('29*', 2236).then((veri){
                              if(veri.split("*")[0]=="error"){
                                baglanti=false;
                                baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
                                setState(() {});
                              }else{
                                takipEtVeriIsleme(veri);
                                baglantiDurum="";
                              }
                          });
                        }
                      });
                                
                      setState(() {});
                    },
                    child: Icon(
                      checkBoxGeciciDurum == true
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: checkBoxGeciciDurum == true
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
   );
                                                                  

 }
  


Widget checkBoxUnsorCOKLU(bool format, double oran, int yemArabaTur, StateSetter state){
  Widget ww;
  if(format){
    return Column(
                                                              children: <Widget>[

                                                                Expanded(flex: 5,
                                                                  child: Row(
                                                                  children: <Widget>[
                                                                    Spacer(),

                                                                    checBoxUnsur(oran, 1, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 2, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 3, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 4, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 5, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 6, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 7, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 8, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 9, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 10, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 11, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 12, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 13, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 14, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 15, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 16, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 17, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 18, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 19, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 20, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 21, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 22, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 23, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 24, yemArabaTur,state),

                                                                    Spacer()


                                                                  ],
                                                                ),),
                                                                Spacer(),
                                                                Expanded(flex: 5,
                                                                  child: Row(
                                                                  children: <Widget>[
                                                                    Spacer(),

                                                                    
                                                                    checBoxUnsur(oran, 25, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 26, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 27, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 28, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 29, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 30, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 31, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 32, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 33, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 34, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 35, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 36, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 37, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 38, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 39, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 40, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 41, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 42, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 43, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 44, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 45, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 46, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 47, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 48, yemArabaTur,state),
                                                                    
                                                                    

                                                                    Spacer()


                                                                    

                                                                    



                                                                  ],
                                                                ),),
                                                                Spacer(),
                                                                




                                                              ],
                                                            );
                                                            
  }else{

    return Column(
                                                              children: <Widget>[

                                                                Expanded(flex: 5,
                                                                  child: Row(
                                                                  children: <Widget>[
                                                                    Spacer(),

                                                                    
                                                                    checBoxUnsur(oran, 3, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 4, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 5, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 6, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 7, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 8, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 9, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 10, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 11, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 12, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 13, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 14, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 15, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 16, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 17, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 18, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 19, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 20, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 21, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 22, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 23, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 24, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 1, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 2, yemArabaTur,state),
                                                                    Spacer()


                                                                  ],
                                                                ),),
                                                                Spacer(),
                                                                Expanded(flex: 5,
                                                                  child: Row(
                                                                  children: <Widget>[
                                                                    Spacer(),

                                                                    
                                                                    
                                                                    checBoxUnsur(oran, 27, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 28, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 29, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 30, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 31, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 32, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 33, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 34, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 35, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 36, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 37, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 38, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 39, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 40, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 41, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 42, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 43, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 44, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 45, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 46, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 47, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 48, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 25, yemArabaTur,state),
                                                                    checBoxUnsur(oran, 26, yemArabaTur,state),
                                                                    
                                                                    

                                                                    Spacer()


                                                                    

                                                                    



                                                                  ],
                                                                ),),
                                                                Spacer(),
                                                                




                                                              ],
                                                            );

  }

}
  
  //--------------------------METOTLAR--------------------------------

}
