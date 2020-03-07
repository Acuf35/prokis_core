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
import 'package:timer_builder/timer_builder.dart';
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
    dbVeriler = dbVeri;
    for (int i = 0; i <= dbVeri.length - 1; i++) {
      if (dbVeri[i]["id"] == 1) {
        dilSecimi = dbVeri[i]["veri1"];
      }

      if (dbVeri[i]["id"] == 4) {
        fanAdet = dbVeri[i]["veri1"];
      }

    }

    for(int i=0; i<=60 ; i++){
      if(int.parse(fanAdet)>=i){
        fanSet[i]=double.parse(setSicA)+i%6;
      }else{
        fanSet[i]=0;
      }
    }
    

    _dbVeriCekme();
  }
//--------------------------CONSTRUCTER METHOD--------------------------------

  @override
  Widget build(BuildContext context) {


    if (timerSayac == 0) {
      _takipEt();

      Timer.periodic(Duration(seconds: 2), (timer) {

        yazmaSonrasiGecikmeSayaci++;
        if (timerCancel) {
          timer.cancel();
        }
        if (!baglanti && yazmaSonrasiGecikmeSayaci>3) {
          baglanti = true;
          _takipEt();
        }
      });
    }

    timerSayac++;


    var oran = MediaQuery.of(context).size.width / 731.4;

    return Scaffold(
        appBar: Metotlar().appBar(dilSecimi, context, oran, 'tv181'),
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
                            Metotlar().getSystemDate(dbVeriler),
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
                                              "tv115","");

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
                                          Dil().sec(
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
                                            "tv126","");
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
                                          Dil().sec(
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
                                                              Dil()
                                                                  .sec(
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
                                                                  Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: <Widget>[
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F1 :", fanSet[1].toString(),fanAdet, oran,1),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F2 :", fanSet[2].toString(),fanAdet, oran,2),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F3 :", fanSet[3].toString(),fanAdet, oran,3),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F4 :", fanSet[4].toString(),fanAdet, oran,4),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F5 :", fanSet[5].toString(),fanAdet, oran,5),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F6 :", fanSet[6].toString(),fanAdet, oran,6),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F7 :", fanSet[7].toString(),fanAdet, oran,7),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F8 :", fanSet[8].toString(),fanAdet, oran,8),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F9 :", fanSet[9].toString(),fanAdet, oran,9),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F10: ", fanSet[10].toString(),fanAdet, oran,10),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: <Widget>[
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F11:", fanSet[11].toString(),fanAdet, oran,11),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F12:", fanSet[12].toString(),fanAdet, oran,12),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F13:", fanSet[13].toString(),fanAdet, oran,13),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F14:", fanSet[14].toString(),fanAdet, oran,14),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F15:", fanSet[15].toString(),fanAdet, oran,15),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F16:", fanSet[16].toString(),fanAdet, oran,16),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F17:", fanSet[17].toString(),fanAdet, oran,17),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F18:", fanSet[18].toString(),fanAdet, oran,18),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F19:", fanSet[19].toString(),fanAdet, oran,19),
                                                                          Spacer(),
                                                                          _fanSetUnsur(state ,"F20:", fanSet[20].toString(),fanAdet, oran,20),
                                                                          Spacer(),
                                                                        ],
                                                                      ),
                                                                      Visibility(visible: int.parse(fanAdet)>20,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F21:", fanSet[21].toString(),fanAdet, oran,21),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F22:", fanSet[22].toString(),fanAdet, oran,22),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F23:", fanSet[23].toString(),fanAdet, oran,23),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F24:", fanSet[24].toString(),fanAdet, oran,24),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F25:", fanSet[25].toString(),fanAdet, oran,25),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F26:", fanSet[26].toString(),fanAdet, oran,26),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F27:", fanSet[27].toString(),fanAdet, oran,27),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F28:", fanSet[28].toString(),fanAdet, oran,28),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F29:", fanSet[29].toString(),fanAdet, oran,29),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F30:", fanSet[30].toString(),fanAdet, oran,30),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Visibility(visible: int.parse(fanAdet)>30,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F31:", fanSet[31].toString(),fanAdet, oran,31),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F32:", fanSet[32].toString(),fanAdet, oran,32),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F33:", fanSet[33].toString(),fanAdet, oran,33),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F34:", fanSet[34].toString(),fanAdet, oran,34),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F35:", fanSet[35].toString(),fanAdet, oran,35),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F36:", fanSet[36].toString(),fanAdet, oran,36),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F37:", fanSet[37].toString(),fanAdet, oran,37),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F38:", fanSet[38].toString(),fanAdet, oran,38),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F39:", fanSet[39].toString(),fanAdet, oran,39),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F40:", fanSet[40].toString(),fanAdet, oran,40),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Visibility(visible: int.parse(fanAdet)>40,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F41:", fanSet[41].toString(),fanAdet, oran,41),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F42:", fanSet[42].toString(),fanAdet, oran,42),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F43:", fanSet[43].toString(),fanAdet, oran,43),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F44:", fanSet[44].toString(),fanAdet, oran,44),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F45:", fanSet[45].toString(),fanAdet, oran,45),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F46:", fanSet[46].toString(),fanAdet, oran,46),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F47:", fanSet[47].toString(),fanAdet, oran,47),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F48:", fanSet[48].toString(),fanAdet, oran,48),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F49:", fanSet[49].toString(),fanAdet, oran,49),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F50:", fanSet[50].toString(),fanAdet, oran,50),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Visibility(visible: int.parse(fanAdet)>50,
                                                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: <Widget>[
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F51:", fanSet[51].toString(),fanAdet, oran,51),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F52:", fanSet[52].toString(),fanAdet, oran,52),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F53:", fanSet[53].toString(),fanAdet, oran,53),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F54:", fanSet[54].toString(),fanAdet, oran,54),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F55:", fanSet[55].toString(),fanAdet, oran,55),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F56:", fanSet[56].toString(),fanAdet, oran,56),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F57:", fanSet[57].toString(),fanAdet, oran,57),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F58:", fanSet[58].toString(),fanAdet, oran,58),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F59:", fanSet[59].toString(),fanAdet, oran,59),
                                                                            Spacer(),
                                                                            _fanSetUnsur(state ,"F60:", fanSet[60].toString(),fanAdet, oran,60),
                                                                            Spacer(),
                                                                          ],
                                                                        ),
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
                                              color: Colors.red[700],
                                            );
                                          }),
                                          Text(
                                            Dil().sec(dilSecimi, "btn10"),
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
                                    child: Text(Dil().sec(dilSecimi, "tv184"),textScaleFactor: oran),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: charts.BarChart(


                                        _grafikDataKlasikNormal(
                                            double.parse(setSicA),
                                            double.parse(dogalBolgeB),dilSecimi,fanSet),


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
        floatingActionButton: Container(width: 56*oran,height: 56*oran,
          child: FittedBox(
                      child: FloatingActionButton(
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
                    Dil()
                        .sec(dilSecimi, "tv123"), //Sıcaklık diyagramı
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
                                          Dil().sec(
                                              dilSecimi, "tv115"),style: TextStyle(fontSize: 13*oran),
                                    ),
                                    Text(
                                      " : " +
                                          Dil().sec(
                                              dilSecimi, "tv116"),style: TextStyle(fontSize: 13*oran),
                                    ),
                                    Text(
                                      " : " +
                                          Dil().sec(
                                              dilSecimi, "tv118"),style: TextStyle(fontSize: 13*oran),
                                    ),
                                    Text(
                                      " : " +
                                          Dil().sec(
                                              dilSecimi, "tv120"),style: TextStyle(fontSize: 13*oran),
                                    ),
                                    Text(
                                      " : " +
                                          Dil().sec(
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
                        title: Text(Dil().sec(dilSecimi, "tv186"),textScaleFactor: oran,),
                        subtitle: Text(
                          Dil().sec(dilSecimi, "info3"),
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

      String gonderilecekFanSet;
      String gonderilecekFanIndex="0";
      for(int i=1;i<=60;i++){
        if(index-10==i){
          String deger=_onlar.toString() + _birler.toString() + "." + _ondalik.toString();
          fanSet[i]=double.parse(deger);
          gonderilecekFanSet=fanSet[i].toString();
          gonderilecekFanIndex=i.toString();
        }
      }

      if(veriGonderilsinMi){
        yazmaSonrasiGecikmeSayaci=0;
        _veriGonder("2*$setSicA*$dogalBolgeB*$gonderilecekFanIndex*$gonderilecekFanSet");
      }


      setState(() {});
    });
  }


  Future<Null> bottomDrawerIcindeGuncelle(StateSetter updateState) async {
    updateState(() {});
  }

  
static List<charts.Series<GrafikSicaklikCizelgesi, String>> _grafikDataKlasikNormal(
      double setSic, dogBol, String dil, List<double> fanSet) {
        double deger=fanSet.reduce(max)-setSic-dogBol;
        double tunBolYRD= deger<0 ? 0 : deger;
    final fasilaBolgesi = [
      new GrafikSicaklikCizelgesi(Dil().sec(dil, "tv183"),setSic, Colors.blue[700]),
    ];

    final dogalBolge = [
      new GrafikSicaklikCizelgesi(Dil().sec(dil, "tv183"), dogBol, Colors.green[700]),
    ];

    final tunelBolge = [
      new GrafikSicaklikCizelgesi(Dil().sec(dil, "tv183"), tunBolYRD, Colors.red[700]),
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
        id: Dil().sec(dil, "tv187"),
        domainFn: (GrafikSicaklikCizelgesi deger, _) => deger.baslik,
        measureFn: (GrafikSicaklikCizelgesi deger, _) => deger.deger,
        colorFn: (GrafikSicaklikCizelgesi clickData, _) => clickData.color,
        data: dogalBolge,
      ),
      new charts.Series<GrafikSicaklikCizelgesi, String>(
        id: Dil().sec(dil, "tv190"),
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
              Dil().sec(dilSecimi, "toast8"), context,
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
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  _takipEt() async {
    try {
      String gelenMesaj = "";
      const Duration ReceiveTimeout = const Duration(milliseconds: 2000);
      await Socket.connect('192.168.1.110', 2236).then((socket) {

        socket.add(utf8.encode('2*$fanAdet'));

        socket.listen(
          (List<int> event) {
            gelenMesaj = utf8.decode(event);
            print(gelenMesaj);
            if (gelenMesaj != "") {
              var degerler = gelenMesaj.split('*');
              print(degerler);
              print(yazmaSonrasiGecikmeSayaci);
              
              setSicA=degerler[0];
              dogalBolgeB=degerler[1];

              for(int i=2;i<=61;i++){
                fanSet[i-1]=double.parse(degerler[i]);
              }
              

              socket.add(utf8.encode('ok'));
            }
          },
          onDone: () {
            baglanti = false;
            socket.close();
            if (!timerCancel) {
              setState(() {});
              
            }
          },
        );
      }).catchError((Object error) {
        print(error);
        Toast.show(Dil().sec(dilSecimi, "toast20"), context, duration: 3);
        baglanti = false;
      });
    } catch (e) {
      print(e);
      Toast.show(Dil().sec(dilSecimi, "toast11"), context,
          duration: 3);
      baglanti = false;
    }
  }

  Widget _fanSetUnsur(var state,String fanBaslik, String fanSetDeger, String fanAdet,double oran, int fanNo,  ){

    return Expanded(flex: 10,
      child: Visibility(visible: int.parse(fanAdet)>=fanNo, maintainAnimation: true,maintainState: true,maintainSize: true,
              child: RawMaterialButton(
    fillColor: Colors.blue[700],
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    constraints: BoxConstraints(),
             onPressed: (){
               _index = 10+fanNo;
              _onlar = int.parse(
                          fanSet[fanNo].toString().split(".")[0]) <
                      10
                  ? 0
                  : (int.parse(
                          fanSet[fanNo].toString().split(".")[0]) ~/
                      10);
              _birler =
                  int.parse(fanSet[fanNo].toString().split(".")[0]) %
                      10;
              _ondalik =
                  int.parse(fanSet[fanNo].toString().split(".")[1]);

              _degergiris2X1(
                  _onlar,
                  _birler,
                  _ondalik,
                  _index,
                  oran,
                  dilSecimi,
                  "tv115","Fan $fanNo ").then((onValue){
                    bottomDrawerIcindeGuncelle(state);
                  });

                                      

             },
             child: Container(padding: EdgeInsets.only(top: 5,bottom: 5),
               child: Row(mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Text(fanBaslik,style: TextStyle(fontFamily: "Kelly Slab",
                   color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 16),textScaleFactor: oran,),
                   
                   Text(fanSetDeger,style: TextStyle(fontFamily: "Kelly Slab",
                   color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),textScaleFactor: oran,),
                 ],
               ),
             ),
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







