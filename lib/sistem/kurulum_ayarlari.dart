
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:prokis/sistem/kurulum/klepe_yontemi.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/yardimci/sifre_giris_admin.dart';
import 'package:prokis/sistem/kurulum/bacafan_haritasi.dart';
import 'package:prokis/sistem/kurulum/fan_yontemi.dart';
import 'package:prokis/sistem/kurulum/isisensor_haritasi.dart';
import 'package:prokis/sistem/kurulum/isitici_haritasi.dart';
import 'package:prokis/sistem/kurulum/klepe_haritasi.dart';
import 'package:prokis/sistem/kurulum/mh_yontemi.dart';
import 'package:prokis/sistem/kurulum/ped_haritasi.dart';
import 'package:prokis/sistem/kurulum/temel_ayarlar.dart';
import 'package:prokis/languages/select.dart';
import 'package:prokis/genel_ayarlar/sistem.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:toast/toast.dart';

import 'package:prokis/sistem/kurulum/adetler.dart';
import 'package:prokis/sistem/kurulum/airinlet_ve_sirkfan.dart';
import 'package:prokis/sistem/kurulum/diger_cikislar.dart';
import 'package:prokis/sistem/kurulum/dil_secimi.dart';
import 'package:prokis/sistem/kurulum/fan_haritasi.dart';
import 'package:prokis/sistem/kurulum/girisler.dart';
import 'package:prokis/sistem/kurulum/silo_haritasi.dart';
import 'package:prokis/sistem/kurulum/uz_debi_nem.dart';

class KurulumAyarlari extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return KurulumAyarlariState();
  }
}

class KurulumAyarlariState extends State<KurulumAyarlari> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String sifre = "0";
  String bacafanAdet = "0";
  String airinletAdet = "0";
  String isiticiAdet = "0";
  String siloAdet = "0";
  bool sirkfanVarMi = false;
  
  List<Map> dbVeriler;

  int timerSayac = 0;
  int yazmaSonrasiGecikmeSayaci = 0;
  bool timerCancel = false;
  bool baglanti = false;

  String baglantiDurum="";
  String alarmDurum="00000000000000000000000000000000000000000000000000000000000000000000000000000000";

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

