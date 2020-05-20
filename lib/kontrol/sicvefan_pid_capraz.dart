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
import 'package:prokis/yardimci/deger_giris_2x1.dart';
import 'package:prokis/languages/select.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SicVeFanPIDCapraz extends StatefulWidget {
  List<Map> gelenDBveri;
  SicVeFanPIDCapraz(List<Map> dbVeriler) {
    gelenDBveri = dbVeriler;
  }

  @override
  State<StatefulWidget> createState() {
    return SicVeFanPIDCaprazState(gelenDBveri);
  }
}

class SicVeFanPIDCaprazState extends State<SicVeFanPIDCapraz> {
  //++++++++++++++++++++++++++DATABASE DEĞİŞKENLER+++++++++++++++++++++++++++++++
  final dbHelper = DatabaseHelper.instance;
  var dbSatirlar;
  int dbSatirSayisi = 0;
  int dbSayac = 0;
  String dilSecimi = "EN";
  String kurulumDurum = "0";
  List<Map> dbVeriler;

  String setSicA = "21.0";
  String capHavFarkC = "2.0";
  String pidSetKaydirma = "0.2";

  int _onlar = 0;
  int _birler = 0;
  int _ondalik = 0;
  int _index = 0;

  List<charts.Series> seriesList;
  bool animate;

  bool timerCancel = false;
  int timerSayac = 0;
  bool baglanti = false;

  int yazmaSonrasiGecikmeSayaci = 4;

