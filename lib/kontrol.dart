
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:prokis/min_hav_agirlik.dart';
import 'package:prokis/min_hav_hacim.dart';
import 'package:prokis/min_hav_klasik.dart';
import 'package:prokis/sicvefan_klasik_capraz.dart';
import 'package:prokis/sicvefan_klasik_normal.dart';
import 'package:prokis/sicvefan_lineer_capraz.dart';
import 'package:prokis/sicvefan_lineer_normal.dart';
import 'package:prokis/sicvefan_pid_capraz.dart';
import 'package:prokis/sicvefan_pid_normal.dart';
import 'package:prokis/sogutma.dart';
import 'package:timer_builder/timer_builder.dart';
import 'aydinlatma.dart';
import 'deneme.dart';
import 'genel/database_helper.dart';
import 'genel/metotlar.dart';
import 'isitma.dart';
import 'klepe_klasik.dart';
import 'klepe_tunel.dart';
import 'languages/select.dart';

class Kontrol extends StatefulWidget {
  List<Map> gelenDBveri;
  Kontrol(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return KontrolState(gelenDBveri);
  }
}

class KontrolState extends State<Kontrol> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String bacaFanAdet = "0";
  String fanYontemi = "0";
  String klepeYontemi = "0";
  String mhYontemi = "0";
  List<Map> dbVeriler;
//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  KontrolState(List<Map> dbVeri) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 5) {
        bacaFanAdet = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 6) {
        fanYontemi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 7) {
        mhYontemi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 8) {
        klepeYontemi = dbVeri[i]["veri1"];
      }


    }

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
      
      appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv106'),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                              child: Container(alignment: Alignment.centerLeft,color: Colors.grey[300],padding: EdgeInsets.only(left: 10*oran),
                                child: TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
                          return Text(
                            Metotlar().getSystemTime(),
                            style: TextStyle(
                                  color: Colors.grey[700],
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
                            Metotlar().getSystemDate(),
                            style: TextStyle(
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
                Expanded(
                  flex: 10,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
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
                                                  Dil().sec(dilSecimi, 'tv107'),
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
                                child: RawMaterialButton(
                                  onPressed: () {

                                    if(fanYontemi=="2" && bacaFanAdet!="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanLineerCapraz(dbVeriler)),
                                        );
                                    }

                                    if(fanYontemi=="2" && bacaFanAdet=="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanLineerNormal(dbVeriler)),
                                        );
                                    }

                                    if(fanYontemi=="1" && bacaFanAdet!="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanKlasikCapraz(dbVeriler)),
                                        );
                                    }

                                    if(fanYontemi=="1" && bacaFanAdet=="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanKlasikNormal(dbVeriler)),
                                        );
                                    }

                                    if(fanYontemi=="3" && bacaFanAdet!="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanPIDCapraz(dbVeriler)),
                                        );
                                    }

                                    if(fanYontemi=="3" && bacaFanAdet=="0"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SicVeFanPIDNormal(dbVeriler)),
                                        );
                                    }
                                    

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/tem_hum_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
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
                                                  Dil().sec(dilSecimi, 'tv108'),
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
                                child: RawMaterialButton(
                                  onPressed: () {

                                    if(klepeYontemi=="1"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => KlepeKlasik(dbVeriler)),
                                        );

                                    }

                                    if(klepeYontemi=="2"){
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => KlepeTunel(dbVeriler)),
                                        );

                                    }
                                    
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/klepe_icon2.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
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
                                                  Dil().sec(dilSecimi, 'tv109'),
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
                                child: RawMaterialButton(
                                  onPressed: () {

                                    Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Sogutma(dbVeriler)),
                                        );

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/cooling_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
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
                                                  Dil().sec(dilSecimi, 'tv110'),
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
                                child: RawMaterialButton(
                                  onPressed: () {

                                    if(mhYontemi=="1"){
                                      Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MinHavKlasik(dbVeriler)),
                                          );
                                    }
                                    
                                    if(mhYontemi=="2"){
                                      Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MinHavAgirlik(dbVeriler)),
                                          );
                                    }

                                    if(mhYontemi=="3"){
                                      Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MinHavHacim(dbVeriler)),
                                          );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/minvent_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
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
                Expanded(
                  flex: 10,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
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
                                                  Dil().sec(dilSecimi, 'tv111'),
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
                                child: RawMaterialButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Isitma(dbVeriler)),
                                        );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/heating_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
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
                                                  Dil().sec(dilSecimi, 'tv112'),
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Aydinlatma(dbVeriler)),
                                        );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/aydinlatma_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
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
                                                  Dil().sec(dilSecimi, 'tv113'),
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/su_silo_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Spacer(
                        flex: 1,
                      ),
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
                                                  Dil().sec(dilSecimi, 'tv114'),
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/diger_ops_icon.png'),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
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
                                MaterialPageRoute(
                                    builder: (context) => GenelAyarlar(dbVeriler)),
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
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
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
}
