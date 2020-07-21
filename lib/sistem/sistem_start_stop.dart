import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar/sistem.dart';
import 'package:prokis/provider/dbprokis.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:prokis/yardimci/database_helper.dart';
import 'package:prokis/yardimci/metotlar.dart';
import 'package:prokis/languages/select.dart';
import 'package:toast/toast.dart';

class SistemStartStop extends StatefulWidget {
  List<Map> gelenDBveri;
  SistemStartStop(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return SistemStartStopState(gelenDBveri);
  }
}

class SistemStartStopState extends State<SistemStartStop> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  bool sistemDurumu = false;

  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci = 4;
  bool takipEtiGeciciDurdur = false;

  String baglantiDurum="";
  String alarmDurum="00000000000000000000000000000000000000000000000000000000000000000000000000000000";

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  SistemStartStopState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
    }
    SystemChrome.setEnabledSystemUIOverlays([]);
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
    var oran = MediaQuery.of(context).size.width / 731.4;
    final dbProkis = Provider.of<DBProkis>(context);

    if (timerSayac == 0) {
      Metotlar().takipEt('30*', 2236).then((veri) {
        var degerler = veri.split("*");
        if (degerler[0] == "error") {
          baglanti=false;
          baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
          setState(() {});
        } else {
          sistemDurumu = degerler[0] == "True" ? true : false;
          baglanti = false;
          baglantiDurum="";
          alarmDurum=degerler[1];

          if (!timerCancel) {
            setState(() {});
          }
        }
      });

      Timer.periodic(Duration(seconds: 2), (timer) {
        yazmaSonrasiGecikmeSayaci++;

        if (timerCancel) {
          timer.cancel();
        }

        if (!baglanti && yazmaSonrasiGecikmeSayaci > 3) {
          baglanti = true;
          Metotlar().takipEt('30*', 2236).then((veri) {
            var degerler = veri.split("*");
            if (degerler[0] == "error") {
              baglanti=false;
              baglantiDurum=Metotlar().errorToastMesaj(veri.split("*")[1],dbProkis);
              setState(() {});
            } else {

              sistemDurumu = degerler[0] == "True" ? true : false;
              baglanti = false;
              baglantiDurum="";
              alarmDurum=degerler[1];

              if (!timerCancel) {
                setState(() {});
              }
            }
          });
        }
      });
    }

    timerSayac++;

    return Scaffold(
      appBar: Metotlar()
          .appBarSade(dilSecimi, context, oran, 'tv684', Colors.grey[600],baglantiDurum, alarmDurum),
      floatingActionButton: Container(
        width: 56 * oran,
        height: 56 * oran,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              timerCancel = true;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Sistem()),
              );
              SystemChrome.setEnabledSystemUIOverlays([]);
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
                      Metotlar().getSystemTime(dbProkis.getDbVeri),
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
                      Metotlar().getSystemDate(dbProkis.getDbVeri),
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
            flex: 40,
            child: Column(
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        Dil().sec(dilSecimi, "tv685"),
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.grey,
                            decoration: TextDecoration.underline),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Row(
                    children: <Widget>[
                      Spacer(
                        flex: 5,
                      ),
                      Expanded(
                        flex: 3,
                        child: RawMaterialButton(
                          onPressed: () {
                            print("GİRİYOR");

                            if (sistemDurumu) {
                              sistemDurumu = false;
                            } else {
                              sistemDurumu = true;
                            }
                            String komut = sistemDurumu ? "30*1" : "30*0";

                            Metotlar().veriGonder(komut, 2235).then((value) {
                              yazmaSonrasiGecikmeSayaci = 0;
                              if (value.split("*")[0] == "error") {
                                Toast.show(
                                    Dil().sec(dilSecimi, "toast101"),
                                    context,
                                    duration: 3);
                              } else {
                                Toast.show(
                                    Dil().sec(dilSecimi, "toast8"), context,
                                    duration: 3);
                              }

                              setState(() {});
                            });
                          },
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: LayoutBuilder(
                                    builder: (context, constraint) {
                                  return Icon(
                                    Icons.brightness_1,
                                    size: constraint.biggest.height,
                                    color: sistemDurumu
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                  );
                                }),
                              ),
                              Center(
                                  child: Text(
                                sistemDurumu
                                    ? Dil().sec(dilSecimi, "btn12")
                                    : Dil().sec(dilSecimi, "btn13"),
                                style: TextStyle(
                                  fontSize: 40 * oran,
                                  fontFamily: 'Kelly Slab',
                                  fontWeight: FontWeight.bold,
                                  color: sistemDurumu
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ))
                            ],
                          ),
                          constraints: BoxConstraints(),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      Spacer(
                        flex: 5,
                      )
                    ],
                  ),
                ),
                Spacer(
                  flex: 3,
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        Dil().sec(dilSecimi, "tv686"),
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.grey,
                            decoration: TextDecoration.underline),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: AutoSizeText(
                        sistemDurumu
                            ? Dil().sec(dilSecimi, "tv687")
                            : Dil().sec(dilSecimi, "tv688"),
                        style: TextStyle(
                          fontFamily: 'Audio wide',
                          fontSize: 50,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
                Spacer()
              ],
            ),
          )
        ],
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
                      Dil().sec(dilSecimi, "tv684"),
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
                            text: TextSpan(children: <TextSpan>[
                              //Giriş metni
                              TextSpan(
                                  text: Dil().sec(dilSecimi, "info48"),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13 * oran)),
                            ]),
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
}