  String baglantiDurum="";
  String alarmDurum="0";


//--------------------------DATABASE DEĞİŞKENLER--------------------------------

//++++++++++++++++++++++++++CONSTRUCTER METHOD+++++++++++++++++++++++++++++++
  SicVeFanPIDCaprazState(List<Map> dbVeri) {
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }
    }

    

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {
    if (timerSayac == 0) {
      
      Metotlar().takipEt('4*', 2236).then((veri){
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
          
          Metotlar().takipEt('4*', 2236).then((veri){
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
        appBar:Metotlar().appBar(dilSecimi, context, oran, 'tv181',baglantiDurum, alarmDurum),
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
                                          Dil().sec(
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
                                            "tv115",
                                            "");
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
                          //Çapraz havalandırma Bitiş Sıcaklığı giriş butonu
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
                                          Dil().sec(
                                              dilSecimi, "tv128"),
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
                                        _index = 2;
                                        _onlar = int.parse(
                                                    capHavFarkC.split(".")[0]) <
                                                10
                                            ? 0
                                            : (int.parse(capHavFarkC
                                                    .split(".")[0]) ~/
                                                10);
                                        _birler = int.parse(
                                                capHavFarkC.split(".")[0]) %
                                            10;
                                        _ondalik = int.parse(
                                            capHavFarkC.split(".")[1]);

                                        _degergiris2X1(
                                            _onlar,
                                            _birler,
                                            _ondalik,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv128",
                                            "");
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          LayoutBuilder(
                                              builder: (context, constraint) {
                                            return Icon(
                                              Icons.brightness_1,
                                              size: constraint.biggest.height,
                                              color: Colors.orange[700],
                                            );
                                          }),
                                          Text(
                                            capHavFarkC,
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
                          //pid set kaydırma
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
                                          Dil().sec(
                                              dilSecimi, "tv191"),
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
                                        _index = 3;
                                        _onlar = int.parse(
                                                    pidSetKaydirma.split(".")[0]) <
                                                10
                                            ? 0
                                            : (int.parse(pidSetKaydirma
                                                    .split(".")[0]) ~/
                                                10);
                                        _birler = int.parse(
                                                pidSetKaydirma.split(".")[0]) %
                                            10;
                                        _ondalik = int.parse(
                                            pidSetKaydirma.split(".")[1]);

                                        _degergiris2X1(
                                            _onlar,
                                            _birler,
                                            _ondalik,
                                            _index,
                                            oran,
                                            dilSecimi,
                                            "tv191",
                                            "");
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
                                            pidSetKaydirma,
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
                            Expanded(
                              flex: 28,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(Dil()
                                        .sec(dilSecimi, "tv184"),textScaleFactor: oran),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: charts.BarChart(
                                        
                                        _grafikDataPIDCapraz(
                                            double.parse(setSicA),double.parse(capHavFarkC),dilSecimi),


                                            domainAxis: new charts.OrdinalAxisSpec(
                                          
                                          renderSpec: new charts.SmallTickRendererSpec(
                                          
                                              // Tick and Label styling here.
                                            labelStyle: new charts.TextStyleSpec(
                                              fontSize: (12*oran).floor(), // size in Pts.
                                              color: charts.MaterialPalette.black)
                                            )
                                        ),

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
                                                  setSicA) +double.parse(capHavFarkC)),
                                              charts.TickSpec<num>(
                                                      double.parse(
                                                  setSicA) +double.parse(capHavFarkC)+1),
                                              charts.TickSpec<num>(double.parse(
                                                  setSicA) +double.parse(capHavFarkC)+2),
                                              
                                            ],
                                          ),


                                          renderSpec: new charts
                                                  .GridlineRendererSpec(
                                              labelRotation: 50,
                                              labelOffsetFromAxisPx:
                                                  (1 * oran).round(),

                                              // Tick and Label styling here.
                                              labelStyle: new charts
                                                      .TextStyleSpec(
                                                  fontSize: (8 * oran)
                                                      .round(), // size in Pts.
                                                  color: charts
                                                      .MaterialPalette.black),

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
                        Dil().sec(
                            dilSecimi, "tv123"), //Sıcaklık diyagramı
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
                                  image: AssetImage(
                                      "assets/images/diagram_pid_capraz.jpg"),
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
                                        Text(
                                          "A",
                                          style: TextStyle(fontSize: 10 * oran),
                                        ),
                                        Text(
                                          "A+C",
                                          style: TextStyle(fontSize: 10 * oran),
                                        ),
                                        Text(
                                          "D",
                                          style: TextStyle(fontSize: 10 * oran),
                                        ),
                                        Text(
                                          "E",
                                          style: TextStyle(fontSize: 10 * oran),
                                        ),
                                        Text(
                                          "G",
                                          style: TextStyle(fontSize: 10 * oran),
                                        ),
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
                                        Text(
                                          " : " +
                                              Dil().sec(
                                                  dilSecimi, "tv115"),
                                          style: TextStyle(fontSize: 13 * oran),
                                        ),
                                        Text(
                                          " : " +
                                              Dil().sec(
                                                  dilSecimi, "tv117"),
                                          style: TextStyle(fontSize: 13 * oran),
                                        ),
                                        Text(
                                          " : " +
                                              Dil().sec(
                                                  dilSecimi, "tv118"),
                                          style: TextStyle(fontSize: 13 * oran),
                                        ),
                                        Text(
                                          " : " +
                                              Dil().sec(
                                                  dilSecimi, "tv119"),
                                          style: TextStyle(fontSize: 13 * oran),
                                        ),
                                        Text(
                                          " : " +
                                              Dil().sec(
                                                  dilSecimi, "tv121"),
                                          style: TextStyle(fontSize: 13 * oran),
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
                            title: Text(Dil().sec(dilSecimi, "tv186"),textScaleFactor: oran,),
                            subtitle: Text(
                              Dil().sec(dilSecimi, "info6"),
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

  Future _degergiris2X1(int onlar, birler, ondalik, index, double oran,
      String dil, baslik, onBaslik) async {
    // flutter defined function

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return DegerGiris2X1.Deger(
            onlar, birler, ondalik, index, oran, dil, baslik, onBaslik);
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

 
      if (index == 1) {
        setSicA =
            _onlar.toString() + _birler.toString() + "." + _ondalik.toString();
      }

      if (index == 2) {
        capHavFarkC = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
      }

      if (index == 3) {
        pidSetKaydirma = (_onlar == 0 ? "" : _onlar.toString()) +
            _birler.toString() +
            "." +
            _ondalik.toString();
      }

      if (veriGonderilsinMi) {

          yazmaSonrasiGecikmeSayaci = 0;
          String komut="4*$setSicA*$capHavFarkC*$pidSetKaydirma*";
          Metotlar().veriGonder(komut, 2235).then((value){
            if(value.split("*")[0]=="error"){
              Toast.show(Metotlar().errorToastMesaj(value.split("*")[1]), context,duration:3);
            }else{
              Toast.show(Dil().sec(dilSecimi, "toast8"), context,duration:3);
              
              baglanti = false;
              Metotlar().takipEt('4*', 2236).then((veri){
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

  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

  static List<charts.Series<GrafikSicaklikCizelgesi, String>> _grafikDataPIDCapraz(
      double setSic, capBol, String dil) {
    final fasilaBolgesi = [
      new GrafikSicaklikCizelgesi(Dil().sec(dil, "tv183"),setSic, Colors.blue[700]),
    ];

    final caprazBolge = [
      new GrafikSicaklikCizelgesi(Dil().sec(dil, "tv183"), capBol, Colors.orange[700]),
    ];

    return [
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: Dil().sec(dil, "tv188"),
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: fasilaBolgesi,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: Dil().sec(dil, "tv189"),
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: caprazBolge,
      ),
    ];
  }


  takipEtVeriIsleme(String gelenMesaj){
    
    var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);

              setSicA = degerler[0];
              capHavFarkC = degerler[1];
              pidSetKaydirma = degerler[2];

              alarmDurum=degerler[3];


    baglanti=false;
    if(!timerCancel){
      setState(() {
        
      });
    }
    
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
