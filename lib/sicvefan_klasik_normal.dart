import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:prokis/genel/metotlar.dart';
import 'package:prokis/kontrol.dart';
import 'package:toast/toast.dart';
import 'genel/database_helper.dart';
import 'genel/deger_giris_1x0.dart';
import 'genel/deger_giris_2x1.dart';
import 'languages/select.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SicVeFanKlasikNormal extends StatefulWidget {
  List<Map> gelenDBveri;
  SicVeFanKlasikNormal(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return SicVeFanKlasikNormalState(gelenDBveri);
  }
}

class SicVeFanKlasikNormalState extends State<SicVeFanKlasikNormal> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  String fanAdet = "0";
  List<Map> dbVeriler;

  String dogalBolgeB = "1.0";
  String setSicA = "21.0";
  String maksFanFarkiH = "5.0";
  String fanKademesi = "1";

  double gun1 = 33.0;
  double gun7 = 31.0;
  double gun14 = 29.0;
  double gun21 = 27.0;
  double gun28 = 25.0;
  double gun35 = 23.0;
  double gun42 = 21.0;
  List<String> gun = new List(43);
  List<double> fanSet = new List(61);

  int _onlar = 0;
  int _birler = 0;
  int _ondalik = 0;
  int _index = 0;

  List<charts.Series> seriesList;
  bool animate;

  bool timerCancel=false;
  int timerSayac=0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci=4;

//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  SicVeFanKlasikNormalState(List<Map> dbVeri) {
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {
        fanAdet = dbVeri[i]["veri1"];
      }

    }
