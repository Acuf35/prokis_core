
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/adetler.dart';
import 'package:prokis/airinlet_haritasi.dart';
import 'package:prokis/aluyay.dart';
import 'package:prokis/bacafan_haritasi.dart';
import 'package:prokis/dil_secimi.dart';
import 'package:prokis/fan_haritasi.dart';
import 'package:prokis/fan_yontemi.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/isisensor_haritasi.dart';
import 'package:prokis/isitici_haritasi.dart';
import 'package:prokis/klepe_haritasi.dart';
import 'package:prokis/klp_yontemi.dart';
import 'package:prokis/kontrol.dart';
import 'package:prokis/kumes_olustur.dart';
import 'package:prokis/mh_yontemi.dart';
import 'package:prokis/ped_haritasi.dart';
import 'package:prokis/silo_haritasi.dart';
import 'package:prokis/uz_debi_nem.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_2x1.dart';
import 'genel/metotlar.dart';
import 'genel/sifre_giris_admin.dart';
import 'languages/select.dart';

class KurulumAyarlari extends StatefulWidget {
  List<Map> gelenDBveri;
  KurulumAyarlari(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return KurulumAyarlariState(gelenDBveri);
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
  
  List<Map> dbVeriler;
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  KurulumAyarlariState(List<Map> dbVeri) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
      if (dbVeri[i]["id"] == 3) {
        sifre = dbVeri[i]["veri4"];
      }
    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
      appBar: Metotlar().appBarSade(dilSecimi, context, oran, 'tv299',Colors.grey[600]),
      body: Column(
        children: <Widget>[
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DilSecimi(dbVeriler,false)),
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
                        flex: 1,
                      ),
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
                      Spacer(
                        flex: 1,
                      ),
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Adetler(dbVeriler,false)),
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
                        flex: 1,
                      ),
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FanYontemi(dbVeriler,false)),
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MhYontemi(dbVeriler,false)),
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
                        flex: 1,
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
                                                  Dil().sec(dilSecimi, 'tv305'),
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

                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              KlpYontemi(dbVeriler,false)),
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
                        flex: 1,
                      ),
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UzDebiNem(dbVeriler,false)),
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
                        flex: 1,
                      ),
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FanHaritasi(dbVeriler,false)),
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              KlepeHaritasi(dbVeriler,false)),
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
                        flex: 1,
                      ),
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

                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PedHaritasi(dbVeriler,false)),
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
                        flex: 1,
                      ),
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IsiSensorHaritasi(dbVeriler,false)),
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
                        flex: 1,
                      ),
                      //BacaFan Haritası
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BacafanHaritasi(dbVeriler,false)),
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
                      //Air Inlet Haritası
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AirInletHaritasi(dbVeriler,false)),
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
                        flex: 1,
                      ),
                      //Isıtıcı Haritası
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

                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IsiticiHaritasi(dbVeriler,false)),
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
                        flex: 1,
                      ),
                      //Silo Haritası
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SiloHaritasi(dbVeriler,false)),
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
                        flex: 1,
                      ),
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
                                        Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AluyayHaritasi(dbVeriler,false)),
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
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Container(width: 56*oran,height: 56*oran,
        child: FittedBox(
                    child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => GenelAyarlar(dbVeriler)),
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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  KumesOlustur(dbVeriler,false)),
        );


      }else if(sifre!=val[1] && val[0]=='1'){
        Toast.show("Yanlış şifre girdiniz!", context,duration: 3);
      }
      
    });
  }




}
