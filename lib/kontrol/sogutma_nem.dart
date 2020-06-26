import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/genel_ayarlar/kontrol.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/deger_giris_2x1.dart';
import 'package:prokis/yardimci/deger_giris_3x0.dart';
import 'package:prokis/languages/select.dart';

class SogutmaNem extends StatefulWidget {
  List<Map> gelenDBveri;
  SogutmaNem(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return SogutmaNemState(gelenDBveri);
  }
}

class SogutmaNemState extends State<SogutmaNem> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String pedAdet = "0";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  int _yuzler = 0;
  int _onlar = 0;
  int _birler = 0;
  int _ondalik = 0;
  int _index = 0;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  List<String> calismaSicakligi = new List(11);
  List<String> calismaSicakligifark = new List(11);
  List<String> durmaSicakligi = new List(11);
  List<String> durmaSicakligiFark = new List(11);

  String maksimumNem = "0.0";
  String minimumNem = "0.0";
  bool dusukNemdePedCalissin = false;
  bool sicaklikOncelikli = false;
  bool ped1 = false;
  bool ped23 = false;
  String nemFark = "0.0";
  String calismaSure = "240";
  String durmaSure = "360";

  String baglantiDurum="";
  String alarmDurum="00000000000000000000000000000000000000000000000000000000000000000000000000000000";


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  SogutmaNemState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 4) {
        pedAdet = dbVeri[i]["veri3"];
      }
    }

    for (int i = 1; i <= 10; i++) {
      calismaSicakligi[i] = "0.0";
      calismaSicakligifark[i] = "0.0";
      durmaSicakligi[i] = "0.0";
      durmaSicakligiFark[i] = "0.0";
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

@override
  void dispose() {
    timerCancel=true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
final dbProkis = Provider.of<DBProkis>(context);
    if (timerSayac == 0) {
      
      Metotlar().takipEt('9*', 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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
          
          Metotlar().takipEt('9*', 2236).then((veri){
              if(veri.split("*")[0]=="error"){
                baglanti=false;
                baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv249',baglantiDurum, alarmDurum),
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
                      flex: 13,
                      child: Column(
                        children: <Widget>[
                          //Beyaz alan üst boşluk
                          Container(
                            height: 5 * oran,
                          ),
                          //ilk 5 ped bölümü
                          Expanded(
                            flex: 10,
                            child: Row(
                              children: <Widget>[
                                Spacer(
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          children: <Widget>[
                                            Spacer(
                                              flex: 1,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv245"),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors.green[700],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 60,
                                                    ),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  color: Colors.grey[300],
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv242"),
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
                                              child: SizedBox(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv246"),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Kelly Slab',
                                                      color: Colors
                                                          .deepOrange[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 60,
                                                    ),
                                                    maxLines: 1,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                child: Container(
                                                  color: Colors.grey[300],
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: AutoSizeText(
                                                    Dil().sec(
                                                        dilSecimi, "tv243"),
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: int.parse(pedAdet) > 0,
                                    child: _pedUnsur(oran, 1,dbProkis)),
                                Visibility(
                                    visible: int.parse(pedAdet) > 1,
                                    child: _pedUnsur(oran, 2,dbProkis)),
                                Visibility(
                                    visible: int.parse(pedAdet) > 2,
                                    child: _pedUnsur(oran, 3,dbProkis)),
                                Visibility(
                                    visible: int.parse(pedAdet) > 3,
                                    child: _pedUnsur(oran, 4,dbProkis)),
                                Visibility(
                                    visible: int.parse(pedAdet) > 4,
                                    child: _pedUnsur(oran, 5,dbProkis)),
                              ],
                            ),
                          ),
                          Spacer(),
                          //Son 5 ped bölümü
                          Expanded(
                            flex: 10,
                            child: Row(
                              children: <Widget>[
                                Spacer(
                                  flex: 1,
                                ),
                                Visibility(
                                  visible: int.parse(pedAdet) > 5,
                                  child: Expanded(
                                    flex: 8,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 5,
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(
                                                flex: 1,
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv245"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        color:
                                                            Colors.green[700],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 60,
                                                      ),
                                                      maxLines: 1,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    color: Colors.grey[300],
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv242"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Kelly Slab',
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
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv246"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        color: Colors
                                                            .deepOrange[800],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 60,
                                                      ),
                                                      maxLines: 1,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    color: Colors.grey[300],
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv243"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        color: Colors.black,
                                                        fontSize: 60,
                                                      ),
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
                                ),
                                Visibility(
                                    visible: int.parse(pedAdet) > 5,
                                    child: _pedUnsur(oran, 6,dbProkis)),
                                Visibility(
                                    visible: int.parse(pedAdet) > 6,
                                    child: _pedUnsur(oran, 7,dbProkis)),
                                Visibility(
                                    visible: int.parse(pedAdet) > 7,
                                    child: _pedUnsur(oran, 8,dbProkis)),
                                Visibility(
                                    visible: int.parse(pedAdet) > 8,
                                    child: _pedUnsur(oran, 9,dbProkis)),
                                Visibility(
                                    visible: int.parse(pedAdet) > 9,
                                    child: _pedUnsur(oran, 10,dbProkis)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          //Min. Nem ve Düşük nem de ped çalışma durumu
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                //Min. Nem
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Spacer(),
                                      Expanded(
                                        flex: 10,
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            _index = 25;
                                            _onlar = int.parse(minimumNem
                                                        .split(".")[0]) <
                                                    10
                                                ? 0
                                                : (int.parse(minimumNem
                                                        .split(".")[0]) ~/
                                                    10);
                                            _birler = int.parse(
                                                    minimumNem.split(".")[0]) %
                                                10;
                                            _ondalik = int.parse(
                                                minimumNem.split(".")[1]);

                                            _degergiris2X1(
                                                _onlar,
                                                _birler,
                                                _ondalik,
                                                _index,
                                                oran,
                                                dilSecimi,
                                                "tv484",
                                                "",dbProkis);
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    color: Colors.white,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv482"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        color: Colors.black,
                                                        fontSize: 60,
                                                      ),
                                                      maxLines: 2,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Stack(
                                                  children: <Widget>[
                                                    LayoutBuilder(builder:
                                                        (context, constraint) {
                                                      return Center(
                                                        child: Icon(
                                                          Icons.brightness_1,
                                                          size: constraint
                                                              .biggest.height,
                                                          color:
                                                              Colors.cyan[800],
                                                        ),
                                                      );
                                                    }),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        minimumNem,
                                                        style: TextStyle(
                                                            fontSize: 20 * oran,
                                                            fontFamily:
                                                                'Kelly Slab',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
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
                                      Spacer()
                                    ],
                                  ),
                                ),
                                //Düşük nemde ped çalışsın
                                Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              
                                              Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      Dil().sec(dilSecimi, "tv485"),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'Kelly Slab',
                                                        color: Colors.black,
                                                        fontSize: 60,
                                                        //fontWeight: FontWeight.bold
                                                      ),
                                                      maxLines: 3,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: IconButton(alignment: Alignment.topCenter,
                                                  padding: EdgeInsets.all(0),
                                                  onPressed: () {

                                                    _index = 26;
                                                    if (!dusukNemdePedCalissin) {
                                                      dusukNemdePedCalissin = true;
                                                    } else {
                                                      dusukNemdePedCalissin = false;
                                                    }

                                                    String veri=dusukNemdePedCalissin==true ? '1' : '0';
                                                    
                                                    yazmaSonrasiGecikmeSayaci = 0;
                                                    String komut="10*$_index*$veri";
                                                    Metotlar().veriGonder(komut, 2235).then((value){
                                                      if(value.split("*")[0]=="error"){
                                                        Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                                                      }else{
                                                        Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);

                                                        baglanti = false;
                                                        Metotlar().takipEt('9*', 2236).then((veri){
                                                            if(veri.split("*")[0]=="error"){
                                                              baglanti=false;
                                                              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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
                                                      dusukNemdePedCalissin == true
                                                          ? Icons.check_box
                                                          : Icons.check_box_outline_blank),
                                                  color: dusukNemdePedCalissin == true
                                                      ? Colors.green.shade500
                                                      : Colors.blue.shade600,
                                                  iconSize: 30 * oran,
                                                ),
                                              ),
                                              
                                            ],
                                          ),
                                        ),
                              ],
                            ),
                          ),
                          //Sicaklik öndelikli ve ped1, ped2-3 seçimi
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                    flex: 6,
                                    child: Visibility(visible: dusukNemdePedCalissin,
                                                                          child: Column(
                                        children: <Widget>[
                                          //Sıcaklık Öncelikli
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                
                                                Expanded(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: AutoSizeText(
                                                        Dil().sec(dilSecimi, "tv486"),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Kelly Slab',
                                                          color: Colors.black,
                                                          fontSize: 60,
                                                          //fontWeight: FontWeight.bold
                                                        ),
                                                        maxLines: 3,
                                                        minFontSize: 8,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 4,
                                                  child: IconButton(alignment: Alignment.topCenter,
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () {

                                                      _index = 27;
                                                      if (!sicaklikOncelikli) {
                                                        sicaklikOncelikli = true;
                                                      } else {
                                                        sicaklikOncelikli = false;
                                                      }

                                                      String veri=sicaklikOncelikli==true ? '1' : '0';
                                                      

                                                      yazmaSonrasiGecikmeSayaci = 0;
                                                      String komut="10*$_index*$veri";
                                                      Metotlar().veriGonder(komut, 2235).then((value){
                                                        if(value.split("*")[0]=="error"){
                                                          Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                                                        }else{
                                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);

                                                          baglanti = false;
                                                          Metotlar().takipEt('9*', 2236).then((veri){
                                                              if(veri.split("*")[0]=="error"){
                                                                baglanti=false;
                                                                baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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
                                                        sicaklikOncelikli == true
                                                            ? Icons.check_box
                                                            : Icons.check_box_outline_blank),
                                                    color: sicaklikOncelikli == true
                                                        ? Colors.green.shade500
                                                        : Colors.blue.shade600,
                                                    iconSize: 30 * oran,
                                                  ),
                                                ),
                                                //Spacer(flex: 1,)
                                              ],
                                            ),
                                          ),
                                          //Ped 1
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Spacer(),
                                                Expanded(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    child: Container(color: Colors.yellow,
                                                      alignment: Alignment.bottomCenter,
                                                      child: AutoSizeText(
                                                        Dil().sec(dilSecimi, "tv487"),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Kelly Slab',
                                                          color: Colors.black,
                                                          fontSize: 60,
                                                          //fontWeight: FontWeight.bold
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
                                                    child: 
                                                    RawMaterialButton(
                                                      
                                          onPressed: () {
                                            _index = 28;
                                            if (ped1) {
                                              ped1 = false;
                                            } else {
                                              ped1 = true;
                                            }

                                            String veri=ped1==true ? '1' : '0';
                                                      
                                                      yazmaSonrasiGecikmeSayaci = 0;
                                                      String komut="10*$_index*$veri";
                                                      Metotlar().veriGonder(komut, 2235).then((value){
                                                        if(value.split("*")[0]=="error"){
                                                          Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                                                        }else{
                                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);

                                                          baglanti = false;
                                                          Metotlar().takipEt('9*', 2236).then((veri){
                                                              if(veri.split("*")[0]=="error"){
                                                                baglanti=false;
                                                                baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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
                                            ped1 == true
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: ped1 == true
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
                                          //Ped 2-3
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Spacer(),
                                                Expanded(
                                                  flex: 2,
                                                  child: SizedBox(
                                                    child: Container(color: Colors.yellow,
                                                      alignment: Alignment.bottomCenter,
                                                      child: AutoSizeText(
                                                        Dil().sec(dilSecimi, "tv488"),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Kelly Slab',
                                                          color: Colors.black,
                                                          fontSize: 60,
                                                          //fontWeight: FontWeight.bold
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
                                            _index = 29;
                                            if (ped23) {
                                              ped23 = false;
                                            } else {
                                              ped23 = true;
                                            }
                                            String veri=ped23==true ? '1' : '0';
                                                      
                                                      yazmaSonrasiGecikmeSayaci = 0;
                                                      String komut="10*$_index*$veri";
                                                      Metotlar().veriGonder(komut, 2235).then((value){
                                                        if(value.split("*")[0]=="error"){
                                                          Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
                                                        }else{
                                                          Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);

                                                          baglanti = false;
                                                          Metotlar().takipEt('9*', 2236).then((veri){
                                                              if(veri.split("*")[0]=="error"){
                                                                baglanti=false;
                                                                baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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
                                            ped23 == true
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: ped23 == true
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
                                                                                    
                                        ],
                                      ),
                                    )
                                    ),
                                Spacer(
                                  flex: 1,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          //Maks. Nem ve Nem fark
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                //Maks. Nem
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Spacer(),
                                      Expanded(
                                        flex: 10,
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            _index = 21;
                                            _onlar = int.parse(maksimumNem
                                                        .split(".")[0]) <
                                                    10
                                                ? 0
                                                : (int.parse(maksimumNem
                                                        .split(".")[0]) ~/
                                                    10);
                                            _birler = int.parse(
                                                    maksimumNem.split(".")[0]) %
                                                10;
                                            _ondalik = int.parse(
                                                maksimumNem.split(".")[1]);

                                            _degergiris2X1(
                                                _onlar,
                                                _birler,
                                                _ondalik,
                                                _index,
                                                oran,
                                                dilSecimi,
                                                "tv252",
                                                "",dbProkis);
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    color: Colors.white,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv250"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        color: Colors.black,
                                                        fontSize: 60,
                                                      ),
                                                      maxLines: 2,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Stack(
                                                  children: <Widget>[
                                                    LayoutBuilder(builder:
                                                        (context, constraint) {
                                                      return Center(
                                                        child: Icon(
                                                          Icons.brightness_1,
                                                          size: constraint
                                                              .biggest.height,
                                                          color:
                                                              Colors.cyan[800],
                                                        ),
                                                      );
                                                    }),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        maksimumNem,
                                                        style: TextStyle(
                                                            fontSize: 20 * oran,
                                                            fontFamily:
                                                                'Kelly Slab',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
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
                                      Spacer()
                                    ],
                                  ),
                                ),
                                //Nem fark
                                Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Spacer(),
                                      Expanded(
                                        flex: 10,
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            _index = 22;
                                            _onlar = int.parse(
                                                        nemFark.split(".")[0]) <
                                                    10
                                                ? 0
                                                : (int.parse(nemFark
                                                        .split(".")[0]) ~/
                                                    10);
                                            _birler = int.parse(
                                                    nemFark.split(".")[0]) %
                                                10;
                                            _ondalik = int.parse(
                                                nemFark.split(".")[1]);

                                            _degergiris2X1(
                                                _onlar,
                                                _birler,
                                                _ondalik,
                                                _index,
                                                oran,
                                                dilSecimi,
                                                "tv251",
                                                "",dbProkis);
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(
                                                child: SizedBox(
                                                  child: Container(
                                                    color: Colors.white,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: AutoSizeText(
                                                      Dil().sec(
                                                          dilSecimi, "tv251"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Kelly Slab',
                                                        color: Colors.black,
                                                        fontSize: 60,
                                                      ),
                                                      maxLines: 2,
                                                      minFontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Stack(
                                                  children: <Widget>[
                                                    LayoutBuilder(builder:
                                                        (context, constraint) {
                                                      return Center(
                                                        child: Icon(
                                                          Icons.brightness_1,
                                                          size: constraint
                                                              .biggest.height,
                                                          color:
                                                              Colors.cyan[800],
                                                        ),
                                                      );
                                                    }),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        nemFark,
                                                        style: TextStyle(
                                                            fontSize: 20 * oran,
                                                            fontFamily:
                                                                'Kelly Slab',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center,
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
                                      Spacer()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          //Çalışma ve durma Süresi
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                //Çalışma ve durma Süresi alanı
                                Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: <Widget>[
                                        //Çalışma Süresi
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(flex: 3,
                                                  child: SizedBox(
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                      padding: EdgeInsets.only(left: 3*oran,right: 3*oran),
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, "tv270"),
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Kelly Slab',
                                                      color: Colors.black,
                                                      fontSize: 60,
                                                    ),
                                                    maxLines: 2,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              )),
                                              Expanded(flex: 6,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(),
                                                    Expanded(flex: 6,
                                                                                                            child: LayoutBuilder(builder:
                                                          (context, constraint) {
                                                        return RawMaterialButton(
                                                          onPressed: () {


                                                            
                                                                  int sayi = int.parse(
                                                                      calismaSure);
                                                                  _index =
                                                                      23;
                                                                  _yuzler = sayi <
                                                                          100
                                                                      ? 0
                                                                      : sayi ~/
                                                                          100;
                                                                  _onlar = sayi < 10
                                                                      ? 0
                                                                      : (sayi >
                                                                              99
                                                                          ? (sayi - 100 * _yuzler) ~/
                                                                              10
                                                                          : sayi ~/
                                                                              10);
                                                                  _birler =
                                                                      sayi % 10;

                                                                  _degergiris3X0(
                                                                          _yuzler,
                                                                          _onlar,
                                                                          _birler,
                                                                          _index,
                                                                          3,
                                                                          oran,
                                                                          dilSecimi,
                                                                          "tv270",
                                                                          "",dbProkis);



                                                          },
                                                          fillColor: Colors.blue,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: AutoSizeText(
                                                                calismaSure,
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  color:
                                                                      Colors.black,
                                                                  fontSize: 60,
                                                                ),
                                                                maxLines: 2,
                                                                minFontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                              ),
                                              Spacer()
                                            ],
                                          ),
                                        ),
                                        //Durma Süresi
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Expanded(flex: 3,
                                                  child: SizedBox(
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                      padding: EdgeInsets.only(left: 5*oran,right: 5*oran),
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, "tv271"),
                                                    textAlign:
                                                        TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Kelly Slab',
                                                      color: Colors.black,
                                                      fontSize: 60,
                                                    ),
                                                    maxLines: 2,
                                                    minFontSize: 8,
                                                  ),
                                                ),
                                              )),
                                              Expanded(flex: 6,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(),
                                                    Expanded(flex: 6,
                                                                                                            child: LayoutBuilder(builder:
                                                          (context, constraint) {
                                                        return RawMaterialButton(
                                                          onPressed: () {

                                                            
                                                            
                                                                  int sayi = int.parse(
                                                                      durmaSure);
                                                                  _index =
                                                                      24;
                                                                  _yuzler = sayi <
                                                                          100
                                                                      ? 0
                                                                      : sayi ~/
                                                                          100;
                                                                  _onlar = sayi < 10
                                                                      ? 0
                                                                      : (sayi >
                                                                              99
                                                                          ? (sayi - 100 * _yuzler) ~/
                                                                              10
                                                                          : sayi ~/
                                                                              10);
                                                                  _birler =
                                                                      sayi % 10;

                                                                  _degergiris3X0(
                                                                          _yuzler,
                                                                          _onlar,
                                                                          _birler,
                                                                          _index,
                                                                          3,
                                                                          oran,
                                                                          dilSecimi,
                                                                          "tv271",
                                                                          "",dbProkis);


                                                          },
                                                          fillColor: Colors.blue,
                                                          child: SizedBox(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: AutoSizeText(
                                                                durmaSure,
                                                                textAlign: TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  color:
                                                                      Colors.black,
                                                                  fontSize: 60,
                                                                ),
                                                                maxLines: 2,
                                                                minFontSize: 8,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    Spacer()
                                                  ],
                                                ),
                                              ),
                                              Spacer()
                                            ],
                                          ),
                                        ),
                                        ],
                                    )
                                    ),
                                Spacer(
                                  flex: 2,
                                )
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
                        Dil().sec(dilSecimi, "tv253"), //Sıcaklık diyagramı
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
                    flex: 7,
                    child: DrawerHeader(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.all(0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage(
                                      'assets/images/diagram_sogutma_civbro.jpg'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              color: Colors.grey[100],
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "A+X",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "A+X+B",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "A+X+C",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "D",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "E",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "F",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "G",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "H",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "J",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "K",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                        Expanded(
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  "L",
                                                  style: TextStyle(
                                                      fontSize: 11 * oran),
                                                ))),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv115")+" + "+Dil().sec(dilSecimi, "tv187"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv254"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv255"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv252"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv251"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv256"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv257"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv258"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv259"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv260"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              " : " +
                                                  Dil().sec(dilSecimi, "tv261"),
                                              style:
                                                  TextStyle(fontSize: 11 * oran),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
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
                              Dil().sec(dilSecimi, "info10"),
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
      double oran, String dil, baslik, onBaslik, DBProkis dbProkis) async {
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

      String veri="";

      if(_index==23){
        calismaSure =
            (_yuzler * 100 + _onlar * 10 + _birler).toString();
            veri=calismaSure;
      }
      if(_index==24){
        durmaSure =
            (_yuzler * 100 + _onlar * 10 + _birler).toString();
            veri=durmaSure;
      }

      

      if (veriGonderilsinMi) {

        yazmaSonrasiGecikmeSayaci = 0;
        String komut="10*$_index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);

            baglanti = false;
            Metotlar().takipEt('9*', 2236).then((veri){
                if(veri.split("*")[0]=="error"){
                  baglanti=false;
                  baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
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


  Future _degergiris2X1(
      int onlarUnsur,
      int birlerUnsur,
      int ondalikUnsur,
      int pedIndex,
      double oran,
      String dil,
      String baslik,
      String onBaslik,DBProkis dbProkis) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X1.Deger(onlarUnsur, birlerUnsur, ondalikUnsur,
            pedIndex, oran, dil, baslik, onBaslik);
      },
    ).then((val) {
      bool veriGonderilsinMi = false;
      if (_onlar != val[0] ||
          _birler != val[1] ||
          _ondalik != val[2] ||
          _index != val[3]) {
        veriGonderilsinMi = true;
      }

      _onlar = val[0];
      _birler = val[1];
      _ondalik = val[2];
      _index = val[3];

      String veri = '';

      if (_index < 11) {
        for (int i = 1; i <= 10; i++) {
          if (_index == i) {
            calismaSicakligifark[_index] =
                (_onlar == 0 ? "" : _onlar.toString()) +
                    _birler.toString() +
                    "." +
                    _ondalik.toString();
            veri = calismaSicakligifark[_index];
          }
        }
      }

      if (_index < 21 && _index > 10) {
        for (int i = 11; i <= 20; i++) {
          if (_index == i) {
            durmaSicakligiFark[_index - 10] =
                (_onlar == 0 ? "" : _onlar.toString()) +
                    _birler.toString() +
                    "." +
                    _ondalik.toString();
            veri = durmaSicakligiFark[_index - 10];
          }
        }
      }

      if (_index == 21) {
        maksimumNem = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
        veri = maksimumNem;
      }

      if (_index == 22) {
        nemFark = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
        veri = nemFark;
      }

      if (_index == 25) {
        minimumNem = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
        veri = minimumNem;
      }

      if (veriGonderilsinMi) {

        yazmaSonrasiGecikmeSayaci = 0;
        String komut="10*$_index*$veri";
        Metotlar().veriGonder(komut, 2235).then((value){
          if(value.split("*")[0]=="error"){
            Toast.show(Dil().sec(dilSecimi, "toast101"), context,duration:3);
          }else{
            Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);

            baglanti = false;
            Metotlar().takipEt('9*', 2236).then((veri){
                if(veri.split("*")[0]=="error"){
                  baglanti=false;
                  baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
                  setState(() {});
                }else{
                  takipEtVeriIsleme(veri);
                  baglantiDurum="";
                }
            });
          }
        });

      }
    });
  }

  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

  
  takipEtVeriIsleme(String gelenMesaj){
    
    var degerler = gelenMesaj.split('#');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              calismaSicakligi[1] = degerler[0].split("*")[0];
              calismaSicakligi[2] = degerler[0].split("*")[1];
              calismaSicakligi[3] = degerler[0].split("*")[2];
              calismaSicakligi[4] = degerler[0].split("*")[3];
              calismaSicakligi[5] = degerler[0].split("*")[4];
              calismaSicakligi[6] = degerler[0].split("*")[5];
              calismaSicakligi[7] = degerler[0].split("*")[6];
              calismaSicakligi[8] = degerler[0].split("*")[7];
              calismaSicakligi[9] = degerler[0].split("*")[8];
              calismaSicakligi[10] = degerler[0].split("*")[9];
              durmaSicakligi[1] = degerler[0].split("*")[10];
              durmaSicakligi[2] = degerler[0].split("*")[11];
              durmaSicakligi[3] = degerler[0].split("*")[12];
              durmaSicakligi[4] = degerler[0].split("*")[13];
              durmaSicakligi[5] = degerler[0].split("*")[14];
              durmaSicakligi[6] = degerler[0].split("*")[15];
              durmaSicakligi[7] = degerler[0].split("*")[16];
              durmaSicakligi[8] = degerler[0].split("*")[17];
              durmaSicakligi[9] = degerler[0].split("*")[18];
              durmaSicakligi[10] = degerler[0].split("*")[19];

              calismaSicakligifark[1] = degerler[1].split("*")[0];
              calismaSicakligifark[2] = degerler[1].split("*")[1];
              calismaSicakligifark[3] = degerler[1].split("*")[2];
              calismaSicakligifark[4] = degerler[1].split("*")[3];
              calismaSicakligifark[5] = degerler[1].split("*")[4];
              calismaSicakligifark[6] = degerler[1].split("*")[5];
              calismaSicakligifark[7] = degerler[1].split("*")[6];
              calismaSicakligifark[8] = degerler[1].split("*")[7];
              calismaSicakligifark[9] = degerler[1].split("*")[8];
              calismaSicakligifark[10] = degerler[1].split("*")[9];
              durmaSicakligiFark[1] = degerler[1].split("*")[10];
              durmaSicakligiFark[2] = degerler[1].split("*")[11];
              durmaSicakligiFark[3] = degerler[1].split("*")[12];
              durmaSicakligiFark[4] = degerler[1].split("*")[13];
              durmaSicakligiFark[5] = degerler[1].split("*")[14];
              durmaSicakligiFark[6] = degerler[1].split("*")[15];
              durmaSicakligiFark[7] = degerler[1].split("*")[16];
              durmaSicakligiFark[8] = degerler[1].split("*")[17];
              durmaSicakligiFark[9] = degerler[1].split("*")[18];
              durmaSicakligiFark[10] = degerler[1].split("*")[19];

              maksimumNem = degerler[2];
              nemFark = degerler[3];
              calismaSure = degerler[4];
              durmaSure = degerler[5];
              
              minimumNem = degerler[6];
              dusukNemdePedCalissin = degerler[7]=="True" ? true : false;
              sicaklikOncelikli =  degerler[8]=="True" ? true : false;
              ped1 =  degerler[9]=="True" ? true : false;
              ped23 =  degerler[10]=="True" ? true : false;

              alarmDurum=degerler[11];


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
  }
 

  Widget _pedUnsur(double oran, int pedNo, DBProkis dbProkis) {
    return Expanded(
      flex: 5,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Text(
              Dil().sec(dilSecimi, "tv244") + " " + pedNo.toString(),
              style: TextStyle(
                  fontFamily: 'Kelly Slab', fontWeight: FontWeight.bold),
              textScaleFactor: oran,
            ),
          ),
          Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: RawMaterialButton(
                        onPressed: () {
                          _index = pedNo;
                          _onlar = int.parse(calismaSicakligifark[pedNo]
                                      .split(".")[0]) <
                                  10
                              ? 0
                              : (int.parse(calismaSicakligifark[pedNo]
                                      .split(".")[0]) ~/
                                  10);
                          _birler = int.parse(
                                  calismaSicakligifark[pedNo].split(".")[0]) %
                              10;
                          _ondalik = int.parse(
                              calismaSicakligifark[pedNo].split(".")[1]);

                          _degergiris2X1(
                              _onlar,
                              _birler,
                              _ondalik,
                              _index,
                              oran,
                              dilSecimi,
                              "tv247",
                              Dil().sec(dilSecimi, "tv244") + " $pedNo ",dbProkis);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            LayoutBuilder(builder: (context, constraint) {
                              return Icon(
                                Icons.brightness_1,
                                size: constraint.biggest.height,
                                color: Colors.green[900],
                              );
                            }),
                            Text(
                              calismaSicakligifark[pedNo],
                              style: TextStyle(
                                  fontSize: 20 * oran,
                                  fontFamily: 'Kelly Slab',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(calismaSicakligi[pedNo], textScaleFactor: oran),
              alignment: Alignment.center,
              color: Colors.grey[300],
            ),
          ),
          Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: RawMaterialButton(
                        onPressed: () {
                          _index = pedNo + 10;
                          _onlar = int.parse(
                                      durmaSicakligiFark[pedNo].split(".")[0]) <
                                  10
                              ? 0
                              : (int.parse(durmaSicakligiFark[pedNo]
                                      .split(".")[0]) ~/
                                  10);
                          _birler = int.parse(
                                  durmaSicakligiFark[pedNo].split(".")[0]) %
                              10;
                          _ondalik = int.parse(
                              durmaSicakligiFark[pedNo].split(".")[1]);

                          _degergiris2X1(
                              _onlar,
                              _birler,
                              _ondalik,
                              _index,
                              oran,
                              dilSecimi,
                              "tv248",
                              Dil().sec(dilSecimi, "tv244") + " $pedNo ",dbProkis);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            LayoutBuilder(builder: (context, constraint) {
                              return Icon(
                                Icons.brightness_1,
                                size: constraint.biggest.height,
                                color: Colors.deepOrange[800],
                              );
                            }),
                            Text(
                              durmaSicakligiFark[pedNo],
                              style: TextStyle(
                                  fontSize: 20 * oran,
                                  fontFamily: 'Kelly Slab',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(durmaSicakligi[pedNo], textScaleFactor: oran),
              alignment: Alignment.center,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
  //--------------------------METOTLAR--------------------------------

}
