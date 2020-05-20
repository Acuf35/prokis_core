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
import 'package:prokis/yardimci/deger_giris_1x2.dart';
import 'package:prokis/yardimci/deger_giris_2x1.dart';
import 'package:prokis/yardimci/deger_giris_3x0.dart';
import 'package:prokis/languages/select.dart';

class MinHavHacim extends StatefulWidget {
  List<Map> gelenDBveri;
  MinHavHacim(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return MinHavHacimState(gelenDBveri);
  }
}

class MinHavHacimState extends State<MinHavHacim> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String airInletAdet = "1";
  String bacafanAdet = "1";
  List<Map> dbVeriler;

  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _index = 0;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  String calismaSuresiUstSinir = "150";
  String airInletOncelikSuresi = "20";
  String havaGirisKatsayisi = "80";
  bool fasilaOffdaAirInletKapansinMi = false;
  String donguSecimi='5';
  String fasilaDoubleX2='0';

  String bacafanMotorHizi='0.0';
  bool dijitalCikis = false;
  bool analogCikis = false;

  String calismaSure = "120";
  String durmaSure = "240";
  String minHavFanSayisi = "2";
  String hayvanBasinaIhtiyac = "700";

  String baglantiDurum="";
  String alarmDurum="0";


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  MinHavHacimState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 5) {
        airInletAdet = dbVeri[i]["veri2"];
        var xx=dbVeri[i]["veri1"].split('#'); 
        bacafanAdet = xx[0];
      }
      if (dbVeri[i]["id"] == 24) {
        var xx = dbVeri[i]["veri4"];
        var yy=xx.split('*');
        dijitalCikis=yy[0]=="1" ? true : false;
        analogCikis=yy[1]=="1" ? true : false;
      }
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    if (timerSayac == 0) {
      
      Metotlar().takipEt('12*', 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1]);
              setState(() {});
            }else{
              takipEtVeriIsleme(veri);
              baglantiDurum="";
            }
        });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          
          Metotlar().takipEt('12*', 2236).then((veri){
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
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv276',baglantiDurum, alarmDurum),
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
                                Visibility(visible: bacafanAdet=="0" ? true : false,
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
                                ),
                                Visibility(visible: airInletAdet!="0" && dijitalCikis ? true : false,
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
                                  child: Visibility(visible: airInletAdet!="0" && dijitalCikis ? true : false,
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
                                              if(donguSecimi=='10'){
                                              _index = 4;
                                              if (!fasilaOffdaAirInletKapansinMi) {
                                                fasilaOffdaAirInletKapansinMi = true;
                                              } else {
                                                fasilaOffdaAirInletKapansinMi = false;
                                              }
                                              String veri=fasilaOffdaAirInletKapansinMi==true ? '1' : '0';
                                              

                                              yazmaSonrasiGecikmeSayaci = 0;
                                              String komut="13*$_index*$veri";
                                              Metotlar().veriGonder(komut, 2235).then((value){
                                                if(value.split("*")[0]=="error"){
                                                  Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                }else{
                                                  Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                  
                                                  baglanti = false;
                                                  Metotlar().takipEt('12*', 2236).then((veri){
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
                                              Dil().sec(dilSecimi, "tv296"),
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
                                                  Text(Dil().sec(dilSecimi, "tv297"),textScaleFactor: oran,),
                                                  RawMaterialButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,constraints: BoxConstraints(),
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      fasilaOffdaAirInletKapansinMi=false;
                                                      _index = 0;
                                                      if (donguSecimi!='5') {
                                                        donguSecimi = '5';
                                                      }
                                                      String veri=(int.parse(donguSecimi)*60000).toString();
                                                      

                                                      yazmaSonrasiGecikmeSayaci = 0;
                                                      String komut="13*$_index*$veri*5";
                                                      Metotlar().veriGonder(komut, 2235).then((value){
                                                        if(value.split("*")[0]=="error"){
                                                          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                        }else{
                                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                          
                                                          baglanti = false;
                                                          Metotlar().takipEt('12*', 2236).then((veri){
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
                                                        donguSecimi == '5'
                                                            ? Icons.check_box
                                                            : Icons.check_box_outline_blank,color: donguSecimi == '5'
                                                        ? Colors.green.shade500
                                                        : Colors.blue.shade600,
                                                    size: 30 * oran,),
                                                    
                                                  ),
                                                  Container(width: 10*oran,),
                                                  Visibility(maintainState: true,maintainSize: true,maintainAnimation: true,
                                                    visible:donguSecimi=='5' && dijitalCikis ? true : false,child: Text("x2",textScaleFactor: oran,)),
                                                  Visibility(maintainState: true,maintainSize: true,maintainAnimation: true,
                                                    visible:donguSecimi=='5' && dijitalCikis ? true : false,
                                                    child: RawMaterialButton(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,constraints: BoxConstraints(),
                                                      padding: EdgeInsets.all(0),
                                                      onPressed: () {
                                                        _index = 0;
                                                        String veri="";
                                                        if (fasilaDoubleX2=="0") {
                                                          fasilaDoubleX2 = "1";
                                                          veri="600000";
                                                        }else{
                                                          fasilaDoubleX2 = "0";
                                                          veri="300000";
                                                        }
                                                        
                                                        yazmaSonrasiGecikmeSayaci = 0;
                                                        String komut="13*$_index*$veri*x2on";
                                                        Metotlar().veriGonder(komut, 2235).then((value){
                                                          if(value.split("*")[0]=="error"){
                                                            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                          }else{
                                                            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                            
                                                            baglanti = false;
                                                            Metotlar().takipEt('12*', 2236).then((veri){
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
                                                          fasilaDoubleX2 == '1'
                                                              ? Icons.check_box
                                                              : Icons.check_box_outline_blank,color: fasilaDoubleX2 == '1'
                                                          ? Colors.green.shade500
                                                          : Colors.blue.shade600,size: 30 * oran,),
                                                    ),
                                                  ),
                                                
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Expanded(flex: 2,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(Dil().sec(dilSecimi, "tv298"),textScaleFactor: oran,),
                                                  IconButton(
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {
                                                      _index = 0;
                                                      if (donguSecimi!="10") {
                                                        donguSecimi = "10";
                                                        fasilaDoubleX2='0';
                                                      }
                                                      String veri=(int.parse(donguSecimi)*60000).toString();
                                                      

                                                      yazmaSonrasiGecikmeSayaci = 0;
                                                      String komut="13*$_index*$veri*10";
                                                      Metotlar().veriGonder(komut, 2235).then((value){
                                                        if(value.split("*")[0]=="error"){
                                                          Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
                                                        }else{
                                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
                                                          
                                                          baglanti = false;
                                                          Metotlar().takipEt('12*', 2236).then((veri){
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
                                                    icon: Icon(
                                                        donguSecimi == '10'
                                                            ? Icons.check_box
                                                            : Icons.check_box_outline_blank),
                                                    color: donguSecimi == '10'
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
                                Spacer(),
                                Visibility(visible: dijitalCikis,
                                                                  child: Expanded(
                                    child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(Dil().sec(dilSecimi, "tv270"),
                                        style: TextStyle(fontFamily: 'Kelly Slab',color: Colors.grey[600]),textScaleFactor: oran,
                                        ),
                                        Text(calismaSure,style: TextStyle(fontFamily: 'Kelly Slab',fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue[200]),textScaleFactor: oran,)
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(visible: dijitalCikis,
                                                                  child: Expanded(
                                                                    child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(Dil().sec(dilSecimi, "tv271"),
                                        style: TextStyle(fontFamily: 'Kelly Slab',color: Colors.grey[600]),textScaleFactor: oran,
                                        ),
                                        Text(durmaSure,style: TextStyle(fontFamily: 'Kelly Slab',fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue[200]),textScaleFactor: oran,)
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(visible: analogCikis,
                                    child: Expanded(
                                      child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(Dil().sec(dilSecimi, "tv494"),textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: 'Kelly Slab',color: Colors.grey[600]),textScaleFactor: oran,
                                        ),
                                        Text(bacafanMotorHizi,style: TextStyle(fontFamily: 'Kelly Slab',fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue[200]),textScaleFactor: oran,)
                                      ],
                                    ),
                                  ),
                                ),
                                
                                Expanded(
                                                                  child: Column(mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(Dil().sec(dilSecimi, "tv295"),textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: 'Kelly Slab',color: Colors.grey[600]),textScaleFactor: oran,
                                      ),
                                      Text(hayvanBasinaIhtiyac,style: TextStyle(fontFamily: 'Kelly Slab',fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue[200]),textScaleFactor: oran,)
                                    ],
                                  ),
                                ),
                                
                                Visibility(visible: bacafanAdet=="0" ? true : false,
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
                                Spacer(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    
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
                              (dijitalCikis ?  Dil().sec(dilSecimi, "info13_1") : Dil().sec(dilSecimi, "info13_2")) +
                              (dijitalCikis ? Dil().sec(dilSecimi, "info12_3") : "")+
                              (dijitalCikis && airInletAdet!="0" ? Dil().sec(dilSecimi, "info12_4") : "")+
                              Dil().sec(dilSecimi, "info12_5")+
                              (dijitalCikis && airInletAdet!="0" ? Dil().sec(dilSecimi, "info12_6") : "")+
                              (dijitalCikis ? Dil().sec(dilSecimi, "info13_3") : Dil().sec(dilSecimi, "info13_4"))+
                              Dil().sec(dilSecimi, "info14_1"),
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
      _yuzler = val[0];
      _onlar = val[1];
      _birler = val[2];
      _index = val[3];

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
        String komut="13*$_index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
            
            baglanti = false;
            Metotlar().takipEt('12*', 2236).then((veri){
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

      }

      setState(() {});
    });
  }

  takipEtVeriIsleme(String gelenMesaj){
    
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
    donguSecimi=degerler[9];
    fasilaDoubleX2=degerler[8]=='300000' ? '0' : (donguSecimi=='5' ? '1' : '0');
    bacafanMotorHizi=degerler[10];

    alarmDurum=degerler[11];


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 

  //--------------------------METOTLAR--------------------------------

}