@override
  void dispose() {
    timerCancel=true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
final dbProkis = Provider.of<DBProkis>(context);

    if (timerSayac == 0) {
      Metotlar().takipEt("alarm*", 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
              setState(() {});
            }else{
              alarmDurum=veri;
              baglantiDurum="";
              baglanti=false;
              if(!timerCancel)
                setState(() {});
            }
          });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          Metotlar().takipEt("alarm*", 2236).then((veri){
            if(veri.split("*")[0]=="error"){
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
              setState(() {});
            }else{
              alarmDurum=veri;
              baglantiDurum="";
              baglanti=false;
              if(!timerCancel)
                setState(() {});
            }
          });
        }
      });
      
    }

    timerSayac++;

    var oran = MediaQuery.of(context).size.width / 731.4;
    dilSecimi = dbProkis.dbVeriGetir(1, 1, "EN");
    sifre = dbProkis.dbVeriGetir(3, 4, "");
    var yy=dbProkis.dbVeriGetir(5, 1, "0#0").split('#'); 
    bacafanAdet = yy[0];
    sirkfanVarMi = yy[1]=="1" ? true : false;
    airinletAdet=dbProkis.dbVeriGetir(5, 2, "0");
    isiticiAdet=dbProkis.dbVeriGetir(5, 3, "0");
    siloAdet=dbProkis.dbVeriGetir(5, 4, "0");






    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv299',Colors.grey[600],baglantiDurum, alarmDurum),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                              child: Container(alignment: Alignment.centerLeft,color: Colors.grey[300],padding: EdgeInsets.only(left: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemTime(dbProkis.getDbVeri),
                            style: TextStyle(
                                  //color: Color(0xff2d386b),
                                  color: Colors.grey[700],
                                  fontFamily: 'Kelly Slab',
                                  fontSize: 12*oran,
                                  fontWeight: FontWeight.bold),
                          );
                        }),
                              ),
              ),
              //Spacer(flex: 6,),
              Expanded(
                              child: Container(alignment: Alignment.centerRight,color: Colors.grey[300],padding: EdgeInsets.only(right: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemDate(dbProkis.getDbVeri),
                            style: TextStyle(
                                  //color: Color(0xff2d386b),
                                  color: Colors.grey[700],
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
            flex: 40,
            child: Column(
              children: <Widget>[
                Spacer(),
                // 1. Satır
                Expanded(
                  flex: 10,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      //Dil Seçimi
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv1'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DilSecimi(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      Spacer(),
                      //Temel Ayarlar
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv2'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {

                                        _sifreGiris(oran);

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      Spacer(),
                      //Adetler
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv302'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Adetler(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      Spacer(),
                      //Fan Yöntemi
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv303'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FanYontemi(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      Spacer(),
                      //MH Yöntemi
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv304'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MhYontemi(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      
                      Spacer(
                        flex: 3,
                      ),
                      
                    ],
                  ),
                ),
                Spacer(),
                //2. Satır
                Expanded(
                  flex: 10,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      //KLP Yöntemi
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv27'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              KlpYontemi(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      Spacer(),
                      //Fan Haritası
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv31'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FanHaritasi(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      Spacer(),
                      //KLP Haritası
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv38'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              KlepeHaritasi(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      Spacer(),
                      //PED Haritası
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv307'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PedHaritasi(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      Spacer(),
                      //Isı Sensor Haritası
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv308'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IsiSensorHaritasi(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      
                      Spacer(
                        flex: 3,
                      ),
                      
                    ],
                  ),
                ),
                Spacer(),
                //3. Satır
                Expanded(
                  flex: 10,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      //BacaFan Haritası
                      Expanded(
                          flex: 4,
                          child: Visibility(visible: bacafanAdet!="0",
                                                      child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, 'tv68'),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily: 'Kelly Slab',
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
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: 
                                  RawMaterialButton(
                                        onPressed: () {
                                          timerCancel=true;
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BacafanHaritasi(false)),
                                            );

                                          

                                          

                                        },
                                        child: LayoutBuilder(
                                            builder: (context, constraint) {
                                          return Icon(
                                            Icons.settings,
                                            size: constraint.biggest.height,
                                            color: Colors.grey[700],
                                          );
                                        }),
                                      ),
                                  
                                ),
                              ],
                            ),
                          )),
                      Spacer(),
                      //Air Inlet Haritası
                      Expanded(
                          flex: 4,
                          child: Visibility(visible: airinletAdet=="0" && !sirkfanVarMi ? false : true,
                                                      child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, 'tv71'),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily: 'Kelly Slab',
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
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: 
                                  RawMaterialButton(
                                        onPressed: () {
                                          timerCancel=true;
                                          Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AirInletVeSirkFan(false)),
                                      );

                                        },
                                        child: LayoutBuilder(
                                            builder: (context, constraint) {
                                          return Icon(
                                            Icons.settings,
                                            size: constraint.biggest.height,
                                            color: Colors.grey[700],
                                          );
                                        }),
                                      ),
                                  
                                ),
                              ],
                            ),
                          )),
                      Spacer(),
                      //Isıtıcı Haritası
                      Expanded(
                          flex: 4,
                          child: Visibility(visible: isiticiAdet!="0",
                                                      child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, 'tv76'),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily: 'Kelly Slab',
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
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: 
                                  RawMaterialButton(
                                        onPressed: () {
                                          timerCancel=true;
                                          Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IsiticiHaritasi(false)),
                                      );

                                        },
                                        child: LayoutBuilder(
                                            builder: (context, constraint) {
                                          return Icon(
                                            Icons.settings,
                                            size: constraint.biggest.height,
                                            color: Colors.grey[700],
                                          );
                                        }),
                                      ),
                                  
                                ),
                              ],
                            ),
                          )),
                      Spacer(),
                      //Silo Haritası
                      Expanded(
                          flex: 4,
                          child: Visibility(visible: siloAdet!="0",
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(
                                                child: Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: AutoSizeText(
                                                    Dil().sec(dilSecimi, 'tv84'),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 50.0,
                                                        fontFamily: 'Kelly Slab',
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
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: 
                                  RawMaterialButton(
                                        onPressed: () {
                                          timerCancel=true;
                                          Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SiloHaritasi(false)),
                                      );

                                        },
                                        child: LayoutBuilder(
                                            builder: (context, constraint) {
                                          return Icon(
                                            Icons.settings,
                                            size: constraint.biggest.height,
                                            color: Colors.grey[700],
                                          );
                                        }),
                                      ),
                                  
                                ),
                              ],
                            ),
                          )),
                      Spacer(),
                      //Alarm-Uyarı-Aydınlatma
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv85'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DigerCikislar(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 3,
                      ),
                      
                    ],
                  ),
                ),
                Spacer(),
                //4. Satır
                Expanded(
                  flex: 10,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      //Girişlerin tanımlanması
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv349'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Girisler(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),
                      Spacer(),
                      //Uzunluk,Nem,Debi
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: AutoSizeText(
                                                  Dil().sec(dilSecimi, 'tv306'),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 50.0,
                                                      fontFamily: 'Kelly Slab',
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
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: 
                                RawMaterialButton(
                                      onPressed: () {
                                        timerCancel=true;
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UzDebiNem(false)),
                                    );

                                      },
                                      child: LayoutBuilder(
                                          builder: (context, constraint) {
                                        return Icon(
                                          Icons.settings,
                                          size: constraint.biggest.height,
                                          color: Colors.grey[700],
                                        );
                                      }),
                                    ),
                                
                              ),
                            ],
                          )),                    
                      Spacer(
                        flex: 18,
                      ),
                      
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
        child: FittedBox(
                    child: FloatingActionButton(
            onPressed: () {
              timerCancel=true;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Sistem()),
              );
            },
            backgroundColor: Colors.grey[700],
            child: Icon(
              Icons.arrow_back,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
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
                      Dil().sec(dilSecimi, "tv401"), 
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
                          subtitle: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                //Giriş metni
                                TextSpan(
                                  text: Dil().sec(dilSecimi, "info29"),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13*oran
                                  )
                                ),
                              ]
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
        ),
      ),
      drawer: Metotlar().navigatorMenu(dilSecimi, context, oran)
      );
  }

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


  Future _sifreGiris(double oran) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return SifreGirisAdmin.Deger(dilSecimi,oran);
      },
    ).then((val) {

      print('$sifre  ,  $val');

      if(sifre==val[1] && val[0]=='1'){
        timerCancel=true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TemelAyarlar(false)),
        );


      }else if(sifre!=val[1] && val[0]=='1'){
        Toast.show("Yanlış şifre girdiniz!", context,duration: 3);
      }
      
    });
  }




}
