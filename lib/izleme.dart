import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel_ayarlar.dart';
import 'package:timer_builder/timer_builder.dart';
import 'genel/database_helper.dart';
import 'genel/metotlar.dart';
import 'languages/select.dart';

class Izleme extends StatefulWidget {
  List<Map> gelenDBveri;
  Izleme(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return IzlemeState(gelenDBveri);
  }
}

class IzlemeState extends State<Izleme> with TickerProviderStateMixin {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  int unsurAdet = 0;
  int sutunSayisi;
  List<int> fanHaritaGrid = new List(121);
  List<String> fanNo = new List(121);

  List<String> klepeNo = new List(19);
  List<String> klepeAciklik = new List(11);
  List<String> pedNo = new List(25);
  List<bool> pedDurum = new List(11);

  List<String> isisensorNo = new List(23);
  List<String> isisensorDeger = new List(16);

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

  //++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  IzlemeState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 15) {
        var xx = dbVeri[i]["veri4"].split("*");
        var fanGrid = xx[0].split("#");
        sutunSayisi = int.parse(xx[1]);
        unsurAdet = int.parse(xx[2]);
        for (int i = 0; i < unsurAdet; i++) {
          fanHaritaGrid[i] = int.parse(fanGrid[i]);
        }
      }

      if (dbVeri[i]["id"] == 17) {
        String xx;
        if (dbVeri[i]["veri1"] == "ok") {
          xx = dbVeri[i]["veri2"];
          var klepeNolar = xx.split("#");
          for (int i = 1; i <= 18; i++) {
            klepeNo[i] = klepeNolar[i - 1];
          }
        }
      }

      if (dbVeri[i]["id"] == 19) {
        String xx;

        if (dbVeri[i]["veri1"] == "ok") {
          xx = dbVeri[i]["veri2"];
          var pedNolar = xx.split("#");
          for (int i = 1; i <= 24; i++) {
            pedNo[i] = pedNolar[i - 1];
          }
        }
      }


      if (dbVeri[i]["id"] == 21) {
        String xx;

        if (dbVeri[i]["veri1"] == "ok") {
          xx = dbVeri[i]["veri2"];
          var isisensorNolar = xx.split("#");
          for (int i = 1; i <= 22; i++) {
            isisensorNo[i] = isisensorNolar[i - 1];
          }

        }
      }


      if (dbVeri[i]["id"] == 15) {
        String xx;

        if (dbVeri[i]["veri1"] == "ok") {
          xx = dbVeri[i]["veri2"];
          var fanNolar = xx.split("#");
          for (int i = 1; i <= 120; i++) {
            fanNo[i] = fanNolar[i - 1];
          }
        }
      }

    }

    for(int i=0;i<=10;i++){
      klepeAciklik[i]="0";
      isisensorDeger[i]="0.0";
      pedDurum[i]=false;
    }


    klepeAciklik[3]="100";
    klepeAciklik[1]="100";
    klepeAciklik[2]="100";
    print(fanNo);

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  AnimationController _controller1;
  AnimationController _controller2;
  Offset _offset;

  @override
  Future initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    Duration _periot = new Duration(hours: 60, seconds: 0, milliseconds: 0);

    //_controller1.animateBack(1.0);
    _controller1.repeat();
    _controller2.stop();
  }

  @override
  Widget build(BuildContext context) {
    _offset = Offset(1, 1);

    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv569'),
        floatingActionButton: Opacity(
          opacity: 0.4,
          child: Container(
            width: 56 * oran,
            height: 56 * oran,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  _controller1.dispose();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GenelAyarlar(dbVeriler)),
                  );
                },
                backgroundColor: Colors.blue[700],
                child: Icon(
                  Icons.arrow_back,
                  size: 50,
                  color: Colors.white,
                ),
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
              flex: 40,
              child: Row(
                children: <Widget>[
                  //Çatılı Fan Harita Bölümü
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: <Widget>[
                        //Çatı resmi
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.center,
                                image:
                                    AssetImage('assets/images/cati_icon.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        //Fan Harita Bölümü
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 5.0 * oran,
                                right: 5.0 * oran,
                                bottom: 5.0 * oran),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 3 * oran)),
                              child: Row(
                                children: <Widget>[
                                  //Spacer(flex: 1,),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: <Widget>[
                                        //Spacer(flex: 1,),
                                        Expanded(
                                          flex: 2,
                                          child: seciliHaritaGrid(
                                            oran,
                                          ),
                                        ),
                                        //Spacer(flex: 1,)
                                      ],
                                    ),
                                  ),
                                  //Spacer(flex: 1,)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 4,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Stack(fit: StackFit.expand,
                                  children: <Widget>[
                                    
                                    Row(
                                      children: <Widget>[
                                        Expanded(flex: 3,
                                          child: RawMaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(10*oran),
                                                topLeft: Radius.circular(10*oran)
                                              )),
                                            onPressed: (){},
                                            fillColor: Colors.grey,
                                            
                                          ),
                                        ),
                                        Spacer(flex: 2,)
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(flex: 2,
                                          child: RawMaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(10*oran),
                                                topLeft: Radius.circular(10*oran)
                                              )),
                                            onPressed: (){},
                                            fillColor: Colors.black,
                                          ),
                                        ),
                                        Spacer(flex: 3,)
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(flex: 1,
                                          child: RawMaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(10*oran),
                                                topLeft: Radius.circular(10*oran)
                                              )),
                                            onPressed: (){},
                                            fillColor: Colors.grey,
                                          ),
                                        ),
                                        Spacer(flex: 4,)
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              Spacer(flex: 6,)
                            ],
                          ),
                        ),
                        ],
                    ),
                  ),
                  //Diğer unsurlar bölümü
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding:  EdgeInsets.only(bottom: 5*oran),
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                //Klepe Sol Duvar
                                Expanded(
                                  flex: 32,
                                  child: Column(
                                    children: <Widget>[
                                      //Başlık
                                      Text(
                                        "Sol Duvar",
                                        textScaleFactor: oran,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      //Duvar
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[13]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[10]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[14]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[11]),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[15]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[12]),
                                                    Spacer(),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                //Klepe Ön Duvar
                                Expanded(
                                  flex: 16,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Ön Duvar",
                                        textScaleFactor: oran,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[1]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[2]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 2,
                                                    ),
                                                    _klepeIzlemeUnsurOnSol(oran,klepeNo[3]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                //Klepe Sağ Duvar
                                Expanded(
                                  flex: 32,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Sağ Duvar",
                                        textScaleFactor: oran,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[4]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[7]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[5]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[8]),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[6]),
                                                    Spacer(
                                                      flex: 3,
                                                    ),
                                                    _klepeIzlemeUnsurSag(oran,klepeNo[9]),
                                                    Spacer(flex: 2,),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
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
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(right: 5*oran),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(10*oran)
                              ),
                              child: Column(
                                children: <Widget>[
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
                                  flex: 3,
                                  child: Column(
                                    children: <Widget>[
                                      Spacer(),
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Spacer(flex: 7,),
                                            Expanded(flex: 4,
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
                                          ],
                                        ),
                                      ),
                                      _isisensorHaritaUnsur(oran,isisensorNo[22]),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 25,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            //color: Colors.pink,
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  "assets/images/bina_catisiz_ust_gorunum.png"),
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
                                                        _isisensorHaritaUnsur(oran,isisensorNo[1]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[2]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[3]),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: <Widget>[
                                                        _isisensorHaritaUnsur(oran,isisensorNo[4]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[5]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[6]),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: <Widget>[
                                                        _isisensorHaritaUnsur(oran,isisensorNo[7]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[8]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[9]),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: <Widget>[
                                                        _isisensorHaritaUnsur(oran,isisensorNo[10]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[11]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[12]),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: <Widget>[
                                                        _isisensorHaritaUnsur(oran,isisensorNo[13]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[14]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[15]),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: <Widget>[
                                                        _isisensorHaritaUnsur(oran,isisensorNo[16]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[17]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[18]),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Column(
                                                      children: <Widget>[
                                                        _isisensorHaritaUnsur(oran,isisensorNo[19]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[20]),
                                                        _isisensorHaritaUnsur(oran,isisensorNo[21]),
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
                          ),
                        ),                     
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 5*oran),
                            child: Row(
                              children: <Widget>[
                                Spacer(),
                                //Ped Sol Duvar
                                Expanded(
                                  flex: 33,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Sol Duvar",
                                        textScaleFactor: oran,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[19]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[16]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[13]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[20]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[17]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[14]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[21]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[18]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[15]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                //Ped Ön Duvar
                                Expanded(
                                  flex: 14,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Ön Duvar",
                                        textScaleFactor: oran,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              _pedIzlemeUnsur(oran, pedNo[1]),
                                              Spacer(),
                                              _pedIzlemeUnsur(oran, pedNo[2]),
                                              Spacer(),
                                              _pedIzlemeUnsur(oran, pedNo[3]),
                                              Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                //Ped Sağ Duvar
                                Expanded(
                                  flex: 33,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Sol Duvar",
                                        textScaleFactor: oran,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.black),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[4]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[7]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[10]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[5]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[8]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[11]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Expanded(
                                                flex: 4,
                                                child: Row(
                                                  children: <Widget>[
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[6]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[9]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                    _pedIzlemeUnsur(oran, pedNo[12]),
                                                    Spacer(
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                            ],
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
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
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

  Widget seciliHaritaGrid(double oran) {
    return GridView.count(
      //maxCrossAxisExtent: oranHarita/sutunSayisi,
      //childAspectRatio:2,
      crossAxisCount: sutunSayisi,
      children: List.generate(unsurAdet, (index) {
        return Center(child: _fanIzlemeUnsur(oran, index));
      }),
    );
  }

  Widget _fanIzlemeUnsur(double oran, int index) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            RotationTransition(
              turns: fanHaritaGrid[index] == 2 ? _controller1 : _controller2,
              child: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.0).animate(
                    fanHaritaGrid[index] == 2 ? _controller1 : _controller2),
                child: Image.asset(
                  fanHaritaGrid[index] == 2
                      ? "assets/images/giris_rotate_icon.png"
                      : "assets/images/duvar_icon.png",
                  scale: 1.5 / oran,
                ),
              ),
            ),
            Visibility(
                visible: fanHaritaGrid[index] == 2 ? true : false,
                child: Image.asset(
                  "assets/images/giris_sabit_icon.png",
                  scale: 1.5 / oran,
                )),
            Visibility(
              visible: fanHaritaGrid[index] == 2 ? true : false,
              child: Padding(
                padding: EdgeInsets.only(left: 2 * oran),
                child: Text(
                  fanNo[index+1],
                  style: TextStyle(),
                  textScaleFactor: oran,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _klepeIzlemeUnsurOnSol(double oran, String klpNo){

    String aciklik=klepeAciklik[int.parse(klpNo)];

    double klpSkewKatsayi=(double.parse(aciklik)/100)*0.8;
    int ustSeviye=((double.parse(aciklik)/100)*8).round();

    
    return Expanded(
            flex: klpNo=="0" ? 2 : 8,
            child: Visibility(visible: klpNo=="0" ? false : true,
                          child: RotatedBox(
                quarterTurns: -2,
                child: Stack(
                  alignment:
                      Alignment.topCenter,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1 *
                                  oran,
                              color: Colors
                                  .black),
                          color: Colors
                              .white),
                    ),
                    Transform(
                      transform:
                          Matrix4.skewX(
                              klpSkewKatsayi),
                      child: Padding(
                        padding: EdgeInsets
                            .only(
                                bottom: ustSeviye *
                                    oran),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1 *
                                      oran),
                              color: Colors
                                      .blue[
                                  100]),
                          alignment:
                              Alignment
                                  .center,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child:
                              RotatedBox(
                            quarterTurns:
                                -2,
                            child:
                                SizedBox(
                              child:
                                  Container(
                                padding: EdgeInsets.only(
                                    left: 2 *
                                        oran),
                                alignment:
                                    Alignment
                                        .bottomLeft,
                                child:
                                    AutoSizeText(
                                  "K$klpNo: $aciklik%",
                                  textAlign:
                                      TextAlign.center,
                                  style:
                                      TextStyle(
                                    fontFamily:
                                        'Kelly Slab',
                                    color:
                                        Colors.black,
                                    fontSize:
                                        60,
                                  ),
                                  maxLines:
                                      1,
                                  minFontSize:
                                      8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(flex: 2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );


  }

  Widget _klepeIzlemeUnsurSag(double oran, String klpNo){

    String aciklik=klepeAciklik[int.parse(klpNo)];

    double klpSkewKatsayi=(double.parse(aciklik)/100)*0.8;
    int ustSeviye=((double.parse(aciklik)/100)*8).round();

    
    return Expanded(
            flex: klpNo=="0" ? 2 : 8,
            child: Visibility(visible: klpNo=="0" ? false : true,
                          child: RotatedBox(
                quarterTurns: -2,
                child: Stack(
                  alignment:
                      Alignment.topCenter,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1 *
                                  oran,
                              color: Colors
                                  .black),
                          color: Colors
                              .white),
                    ),
                    Transform(
                      transform:
                          Matrix4.skewX(
                              -klpSkewKatsayi),
                      child: Padding(
                        padding: EdgeInsets
                            .only(
                                bottom: ustSeviye *
                                    oran),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1 *
                                      oran),
                              color: Colors
                                      .blue[
                                  100]),
                          alignment:
                              Alignment
                                  .center,
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child:
                              RotatedBox(
                            quarterTurns:
                                -2,
                            child:
                                SizedBox(
                              child:
                                  Container(
                                padding: EdgeInsets.only(
                                    right: 2 *
                                        oran),
                                alignment:
                                    Alignment
                                        .bottomRight,
                                child:
                                    AutoSizeText(
                                  "K$klpNo: $aciklik%",
                                  textAlign:
                                      TextAlign.center,
                                  style:
                                      TextStyle(
                                    fontFamily:
                                        'Kelly Slab',
                                    color:
                                        Colors.black,
                                    fontSize:
                                        60,
                                  ),
                                  maxLines:
                                      1,
                                  minFontSize:
                                      8,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(flex: 2),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );


  }


  Widget _pedIzlemeUnsur(double oran, String pedNo){

    bool durum=pedDurum[int.parse(pedNo)];

    return Expanded(
            flex: 4,
            child: Visibility(visible: pedNo=="0" ? false : true,
                          child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration:
                          BoxDecoration(
                        image:
                            DecorationImage(
                          alignment: Alignment
                              .centerRight,
                          image: AssetImage(
                              durum ? 'assets/images/ped_izleme_icon_on.png' : 'assets/images/ped_izleme_icon_off.png'),
                          fit: BoxFit
                              .contain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      pedNo,
                      textScaleFactor:
                          oran,
                    ),
                  )
                ],
              ),
            ),
          );
                                            
  }


  Widget _isisensorHaritaUnsur(double oran, String isiSensNo) {

    String sensDeger=isisensorDeger[int.parse(isiSensNo)];


    return Expanded(
      child: Visibility(

        visible: isiSensNo=="0" ? false : true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(flex: 3,
                child: Column(
                  children: <Widget>[
                    Expanded(flex: 5,
                  child:SizedBox(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: AutoSizeText(
                        "S" +isiSensNo,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 50.0,
                            fontFamily: 'Kelly Slab'),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
                    ),
                  ),
                           
                ),
                    Expanded(flex: 6,
                  child:SizedBox(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: AutoSizeText(
                        "$sensDeger",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 50.0,
                            fontFamily: 'Kelly Slab'),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
                    ),
                  ),
                           
                ),
                    Spacer(flex: 4,)
            
                    
                  ],
                ),
              ),
              Expanded(flex: 3,
                                          child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.pink,
                                image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage(
                                      'assets/images/harita_isi_sensor_icon.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                    ),
                    
            Spacer()
            ],
        ),
      ),
    );
  }



}