/*
     else if (fanYontemi == "3" && bacaFanAdet == "0") {
      diagramPath = 'assets/images/diagram_klasik_normal.jpg';
      visibilityler = 'A1*B0*C0*D1*E0*F0*G1*H0';
      harfMetinler = 'A***D***G*';
      infoNo = "info5";
    } 
    */

    for(int i=0; i<=60 ; i++){
      fanSet[i]=double.parse(setSicA)+i%6;
    }
    print(fanSet.reduce(max));

    _gunlerSet();

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {


    if (timerSayac == 0) {
      //_takipEt();

      Timer.periodic(Duration(seconds: 2), (timer) {

        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci>3) {
          baglanti = true;
          //_takipEt();
        }
      });
    }

    timerSayac++;


    var width = MediaQuery.of(context).size.width *
        MediaQuery.of(context).devicePixelRatio;
    var height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    var carpim = width * height;
    var oran = carpim / 2073600.0;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30 * oran),
          child: AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  iconSize: 40 * oran,
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              ),
              actions: [
                Row(
                  children: <Widget>[
                    Builder(
                      builder: (context) => IconButton(
                        color: Colors.yellow[700],
                        iconSize: 40 * oran,
                        icon: Icon(Icons.info_outline),
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        tooltip: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip,
                      ),
                    ),
                  ],
                ),
              ],
              primary: false,
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text(
                SelectLanguage().selectStrings(dilSecimi, "tv181"),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28 * oran,
                    fontFamily: 'Kelly Slab',
                    fontWeight: FontWeight.bold),
              )),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: Column(
                  children: <Widget>[
                    Spacer(
                      flex: 1,
                    ),
                    //Set Sıcaklığı
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(),
                          //Set Sıcaklığı giriş butonu
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                              dilSecimi, "tv125"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontFamily: 'Kelly Slab',
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                          
                                          _index = 1;
                                          _onlar = int.parse(
                                                      setSicA.split(".")[0]) <
                                                  10
                                              ? 0
                                              : (int.parse(
                                                      setSicA.split(".")[0]) ~/
                                                  10);
                                          _birler =
                                              int.parse(setSicA.split(".")[0]) %
                                                  10;
                                          _ondalik =
                                              int.parse(setSicA.split(".")[1]);

                                          _degergiris2X1(
                                              _onlar,
                                              _birler,
                                              _ondalik,
                                              _index,
                                              oran,
                                              dilSecimi,
                                              "tv115");

                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          LayoutBuilder(
                                              builder: (context, constraint) {
                                            return Icon(
                                              Icons.brightness_1,
                                              size: constraint.biggest.height,
                                              color: Colors.blue[700],
                                            );
                                          }),
                                          Text(
                                            setSicA,
                                            style: TextStyle(
                                                fontSize: 25 * oran,
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
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
                          Spacer(),
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    //Diğerleri
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Spacer(),
                          //Doğal Bölge giriş butonu
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                                  dilSecimi, "tv126"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontFamily: 'Kelly Slab',
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        _index = 0;
                                        _onlar = int.parse(
                                                    dogalBolgeB.split(".")[0]) <
                                                10
                                            ? 0
                                            : (int.parse(dogalBolgeB
                                                    .split(".")[0]) ~/
                                                10);
                                        _birler = int.parse(
                                                dogalBolgeB.split(".")[0]) %
                                            10;
                                        _ondalik = int.parse(
                                            dogalBolgeB.split(".")[1]);

                                        _degergiris2X1(
                                            _onlar,
                                            _birler,
                                            _ondalik,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv126");
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          LayoutBuilder(
                                              builder: (context, constraint) {
                                            return Icon(
                                              Icons.brightness_1,
                                              size: constraint.biggest.height,
                                              color: Colors.green[700],
                                            );
                                          }),
                                          Text(
                                            dogalBolgeB,
                                            style: TextStyle(
                                                fontSize: 25 * oran,
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
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
                          Spacer(),
                          //Fan Set değerleri
                          Expanded(
                            flex: 3,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: AutoSizeText(
                                          SelectLanguage().selectStrings(
                                              dilSecimi, "tv185"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 50.0,
                                              fontFamily: 'Kelly Slab',
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          minFontSize: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        
                                        //ayarlanacak

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
                                                              SelectLanguage()
                                                                  .selectStrings(
                                                                      dilSecimi,
                                                                      "tv127"),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Kelly Slab',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                          ),
                                                          //Fan Set Sıcaklıkları giriş bölümü
                                                          Expanded(flex: 10,
                                                            child: Container(color: Colors.white,
                                                              child: Column(mainAxisSize: MainAxisSize.max,
                                                                children: <Widget>[
                                                                  Expanded(child: ListView(
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                        ],
                                                                      ),
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                          _fanSetUnsur("F3: ", fanSet[3].toString(), oran),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),)
                                                                ],),
                                                            ),

                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              });
                                        
                                        


                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          LayoutBuilder(
                                              builder: (context, constraint) {
                                            return Icon(
                                              Icons.brightness_1,
                                              size: constraint.biggest.height,
                                              color: Colors.cyan[800],
                                            );
                                          }),
                                          Text(
                                            SelectLanguage().selectStrings(dilSecimi, "btn10"),
                                            style: TextStyle(
                                                fontSize: 20 * oran,
                                                fontFamily: 'Kelly Slab',
                                                fontWeight: FontWeight.bold,
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
                          Spacer(),
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    //Sıcaklık çizelgesi bölümü
                    Expanded(
                      flex: 10,
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Spacer(
                              flex: 1,
                            ),
                            Expanded(flex: 28,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(SelectLanguage().selectStrings(dilSecimi, "tv184")),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: charts.BarChart(
                                        _grafikDataKlasikNormal(
                                            double.parse(setSicA),
                                            double.parse(dogalBolgeB),dilSecimi,fanSet),

                                        primaryMeasureAxis:
                                            new charts.NumericAxisSpec(
                                          showAxisLine: true,

                                          tickProviderSpec: new charts
                                              .StaticNumericTickProviderSpec(
                                            <charts.TickSpec<num>>[
                                              charts.TickSpec<num>(0),
                                              charts.TickSpec<num>(4),
                                              charts.TickSpec<num>(8),
                                              charts.TickSpec<num>(12),
                                              charts.TickSpec<num>(16),
                                              charts.TickSpec<num>(
                                                  double.parse(setSicA)),
                                              charts.TickSpec<num>(double.parse(
                                                      setSicA) +
                                                  double.parse(dogalBolgeB)),
                                              charts.TickSpec<num>(
                                                      fanSet.reduce(max)),
                                              charts.TickSpec<num>(fanSet.reduce(max) +
                                                  1),
                                              charts.TickSpec<num>(fanSet.reduce(max) +
                                                  2),
                                              charts.TickSpec<num>(fanSet.reduce(max)+
                                                  3),
                                            ],
                                          ),



                                          renderSpec: new charts
                                                  .GridlineRendererSpec(
                                              labelRotation: 50,
                                              labelOffsetFromAxisPx: (1*oran).round(),

                                              // Tick and Label styling here.
                                              labelStyle:
                                                  new charts.TextStyleSpec(
                                                      fontSize:
                                                          (8*oran).round(), // size in Pts.
                                                      color: charts
                                                          .MaterialPalette
                                                          .black),

                                              // Change the line colors to match text color.
                                              lineStyle:
                                                  new charts.LineStyleSpec(
                                                      color: charts
                                                          .MaterialPalette
                                                          .black)),
                                        ),
                                        behaviors: [
                                          new charts.SeriesLegend(),
                                          new charts.SlidingViewport(),
                                          new charts.PanAndZoomBehavior(),
                                        ],
                                        animate: animate,
                                        barGroupingType:
                                            charts.BarGroupingType.stacked,
                                        vertical: false,
                                      )),
                                  Spacer()
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 4,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            timerCancel=true;
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
        drawer: Metotlar().navigatorMenu(dilSecimi, context, oran),
        endDrawer: Drawer(
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  SelectLanguage()
                      .selectStrings(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
                padding: EdgeInsets.only(left: 10),
                margin: EdgeInsets.all(0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage("assets/images/diagram_klasik_normal.jpg"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
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
                                  Text("A",style: TextStyle(fontSize: 10*oran),),
                                  Text("A+B",style: TextStyle(fontSize: 10*oran),),
                                  Text("D",style: TextStyle(fontSize: 10*oran),),
                                  Text("F",style: TextStyle(fontSize: 10*oran),),
                                  Text("G",style: TextStyle(fontSize: 10*oran),),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    " : " +
                                        SelectLanguage().selectStrings(
                                            dilSecimi, "tv115"),style: TextStyle(fontSize: 13*oran),
                                  ),
                                  Text(
                                    " : " +
                                        SelectLanguage().selectStrings(
                                            dilSecimi, "tv116"),style: TextStyle(fontSize: 13*oran),
                                  ),
                                  Text(
                                    " : " +
                                        SelectLanguage().selectStrings(
                                            dilSecimi, "tv118"),style: TextStyle(fontSize: 13*oran),
                                  ),
                                  Text(
                                    " : " +
                                        SelectLanguage().selectStrings(
                                            dilSecimi, "tv120"),style: TextStyle(fontSize: 13*oran),
                                  ),
                                  Text(
                                    " : " +
                                        SelectLanguage().selectStrings(
                                            dilSecimi, "tv121"),style: TextStyle(fontSize: 13*oran),
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
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      dense: false,
                      title: Text('Açıklama'),
                      subtitle: Text(
                        SelectLanguage().selectStrings(dilSecimi, "info3"),
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

  Future _degergiris2X1(int onlar, birler, ondalik, index, double oran,
      String dil, baslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X1.Deger(
            onlar, birler, ondalik, index, oran, dil, baslik);
      },
    ).then((val) {
      bool veriGonderilsinMi=false;
      if (_onlar != val[0] ||
          _birler != val[1] ||
          _ondalik != val[2] ||
          _index != val[3]) {
            veriGonderilsinMi=true;
          }
      _onlar = val[0];
      _birler = val[1];
      _ondalik = val[2];
      _index = val[3];

      if (index == 0) {
        dogalBolgeB = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
      }
      if (index == 1) {
        setSicA =
            _onlar.toString() + _birler.toString() + "." + _ondalik.toString();
      }
      if (index == 3) {
        maksFanFarkiH = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
      }
      if (index == 4) {
        gun1 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 5) {
        gun7 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 6) {
        gun14 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 7) {
        gun21 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 8) {
        gun28 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 9) {
        gun35 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }
      if (index == 10) {
        gun42 = _onlar * 10 + _birler + _ondalik / 10;
        _gunlerSet();
      }

      if(veriGonderilsinMi){
        yazmaSonrasiGecikmeSayaci=0;
        _veriGonder("1*$gun1*$gun7*$gun14*$gun21*$gun28*$gun35*$gun42*$dogalBolgeB*$maksFanFarkiH*$fanKademesi");
      }
      

      setState(() {});
    });
  }

  Future _degergiris1X0(
      int birlerX, index, double oran, String dil, baslik, int ustLimit) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris1X0.Deger(ustLimit, birlerX, index, oran, dil, baslik);
      },
    ).then((val) {
      bool veriGonderilsinMi=false;
      if(_birler!=val[0]){
        veriGonderilsinMi=true;
      }
      _birler = val[0];
      _index = val[1];

      fanKademesi = _birler.toString();
      if(veriGonderilsinMi){
        yazmaSonrasiGecikmeSayaci=0;
        _veriGonder("1*$gun1*$gun7*$gun14*$gun21*$gun28*$gun35*$gun42*$dogalBolgeB*$maksFanFarkiH*$fanKademesi");
      }

      setState(() {});
    });
  }

  String _gunSetHesap(double gunBuyuk, gunKucuk, int bolum, carpim) {
    return ((gunKucuk - (((gunKucuk - gunBuyuk) * carpim) / bolum)).toString())
        .substring(0, 4);
  }

  _gunlerSet() {
    gun[1] = gun1.toString();
    gun[2] = _gunSetHesap(gun7, gun1, 6, 1);
    gun[3] = _gunSetHesap(gun7, gun1, 6, 2);
    gun[4] = _gunSetHesap(gun7, gun1, 6, 3);
    gun[5] = _gunSetHesap(gun7, gun1, 6, 4);
    gun[6] = _gunSetHesap(gun7, gun1, 6, 5);

    gun[7] = gun7.toString();
    gun[8] = _gunSetHesap(gun14, gun7, 7, 1);
    gun[9] = _gunSetHesap(gun14, gun7, 7, 2);
    gun[10] = _gunSetHesap(gun14, gun7, 7, 3);
    gun[11] = _gunSetHesap(gun14, gun7, 7, 4);
    gun[12] = _gunSetHesap(gun14, gun7, 7, 5);
    gun[13] = _gunSetHesap(gun14, gun7, 7, 6);

    gun[14] = gun14.toString();
    gun[15] = _gunSetHesap(gun21, gun14, 7, 1);
    gun[16] = _gunSetHesap(gun21, gun14, 7, 2);
    gun[17] = _gunSetHesap(gun21, gun14, 7, 3);
    gun[18] = _gunSetHesap(gun21, gun14, 7, 4);
    gun[19] = _gunSetHesap(gun21, gun14, 7, 5);
    gun[20] = _gunSetHesap(gun21, gun14, 7, 6);

    gun[21] = gun21.toString();
    gun[22] = _gunSetHesap(gun28, gun21, 7, 1);
    gun[23] = _gunSetHesap(gun28, gun21, 7, 2);
    gun[24] = _gunSetHesap(gun28, gun21, 7, 3);
    gun[25] = _gunSetHesap(gun28, gun21, 7, 4);
    gun[26] = _gunSetHesap(gun28, gun21, 7, 5);
    gun[27] = _gunSetHesap(gun28, gun21, 7, 6);

    gun[28] = gun28.toString();
    gun[29] = _gunSetHesap(gun35, gun28, 7, 1);
    gun[30] = _gunSetHesap(gun35, gun28, 7, 2);
    gun[31] = _gunSetHesap(gun35, gun28, 7, 3);
    gun[32] = _gunSetHesap(gun35, gun28, 7, 4);
    gun[33] = _gunSetHesap(gun35, gun28, 7, 5);
    gun[34] = _gunSetHesap(gun35, gun28, 7, 6);

    gun[35] = gun35.toString();
    gun[36] = _gunSetHesap(gun42, gun35, 7, 1);
    gun[37] = _gunSetHesap(gun42, gun35, 7, 2);
    gun[38] = _gunSetHesap(gun42, gun35, 7, 3);
    gun[39] = _gunSetHesap(gun42, gun35, 7, 4);
    gun[40] = _gunSetHesap(gun42, gun35, 7, 5);
    gun[41] = _gunSetHesap(gun42, gun35, 7, 6);
    gun[42] = gun42.toString();
  }

  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

  
  static List<charts.Series<GrafikSicaklikCizelgesi, String>> _grafikDataLineerCapraz(
      double setSic, dogBol, capFark, maksFanFark, String dil) {
    final fasilaBolgesi = [
      new GrafikSicaklikCizelgesi(SelectLanguage().selectStrings(dil, "tv183"),setSic, Colors.blue[700]),
    ];

    final dogalBolge = [
      new GrafikSicaklikCizelgesi(SelectLanguage().selectStrings(dil, "tv183"), dogBol, Colors.green[700]),
    ];

    final caprazBolge = [
      new GrafikSicaklikCizelgesi(SelectLanguage().selectStrings(dil, "tv183"), capFark, Colors.orange[700]),
    ];

    final tunelBolge = [
      new GrafikSicaklikCizelgesi(SelectLanguage().selectStrings(dil, "tv183"), maksFanFark, Colors.red[700]),
    ];

    return [
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: 'Set Sıc.',
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: fasilaBolgesi,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: 'Doğ. Böl.',
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: dogalBolge,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: 'Çapr. Hav.',
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: caprazBolge,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: 'Tün. Hav.',
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: tunelBolge,
      ),
    ];
  }

  static List<charts.Series<GrafikSicaklikCizelgesi, String>> _grafikDataLineerNormal(
      double setSic, dogBol, maksFanFark, String dil) {
    final fasilaBolgesi = [
      new GrafikSicaklikCizelgesi(SelectLanguage().selectStrings(dil, "tv183"),setSic, Colors.blue[700]),
    ];

    final dogalBolge = [
      new GrafikSicaklikCizelgesi(SelectLanguage().selectStrings(dil, "tv183"), dogBol, Colors.green[700]),
    ];

    final tunelBolge = [
      new GrafikSicaklikCizelgesi(SelectLanguage().selectStrings(dil, "tv183"), maksFanFark, Colors.red[700]),
    ];

    return [
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: 'Set Sıc.',
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: fasilaBolgesi,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: 'Doğ. Böl.',
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: dogalBolge,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: 'Tün. Hav.',
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: tunelBolge,
      ),
    ];
  }

static List<charts.Series<GrafikSicaklikCizelgesi, String>> _grafikDataKlasikNormal(
      double setSic, dogBol, String dil, List<double> fanSet) {
        double deger=fanSet.reduce(max)-setSic-dogBol;
        double tunBolYRD= deger<0 ? 0 : deger;
    final fasilaBolgesi = [
      new GrafikSicaklikCizelgesi(SelectLanguage().selectStrings(dil, "tv183"),setSic, Colors.blue[700]),
    ];

    final dogalBolge = [
      new GrafikSicaklikCizelgesi(SelectLanguage().selectStrings(dil, "tv183"), dogBol, Colors.green[700]),
    ];

    final tunelBolge = [
      new GrafikSicaklikCizelgesi(SelectLanguage().selectStrings(dil, "tv183"), tunBolYRD, Colors.red[700]),
    ];

    return [
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: 'Set Sıc.',
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: fasilaBolgesi,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: 'Doğ. Böl.',
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: dogalBolge,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: 'Tün. Hav.',
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: tunelBolge,
      ),
    ];
  }


  _veriGonder(String emir) async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2235).then((socket) {
        String gelen_mesaj = "";

        socket.add(utf8.encode(emir));

       
      socket.listen((List<int> event) {
        
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
        Toast.show("Bağlantı hatası!", context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  _takipEt() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2236).then((socket) {

        socket.add(utf8.encode('1*'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);

            if (gelenMesaj != "") {
              var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              gun1=double.parse(degerler[0]);
              gun7=double.parse(degerler[1]);
              gun14=double.parse(degerler[2]);
              gun21=double.parse(degerler[3]);
              gun28=double.parse(degerler[4]);
              gun35=double.parse(degerler[5]);
              gun42=double.parse(degerler[6]);
              dogalBolgeB=degerler[7];
              maksFanFarkiH=degerler[9];
              fanKademesi=degerler[10];
              setSicA=degerler[11];

              socket.add(utf8.encode('ok'));
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            _gunlerSet();
            if (!timerCancel) {
              setState(() {});
              
            }
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show("Bağlantı hatası!", context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(SelectLanguage().selectStrings(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  Widget _fanSetUnsur(String fanNo,fanSetDeger,double oran){

    return RawMaterialButton(
      fillColor: Colors.blue[700],
      constraints: BoxConstraints(),
             onPressed: (){},
             child: Container(padding: EdgeInsets.only(left: 4*oran,right: 4*oran,top: 10*oran,bottom: 10*oran),
               child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   Text(fanNo,style: TextStyle(fontFamily: "Kelly Slab",
                   color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16),textScaleFactor: oran,),
                   
                   Text(fanSetDeger,style: TextStyle(fontFamily: "Kelly Slab",
                   color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),textScaleFactor: oran,),
                 ],
               ),
             ),
           );

  }

  //--------------------------METOTLAR--------------------------------

}

class GrafikSicaklikCizelgesi {
  final String baslik;
  final double deger;
  final charts.Color color;

  GrafikSicaklikCizelgesi(this.baslik, this.deger, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
